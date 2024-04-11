/*
VaporShell provides a minimal framework for starting Igis projects.
Copyright (C) 2021, 2022 CoderMerlin.com
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import Vapor
import Fluent
import FluentMySQLDriver

func routes(_ app: Application) throws {
    
    func serveIndex(_ req: Request) async throws -> View {
        return try await req.view.render("index.html")
    }
    
    app.get { req in
        return try await serveIndex(req)
    }

    let sessionRoutes = app.grouped([User.sessionAuthenticator(), UserAuthenticator()])
    
    sessionRoutes.get("login") { req in
        return try await serveIndex(req);
    }

    sessionRoutes.get("signup") { req in                
        return try await serveIndex(req)
    }

    sessionRoutes.get("verify") { req in
        return try await serveIndex(req);
    }
    
    sessionRoutes.post("login") { req -> Msg in
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }
        req.session.authenticate(user)
        return Msg(success: true, msg: "authenticated");
    }

    let teacherSignUp = TeacherSignUp();
    sessionRoutes.post("signup") { req -> Msg in
        return try await teacherSignUp.signUp(req);
    };

    let teacherForgot = TeacherForgotPassword();
    sessionRoutes.post("forgotPassword") { req -> Msg in
        return try await teacherForgot.forgotPassword(req);
    }

    sessionRoutes.get("logout") { req in
        req.session.destroy();

        guard let vaporPublic = Environment.get("VAPOR_SERVER_PUBLIC_URL") else {
                fatalError("Failed to determine VAPOR_SERVER_PUBIC_URL from environment");
        }
        
        return req.redirect(to: vaporPublic + "/login")
    };

    let teacherProtectedRoutes = sessionRoutes.grouped(TeacherMiddleware());

    struct IsAdmin : Content {
        var value: Bool;
    }
    
    teacherProtectedRoutes.get("isAdmin") { req in
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized);
        }

        return IsAdmin(value: user.userType == .admin);
    }
    
    teacherProtectedRoutes.get("dashboard") { req in
        return try await serveIndex(req)        
    }

    teacherProtectedRoutes.get("clubs", "new") { req in
        return try await serveIndex(req)        
    }

    teacherProtectedRoutes.get("club", ":clubId") { req in
        return try await serveIndex(req)        
    }

    teacherProtectedRoutes.get("club", "edit", ":clubId") { req in
        return try await serveIndex(req)        
    }

    teacherProtectedRoutes.get("event-request") { req in
        return try await serveIndex(req)        
    }

    try app.register(collection: AdminController())
    try app.register(collection: TeacherController())
    try app.register(collection: StudentController())
    try app.register(collection: PictureController())
}
