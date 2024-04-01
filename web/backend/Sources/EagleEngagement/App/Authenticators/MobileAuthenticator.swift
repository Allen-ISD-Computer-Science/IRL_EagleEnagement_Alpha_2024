import Fluent
import Vapor
import JWT

struct UserToken: Content, Authenticatable, JWTPayload {

    // Expiration - 8 Months;
    let expirationTime: TimeInterval = 60 * 60 * 24 * 31 * 8;

    // Token Data
    var expiration: ExpirationClaim
    var userId: Int
    var expiredNum: Int // Allows users to "Log out on all devices"

    init(userId: Int, expiredNum: Int) {
        self.userId = userId;
        self.expiredNum = expiredNum;
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    init(user: StudentUser) throws {
        self.userId = user.user.id!;
        self.expiredNum = user.expiredNum;
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

struct StudentUserAuthenticator : AsyncJWTAuthenticator {
    typealias Payload = UserToken;

    func authenticate(jwt: UserToken, for request: Request) async throws {
        let userOpt = try await StudentUser.query(on: request.db)
          .join(User.self, on: \StudentUser.$user.$id == \User.$id)
          .filter(User.self, \.$id == jwt.userId)
          .first();

        guard let user = userOpt else {
            throw Abort(.unauthorized);
        }
        
        guard user.expiredNum == jwt.expiredNum else {
            throw Abort(.unauthorized);
        }
        
        request.auth.login(jwt);
    }
    
}
