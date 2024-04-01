package com.ahscs.eagleengagement

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import android.util.Base64
import android.widget.*
import com.ahscs.eagleengagement.datamodels.DataModel
import java.io.FileOutputStream

class VerifyActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_account_verify)

        // functionality for create account button
        val createButton = findViewById<Button>(R.id.buttonCreateAcct)
        createButton.setOnClickListener {
            val email = findViewById<EditText>(R.id.inputVerifyEmail).text.toString()
            val token = findViewById<EditText>(R.id.inputVerifyCode).text.toString()
            val password = findViewById<EditText>(R.id.inputVerifyPassword).text.toString()
            val passwordConfirm = findViewById<EditText>(R.id.inputVerifyConfirmPassword).text.toString()
            if (password == passwordConfirm) {
                var encodedPassword1 = Base64.encodeToString(password.toByteArray(), Base64.NO_WRAP)
                var encodedPassword2 = Base64.encodeToString(passwordConfirm.toByteArray(), Base64.NO_WRAP)
                postDataUsingRetrofit(email, token, encodedPassword1, encodedPassword2)
            } else {
                Toast.makeText(applicationContext, "Passwords must match!", Toast.LENGTH_SHORT).show()
            }
        }
    }

    // post verification data to api
    private fun postDataUsingRetrofit(email: String, token: String, password: String, confirmPassword: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val dataModel = AuthDataModel.VerifyDataModel(email.lowercase(), token, password, confirmPassword)
        val call: Call<DataModel.Response> = retrofitAPI.postVerify(dataModel)
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    Toast.makeText(applicationContext, "Account Created!", Toast.LENGTH_SHORT).show()
                    try {
                        val jwt = response.body()!!.msg

                        if(!filesDir.exists()) filesDir.mkdir()
                        val jwt_file = getString(R.string.jwt_storage_file_name)
                        val fosSaved: FileOutputStream = openFileOutput(jwt_file, Context.MODE_PRIVATE)
                        fosSaved.write(jwt.toByteArray())
                        fosSaved.close()
                    } catch (e : Exception) {
                        Toast.makeText(applicationContext, "An error occurred while verifying, try again later!", Toast.LENGTH_SHORT).show()
                    }

                    startActivity(Intent(applicationContext, MainActivity::class.java))
                    finish()
                }else{
                    println(response.body().toString())
                    if (response.code().toString() == "400") {
                        Toast.makeText(applicationContext, "Invalid code or email!", Toast.LENGTH_SHORT).show()
                    } else {
                        Toast.makeText(applicationContext, "Invalid!", Toast.LENGTH_SHORT).show()
                    }
                }
            }

            override fun onFailure(call: Call<DataModel.Response?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }
}