package com.ahscs.eagleengagement

import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.AuthDataModel.LoginDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Path

interface RetrofitAPI {
    // contains the api routes and uses data models
    @POST("login")
    fun postLogin(@Body dataModel: LoginDataModel?) : Call<DataModel.Response>

    @POST("profile")
    fun postProfile(@Header("Authorization") authToken: String) : Call<DataModel.ProfileResponse>

    @POST("profile/edit")
    fun postEditProfile(@Header("Authorization") authToken: String, @Body dataModel: DataModel.EditProfile?) : Call<DataModel.Response>

    @POST("signup")
    fun postSignUp(@Body dataModel: AuthDataModel.SignUpDataModel?) : Call<DataModel.Response>

    @POST("verify")
    fun postVerify(@Body dataModel: AuthDataModel.VerifyDataModel?) : Call<DataModel.Response>

    @POST("forgotPassword")
    fun postForgotPassword(@Body dataModel: AuthDataModel.ForgotPasswordDataModel?) : Call<DataModel.Response>

    @POST("events")
    fun postEvents(@Header("Authorization") authToken: String): Call<MutableList<DataModel.EventResponse>>

    @POST("event/{id}")
    fun postEventContent(@Header ("Authorization") authToken: String, @Path("id") eventId: String): Call<DataModel.EventContentResponse>

    @POST("event/{id}/checkIn")
    fun postEventCheckIn(@Header ("Authorization") authToken: String, @Path("id") eventId: String, @Body datamodel: DataModel.EventCheckIn): Call<DataModel.EventCheckInResponse>

    @POST("clubs")
    fun postClubs(@Header("Authorization") authToken: String): Call<MutableList<DataModel.ClubResponse>>

    @POST("club/{id}")
    fun postClubContent(@Header ("Authorization") authToken: String, @Path("id") clubId: String): Call<DataModel.ClubContentResponse>
}