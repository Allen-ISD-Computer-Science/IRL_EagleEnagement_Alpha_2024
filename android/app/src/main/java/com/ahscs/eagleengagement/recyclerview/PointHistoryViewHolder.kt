package com.ahscs.eagleengagement.recyclerview

import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.R
import com.ahscs.eagleengagement.datamodels.DataModel
import java.text.SimpleDateFormat

class PointHistoryViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    fun updateInfo(info: DataModel.PointHistoryResponse) {
        var reason : TextView = itemView.findViewById(R.id.txtReason)
        reason.text = info.reason

        var points : TextView = itemView.findViewById(R.id.txtPointsWorth)
        points.text = info.points.toString()

        val dateFormat = SimpleDateFormat("MMMM d, yyyy")
        val dateString = dateFormat.format(info.date)
        var date : TextView = itemView.findViewById(R.id.txtDate)
        date.text = dateString
    }

}