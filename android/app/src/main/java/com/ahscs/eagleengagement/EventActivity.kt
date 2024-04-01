package com.ahscs.eagleengagement

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.AppCompatButton
import androidx.core.app.ActivityCompat
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.FileOutputStream
import java.text.SimpleDateFormat

class EventActivity : AppCompatActivity() {
    var eventAddress : String? = null
    private val LOCATION_PERMISSION_REQ_CODE = 1000;
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    var jwt : String? = null
    var eventId : String? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_page)


        eventId = intent.getStringExtra("eventId")
        jwt = intent.getStringExtra("jwt")
        updateEventInfo(jwt!!, eventId!!)

        // request permission for location
        val locationPermissionRequest = registerForActivityResult(
            ActivityResultContracts.RequestMultiplePermissions()
        ) { permissions ->
            when {
                permissions.getOrDefault(Manifest.permission.ACCESS_FINE_LOCATION, false) -> {
                    // Precise location access granted.
                }
                permissions.getOrDefault(Manifest.permission.ACCESS_COARSE_LOCATION, false) -> {
                    // Only approximate location access granted.
                } else -> {
                // No location access granted.
            }
            }
        }
        locationPermissionRequest.launch(arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION))

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    }

    // get event info from API and update in the activity
    private fun updateEventInfo(jwt: String, eventId: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<DataModel.EventContentResponse> = retrofitAPI.postEventContent("Bearer $jwt", eventId)
        call!!.enqueue(object: Callback<DataModel.EventContentResponse?> {
            override fun onResponse(
                call: Call<DataModel.EventContentResponse?>?,
                response: Response<DataModel.EventContentResponse?>
            ) {

                if (response.isSuccessful) {
                    try {
                        val data = response.body()!!
                        var name : TextView = findViewById(R.id.txtName)
                        name.text = data.name

                        var points : TextView = findViewById(R.id.txtPoints)
                        points.text = data.pointsWorth.toString()

                        var address : TextView = findViewById(R.id.txtAddress)
                        address.text = data.locationName + "\n" + data.address
                        eventAddress = data.address

                        val dayFormat = SimpleDateFormat("EEEE")
                        val day : TextView = findViewById(R.id.txtDay)
                        day.text = dayFormat.format(data.startDate)

                        val timeFormat1 = SimpleDateFormat("h:mma - ")
                        val timeFormat2 = SimpleDateFormat("h:mma")
                        val timeString = timeFormat1.format(data.startDate) + timeFormat2.format(data.endDate)
                        var time : TextView = findViewById(R.id.txtTime)
                        time.text = timeString

                        val dateFormat = SimpleDateFormat("d")
                        var date : TextView = findViewById(R.id.txtDate)
                        date.text = dateFormat.format(data.startDate)

                        val monthFormat = SimpleDateFormat("MMM")
                        val month : TextView = findViewById(R.id.txtMonth)
                        month.text = monthFormat.format(data.startDate)

                        var description : TextView = findViewById(R.id.txtDescription)
                        description.text = data.description

                        configureBtns()
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.EventContentResponse?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })
    }

    // send location to API for check in
    private fun checkIn(jwt: String, eventId: String, latitude: Double, longitude: Double, accuracy: Double) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val dataModel = DataModel.EventCheckIn(latitude, longitude, accuracy, "hi")
        val call: Call<DataModel.EventCheckInResponse> = retrofitAPI.postEventCheckIn("Bearer $jwt", eventId, dataModel)
        call!!.enqueue(object: Callback<DataModel.EventCheckInResponse?> {
            override fun onResponse(
                call: Call<DataModel.EventCheckInResponse?>?,
                response: Response<DataModel.EventCheckInResponse?>
            ) {

                if (response.isSuccessful && response.body()!!.success) {
                    val builder = AlertDialog.Builder(this@EventActivity, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
                    builder.setCancelable(true)
                    builder.setTitle("Success!")
                    builder.setMessage("You have been checked in to the event!")
                    builder.setNeutralButton("Ok") { dialog, _ ->
                        dialog.dismiss()
                    }
                    builder.show()
                }else{
                    val builder = AlertDialog.Builder(this@EventActivity, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
                    builder.setCancelable(true)
                    builder.setTitle("Error")
                    builder.setMessage(response.body()!!.msg)
                    builder.setNeutralButton("Ok") { dialog, _ ->
                        dialog.dismiss()
                    }
                    builder.show()
                }
            }

            override fun onFailure(call: Call<DataModel.EventCheckInResponse?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }

    // set functionality for buttons
    private fun configureBtns() {
        val backBtn = findViewById<ImageView>(R.id.eventBackBtn)
        backBtn.setOnClickListener {
            finish()
        }

        val checkinBtn = findViewById<AppCompatButton>(R.id.btnCheckin)
        checkinBtn.setOnClickListener {


            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
            }
            fusedLocationClient.lastLocation
                .addOnSuccessListener { location ->
                    // getting the last known or current location
                    val latitude = location.latitude
                    val longitude = location.longitude
                    val accuracy = location.accuracy
                    println("JWT: $jwt")
                    checkIn(jwt!!, eventId!!, latitude, longitude, accuracy.toDouble())
                }
                .addOnFailureListener {
                    println("Location getting failed ${it.message}")
                    Toast.makeText(this, "Failed on getting current location",
                        Toast.LENGTH_SHORT).show()
                }
        }

        val directionsBtn = findViewById<ImageView>(R.id.btnDirections)
        directionsBtn.setOnClickListener {
            val map = "https://maps.google.com/maps?q=$eventAddress"
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(map))
            intent.setClassName("com.google.android.apps.maps", "com.google.android.maps.MapsActivity")
            startActivity(intent)
        }
    }


}