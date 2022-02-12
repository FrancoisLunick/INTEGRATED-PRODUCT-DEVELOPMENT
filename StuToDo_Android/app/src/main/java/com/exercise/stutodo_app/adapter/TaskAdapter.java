package com.exercise.stutodo_app.adapter;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.R;

public class TaskAdapter extends RecyclerView.ViewHolder {

    View mView;

    public TaskAdapter(@NonNull View itemView) {
        super(itemView);

        mView = itemView;
    }

    public void setTaskTitle(String title) {

        TextView taskTitle = mView.findViewById(R.id.custom_item_title);

        taskTitle.setText(title);

    }

    public void setTaskNote(String note) {

        TextView taskNote = mView.findViewById(R.id.custom_item_note);

        taskNote.setText(note);
    }

    public void setTaskDueMessage(String dueMessage) {

        TextView taskDue = mView.findViewById(R.id.custom_item_due);

        taskDue.setText(dueMessage);

    }

    public void setTaskDate(String date) {

        TextView taskDate = mView.findViewById(R.id.custom_item_date);

        taskDate.setText(date);
    }
}
