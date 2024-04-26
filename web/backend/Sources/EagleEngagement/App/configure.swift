/*
VaporShell provides a minimal framework for starting Vapor projects.
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

import JWT
import FCM
import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
func configure(_ app: Application) throws {
    // UNCOMMENT-PUBLIC to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)
    
    let mysqlHost = Environment.get("MYSQL_HOSTNAME") ?? "db";
    let mysqlPortStr = Environment.get("MYSQL_PORT") ?? "3306";
    guard let mysqlPort = Int(mysqlPortStr) else {
        fatalError("Failed to determine MYSQL_PORT from environment (NaN)");
    }
    guard let mysqlUser = Environment.get("MYSQL_USERNAME") else {
        fatalError("Failed to determine MYSQL_USERNAME from environment");
    }
    guard let mysqlPass = Environment.get("MYSQL_PASSWORD") else {
        fatalError("Failed to determine MYSQL_PASSWORD from environment");
    }
    guard let mysqlDBName = Environment.get("MYSQL_DATABASE") else {
        fatalError("Failed to determine MYSQL_DATABASE from environment");
    }

    guard let jwtSecret = Environment.get("JWT_SECRET") else {
        fatalError("Failed to determine JWT_SECRET from environment");
    }

    app.jwt.signers.use(.hs256(key: jwtSecret));

    app.fcm.configuration = .envServiceAccountKeyFields;
    
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    app.databases.use(.mysql(
                        hostname: mysqlHost,
                        port: mysqlPort,
                        username: mysqlUser,
                        password: mysqlPass,
                        database: mysqlDBName,
                        tlsConfiguration: tls
                      ), as: .mysql)

    // Set local port
    guard let portString = Environment.get("VAPOR_LOCAL_PORT"),
          let port = Int(portString) else {
        fatalError("Failed to determine VAPOR LOCAL PORT from environment")
    }
    app.http.server.configuration.port = port

    // Set local host
    guard let hostname = Environment.get("VAPOR_LOCAL_HOST") else {
        fatalError("Failed to determine VAPOR LOCAL HOST from environment")
    }
    app.http.server.configuration.hostname = hostname

    app.routes.defaultMaxBodySize = "2mb"

    // register routes
    try routes(app)
}
