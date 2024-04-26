package com.ahscs.eagleengagement

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.AppCompatButton
import androidx.appcompat.widget.AppCompatCheckBox
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

class RequestActivity : AppCompatActivity() {
    var jwt : String? = null
    var events = mutableMapOf<String, Int>()
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_point_requests_page)

        jwt = intent.getStringExtra("jwt")
        events = loadPastEvents(jwt!!)
        println(events.toString())



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

        configureBtns()
    }

    fun submit(jwt: String, data: DataModel.MissingRequest) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<DataModel.Response> = retrofitAPI.postMissingPoints("Bearer $jwt", data)
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    startActivity(Intent(applicationContext, MainActivity::class.java))
                    finish()
                    val builder = AlertDialog.Builder(this@RequestActivity, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
                    builder.setCancelable(true)
                    builder.setTitle("Submitted!")
                    builder.setMessage("Your request has been submitted! If approved, the points will be added to your account.")
                    builder.setNeutralButton("Ok") { dialog, _ ->
                        dialog.dismiss()
                    }
                    builder.show()
                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.Response?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }

    fun loadPastEvents(jwt: String) : MutableMap<String, Int> {
        var url = resources.getString(R.string.api_link)
        var events = mutableMapOf<String, Int>()
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<MutableList<DataModel.PastEventsResponse>> = retrofitAPI.postEventPast("Bearer $jwt")
        call!!.enqueue(object: Callback<MutableList<DataModel.PastEventsResponse>?> {
            override fun onResponse(
                call: Call<MutableList<DataModel.PastEventsResponse>?>?,
                response: Response<MutableList<DataModel.PastEventsResponse>?>
            ) {

                if (response.isSuccessful) {
                    try {
                        for (event in response.body()!!) {
                            events[event.name] = event.id
                        }
                        val eventSpinner : Spinner = findViewById(R.id.spinnerMissedEvents)
                        val eventAdapter = ArrayAdapter(applicationContext, androidx.appcompat.R.layout.support_simple_spinner_dropdown_item, events.keys.toList())
                        eventAdapter.setDropDownViewResource(androidx.appcompat.R.layout.support_simple_spinner_dropdown_item)
                        eventSpinner.adapter = eventAdapter
                        eventSpinner.onItemSelectedListener = (object : AdapterView.OnItemSelectedListener {
                            override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                                (eventSpinner.getChildAt(0) as TextView).setTextColor(Color.WHITE)
                                (eventSpinner.getChildAt(0) as TextView).textSize = 28f
                            }

                            override fun onNothingSelected(p0: AdapterView<*>?) {
                                return
                            }
                        })
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<MutableList<DataModel.PastEventsResponse>?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })
        return events
    }

    private fun configureBtns() {
        val backBtn = findViewById<ImageView>(R.id.rewardBackBtn)
        backBtn.setOnClickListener {
            finish()
        }

        val submitBtn = findViewById<AppCompatButton>(R.id.btnSubmitRequest)
        submitBtn.setOnClickListener {
            val eventName = findViewById<Spinner>(R.id.spinnerMissedEvents).selectedItem.toString()
            val eventId = events[eventName]
            val reason = findViewById<EditText>(R.id.requestReason).text.toString()
            var picture = null

            val isLocationChecked = findViewById<AppCompatCheckBox>(R.id.checkBoxSendLocation).isChecked

            if (isLocationChecked) {
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
                        try {
                            // getting the last known or current location
                            val latitude = location.latitude
                            val longitude = location.longitude
                            val accuracy = location.accuracy

                            val data = DataModel.MissingRequest(
                                eventId!!,
                                reason,
                                picture,
                                latitude.toFloat(),
                                longitude.toFloat(),
                                accuracy
                            )
                            submit(jwt!!, data)
                        } catch (e: Exception) {
                            val builder = AlertDialog.Builder(
                                this@RequestActivity,
                                com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert
                            )
                            builder.setCancelable(true)
                            builder.setTitle("Location Unknown!")
                            builder.setMessage("Unable to obtain your current location! Please try again later.")
                            builder.setNeutralButton("Ok") { dialog, _ ->
                                dialog.dismiss()
                            }
                            builder.show()
                        }
                    }
                    .addOnFailureListener {
                        println("Location getting failed ${it.message}")
                        Toast.makeText(
                            this, "Failed on getting current location",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
            } else {
                val data = DataModel.MissingRequest(
                    eventId!!,
                    reason,
                    picture,
                    null,
                    null,
                    null
                )
                submit(jwt!!, data)
            }
        }
    }
}