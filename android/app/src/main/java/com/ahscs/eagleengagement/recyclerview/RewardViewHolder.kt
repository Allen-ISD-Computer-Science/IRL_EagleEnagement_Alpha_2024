package com.ahscs.eagleengagement.recyclerview

import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.R
import com.ahscs.eagleengagement.datamodels.DataModel
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
            description.maxLines = 10

            var readLess: TextView = itemView.findViewById(R.id.txtReadLessBtn)
            readLess.visibility = View.VISIBLE

            readMore.visibility = View.GONE
        } else {
            var description: TextView = itemView.findViewById(R.id.txtRewardDescription)
            description.maxLines = 2

            var readLess: TextView = itemView.findViewById(R.id.txtReadLessBtn)
            readLess.visibility = View.GONE

            readMore.visibility = View.VISIBLE
        }
    }

}