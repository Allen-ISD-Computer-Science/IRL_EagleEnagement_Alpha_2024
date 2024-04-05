package com.ahscs.eagleengagement

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.datamodels.DataModel
import com.ahscs.eagleengagement.recyclerview.ClubAdapter
import com.ahscs.eagleengagement.recyclerview.RewardAdapter
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class RewardsFragment(jwt: String) : Fragment() {
    private val jwt = jwt

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_rewards_page, container, false)
        configureBtns(view)

        val adapter = RewardAdapter(this)
        getRewards(jwt, adapter)
        val recycler : RecyclerView = view.findViewById(R.id.rewardsRecycler)
        recycler.adapter = adapter

        adapter.setOnClickListener(object : RewardAdapter.OnClickListener {
            override fun onClick(position: Int, model: DataModel.RewardResponse) {

            }
        })

        return view
    }

    private fun getRewards(jwt: String, adapter: RewardAdapter) : MutableList<DataModel.RewardResponse> {
        var rewardList = mutableListOf <DataModel.RewardResponse>()

        var url = resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<MutableList<DataModel.RewardResponse>> = retrofitAPI.postRewards("Bearer $jwt")
        call!!.enqueue(object: Callback<MutableList<DataModel.RewardResponse>?> {
            override fun onResponse(
                call: Call<MutableList<DataModel.RewardResponse>?>?,
                response: Response<MutableList<DataModel.RewardResponse>?>
            ) {

                if (response.isSuccessful) {
                    try {
                        adapter.updateRewards(response.body()!!)
                    } catch (e : Exception) {
                        println("Error getting events")
                    }


                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<MutableList<DataModel.RewardResponse>?>?, t: Throwable) {
                println("Error doing API : " + t.message)
            }
        })

        return rewardList
    }

    private fun configureBtns(view: View) {
        val profileBtn = view.findViewById<ImageView>(R.id.rewardProfileBtn)
        profileBtn.setOnClickListener {
            val intent = Intent(activity, ProfileActivity::class.java)
            intent.putExtra("jwt", jwt)
            activity?.startActivity(intent)
        }
    }

}