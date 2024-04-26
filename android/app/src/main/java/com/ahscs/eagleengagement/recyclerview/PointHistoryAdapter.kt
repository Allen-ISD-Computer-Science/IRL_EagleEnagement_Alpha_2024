package com.ahscs.eagleengagement.recyclerview

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.ahscs.eagleengagement.*
import com.ahscs.eagleengagement.datamodels.DataModel

class PointHistoryAdapter(activity: PointHistoryActivity) : RecyclerView.Adapter<PointHistoryViewHolder>() {
    val context = activity
    private var historyList = mutableListOf<DataModel.PointHistoryResponse>()

    fun updatePointHistory(history: MutableList<DataModel.PointHistoryResponse>) {
        historyList = history
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PointHistoryViewHolder {
        val layout = R.layout.row_point_history

        val view = LayoutInflater
            .from(parent.context)
            .inflate(layout, parent, false)

        return PointHistoryViewHolder(view)
    }

    override fun onBindViewHolder(holder: PointHistoryViewHolder, position: Int) {
        //update info
        val history = historyList[position]
        holder.updateInfo(history)
    }

    override fun getItemCount(): Int {
        return historyList.size
    }
}