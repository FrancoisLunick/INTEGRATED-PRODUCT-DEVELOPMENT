package com.exercise.stutodo_app.adapter;

import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.R;

public class HistoryTaskAdapter extends RecyclerView.Adapter<HistoryTaskAdapter.ViewHolder> {

    @NonNull
    @Override
    public HistoryTaskAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return null;
    }

    @Override
    public void onBindViewHolder(@NonNull HistoryTaskAdapter.ViewHolder holder, int position) {

    }

    @Override
    public int getItemCount() {
        return 0;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        TextView historyTaskTitle;
        TextView historyTaskNote;
        TextView historyTaskDue;
        TextView histryTaskDate;
        ImageView historyTaskCheck;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            historyTaskTitle = itemView.findViewById(R.id.custom_item_historyTitle);
            historyTaskNote = itemView.findViewById(R.id.custom_item_historyNote);
            historyTaskDue = itemView.findViewById(R.id.custom_item_historyDue);
            histryTaskDate = itemView.findViewById(R.id.custom_item_historyDate);
            historyTaskCheck = itemView.findViewById(R.id.historyTask_circle);

        }

    }
}
