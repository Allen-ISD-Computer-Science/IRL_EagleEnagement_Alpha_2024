import Vapor
import Fluent
import Foundation
import FluentMySQLDriver

/// This class provides the model for a PointRequest
final public class EventRequest: Model, Content {
    // Name of the table or collection.
    public static let schema = "EventRequests"

    /// Unique identifier for this Event.
    @ID(custom: "id", generatedBy: .database)
    public var id: Int?

    // userID linking to a User Object
    @Parent(key: "userID")
    public var user: User

    // Name the requested event
    @Field(key: "name")
    public var name: String
    
    // Description the requested event
    @Field(key: "description")
    public var description: String

    // type the requested event
    @Field(key: "eventType")
    public var eventType: String
    
    // location the requested event
    @Field(key: "location")
    public var location: String
    
    // start date the requested event
    @Field(key: "startDate")
    public var startDate: Date

    // end date the requested event
    @Field(key: "endDate")
    public var endDate: Date

    // Enables soft delete - for logs.
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    // Creates a new, empty PointRequest.
    public init() { }

    public init(name: String, description: String, eventType: String, location: String, startDate: Date, endDate: Date, userRequested: Int) {
        self.name = name;
        self.description = description;
        self.eventType = eventType;
        self.location = location;
        self.startDate = startDate;
        self.endDate = endDate;
        self.$user.id = userRequested;
    }
}
