package com.ahscs.eagleengagement

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.datamodels.DataModel
import com.ahscs.eagleengagement.recyclerview.ClubAdapter
import com.ahscs.eagleengagement.recyclerview.EventAdapter
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class ClubsFragment(jwt: String) : Fragment() {
    private val jwt = jwt

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_clubs_page, container, false)
        configureBtns(view)

        val adapter = ClubAdapter(this)
        getClubs(jwt, adapter)
        val recycler : RecyclerView = view.findViewById(R.id.clubsRecycler)
        recycler.adapter = adapter

        adapter.setOnClickListener(object : ClubAdapter.OnClickListener {
            override fun onClick(position: Int, model: DataModel.ClubResponse) {
                val intent = Intent(activity, ClubActivity::class.java)
                intent.putExtra("clubId", model.id.toString())
                intent.putExtra("jwt", jwt)
                startActivity(intent)
            }
        })

        return view
    }

    // retrieve list of clubs from API and update the adapter
    private fun getClubs(jwt: String, adapter: ClubAdapter) : MutableList<DataModel.ClubResponse> {
        var clubList = mutableListOf <DataModel.ClubResponse>()

        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<MutableList<DataModel.ClubResponse>> = retrofitAPI.postClubs("Bearer $jwt")
        call!!.enqueue(object: Callback<MutableList<DataModel.ClubResponse>?> {
            override fun onResponse(
                call: Call<MutableList<DataModel.ClubResponse>?>?,
                response: Response<MutableList<DataModel.ClubResponse>?>
            ) {

                if (response.isSuccessful) {
                    try {
                        adapter.updateClubs(response.body()!!)
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<MutableList<DataModel.ClubResponse>?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })

        return clubList
    }

    // set functionality for buttons
    private fun configureBtns(view: View) {
        val profileBtn = view.findViewById<ImageView>(R.id.clubProfileBtn)
        profileBtn.setOnClickListener {
            val intent = Intent(activity, ProfileActivity::class.java)
            intent.putExtra("jwt", jwt)
            activity?.startActivity(intent)
        }
    }

}