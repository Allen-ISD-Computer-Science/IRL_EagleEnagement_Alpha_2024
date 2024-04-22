package com.ahscs.eagleengagement.recyclerview

import android.app.Activity
import android.provider.ContactsContract.Data
import android.view.LayoutInflater
import android.view.View.OnClickListener
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.ClubsFragment
import com.ahscs.eagleengagement.MainActivity
import com.ahscs.eagleengagement.R
import com.ahscs.eagleengagement.RewardsFragment
import com.ahscs.eagleengagement.datamodels.DataModel

class RewardAdapter(fragment: RewardsFragment) : RecyclerView.Adapter<RewardViewHolder>() {
    val context = fragment
    private var rewardList = mutableListOf<DataModel.RewardResponse>()
    private var onClickListener: OnClickListener? = null

    fun updateRewards(rewards: MutableList<DataModel.RewardResponse>) {
        rewardList = rewards
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RewardViewHolder {
        val layout = R.layout.row_reward

        val view = LayoutInflater
            .from(parent.context)
            .inflate(layout, parent, false)

        return RewardViewHolder(view)
    }

    override fun onBindViewHolder(holder: RewardViewHolder, position: Int) {
        //update info
        val reward = rewardList[position]
        holder.updateInfo(reward)
        holder.itemView.setOnClickListener {
//            onClickListener!!.onClick(position, reward)
            holder.toggleRead()
        }
        holder.getBuyButton()?.setOnClickListener {
            val builder = AlertDialog.Builder(context.context!!, com.google.android.material.R.style.Theme_AppCompat_Dialog_Alert)
            builder.setCancelable(true)
            builder.setTitle("Confirm Purchase")
            builder.setMessage("Please make sure you meet any other requirements for this reward prior to purchasing.")
            builder.setNegativeButton("Cancel") { dialog, _ ->
                dialog.dismiss()
            }
            builder.setPositiveButton("Confirm") { dialog, _ ->
                dialog.dismiss()
                holder.buyReward(reward, context)
            }
            builder.show()
        }
    }

    override fun getItemCount(): Int {
        return rewardList.size
    }

    fun setOnClickListener(onClickListener: OnClickListener) {
        this.onClickListener = onClickListener
    }

    interface OnClickListener {
        fun onClick(position: Int, model: DataModel.RewardResponse)
    }
}