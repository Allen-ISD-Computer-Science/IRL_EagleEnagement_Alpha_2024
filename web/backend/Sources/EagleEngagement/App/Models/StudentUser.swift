import Vapor
import Fluent
import FluentMySQLDriver

/// This class provides the model for an Employee
final public class StudentUser: Model, Content {
    // Name of the table or collection.
    public static let schema = "StudentUsers"
    
    /// Unique identifier for this StudentUser
    @ID(custom: "id", generatedBy: .database)
    public var id: Int?

    // Reference to the User
    @Parent(key: "userID")
    public var user: User

    // Student ID associated with the StudentUser account
    @Field(key: "studentID")
    public var studentID: Int

    // Number of points the studentUser has
    @Field(key: "points")
    public var points: Int

    // Grade of the studentUser
    @Field(key: "grade")
    public var grade: Int?

    // House of the studentUser
    @Field(key: "house")
    public var house: Int?

    // Used for "log out of all devices"
    @Field(key: "expiredNum")
    public var expiredNum: Int;
    
    // Creates a new, empty User.
    public init() { }

    public init(userID: Int, studentID: Int) {
        print("Init StudentUser: \(userID) | \(studentID)");
        self.studentID = studentID;
        self.$user.id = userID;
    }
}
