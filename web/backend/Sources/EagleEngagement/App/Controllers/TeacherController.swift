import Vapor
import Fluent
import Foundation

struct TeacherController : RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let teacherRoutes = routes.grouped("faculty");
        let sessionRoutes = teacherRoutes.grouped([User.sessionAuthenticator(), UserAuthenticator()])
        let teacherProtectedRoutes = sessionRoutes.grouped(TeacherMiddleware());

        let apiRoutes = teacherProtectedRoutes.grouped("api"); // /faculty/api
        apiRoutes.post("clubs", use: fetchClubs);
        apiRoutes.post("club", ":id", use: fetchClub);

        apiRoutes.post("requestEvent", use: requestEvent);
    }

    struct ClubInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var studentsFollowing: Int;
        var lastCheckInCount: Int;
        // todo: revisit        var categories: [String];
    }

    func fetchClubs(_ req: Request) async throws -> [ClubInfo] {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }
          
        let clubs = try await ClubSponsorUser.query(on: req.db)
          .with(\.$user)
          .with(\.$club)
          .filter(\.$user.$id == user.id!)
          .all()
          .map { clubSponsor in
              ClubInfo.init(id: clubSponsor.club.id!, name: clubSponsor.club.name, description: clubSponsor.club.description, studentsFollowing: 100, lastCheckInCount: 30)
          };

        return clubs;
    }

    struct FullClubInfo : Content {
        var name: String;
        var description: String;
        var studentsFollowing: Int;
        var meetingLogs: [MeetingInfo];
        var meetingTimes: String?;
        var locationName: String?;
        var websiteLink: String?;
        var instagramLink: String?;
        var twitterLink: String?;
        var youtubeLink: String?;
    }

    struct MeetingInfo : Content {
        var date: Date;
        var numberOfStudents: Int;
    }

    func fetchClub(_ req: Request) async throws -> FullClubInfo {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }

        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }
          
        let clubOpt = try await ClubSponsorUser.query(on: req.db)
          .with(\.$user)
          .with(\.$club)
          .filter(\.$user.$id == user.id!)
          .filter(\.$club.$id == id)
          .first()
          .map { cS in // clubSponsor
              FullClubInfo.init(
                name: cS.club.name, description: cS.club.description,
                studentsFollowing: 100, meetingLogs: [],
                meetingTimes: cS.club.meetingTimes, locationName: cS.club.locationName,
                websiteLink: cS.club.websiteLink, instagramLink: cS.club.instagramLink,
                twitterLink: cS.club.twitterLink, youtubeLink: cS.club.youtubeLink
              )
          };

        guard let club = clubOpt else {
            throw Abort(.badRequest, reason: "No club or unauthorized");
        }

        return club;
    }

    struct ManageClubInfo : Content {
        var id: Int;
        var name: String;
        var description: String;
        var meetingTimes: String?;
        var locationName: String?;
        var websiteLink: String?;
        var instagramLink: String?;
        var twitterLink: String?;
        var youtubeLink: String?;
        var logoFile: Data?;
        var thumbnailFile: Data?;
    }

    func newClub(_ req: Request) async throws -> Msg {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }

        let args = try req.content.decode(ManageClubInfo.self);

        let club = Club(
          name: args.name, description: args.description,
          meetingTimes: args.meetingTimes, locationName: args.locationName,
          websiteLink: args.websiteLink, instagramLink: args.instagramLink,
          twitterLink: args.twitterLink, youtubeLink: args.youtubeLink
        );

        try await club.save(on: req.db);

        let clubSponsor = ClubSponsorUser(user: user, club: club);
        try await clubSponsor.save(on: req.db);

        return Msg(success: true, msg: "Created Club");
    }

    func editClub(_ req: Request) async throws -> Msg {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }

        let args = try req.content.decode(ManageClubInfo.self);
          
        let clubSponsorOpt = try await ClubSponsorUser.query(on: req.db)
          .with(\.$user)
          .with(\.$club)
          .filter(\.$user.$id == user.id!)
          .filter(\.$club.$id == args.id)
          .first();
        
        guard let clubSponsor = clubSponsorOpt else {
            throw Abort(.badRequest, reason: "No club or unauthorized");
        }

        let club = clubSponsor.club;
        club.name = args.name;
        club.description = args.description;
        club.meetingTimes = args.meetingTimes;
        club.locationName = args.locationName;
        club.websiteLink = args.websiteLink;
        club.instagramLink = args.instagramLink;
        club.twitterLink = args.twitterLink;
        club.youtubeLink = args.youtubeLink;

        try await club.save(on: req.db);

        return Msg(success: true, msg: "Updated Club");
    }

    struct RequestQuery : Content {
        var name: String;
        var eventType: String;
        var description: String;
        var location: String;
        var startDate: Date;
        var endDate: Date;
    }

    func requestEvent(_ req: Request) async throws -> Msg {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }

        let args = try req.content.decode(RequestQuery.self);

        let eventRequest = EventRequest(name: args.name, description: args.description, eventType: args.eventType, location: args.location, startDate: args.startDate, endDate: args.endDate, userRequested: user.id!);

        try await eventRequest.save(on: req.db);

        return Msg(success: true, msg: "Make request!");
    }
    
}
