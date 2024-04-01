package com.ahscs.eagleengagement

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.ContactsContract.Data
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import com.google.android.material.bottomnavigation.BottomNavigationView
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.File
import java.io.FileOutputStream

class MainActivity : AppCompatActivity() {

    lateinit var bottomNav : BottomNavigationView
    private val LOCATION_PERMISSION_REQ_CODE = 1000;

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { isGranted: Boolean ->
        if (!isGranted) {
            Toast.makeText(applicationContext, "You will not receive notifications.", Toast.LENGTH_SHORT)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var jwt: String? = null

        if(!filesDir.exists()) filesDir.mkdir()
        val jwt_file = getString(R.string.jwt_storage_file_name)
        if(!File(filesDir, jwt_file).exists()) {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }else{
            openFileInput(jwt_file).bufferedReader().use { line ->
                try {
//                    if (lines.count() == 1) {
//                        getPoints(lines.first())
//                    }else{
//                        println("more or less lines")
//                    }
                    jwt = line.readText()
                    setPoints(jwt!!)
                } catch (e: Exception) {
                    println("exception ${e.message}")
                }
            }
        }

        if (jwt == null) {
            throw Exception("JWT is null!")
        }

        askNotificationPermission()

        val eventsList = EventsFragment(jwt!!)
        val clubsList = ClubsFragment(jwt!!)
        val rewardsList = RewardsFragment()

        loadFragment(eventsList)
        bottomNav = findViewById(R.id.navBar)
        bottomNav.menu.findItem(R.id.events).isChecked = true
        bottomNav.setOnItemSelectedListener {
            when(it.itemId) {
                R.id.clubs->loadFragment(clubsList)
                R.id.events->loadFragment(eventsList)
                R.id.rewards->loadFragment(rewardsList)
            }
            true
        }


    }

    // update point counter at top of the page
    private fun setPoints(jwt: String) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<DataModel.ProfileResponse> = retrofitAPI.postProfile("Bearer $jwt")
        call!!.enqueue(object: Callback<DataModel.ProfileResponse?> {
            override fun onResponse(
                call: Call<DataModel.ProfileResponse?>?,
                response: Response<DataModel.ProfileResponse?>
            ) {

                if (response.isSuccessful) {
                    try {
                        val points = response.body()!!.points
                        findViewById<TextView>(R.id.txtPoints).text = points.toString()
                    } catch (e : Exception) {
                        startActivity(Intent(applicationContext, LoginActivity::class.java))
                        finish()
                    }


                }else{
                    println(response.raw().toString())
                    startActivity(Intent(applicationContext, LoginActivity::class.java))
                    finish()
                }
            }

            override fun onFailure(call: Call<DataModel.ProfileResponse?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }

    private fun loadFragment(fragment: Fragment) {
        val transaction = supportFragmentManager.beginTransaction()
        transaction.replace(R.id.container, fragment)
        transaction.commit()
    }

    private fun askNotificationPermission() {
        //for API level >= 33
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
                // has permission
            } else if (shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS)) {
                val builder = AlertDialog.Builder(this@MainActivity, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
                builder.setCancelable(true)
                builder.setTitle("Are you sure?")
                builder.setMessage("Allowing notifications will send you reminders to check in to events and club meetings!")
                builder.setNegativeButton("No! I don't want that.") { dialog, _ ->
                    dialog.dismiss()
                }
                builder.setNeutralButton("Nevermind! Allow notifications.") { dialog, _ ->
                    requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                }
                builder.show()
            } else {
                // ask for permission
                requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }
    }

}