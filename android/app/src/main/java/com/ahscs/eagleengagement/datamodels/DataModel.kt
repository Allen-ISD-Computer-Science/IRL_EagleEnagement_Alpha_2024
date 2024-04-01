package com.ahscs.eagleengagement.datamodels

import java.util.Date

sealed class DataModel {
    // data models for getting and posting non authentication
    data class ProfileResponse(
        var name: String,
        var studentID: Int,
        var points: Int,
        var grade: Int,
        var house: Int
    ) : DataModel()

    data class EditProfile(
        var name: String,
        var studentID: Int,
        var grade: Int,
        var house: Int
    ) : DataModel()

    data class EventResponse(
        var id: Int,
        var name: String,
        var eventType: String,
        var locationName: String,
        var pointsWorth: Int,
        var startDate: Date,
        var endDate: Date
    ) : DataModel()

    data class EventContentResponse(
        var id: Int,
        var name: String,
        var description: String,
        var eventType: String,
        var locationName: String,
        var address: String,
        var pointsWorth: Int,
        var startDate: Date,
        var endDate: Date
    ) : DataModel()

    data class EventCheckIn(
        var latitude: Double,
        var longitude: Double,
        var accuracy: Double,
        var deviceUUID: String
    ) : DataModel ()

    data class EventCheckInResponse(
        var success: Boolean,
        var msg: String
    ) : DataModel()

    data class ClubResponse(
        var id: Int,
        var name: String,
        var description: String
    ) : DataModel()

    data class ClubContentResponse(
        var name: String,
        var description: String,
        var sponsors: String,
        var meetingTimes: String?,
        var locationName: String?,
        var websiteLink: String?,
        var instagramLink: String?,
        var twitterLink: String?,
        var youtubeLink: String?
    ) : DataModel()

    data class Response(
        var success: Boolean,
        var msg: String
    ) : DataModel()
}