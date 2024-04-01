package com.ahscs.eagleengagement.recyclerview

import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.R
import com.ahscs.eagleengagement.datamodels.DataModel
import java.text.SimpleDateFormat

class ClubViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    fun updateInfo(info: DataModel.ClubResponse) {
        var name : TextView = itemView.findViewById(R.id.txtClubName)
        name.text = info.name

        var description : TextView = itemView.findViewById(R.id.txtClubListDescription)
        description.text = info.description
    }

}