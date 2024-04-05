# Routes

This file explains all of the routes for the mobile and web API.

## Formatting

All data needs to be sent in JSON and all data will be received in JSON.

Any "Date" objects - sent or recieved, should be in ISO8601 format (`yyyy-MM-dd{T}HH:mm:ss.SSS{Z}` where anything inside {} is a constant).

## Mobile

### Authentication

```
POST /api/signup
firstName: String
lastName: String
email: String
studentID: INT

Returns: {success: Bool, msg: String}
```

```
POST /api/verify
email: String
token: String
password: String
passwordConfirm: String

Returns: {success: Bool, msg: String} - if success is true, msg is a JWT
```

```
POST /api/forgotPassword
email: String
studentID: Int

Returns { success: Bool, msg: String }
```

```
POST /api/login
email: String
password: String

Returns: {success: Bool, msg: String} - if success is true, msg is a JWT
```

```
POST /api/logOutAll

Returns: {success: Bool, msg: String}
```

### Data

**Important:** To receive data, all requests to an API must have an `Authorization: Bearer {token}` header. Without it or if the token is invalid, a 404 will be returned.

```
POST /api/profile

Returns: {name: String, studentID: Int, points: Int, grade: Int, house: Int} - If grade or house are nil, they will be represented as -1.
```

```
POST /api/profile/edit
name: String
studentID: Int
grade: Int
house: Int

Returns { success: Bool, msg: String }
```

```
POST /api/events

Returns: [{id: INT, name: String, eventType: String, locationName: String, pointsWorth: INT, startDate: Date, endDate: Date}]
```

^ Note: will not return events that have already passed.

```
POST /api/event/:id

Returns: {id: INT, name: String, eventType: String, descrition: String, locationName: String, address: String, pointsWorth: INT, startDate: Date, endDate: Date}
```

```
POST /api/clubs

Returns: [{id: INT, name: String, description: String}]
```

```
POST /api/club/:id

Returns { name: String, description: String, sponsors: String, meetingTimes: String?, locationName: String?, websiteLink: String?, instagramLink: String?, twitterLink: String?, youtubeLink: String? }
```

```
POST /api/rewards

Returns: [ { id: Int, name: String, description: String, cost: Int } ]
```

^ Note: if user's grade is set, is filtered on it

```
POST /api/reward/:id/purchase

Returns: { success: Bool, msg: String }
```

## Web

### Authentication

```
POST /signup
firstName: String
lastName: String
email: String

Returns: {success: Bool, msg: String}
```

```
POST /verify
emal: String
token: String
password: String
passwordConfirm: String

Returns: { success: Bool, msg: String }
```

```
POST /login
email: String
password: String

Returns { success: Bool, msg: String }
```

```
POST /forgotPassword
email: String

Returns { success: Bool, msg: String }
```

### Data

```
POST /isAdmin

Returns {value: Bool}
```

```
POST /admin/api/events
includePast: Bool
filterByName: String? - Don't have this as a key if no filter

Returns: [{id: Int, name: String, eventType: String, locationID: Int, locationName: String, pointsWorth: Int, startDate: Date, endDate: Date}]
```

```
POST /admin/api/event/:id

Returns: {id: Int, name: String, description: String, eventType: String, locationID: Int, locationName: String, pointsWorth: Int, startDate: Date, endDate: Date, customImagePath: String}
```

```
POST /admin/api/event/:id/checkIn
latitude: Double;
longitude: Double;
accuracy: Double;
deviceUUID: String;

Returns: { success: Bool, msg: String }
```

```
POST /admin/api/events/new
name: String
description: String
eventType: String
locationID: Int
pointsWorth: Int
startDate: Date
endDate: Date
customImagePath: String? - Don't have this key if no custom path

Returns {success: Bool, msg: String}
```

```
POST /admin/api/events/edit/:id
name: String
description: String
eventType: String
locationID: Int
pointsWorth: Int
startDate: Date
endDate: Date
customImagePath: String? - Don't have this key if no custom path

Returns {success: Bool, msg: String}
```

---

```
POST /admin/api/eventRequests

Returns [{id: Int, name: String, eventType: String, location: String, userRequested: String, startDate: Date, endDate: Date}]
```

```
POST /admin/api/eventRequest/:id

Returns {name: String, description: String eventType: String, location: String, userRequested: String, startDate: Date, endDate: Date}
```

```
POST /admin/api/eventRequest/:id/delete

Returns { success: Bool, msg: String }
```


---

```
POST /admin/api/locations
filterByName: String? - Don't have this as a key if no filter

Returns: [{ id: Int, name: String, description: String, address: String }]
```

```
POST /admin/api/location/:id

Returns: { id: Int, name: String, description: String, address: String, latitude: Float, longitude: Float, radius: Float }
```

```
POST /admin/api/locations/new
locationName: String
description: String
address: String
latitude: Float
longitude: Float
radius: Float

Returns: { success: Bool, msg: String }
```

```
POST /admin/api/location/:id/edit
locationName: String
description: String
address: String
latitude: Float
longitude: Float
radius: Float

Returns: { success: Bool, msg: String }
```

---

```
POST /admin/api/users
filter: String? - Don't have this as a key if no filter

Returns [{ id: Int, studentID: int, name: String, grade: Int?, house: Int?, points: Int }]
```

```
POST /admin/api/users/estimateCount
mode: String
grade: [Int]
house: [Int]

Returns: { amount: Int }
```

^ This gives a count of how many users fit into this classification

```
POST /admin/api/users/modifyPoints
mode: String
grade: [Int]
house: [Int]
points: Int
reason: String

Returns: { success: Bool, msg: String }
```

```
POST /admin/api/user/:id/modifyPoints
points: Int;
reason: String;

Returns { success: Bool, msg: String }
```

```
POST /faculty/api/clubs

Returns [{ id: Int, name: String, description: String, studentsFollowing: Int, lastCheckInCount: Int }]
```

```
POST /faculty/api/club/:id

Returns: { name: String, description: String, studentsFollowing: Int, meetingLogs: [{ date: Date, numberOfStudents: Int }], meetingTimes: String?, locationName: String?, websiteLink: String?, instagramLink: String?, twitterLink: String?, youtubeLink: String? }
```

```
POST /faculty/api/club:id
name: String
description: String
eventType: String
location: String
startDate: Date
endDate: Date

Returns { success: Bool, msg: String }
```

```
POST /faculty/api/requestEvent
name: String;
eventType: String;
description: String;
location: String;
startDate: Date;
endDate: Date;

Returns { success: Bool, msg: String }
```
