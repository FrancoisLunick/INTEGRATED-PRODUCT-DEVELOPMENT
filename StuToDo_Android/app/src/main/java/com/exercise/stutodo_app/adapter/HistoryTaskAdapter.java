package com.exercise.stutodo_app.adapter;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.task.TaskDetailActivity;
import com.google.firebase.firestore.FirebaseFirestore;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class HistoryTaskAdapter extends RecyclerView.Adapter<HistoryTaskAdapter.ViewHolder> {

    private Context context;
    private ArrayList<TaskModel> tasks;

    private String taskTitleString;
    private String taskNoteString;
    private String taskDateString;
    private String taskID;

    private FirebaseFirestore mDB;

    public HistoryTaskAdapter(Context context, ArrayList<TaskModel> tasks) {
        this.context = context;
        this.tasks = tasks;
    }

    @NonNull
    @Override
    public HistoryTaskAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View v = LayoutInflater.from(context).inflate(R.layout.history_task_custom_item, parent, false);

        return new HistoryTaskAdapter.ViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull HistoryTaskAdapter.ViewHolder holder, int position) {

        TaskModel task = tasks.get(position);

        //String date = DateFormat.getDateInstance().format(task.getDueDate());

        SimpleDateFormat spf = new SimpleDateFormat("MMM dd, yyyy");
        String date = spf.format(task.getDueDate());
        holder.histryTaskDate.setText(date);

        holder.historyTaskTitle.setText(task.getTitle());
        holder.historyTaskNote.setText(task.getNote());
        holder.historyTaskDue.setText("Task Completed");
        //holder.taskDate.setText(task.getDueDate().toDate().toString());
        //holder.taskDate.setText(task.getDueDate().toString());

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                taskTitleString = tasks.get(holder.getAdapterPosition()).getTitle();
                taskNoteString = tasks.get(holder.getAdapterPosition()).getNote();
                //taskDateString = tasks.get(holder.getAdapterPosition()).getDueDate().toDate().toString();
                taskDateString = tasks.get(holder.getAdapterPosition()).getDueDate().toString();
                taskID = tasks.get(holder.getAdapterPosition()).getTaskID();

                Log.v("Task", "title" + taskTitleString);

                Intent intent = new Intent(context.getApplicationContext(), TaskDetailActivity.class);
                intent.putExtra("taskTitle", taskTitleString);
                intent.putExtra("taskNote", taskNoteString);
                intent.putExtra("taskDate", taskDateString);
                intent.putExtra("taskID", taskID);

                context.startActivity(intent);

            }
        });
    }

    @Override
    public int getItemCount() {
        return tasks.size();
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
