package com.ahscs.eagleengagement

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.datamodels.DataModel
import com.ahscs.eagleengagement.recyclerview.PointHistoryAdapter
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class PointHistoryActivity : AppCompatActivity() {
    private var jwt: String? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_point_history_page)

        jwt = intent.getStringExtra("jwt")

        configureBtns()

        // set recycler view and adapter
        val adapter = PointHistoryAdapter(this)
        getPointHistory(jwt!!, adapter)
        val recycler : RecyclerView = findViewById(R.id.pointHistoryRecycler)
        recycler.adapter = adapter
    }

    // retrieve list of events from api and update recycler adapter
    private fun getPointHistory(jwt: String, adapter: PointHistoryAdapter) : MutableList<DataModel.PointHistoryResponse> {
        var historyList = mutableListOf <DataModel.PointHistoryResponse>()

        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<MutableList<DataModel.PointHistoryResponse>> = retrofitAPI.postPointHistory("Bearer $jwt")
        call!!.enqueue(object: Callback<MutableList<DataModel.PointHistoryResponse>?> {
            override fun onResponse(
                call: Call<MutableList<DataModel.PointHistoryResponse>?>?,
                response: Response<MutableList<DataModel.PointHistoryResponse>?>
            ) {

                if (response.isSuccessful) {
                    try {
                        adapter.updatePointHistory(response.body()!!)
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<MutableList<DataModel.PointHistoryResponse>?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })

        return historyList
    }

    private fun configureBtns() {
        val backBtn = findViewById<ImageView>(R.id.pointHistoryBackBtn)
        backBtn.setOnClickListener {
            finish()
        }
    }
}