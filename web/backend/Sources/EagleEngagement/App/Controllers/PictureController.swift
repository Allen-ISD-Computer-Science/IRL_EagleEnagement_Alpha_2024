import Vapor
import Fluent
import Foundation

struct PictureController : RouteCollection {
    func storagePath() -> String {
        guard let path = Environment.get("STORAGE_PERMANENT_PATH") else {
            fatalError("Failed to determine STORAGE_PERMANENT_PATH from environment");
        }
        return path;
    }
    
    //    let fileManager = NSFileManager.defaultManager()
    
    func boot(routes: RoutesBuilder) throws {            
        let pictureRoutes = routes.grouped("pictures");
        
        let sessionRoutes = pictureRoutes.grouped([User.sessionAuthenticator(), UserAuthenticator()])
        let teacherProtectedRoutes = sessionRoutes.grouped(TeacherMiddleware());

        teacherProtectedRoutes.get("clubLogos", ":id", use: clubLogo);
        teacherProtectedRoutes.get("clubThumbnails", ":id", use: clubThumbnail);
        teacherProtectedRoutes.post("clubLogos", ":id", "upload", use: uploadClubLogo);
        teacherProtectedRoutes.post("clubThumbnails", ":id", "upload", use: uploadClubThumbnail);

        let studentProtectedRoutes = pictureRoutes.grouped("api").grouped([UserToken.authenticator(), StudentUserAuthenticator(), UserToken.guardMiddleware()])

        studentProtectedRoutes.get("clubLogos", ":id", use: clubLogo);
        studentProtectedRoutes.get("clubThumbnails", ":id", use: clubThumbnail);
    }

    func clubLogo(_ req: Request) async throws -> Response {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        return try await req.fileio.streamFile(at: "\(storagePath())/clubLogos/\(id)");
    }

    func clubThumbnail(_ req: Request) async throws -> Response {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        return try await req.fileio.streamFile(at: "\(storagePath())/clubThumbnails/\(id)");
    }

    struct ImageUploadData: Content {
        var picture: Data
    }

    func uploadClubLogo(_ req: Request) async throws -> Msg {
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
        
        guard let club = clubOpt else {
            throw Abort(.badRequest, reason: "No club or unauthorized");
        }
        
        let data = try req.content.decode(ImageUploadData.self)

        try await req.fileio.writeFile(.init(data: data.picture), at: "\(storagePath())/clubLogos/\(id)");

        return Msg(success: true, msg: "\(club.club.name)'s Logo Updated!");
    }

    func uploadClubThumbnail(_ req: Request) async throws -> Msg {
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
        
        guard let club = clubOpt else {
            throw Abort(.badRequest, reason: "No club or unauthorized");
        }
        
        let data = try req.content.decode(ImageUploadData.self)

        try await req.fileio.writeFile(.init(data: data.picture), at: "\(storagePath())/clubThumbnails/\(id)");

        return Msg(success: true, msg: "\(club.club.name)'s Thumbnail Updated!");
    }
}
