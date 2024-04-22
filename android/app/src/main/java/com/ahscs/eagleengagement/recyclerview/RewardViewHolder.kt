package com.ahscs.eagleengagement.recyclerview

import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.AppCompatButton
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.MainActivity
import com.ahscs.eagleengagement.R
import com.ahscs.eagleengagement.RetrofitAPI
import com.ahscs.eagleengagement.RewardsFragment
import com.ahscs.eagleengagement.datamodels.AuthDataModel
import com.ahscs.eagleengagement.datamodels.DataModel
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.FileOutputStream
import java.text.SimpleDateFormat

class RewardViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    fun updateInfo(info: DataModel.RewardResponse) {
        var name : TextView = itemView.findViewById(R.id.txtRewardName)
        name.text = info.name

        var description : TextView = itemView.findViewById(R.id.txtRewardDescription)
        description.text = info.description

        var cost : TextView = itemView.findViewById(R.id.txtRewardCost)
        cost.text = info.cost.toString()

        var readLess : TextView = itemView.findViewById(R.id.txtReadLessBtn)
        readLess.visibility = View.GONE

        var readMore : TextView = itemView.findViewById(R.id.txtReadMoreBtn)
        readMore.visibility = View.VISIBLE
    }

    fun toggleRead() {
        var readMore : TextView = itemView.findViewById(R.id.txtReadMoreBtn)
        if (readMore.visibility == View.VISIBLE) {
            var description: TextView = itemView.findViewById(R.id.txtRewardDescription)
            description.maxLines = 100

            var readLess: TextView = itemView.findViewById(R.id.txtReadLessBtn)
            readLess.visibility = View.VISIBLE

            readMore.visibility = View.GONE
        } else {
            var description: TextView = itemView.findViewById(R.id.txtRewardDescription)
            description.maxLines = 3

            var readLess: TextView = itemView.findViewById(R.id.txtReadLessBtn)
            readLess.visibility = View.GONE

            readMore.visibility = View.VISIBLE
        }
    }

    fun buyReward(data: DataModel.RewardResponse, fragment: RewardsFragment) {
        val id = data.id
        var url = fragment.resources.getString(R.string.api_link)
        val retrofit = Retrofit.Builder()
            .baseUrl(url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val retrofitAPI = retrofit.create(RetrofitAPI::class.java)
        val call: Call<DataModel.Response> = retrofitAPI.postBuyReward("Bearer " + fragment.jwt, id.toString())
        call!!.enqueue(object: Callback<DataModel.Response?> {
            override fun onResponse(
                call: Call<DataModel.Response?>?,
                response: Response<DataModel.Response?>
            ) {

                if (response.isSuccessful) {
                    if(response.body()!!.msg.startsWith("Purchased")) {
                        fragment.activity!!.startActivity(Intent(fragment.activity!!.applicationContext, MainActivity::class.java))
                        Toast.makeText(fragment.activity!!.applicationContext, response.body()!!.msg, Toast.LENGTH_LONG)
                        fragment.activity!!.finish()
                    }else{
                        val builder = AlertDialog.Builder(fragment.context!!, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
                        builder.setCancelable(true)
                        builder.setTitle("Purchase Failed")
                        builder.setMessage(response.body()!!.msg)
                        builder.setNeutralButton("Ok") { dialog, _ ->
                            dialog.dismiss()
                        }
                        builder.show()
                    }
                }else{
                    println(response.raw().toString())
                }
            }

            override fun onFailure(call: Call<DataModel.Response?>?, t: Throwable) {
                print("Error doing API : " + t.message)
            }
        })
    }

    fun getBuyButton(): AppCompatButton? {
        return itemView.findViewById(R.id.btnBuy)
    }

}