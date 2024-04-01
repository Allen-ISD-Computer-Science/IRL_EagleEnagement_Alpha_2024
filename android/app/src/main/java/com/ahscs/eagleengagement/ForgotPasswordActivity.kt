package com.ahscs.eagleengagement

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class ForgotPasswordActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_password_recovery)

        val nextButton = findViewById<Button>(R.id.buttonNext)
        nextButton.setOnClickListener {
            val email = findViewById<EditText>(R.id.inputForgotPWEmail).text.toString()
            val studentID = findViewById<EditText>(R.id.inputForgotPWStudentID).text.toString()
            postDataUsingRetrofit(email, studentID)
        }
    }

    // send user provided data to api and redirect to verification page
    private fun postDataUsingRetrofit(email: String, studentID: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val dataModel = AuthDataModel.ForgotPasswordDataModel(email.lowercase(), studentID.toInt())
        val call: Call<DataModel.Response> = retrofitAPI.postForgotPassword(dataModel)
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    Toast.makeText(applicationContext, "Password Recovery started!", Toast.LENGTH_SHORT).show()

                    startActivity(Intent(applicationContext, VerifyActivity::class.java))
                    finish()
                }else{
                    println(response.raw().toString())
                    Toast.makeText(applicationContext, "An error occurred!", Toast.LENGTH_SHORT).show()
                }
            }

            override fun onFailure(call: Call<DataModel.Response?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }
}