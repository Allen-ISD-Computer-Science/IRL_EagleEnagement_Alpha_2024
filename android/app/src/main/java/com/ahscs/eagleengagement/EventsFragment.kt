package com.ahscs.eagleengagement

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.datamodels.DataModel
import com.ahscs.eagleengagement.recyclerview.EventAdapter
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class EventsFragment(jwt: String) : Fragment() {
    private val jwt = jwt

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_home_page, container, false)
        configureBtns(view)

        // set recycler view and adapter
        val adapter = EventAdapter(this)
        getEvents(jwt, adapter)
        val recycler : RecyclerView = view.findViewById(R.id.eventRecycler)
        recycler.adapter = adapter

        adapter.setOnClickListener(object : EventAdapter.OnClickListener {
            override fun onClick(position: Int, model: DataModel.EventResponse) {
                val intent = Intent(activity, EventActivity::class.java)
                intent.putExtra("eventId", model.id.toString())
                intent.putExtra("jwt", jwt)
                startActivity(intent)
            }
        })

        return view
    }

    // retrieve list of events from api and update recycler adapter
    private fun getEvents(jwt: String, adapter: EventAdapter) : MutableList<DataModel.EventResponse> {
        var eventList = mutableListOf <DataModel.EventResponse>()

        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<MutableList<DataModel.EventResponse>> = retrofitAPI.postEvents("Bearer $jwt")
        call!!.enqueue(object: Callback<MutableList<DataModel.EventResponse>?> {
            override fun onResponse(
                call: Call<MutableList<DataModel.EventResponse>?>?,
                response: Response<MutableList<DataModel.EventResponse>?>
            ) {

                if (response.isSuccessful) {
                    try {
                        adapter.updateEvents(response.body()!!)
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<MutableList<DataModel.EventResponse>?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })

        return eventList
    }

    // set functionality for buttons
    private fun configureBtns(view: View) {
        val profileBtn = view.findViewById<ImageView>(R.id.eventProfileBtn)
        profileBtn.setOnClickListener {
            val intent = Intent(activity, ProfileActivity::class.java)
            intent.putExtra("jwt", jwt)
            activity?.startActivity(intent)
        }

        val requestBtn = view.findViewById<LinearLayout>(R.id.eventRequestBtn)
        requestBtn.setOnClickListener {
            activity?.startActivity(Intent(activity, RequestActivity::class.java))
        }
    }

}