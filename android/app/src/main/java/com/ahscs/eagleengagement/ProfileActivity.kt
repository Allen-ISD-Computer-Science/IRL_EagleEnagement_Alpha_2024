package com.ahscs.eagleengagement

import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.Spinner
import android.widget.TextView
import android.widget.Toast
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class ProfileActivity : AppCompatActivity() {
    var jwt : String? = null
    var name : String? = null
    var studentID : Int? = null
    var savedGrade : Int? = null
    var savedHouse : Int? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile_page)

        jwt = intent.getStringExtra("jwt")
        updateProfile(jwt!!)

        val editCancelBtn : Button = findViewById(R.id.editCancelBtn)
        val editSaveBtn : Button = findViewById(R.id.editSaveBtn)
        editCancelBtn.visibility = View.GONE
        editSaveBtn.visibility = View.GONE

        val nameTxt : EditText = findViewById(R.id.nameTxt)
        nameTxt.isEnabled = false

        val gradeSpinner : Spinner = findViewById(R.id.gradeSpinner)
        val gradeAdapter = ArrayAdapter.createFromResource(this, R.array.grades, androidx.appcompat.R.layout.support_simple_spinner_dropdown_item)
        gradeSpinner.adapter = gradeAdapter
        gradeSpinner.isClickable = false
        gradeSpinner.isEnabled = false
        gradeSpinner.onItemSelectedListener = (object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                (gradeSpinner.getChildAt(0) as TextView).setTextColor(Color.WHITE)
                (gradeSpinner.getChildAt(0) as TextView).textSize = 24f
            }

            override fun onNothingSelected(p0: AdapterView<*>?) {
                return
            }
        })

        // set adapters for drop down menus
        val houseSpinner : Spinner = findViewById(R.id.houseSpinner)
        val houseAdapter = ArrayAdapter.createFromResource(this, R.array.houses, androidx.appcompat.R.layout.support_simple_spinner_dropdown_item)
        houseSpinner.adapter = houseAdapter
        houseSpinner.isClickable = false
        houseSpinner.isEnabled = false
        houseSpinner.onItemSelectedListener = (object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                (houseSpinner.getChildAt(0) as TextView).setTextColor(Color.WHITE)
                (houseSpinner.getChildAt(0) as TextView).textSize = 24f
            }

            override fun onNothingSelected(p0: AdapterView<*>?) {
                return
            }
        })
    }

    // access API to get profile data and update the fields to be correct
    fun updateProfile(jwt: String) {
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
                        val data = response.body()!!

                        val nameTxt : EditText = findViewById(R.id.nameTxt)
                        nameTxt.setText(data.name)

                        val points : TextView = findViewById(R.id.txtInfoPoints)
                        points.text = data.points.toString()

                        val studentId : TextView = findViewById(R.id.txtInfoStudentId)
                        studentId.text = data.studentID.toString()

                        name = data.name
                        studentID = data.studentID

                        val gradeSpinner : Spinner = findViewById(R.id.gradeSpinner)
                        if (data.grade == 10) {
                            gradeSpinner.setSelection(0)
                        } else if (data.grade == 11) {
                            gradeSpinner.setSelection(1)
                        } else if (data.grade == 12) {
                            gradeSpinner.setSelection(2)
                        } else {
                            gradeSpinner.setSelection(3)
                        }

                        savedGrade = data.grade

                        val houseSpinner : Spinner = findViewById(R.id.houseSpinner)
                        if (data.house == 100) {
                            gradeSpinner.setSelection(0)
                        } else if (data.house == 200) {
                            houseSpinner.setSelection(1)
                        } else if (data.house == 300) {
                            houseSpinner.setSelection(2)
                        } else if (data.house == 400) {
                            houseSpinner.setSelection(3)
                        } else if (data.house == 500) {
                            houseSpinner.setSelection(4)
                        } else if (data.house == 600) {
                            houseSpinner.setSelection(5)
                        } else if (data.house == 700) {
                            houseSpinner.setSelection(6)
                        } else {
                            houseSpinner.setSelection(7)
                        }

                        savedHouse = data.house

                        configureBtns()
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.ProfileResponse?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })
    }

    // gets current values of editable fields and posts it to API
    fun saveProfile(jwt: String, name: String, studentID: Int, grade: Int, house: Int) {
        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val dataModel = DataModel.EditProfile(name, studentID, grade, house)
        val call: Call<DataModel.Response> = retrofitAPI.postEditProfile("Bearer $jwt", dataModel)
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    val nameTxt : EditText = findViewById(R.id.nameTxt)
                    nameTxt.isEnabled = false

                    val gradeSpinner : Spinner = findViewById(R.id.gradeSpinner)
                    val houseSpinner : Spinner = findViewById(R.id.houseSpinner)
                    gradeSpinner.isClickable = false
                    gradeSpinner.isEnabled = false
                    houseSpinner.isClickable = false
                    houseSpinner.isEnabled = false

                    val editCancelBtn : Button = findViewById(R.id.editCancelBtn)
                    val editSaveBtn : Button = findViewById(R.id.editSaveBtn)
                    editCancelBtn.visibility = View.GONE
                    editSaveBtn.visibility = View.GONE

                    val editBtn = findViewById<ImageView>(R.id.btnEditProfile)
                    editBtn.visibility = View.VISIBLE

                    Toast.makeText(applicationContext, "Profile Saved Successfully!", Toast.LENGTH_SHORT).show()
                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.Response?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })
    }

    // set functionality for buttons
    private fun configureBtns() {
        val backBtn = findViewById<ImageView>(R.id.profileBackBtn)
        backBtn.setOnClickListener {
            finish()
        }

        val pointHistoryBtn = findViewById<ImageView>(R.id.profilePointHistoryBtn)
        pointHistoryBtn.setOnClickListener {
            startActivity(Intent(this, PointHistoryActivity::class.java))
        }

        val nameTxt : EditText = findViewById(R.id.nameTxt)

        val gradeSpinner : Spinner = findViewById(R.id.gradeSpinner)
        val houseSpinner : Spinner = findViewById(R.id.houseSpinner)

        val editCancelBtn : Button = findViewById(R.id.editCancelBtn)
        val editSaveBtn : Button = findViewById(R.id.editSaveBtn)

        val editBtn = findViewById<ImageView>(R.id.btnEditProfile)
        editBtn.setOnClickListener {
            nameTxt.isEnabled = true

            gradeSpinner.isClickable = true
            gradeSpinner.isEnabled = true
            houseSpinner.isClickable = true
            houseSpinner.isEnabled = true

            editCancelBtn.visibility = View.VISIBLE
            editSaveBtn.visibility = View.VISIBLE

            editBtn.visibility = View.GONE
        }

        val cancelBtn = findViewById<Button>(R.id.editCancelBtn)
        cancelBtn.setOnClickListener {
            nameTxt.isEnabled = false
            nameTxt.setText(name)

            gradeSpinner.isClickable = false
            gradeSpinner.isEnabled = false
            houseSpinner.isClickable = false
            houseSpinner.isEnabled = false

            if (savedGrade == null) {
                gradeSpinner.setSelection(3)
            } else {
                gradeSpinner.setSelection(savedGrade!! - 10)
            }

            if (savedHouse == null) {
                houseSpinner.setSelection(7)
            } else {
                houseSpinner.setSelection((savedHouse!! / 100) - 1)
            }

            editCancelBtn.visibility = View.GONE
            editSaveBtn.visibility = View.GONE

            editBtn.visibility = View.VISIBLE
        }

        val saveBtn = findViewById<Button>(R.id.editSaveBtn)
        saveBtn.setOnClickListener {
            val newName = nameTxt.text.toString()
            val grade = gradeSpinner.selectedItemPosition + 10
            val house = (houseSpinner.selectedItemPosition + 1) * 100
            savedGrade = grade
            savedHouse = house
            saveProfile(jwt!!, newName, studentID!!, grade, house)
        }
    }
}