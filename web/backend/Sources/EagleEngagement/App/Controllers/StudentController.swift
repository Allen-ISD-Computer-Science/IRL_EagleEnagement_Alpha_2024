import Vapor
import Fluent
import Foundation

struct StudentLoginParams : Content {
    var email: String;
    var password: String;
}

struct StudentController : RouteCollection {
    func randomString(length: Int) -> String {
        let letters = "123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func boot(routes: RoutesBuilder) throws {
        let apiRoutes = routes.grouped("api");
        let protectedRoutes = apiRoutes.grouped([UserToken.authenticator(), StudentUserAuthenticator(), UserToken.guardMiddleware()])

        let studentSignUp = StudentSignUp();
        let verification = Verification();

        // Auth
        apiRoutes.post("signup", use: studentSignUp.signUp);
        apiRoutes.post("verify", use: verification.verifyUser);
        apiRoutes.post("login", use: login);
        apiRoutes.post("forgotPassword", use: forgotPassword);
        protectedRoutes.post("logOutAll", use: logOutAllDevices);
        
        // Data
        protectedRoutes.post("profile", use: fetchProfile);
        protectedRoutes.post("profile", "edit", use: editProfile);
        
        protectedRoutes.post("events", use: fetchEvents);
        protectedRoutes.post("event", ":id", use: fetchEvent);
        protectedRoutes.post("event", ":id", "checkIn", use: checkInEvent);
        
        protectedRoutes.post("clubs", use: fetchClubs);
        protectedRoutes.post("club", ":id", use: fetchClub);

        protectedRoutes.post("rewards", use: fetchRewards);
        protectedRoutes.post("reward", ":id", "purchase", use: purchaseReward);
    }

    func login(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(StudentLoginParams.self);

        if (args.email.isEmpty || args.password.isEmpty) {
            throw Abort(.badRequest);
        }

        if (!args.email.hasSuffix("@student.allenisd.org") || Array(args.email.split(separator: "@")).count > 2) {
            throw Abort(.badRequest, reason: "Email not permitted for Student Login.");
        }

        var decodedString = ""
        if let decodedData = Data(base64Encoded: args.password) {
            decodedString = String(data: decodedData, encoding: .utf8)!
        }

        guard let user = try await User.query(on: req.db)
                .filter(\.$email == args.email)
                .first(), try Bcrypt.verify(decodedString, created: user.passwordHash)
        else {
            throw Abort(.unauthorized);
        }

        guard let studentUser = try await StudentUser.query(on: req.db)
                .with(\.$user)
                .filter(\.$user.$id == user.id!)
                .first()
                else {
            throw Abort(.badRequest, reason: "StudentUser doesn't exist?");
        }
        
        let jwtToken = try UserToken(user: studentUser); 
        return Msg(success: true, msg: try req.jwt.sign(jwtToken));
    }

    func logOutAllDevices(_ req: Request) async throws -> Msg {
        let userToken = try req.jwt.verify(as: UserToken.self);
        
        guard let studentUser = try await StudentUser.query(on: req.db)
                .join(User.self, on: \StudentUser.$user.$id == \User.$id)
                .filter(User.self, \.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }

        studentUser.expiredNum += 1;

        try await studentUser.save(on: req.db);
        return Msg(success: true, msg: "Logged out of all devices!");
    }

    struct ForgotQuery : Content {
        var email: String;
        var studentID: Int;
    }

    func forgotPassword(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(ForgotQuery.self);

        if (args.email.isEmpty || args.studentID < 0) {
            throw Abort(.badRequest);
        }

        if (!args.email.hasSuffix("@student.allenisd.org") || Array(args.email.split(separator: "@")).count > 2) {
            throw Abort(.badRequest, reason: "Email invalid.");
        }

        guard let studentUser = try await StudentUser.query(on: req.db).with(\.$user)
                .filter(\.$studentID == args.studentID)
                .filter(User.self, \.$email == args.email)
                .first() else {
            throw Abort(.badRequest, reason: "Account not found or invalid.");
        }

        let verificationString = randomString(length: 8);
        
        studentUser.user.verificationToken = verificationString;
        try await studentUser.user.save(on: req.db);

        guard let studentForgotTemplateID = Environment.get("STUDENT_FORGOT_TEMPLATE_ID") else {
            fatalError("Failed to determine STUDENT_FORGOT_TEMPLATE_ID from environment");
        }

        let name = studentUser.user.name.split(separator: " ", maxSplits: 1).map(String.init);
        let firstName = name[0];
        let lastName = name[1];

        let contact = EmailContact(firstName: firstName, lastName: lastName, emailAddress: studentUser.user.email)
        let verifyEmail = TokenURLEmail(token: verificationString).createContent(with: contact)
        let emailData = EmailData(contact: contact,
                                  templateExternalID: studentForgotTemplateID,
                                  templateParameters: verifyEmail)

        try await GlobalEmailAPI.sendEmail(from: req, with: emailData)

        return Msg(success: true, msg: "Send forgot code to your email!");
    }

    struct TokenURLEmail: EmailContactConsumer {
        private struct TokenURLEmailWrapper: Encodable {
            let firstName: String?
            let lastName: String?
            let verificationCode: String
            let name: String
        }

        let token: String;

        init(token: String) {
            self.token = token;
        }

        func createContent(with contact: EmailContact) -> Encodable {
            return TokenURLEmailWrapper(firstName: contact.firstName,
                                        lastName: contact.lastName,
                                        verificationCode: self.token,
                                        name: "\(contact.firstName!) \(contact.lastName!)"
            )
        }
    }

    struct ProfileInfo : Content {
        var name: String;
        var studentID: Int;
        var points: Int;
/*        var rankingNum = Int;
        var rankingPercent = Int;
        var rankingNumGrade = Int;
        var rankingPercentGrade = Int; */
        var grade: Int;
        var house: Int;
    }

    func fetchProfile(_ req: Request) async throws -> ProfileInfo {
        let userToken = try req.jwt.verify(as: UserToken.self);
        
        guard let studentUser = try await StudentUser.query(on: req.db)
                .join(User.self, on: \StudentUser.$user.$id == \User.$id)
                .filter(User.self, \.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }

        let both = try studentUser.joined(User.self);
        return ProfileInfo.init(
          name: both.name, studentID: studentUser.studentID, points: studentUser.points,
//          rankingNum: Int(1), rankingPercent: Int(1), rankingNumGrade: Int(1), rankingPercentGrade: 1,
          grade: (studentUser.grade ?? -1), house: (studentUser.house ?? -1)
        )
    }

    struct EditProfileInfo : Content {
        var name: String;
        var studentID: Int;
        var grade: Int;
        var house: Int;
    }

    func editProfile(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(EditProfileInfo.self);
        
        let userToken = try req.jwt.verify(as: UserToken.self);
        
        guard let studentUser = try await StudentUser.query(on: req.db)
                .with(\.$user)
                .filter(\.$user.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }

        studentUser.user.name = args.name;
        studentUser.studentID = args.studentID;
        studentUser.grade = args.grade;
        studentUser.house = args.house;

        try await studentUser.user.save(on: req.db);
        try await studentUser.save(on: req.db);

        return Msg(success: true, msg: "Edited Profile!")
    }

    struct EventInfo : Content {
        var id: Int;
        var name: String;
        var eventType: String;
        var locationName: String;
        var pointsWorth: Int;
        var startDate: Date;
        var endDate: Date;
    }
    
    func fetchEvents(_ req: Request) async throws -> [EventInfo] {
        let currentDate = Date()
        
        let events = try await Events.query(on: req.db)
          .join(Location.self, on: \Events.$location.$id == \Location.$id)
          .filter(Events.self, \.$endDate >= currentDate)
          .sort(Events.self, \.$startDate)
          .field(Events.self, \.$id)
          .field(Events.self, \.$name)
          .field(Events.self, \.$eventType)
          .field(Location.self, \.$locationName)
          .field(Events.self, \.$pointsWorth)
          .field(Events.self, \.$startDate)
          .field(Events.self, \.$endDate)
          .all()
          .map { ev in
              let both = try ev.joined(Location.self);
              return EventInfo.init(id: ev.id!, name: ev.name, eventType: ev.eventType, locationName: both.locationName, pointsWorth: ev.pointsWorth, startDate: ev.startDate, endDate: ev.endDate)
          };

        return events;
    }

    struct FullEventInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var eventType: String;
        var locationName: String;
        var address: String;
        var pointsWorth: Int;
        var startDate: Date;
        var endDate: Date;
    }

    func fetchEvent(_ req: Request) async throws -> FullEventInfo {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        guard let event = try await Events.query(on: req.db)
          .join(Location.self, on: \Events.$location.$id == \Location.$id)
          .filter(\.$id == id)
          .first()
        else {
            throw Abort(.badRequest);
        }
        
        let both = try event.joined(Location.self);
        return FullEventInfo.init(id: event.id!, name: event.name, description: event.description, eventType: event.eventType, locationName: both.locationName, address: both.address, pointsWorth: event.pointsWorth, startDate: event.startDate, endDate: event.endDate)
    }
    
    struct EventCheckinQuery : Content {
        var latitude: Double;
        var longitude: Double;
        var accuracy: Double;
        var deviceUUID: String;
    }

    func checkInEvent(_ req: Request) async throws -> Msg {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let args = try req.content.decode(EventCheckinQuery.self);

        if (args.accuracy > 1000) {
            return Msg(success: false, msg: "Location is too inacurate.");
        }

        let userToken = try req.jwt.verify(as: UserToken.self);

        guard let studentUser = try await StudentUser.query(on: req.db)
                .with(\.$user)
                .filter(\.$user.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }

        guard let event = try await Events.query(on: req.db).with(\.$location)
          .filter(\.$id == id)
          .first()
        else {
            throw Abort(.badRequest, reason: "Invalid Event ID.");
        }

        guard event.checkinType == .location else {
            return Msg(success: false, msg: "CheckInType is not location.");
        }

        guard event.startDate > Date() else {
            return Msg(success: false, msg: "Event has not started yet.")
        }

        guard event.endDate < Date() else {
            return Msg(success: false, msg: "Event has already ended.");
        }

        guard (LocationHelper.circlesIntersect(
              lat1: args.latitude,
              lon1: args.longitude,
              radius1: args.accuracy,
              lat2: Double(event.location.latitude),
              lon2: Double(event.location.longitude),
              radius2: Double(event.location.radius))) else {
            return Msg(success: false, msg: "You are not at the specified location!");
        }

        let eventCheckIns = try await EventCheckIns.query(on: req.db)
             .with(\.$user).with(\.$event)
             .filter(\.$event.$id == event.id!)
             .all();

        if (eventCheckIns.filter { $0.user.id == studentUser.user.id! }.count > 0) {
            return Msg(success: false, msg: "You have already checked into this event!");
        }

        if (eventCheckIns.filter { $0.deviceUUID == args.deviceUUID }.count > 0) {
            return Msg(success: false, msg: "This device already checked into this event. Don't spoof for your friends!");
        }

        let sixHoursAgo = Date(timeIntervalSinceNow: TimeInterval(6 * 60 * 60));

        if let deviceCheckIn = try await EventCheckIns.query(on: req.db)
          .with(\.$event)
          .filter(\.$deviceUUID == args.deviceUUID)
          .filter(\.$date < sixHoursAgo)
          .first() {
            let maxSpeed = 31.2928 // 70mph to meters per second
            let timeBetween = Date().timeIntervalSince(deviceCheckIn.date!);
            let maxDistanceCouldHaveTravelled = timeBetween * maxSpeed;
            
            if (LocationHelper.haversine(lat1: deviceCheckIn.latitude, lon1: deviceCheckIn.longitude, lat2: args.latitude, lon2: args.longitude) > maxDistanceCouldHaveTravelled) {
                return Msg(success: false, msg: "You could not have feasibly checked into this event and the last one considering the time difference. No spoofing!");
            }
        }

        studentUser.points = studentUser.points + event.pointsWorth;
        try await studentUser.save(on: req.db);

        let pointHistory = PointHistory(user: studentUser, reason: event.name, points: event.pointsWorth);
        try await pointHistory.save(on: req.db);

        let eventCheckIn = EventCheckIns(user: studentUser.user, event: event, deviceUUID: args.deviceUUID, latitude: args.latitude, longitude: args.longitude);
        try await eventCheckIn.save(on: req.db);

        return Msg(success: true, msg: "Checked into \(event.name)!");
    }

    struct ClubInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        // todo: revisit        var categories: [String];
    }

    func fetchClubs(_ req: Request) async throws -> [ClubInfo] {
        let clubs = try await Club.query(on: req.db)
          .all()
          .map { club in
              ClubInfo.init(id: club.id!, name: club.name, description: club.description)
          };

        return clubs;
    }

    struct FullClubInfo : Content {
        var name: String;
        var description: String;
        var sponsors: String;
        var meetingTimes: String?;
        var locationName: String?;
        var websiteLink: String?;
        var instagramLink: String?;
        var twitterLink: String?;
        var youtubeLink: String?;
    }

    func fetchClub(_ req: Request) async throws -> FullClubInfo {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let clubSponsors = try await ClubSponsorUser.query(on: req.db).with(\.$club).with(\.$user)
          .filter(\.$club.$id == id)
          .all();

        guard clubSponsors.count > 0 else {
            throw Abort(.badRequest, reason: "Club not found");
        }

        let club = clubSponsors[0].club;
       
        let clubInfo = FullClubInfo.init(name: club.name, description: club.description,
                                         sponsors: clubSponsors.map{ cS in
                                             cS.user.name
                                         }.joined(separator: ", "),
                                         meetingTimes: club.meetingTimes, locationName: club.locationName,
                                         websiteLink: club.websiteLink, instagramLink: club.instagramLink, twitterLink: club.twitterLink, youtubeLink: club.youtubeLink);
        
        return clubInfo; 
    }

    struct RewardInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var cost: Int;
    }

    func fetchRewards(_ req: Request) async throws -> [RewardInfo] {
        let userToken = try req.jwt.verify(as: UserToken.self);

        guard let studentUser = try await StudentUser.query(on: req.db)
                .with(\.$user)
                .filter(\.$user.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }

        
        let rewards = try await Reward.query(on: req.db).all();
        
        if let gradeFilter = studentUser.grade {
            let gradeFlag = [GradeFlags.freshman, GradeFlags.sophomore, GradeFlags.junior, GradeFlags.senior][gradeFilter - 9];
            
            let filteredRewards = rewards.filter { rew in
                (rew.allowedGrades & gradeFlag) != 0 }

            return filteredRewards.map { r in
                RewardInfo.init(id: r.id!, name: r.name, description: r.description, cost: r.cost )};
        }

        return rewards.map { r in
                RewardInfo.init(id: r.id!, name: r.name, description: r.description, cost: r.cost )};
    }

    func purchaseReward(_ req: Request) async throws -> Msg {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let userToken = try req.jwt.verify(as: UserToken.self);

        guard let studentUser = try await StudentUser.query(on: req.db)
                .with(\.$user)
                .filter(\.$user.$id == userToken.userId)
                .first()
        else {
            throw Abort(.unauthorized);
        }
        
        guard let reward = try await Reward.query(on: req.db).filter(\.$id == id).first() else {
            throw Abort(.badRequest, reason: "Invalid Reward ID.");
        };

        if (studentUser.points < reward.cost) {
            return Msg(success: false, msg: "Not enough points to purchase.");
        }

        if let gradeFilter = studentUser.grade {
            let gradeFlag = [GradeFlags.freshman, GradeFlags.sophomore, GradeFlags.junior, GradeFlags.senior][gradeFilter - 9];
            if ((reward.allowedGrades & gradeFlag) == 0) {
                return Msg(success: false, msg: "Selected grade level cannot purchase this reward.");
            }
        }

        studentUser.points = studentUser.points - reward.cost;
        try await studentUser.save(on: req.db);

        let pointHistory = PointHistory(user: studentUser, reason: "Purchased \(reward.id) \(reward.name)", points: -reward.cost);
        try await pointHistory.save(on: req.db);

        return Msg(success: true, msg: "Purchased \(reward.name)");
    }
}
