package com.exercise.stutodo_app.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.TaskModel;
import com.google.android.gms.tasks.Task;

import java.util.ArrayList;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.ViewHolder> {

    View mView;

    Context context;
    ArrayList<TaskModel> tasks;

    public TaskAdapter(Context context, ArrayList<TaskModel> tasks) {
        this.context = context;
        this.tasks = tasks;
    }

    @NonNull
    @Override
    public TaskAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View v = LayoutInflater.from(context).inflate(R.layout.task_custom_item, parent, false);

        return new ViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull TaskAdapter.ViewHolder holder, int position) {

        TaskModel task = tasks.get(position);

        holder.taskTitle.setText(task.getTitle());
        holder.taskNote.setText(task.getNote());
        holder.taskDue.setText("Task Due Soon");
        holder.taskDate.setText(task.getDueDate());
    }

    @Override
    public int getItemCount() {
        return tasks.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        TextView taskTitle;
        TextView taskNote;
        TextView taskDue;
        TextView taskDate;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            taskTitle = itemView.findViewById(R.id.custom_item_title);
            taskNote = itemView.findViewById(R.id.custom_item_note);
            taskDue = itemView.findViewById(R.id.custom_item_due);
            taskDate = itemView.findViewById(R.id.custom_item_date);

        }

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
