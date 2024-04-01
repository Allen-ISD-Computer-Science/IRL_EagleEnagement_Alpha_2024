package com.ahscs.eagleengagement.datamodels

sealed class AuthDataModel {
    // data models specifically for authentication
    data class LoginDataModel(
        var email: String,
        var password: String
    ) : AuthDataModel()

    data class SignUpDataModel(
        var firstName: String,
        var lastName: String,
        var email: String,
        var studentID: Int
    ) : AuthDataModel()

    data class VerifyDataModel(
        var email: String,
        var token: String,
        var password: String,
        var passwordConfirm: String
    ) : AuthDataModel()

    data class ForgotPasswordDataModel(
        var email: String,
        var studentID: Int
    ) : AuthDataModel()

}