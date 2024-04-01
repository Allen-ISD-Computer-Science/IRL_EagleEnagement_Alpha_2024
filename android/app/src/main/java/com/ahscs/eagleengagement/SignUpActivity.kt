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

class SignUpActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_account_creation)

        // functionality for sign up button
        val signUpButton = findViewById<Button>(R.id.buttonSignup)
        signUpButton.setOnClickListener {
            val firstName = findViewById<EditText>(R.id.inputFirstName).text.toString()
            val lastName = findViewById<EditText>(R.id.inputLastName).text.toString()
            val studentID = findViewById<EditText>(R.id.inputStudentID).text.toString()
            val email = findViewById<EditText>(R.id.inputSignUpEmail).text.toString()
            postDataUsingRetrofit(firstName, lastName, studentID, email)
        }
    }

    // sign up data from inputs to api and redirect to verification
    private fun postDataUsingRetrofit(firstName: String, lastName: String, studentID: String, email: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val dataModel = AuthDataModel.SignUpDataModel(firstName, lastName, email.lowercase(), studentID.toInt())
        val call: Call<DataModel.Response> = retrofitAPI.postSignUp(dataModel)
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    Toast.makeText(applicationContext, "Account Creation started!", Toast.LENGTH_SHORT).show()

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