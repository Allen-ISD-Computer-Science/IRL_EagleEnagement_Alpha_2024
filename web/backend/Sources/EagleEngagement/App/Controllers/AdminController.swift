import Vapor
import Fluent
import Foundation

struct AdminController : RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let adminRoutes = routes.grouped("admin");
        let sessionRoutes = adminRoutes.grouped([User.sessionAuthenticator(), UserAuthenticator()])
        let adminProtectedRoutes = sessionRoutes.grouped(AdminMiddleware());

        // React Pages are "GET" requests
        adminProtectedRoutes.get("users", use: serveIndex);
        
        adminProtectedRoutes.get("events", use: serveIndex);
        adminProtectedRoutes.get("events", "new", use: serveIndex);
        adminProtectedRoutes.get("events", "edit", ":id", use:serveIndex);
        
        adminProtectedRoutes.get("locations", use: serveIndex);
        adminProtectedRoutes.get("locations", "new", use: serveIndex);
        adminProtectedRoutes.get("locations", "edit", ":id", use:serveIndex);
        
        adminProtectedRoutes.get("rewards", use: serveIndex);
        adminProtectedRoutes.get("rewards", "new", use: serveIndex);
        adminProtectedRoutes.get("rewards", "edit", ":id", use:serveIndex);

        adminProtectedRoutes.get("event-requests", use: serveIndex);
        adminProtectedRoutes.get("review-checkins", use: serveIndex);
        adminProtectedRoutes.get("review-missing-points", use: serveIndex);

        let apiRoutes = adminProtectedRoutes.grouped("api"); // /admin/api
        apiRoutes.post("eventTypes", use: fetchEventTypes);

        apiRoutes.post("users", use: fetchUsers);
        apiRoutes.post("users", "modify", use: modifyUsers);
        apiRoutes.post("users", "estimateCount", use: estimateCount);
        apiRoutes.post("user", ":id", "modifyPoints", use: modifyUser);

        apiRoutes.post("events", use: fetchEvents);
        apiRoutes.post("event", ":id", use: fetchEvent);
        apiRoutes.post("event", ":id", "edit", use: editEvent);
        apiRoutes.post("events", "new", use: newEvent);

        apiRoutes.post("eventRequests", use: fetchEventRequests);
        apiRoutes.post("eventRequest", ":id", use: fetchEventRequest);
        apiRoutes.post("eventRequest", ":id", "delete", use: removeEventRequest)

        apiRoutes.post("locations", use: fetchLocations);
        apiRoutes.post("location", ":id", use: fetchLocation);
        apiRoutes.post("location", ":id", "edit", use: editLocation);
        apiRoutes.post("locations", "new", use: newLocation);

        apiRoutes.post("rewards", use: fetchRewards);
        apiRoutes.post("reward", ":id", use: fetchReward);
        apiRoutes.post("reward", ":id", "edit", use: editReward);
        apiRoutes.post("rewards", "new", use: newReward);
    }

    // Serves the react page
    func serveIndex(_ req: Request) async throws -> View {
        return try await req.view.render("index.html")
    }

    // Returns event types without duplicates (using Set).
    func fetchEventTypes(_ req: Request) async throws -> [String] {
        let eventTypes = try await Events.query(on: req.db)
          .field(\.$eventType)
          .all()
          .map { ev in
              ev.eventType
          };

        return Array<String>(Set<String>(eventTypes));
    }

    struct UsersQuery : Content {
        var filter: String?;
    }

    struct StudentUserInfo : Content {
        var id: Int;
        var studentID: Int;
        var name: String;
        var grade: Int?;
        var house: Int?;
        var points: Int;
    }
    
    func fetchUsers(_ req: Request) async throws -> [StudentUserInfo] {
        let args = try req.content.decode(UsersQuery.self);

        let studentUsers = try await StudentUser.query(on: req.db).with(\.$user)
          .all()
          .map { studentUser in
              StudentUserInfo.init(id: studentUser.user.id!, studentID: studentUser.studentID, name: studentUser.user.name, grade: studentUser.grade, house: studentUser.house, points: studentUser.points);
          }

        if let fil = args.filter {
            let filter = fil.uppercased();
            let filteredUsers = studentUsers.filter {
                $0.name.uppercased().contains(filter) ||
                  String($0.studentID).contains(filter)
            }

            return filteredUsers;
        }

        return studentUsers;
    }

    struct EstimationQuery : Content {
        var mode: String;
        var grade: [Int];
        var house: [Int];
    }

    struct Estimation : Content {
        var amount: Int
    }
    
    func estimateCount(_ req: Request) async throws -> Estimation {
        let args = try req.content.decode(EstimationQuery.self);
        
        let studentUsers = try await StudentUser.query(on: req.db).with(\.$user);
        var studentUserCount = 0;
        
        if (args.grade.count > 0 && args.house.count > 0) {
            studentUserCount = try await studentUsers
              .group(args.mode == "or" ? .or : .and) { opt in
                  opt.filter(\.$grade ~~ args.grade).filter(\.$house ~~ args.house)
              }
              .count();
        } else if (args.grade.count > 0) {
            studentUserCount = try await studentUsers
              .filter(\.$grade ~~ args.grade)
              .count();
        } else if (args.house.count > 0) {
            studentUserCount = try await studentUsers
              .filter(\.$house ~~ args.house)
              .count();
        } else {
            studentUserCount = try await studentUsers.count();
        }
        
        return Estimation.init(amount: studentUserCount);
    }

    struct ModifyQuery : Content {
        var mode: String;
        var grade: [Int];
        var house: [Int];
        var points: Int;
        var reason: String;
    }

    func modifyUsers(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(ModifyQuery.self);

        var studentUsers : [StudentUser];
        if (args.grade.count > 0 && args.house.count > 0) {
            studentUsers = try await StudentUser.query(on: req.db).with(\.$user)
              .group(args.mode == "or" ? .or : .and) { opt in
                  opt.filter(\.$grade ~~ args.grade).filter(\.$house ~~ args.house)
              }
              .all();
        } else if (args.grade.count > 0) {
            studentUsers = try await StudentUser.query(on: req.db).with(\.$user)
              .filter(\.$grade ~~ args.grade)
              .all();
        } else if (args.house.count > 0) {
            studentUsers = try await StudentUser.query(on: req.db).with(\.$user)
              .filter(\.$house ~~ args.house)
              .all();
        } else {
            studentUsers = try await StudentUser.query(on: req.db).with(\.$user).all();
        }

        for sUser in studentUsers {
            let pointHistory = PointHistory(user: sUser, reason: args.reason, points: args.points);
            try await pointHistory.save(on: req.db);
            
            sUser.points = sUser.points + args.points;
            try await sUser.save(on: req.db);
        }

        return Msg(success: true, msg: "Updated \(studentUsers.count) users.");
    }

    struct ModifyUserQuery : Content {
        var points: Int;
        var reason: String;
    }

    func modifyUser(_ req: Request) async throws -> Msg {
        guard let userID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let args = try req.content.decode(ModifyUserQuery.self);

        guard let studentUser = try await StudentUser.query(on: req.db).with(\.$user)
          .filter(\.$user.$id == userID)
          .first() else {
            throw Abort(.badRequest);
        }

        let pointHistory = PointHistory(user: studentUser, reason: args.reason, points: args.points);
        try await pointHistory.save(on: req.db);
        
        studentUser.points = studentUser.points + args.points;
        try await studentUser.save(on: req.db);

        return Msg(success: true, msg: "Updated \(studentUser.user.name)!");
    }

    struct EventsQuery : Content {
        var includePast: Bool;
        var filterByName: String?;
    }

    struct EventInfo : Content {
        var id: Int;
        var name: String;
        var eventType: String;
        var locationID: Int;
        var locationName: String;
        var pointsWorth: Int;
        var startDate: Date;
        var endDate: Date;
    }

    func fetchEvents(_ req: Request) async throws -> [EventInfo] {
        let eventsQuery = try req.content.decode(EventsQuery.self);
        let includePast = eventsQuery.includePast;
               
        if (includePast) {
            let events = try await Events.query(on: req.db).with(\.$location)
              .sort(Events.self, \.$startDate)
              .all()
              .map { ev in
                  // fetch data and cast it into the EventInfo struct to make it more easily readable and returnable
                  return EventInfo.init(id: ev.id!, name: ev.name, eventType: ev.eventType, locationID: ev.location.id!, locationName: ev.location.locationName, pointsWorth: ev.pointsWorth, startDate: ev.startDate, endDate: ev.endDate)
              };

            if (eventsQuery.filterByName == nil || eventsQuery.filterByName!.isEmpty) {
                return events;
            }

            return events.filter({
                                     $0.name.lowercased().contains(eventsQuery.filterByName!.lowercased());
                                 });
        } else {
            // fetch events that only occurred after the current date
            let currentDate = Date()

            let events = try await Events.query(on: req.db).with(\.$location)
              .filter(Events.self, \.$endDate >= currentDate)
              .sort(Events.self, \.$startDate)
              .all()
              .map { ev in
                  return EventInfo.init(id: ev.id!, name: ev.name, eventType: ev.eventType, locationID: ev.location.id!, locationName: ev.location.locationName, pointsWorth: ev.pointsWorth, startDate: ev.startDate, endDate: ev.endDate)
              };

            if (eventsQuery.filterByName == nil || eventsQuery.filterByName!.isEmpty) {
                return events;
            }

            return events.filter({
                                     $0.name.lowercased().contains(eventsQuery.filterByName!.lowercased());
                                 });
        }
    }

    struct FullEventInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var eventType: String;
        var checkinType: String;
        var locationID: Int;
        var locationName: String;
        var pointsWorth: Int;
        var startDate: Date;
        var endDate: Date;
        var customImagePath: String;
    }

    func fetchEvent(_ req: Request) async throws -> FullEventInfo { // /admin/api/event/:id
        guard let eventID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
 
        let event = try await Events.query(on: req.db).with(\.$location)
          .filter(\Events.$id == eventID)
          .first()
          .map { ev in
              return FullEventInfo.init(id: ev.id!, name: ev.name, description: ev.description, eventType: ev.eventType, checkinType: ev.checkinType.rawValue, locationID: ev.location.id!, locationName: ev.location.locationName, pointsWorth: ev.pointsWorth, startDate: ev.startDate, endDate: ev.endDate, customImagePath: ev.customImagePath)
          };

        if (event == nil) {
            throw Abort(.badRequest, reason: "Event could not be found");
        }

        return event!;

    }

    struct ManageEventInfo : Content {
        var name: String;
        var description: String;
        var eventType: String;
        var checkinType: String;
        var locationID: Int;
        var pointsWorth: Int;
        var startDate: Date;
        var endDate: Date;
        var customImagePath: String?;
    }

    func newEvent(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(ManageEventInfo.self);

        if (!["location", "manual", "photo"].contains(args.checkinType)) {
            throw Abort(.badRequest, reason: "Invalid checkinType!");
        }

        let event = Events(name: args.name, description: args.description, eventType: args.eventType, checkinType: CheckinType(rawValue: args.checkinType)!, locationID: args.locationID, pointsWorth: args.pointsWorth, startDate: args.startDate, endDate: args.endDate, customImagePath: args.customImagePath ?? "");

        try await event.save(on: req.db);

        return Msg(success: true, msg: "Created Event!");
    }

    func editEvent(_ req: Request) async throws -> Msg {
        guard let eventID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
 
        guard let event = try await Events.query(on: req.db)
          .with(\.$location)
          .filter(\.$id == eventID)
          .first() else {
            throw Abort(.badRequest, reason: "Could not find event.")
        }
        
        let args = try req.content.decode(ManageEventInfo.self);

        if (!["location", "manual", "photo"].contains(args.checkinType)) {
            throw Abort(.badRequest, reason: "Invalid checkinType!");
        }
        
        event.name = args.name;
        event.description = args.description;
        event.eventType = args.eventType;
        event.checkinType = CheckinType(rawValue: args.checkinType)!;
        event.location.id = args.locationID;
        event.pointsWorth = args.pointsWorth;
        event.startDate = args.startDate;
        event.endDate = args.endDate;
        if let customImagePath = args.customImagePath {
            event.customImagePath = customImagePath;
        } else {
            event.customImagePath = "";
        }
        
        try await event.save(on: req.db);

        return Msg(success: true, msg: "Updated Event!");
    }

    struct EventRequestInfo : Content {
        var id: Int;
        var name: String;
        var eventType: String;
        var location: String;
        var userRequested: String;
        var startDate: Date;
        var endDate: Date;
    }
    
    func fetchEventRequests(_ req: Request) async throws -> [EventRequestInfo] {
        let requests = try await EventRequest.query(on: req.db).with(\.$user).all().map { eReq in
            EventRequestInfo.init(id: eReq.id!, name: eReq.name, eventType: eReq.eventType, location: eReq.location, userRequested: eReq.user.name, startDate: eReq.startDate, endDate: eReq.endDate);
        };

        return requests;
    }

    struct FullEventRequestInfo : Content {
        var name: String;
        var description: String;
        var eventType: String;
        var location: String;
        var userRequested: String;
        var startDate: Date;
        var endDate: Date;
    }

    func fetchEventRequest(_ req: Request) async throws -> FullEventRequestInfo {
        guard let requestID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }        
        
        guard let request = try await EventRequest.query(on: req.db).with(\.$user).filter(\.$id == requestID).first() else {
            throw Abort(.badRequest);
        };

        return FullEventRequestInfo.init(
          name: request.name,
          description: request.description,
          eventType: request.eventType,
          location: request.location,
          userRequested: request.user.name,
          startDate: request.startDate,
          endDate: request.endDate
        );
    }

    /**
     We do not need an "accept" route because acceptance will be handled by the frontend and then the request will still be removed. This route simply removes the entry.
     */
    func removeEventRequest(_ req: Request) async throws -> Msg {
        guard let requestID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        guard let request = try await EventRequest.query(on: req.db).with(\.$user).filter(\.$id == requestID).first() else {
            throw Abort(.badRequest);
        };

        try await request.delete(on: req.db);

        return Msg(success: true, msg: "Removed request \(requestID)");
    }

    struct LocationQuery : Content {
        var filterByName: String?;
    }

    struct LocationInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var address: String;
    }

    func fetchLocations(_ req: Request) async throws -> [LocationInfo] {
        let locationQuery = try req.content.decode(LocationQuery.self);
        
        let locations = try await Location.query(on: req.db)
          .all()
          .map { loc in
              LocationInfo.init(id: loc.id!, name: loc.locationName, description: loc.description, address: loc.address);
          };
        
        if (locationQuery.filterByName == nil || locationQuery.filterByName!.isEmpty) {
            return locations;
        }
        
        return locations.filter({
                                    $0.name.lowercased().contains(locationQuery.filterByName!.lowercased());
                             });
    }

    func fetchLocation(_ req: Request) async throws -> Location {
        guard let locationID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
 
        guard let location = try await Location.query(on: req.db)
          .filter(\.$id == locationID)
          .first() else {
            throw Abort(.badRequest, reason: "Could not find location.")
        }

        return location;
    }

    struct ManageLocationInfo : Content {
        var locationName: String;
        var description: String;
        var address: String;
        var latitude: Float;
        var longitude: Float;
        var radius: Float;
    }
    
    func newLocation(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(ManageLocationInfo.self);

        let location = Location(name: args.locationName, description: args.description, address: args.address, latitude: args.latitude, longitude: args.longitude, radius: args.radius);
        
        try await location.save(on: req.db);

        return Msg(success: true, msg: "Created Location!");
    }

    func editLocation(_ req: Request) async throws -> Msg {
        guard let locationID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let args = try req.content.decode(ManageLocationInfo.self);
 
        guard let location = try await Location.query(on: req.db)
          .filter(\.$id == locationID)
          .first() else {
            throw Abort(.badRequest, reason: "Could not find location.")
        }

        location.locationName = args.locationName;
        location.description = args.description;
        location.address = args.address;
        location.latitude = args.latitude;
        location.longitude = args.longitude;
        location.radius = args.radius;
        
        try await location.save(on: req.db);

        return Msg(success: true, msg: "Updated Locations!");
    }

    struct RewardQuery : Content {
        var filterByName: String?;
    }

    struct RewardInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var cost: Int;
        var allowedGrades: Int;
    }

    func fetchRewards(_ req: Request) async throws -> [RewardInfo] {
        let rewardQuery = try req.content.decode(RewardQuery.self);
        
        let rewards = try await Reward.query(on: req.db)
          .all()
          .map { rew in
              RewardInfo.init(id: rew.id!, name: rew.name, description: rew.description, cost: rew.cost, allowedGrades: rew.allowedGrades);
          };
        
        if (rewardQuery.filterByName == nil || rewardQuery.filterByName!.isEmpty) {
            return rewards;
        }
        
        return rewards.filter({
                                    $0.name.lowercased().contains(rewardQuery.filterByName!.lowercased());
                             });
    }

    func fetchReward(_ req: Request) async throws -> Reward {
        guard let rewardID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
 
        guard let reward = try await Reward.query(on: req.db)
          .filter(\.$id == rewardID)
          .first() else {
            throw Abort(.badRequest, reason: "Could not find reward.")
        }

        return reward;
    }

    struct ManageRewardInfo : Content {
        var name: String;
        var description: String;
        var cost: Int;
        var allowedGrades: Int;
    }
    
    func newReward(_ req: Request) async throws -> Msg {
        let args = try req.content.decode(ManageRewardInfo.self);

        let reward = Reward(name: args.name, description: args.description, cost: args.cost, allowedGrades: args.allowedGrades);
        
        try await reward.save(on: req.db);

        return Msg(success: true, msg: "Created Reward!");
    }

    func editReward(_ req: Request) async throws -> Msg {
        guard let rewardID = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        let args = try req.content.decode(ManageRewardInfo.self);
 
        guard let reward = try await Reward.query(on: req.db)
          .filter(\.$id == rewardID)
          .first() else {
            throw Abort(.badRequest, reason: "Could not find reward.")
        }

        reward.name = args.name;
        reward.description = args.description;
        reward.cost = args.cost;
        reward.allowedGrades = args.allowedGrades;
        
        try await reward.save(on: req.db);

        return Msg(success: true, msg: "Updated Reward!");
    }
    
}
