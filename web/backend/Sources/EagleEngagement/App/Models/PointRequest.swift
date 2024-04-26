import Vapor
import Fluent
import FluentMySQLDriver

public enum StatusType: String, Codable {
    case unseen,
         approved,
         denied
}

/// This class provides the model for a PointRequest
final public class PointRequest: Model, Content {
    // Name of the table or collection.
    public static let schema = "PointRequests"

    // Auto generated ID
    @ID(custom: "id", generatedBy: .database)
    public var id: Int?

    // userID linking to a User Object
    @Parent(key: "userID")
    public var user: StudentUser

    // eventID linking to an Event
    @Parent(key: "eventID")
    public var event: Events

    // Reason for the request
    @Field(key: "reason")
    public var reason: String

    // status based on admin
    @Enum(key: "status")
    public var status: StatusType

    // date the user made the request
    @Field(key: "date")
    public var date: Date

    // latitude the user made the request from (optional)
    @Field(key: "latitude")
    public var latitude: Float?

    // longitude the user made the request from (optional)
    @Field(key: "longitude")
    public var longitude: Float?

    // imagePath to the file the user uploaded (optional)
    @Field(key: "imagePath")
    public var imagePath: String?

    // Enables soft delete - for logs.
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    // Creates a new, empty PointRequest.
    public init() { }

    public init(userID: Int, eventID: Int, reason: String, imagePath: String?, latitude: Float?, longitude: Float?) {
        self.$user.id = userID;
        self.$event.id = eventID;
        self.reason = reason;
        self.date = Date();
        self.status = .unseen;
        self.latitude = latitude;
        self.longitude = longitude;
        self.imagePath = imagePath;
    }
}

