package com.exercise.stutodo_app.adapter;

import android.content.Context;
import android.content.Intent;
import android.provider.CalendarContract;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.task.TaskDetailActivity;
import com.google.android.gms.tasks.Task;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.ViewHolder> {

    View mView;

    Context context;
    ArrayList<TaskModel> tasks;

    private String key = "";
    private String taskTitleString;
    private String taskNoteString;
    private String taskDateString;
    private String taskID;

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

        //String date = DateFormat.getDateInstance().format(task.getDueDate());

        holder.taskTitle.setText(task.getTitle());
        holder.taskNote.setText(task.getNote());
        holder.taskDue.setText("Task Due Soon");
        //holder.taskDate.setText(task.getDueDate().toDate().toString());
        holder.taskDate.setText(task.getDueDate().toString());

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

//        holder.addToCalendarButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Log.i("Task", "Add to calendar");
//
//                Intent intent = new Intent(Intent.ACTION_INSERT);
//                intent.setData(CalendarContract.Events.CONTENT_URI);
//                intent.putExtra(CalendarContract.Events.TITLE, tasks.get(holder.getAdapterPosition()).getTitle());
//                intent.putExtra(CalendarContract.Events.DESCRIPTION, tasks.get(holder.getAdapterPosition()).getNote());
//                intent.putExtra(CalendarContract.Events.ALL_DAY, true);
//
//                if(intent.resolveActivity(context.getPackageManager()) != null) {
//
//                    context.startActivity(intent);
//
//                } else {
//
//                    Toast.makeText(context, "App does not support this action", Toast.LENGTH_LONG).show();
//
//                }
//            }
//        });
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
