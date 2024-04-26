import Vapor
import Fluent
import FluentMySQLDriver

/// This class provides the model for a ClubFollowerUser
final public class PointHistory: Model, Content {
    // Name of the table or collection.
    public static let schema = "PointHistories"

    @ID(custom: "id", generatedBy: .database)
    public var id: Int?

    // userID to be associated with the point modification
    @Parent(key: "userID")
    public var user: StudentUser

    // reason for the point modification
    @Field(key: "reason")
    public var reason: String

    // Amount of points added or removed
    @Field(key: "points")
    public var points: Int

    @Timestamp(key: "date", on: .create)
    var madeAt: Date?
    
    // Creates a new, empty PointHistory
    public init() { }

    public init(user: User, reason: String, points: Int) {
        self.$user.id = user.id!;
        self.reason = reason;
        self.points = points;
    }
}
