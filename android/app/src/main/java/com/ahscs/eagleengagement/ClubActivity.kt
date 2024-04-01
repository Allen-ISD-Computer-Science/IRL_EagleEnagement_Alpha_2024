package com.ahscs.eagleengagement

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.ahscs.eagleengagement.datamodels.DataModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.text.SimpleDateFormat

class ClubActivity : AppCompatActivity() {
    var link : String? = null
    var instaLink : String? = null
    var xLink : String? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_club_page)

        // get club id and jwt from the intent
        val clubId = intent.getStringExtra("clubId")
        val jwt = intent.getStringExtra("jwt")
        updateClubInfo(jwt!!, clubId!!)

    }

    // update information on activity to show correct club info
    private fun updateClubInfo(jwt: String, clubId: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<DataModel.ClubContentResponse> = retrofitAPI.postClubContent("Bearer $jwt", clubId)
        call!!.enqueue(object: Callback<DataModel.ClubContentResponse?> {
            override fun onResponse(
                call: Call<DataModel.ClubContentResponse?>?,
                response: Response<DataModel.ClubContentResponse?>
            ) {

                if (response.isSuccessful) {
                    try {
                        val data = response.body()!!
                        var name : TextView = findViewById(R.id.txtClubName)
                        name.text = data.name

                        var sponsor : TextView = findViewById(R.id.txtClubSponsor)
                        sponsor.text = "Sponsors: " + data.sponsors

                        var location : TextView = findViewById(R.id.txtClubLocation)
                        if (data.locationName == null) {
                            location.visibility = View.GONE
                        } else {
                            location.text = "Location: " + data.locationName
                        }

                        var times : TextView = findViewById(R.id.txtClubTimes)
                        if (data.meetingTimes == null) {
                            times.visibility = View.GONE
                        } else {
                            times.text = "Meeting Times: " + data.meetingTimes
                        }

                        var description : TextView = findViewById(R.id.txtClubDescription)
                        description.text = data.description

                        link = data.websiteLink
                        instaLink = data.instagramLink
                        xLink = data.twitterLink

                        if (link == null) {
                            findViewById<ImageView>(R.id.imageLink).visibility = View.GONE
                        }
                        if (instaLink == null) {
                            findViewById<ImageView>(R.id.imageInsta).visibility = View.GONE
                        }
                        if (xLink == null) {
                            findViewById<ImageView>(R.id.imageX).visibility = View.GONE
                        }
                        configureBtns()
                    } catch (e : Exception) {
                        println("Error getting clubs")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.ClubContentResponse?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })
    }

    private fun configureBtns() {
        val backBtn = findViewById<ImageView>(R.id.clubBackBtn)
        backBtn.setOnClickListener {
            finish()
        }

        if (link != null) {
            val linkBtn = findViewById<ImageView>(R.id.imageLink)
            linkBtn.setOnClickListener {
                val linkIntent = Intent(Intent.ACTION_VIEW, Uri.parse(link))
                startActivity(linkIntent)
            }
        }

        if (instaLink != null) {
            val linkBtn = findViewById<ImageView>(R.id.imageInsta)
            linkBtn.setOnClickListener {
                val instaIntent = Intent(Intent.ACTION_VIEW, Uri.parse(instaLink))
                startActivity(instaIntent)
            }
        }

        if (xLink != null) {
            val linkBtn = findViewById<ImageView>(R.id.imageX)
            linkBtn.setOnClickListener {
                val xIntent = Intent(Intent.ACTION_VIEW, Uri.parse(xLink))
                startActivity(xIntent)
            }
        }
    }
}