package com.exercise.stutodo_app.adapter;

import android.content.Context;
import android.content.Intent;
import android.provider.CalendarContract;
import android.text.format.Time;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.task.EditTaskActivity;
import com.exercise.stutodo_app.task.OnGoingTaskActivity;
import com.exercise.stutodo_app.task.TaskDetailActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.ViewHolder> {

    View mView;

    Context context;
    ArrayList<TaskModel> tasks;

    private String key = "";
    private String taskTitleString;
    private String taskNoteString;
    private String taskDateString;
    private String taskID;

    private FirebaseFirestore mDB;

    public TaskAdapter(Context context, ArrayList<TaskModel> tasks) {
        this.context = context;
        this.tasks = tasks;
    }

    @NonNull
    @Override
    public TaskAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View v = LayoutInflater.from(context).inflate(R.layout.task_custom_item, parent, false);

        return new ViewHolder(v);

//        if (viewType == 1) {
//            View v = LayoutInflater.from(context).inflate(R.layout.task_custom_item, parent, false);
//
//            return new ViewHolder(v);
//        } else {
//
//            View v = LayoutInflater.from(context).inflate(R.layout.history_task_custom_item, parent, false);
//
//            return new ViewHolder(v);
//        }

    }

    @Override
    public void onBindViewHolder(@NonNull TaskAdapter.ViewHolder holder, int position) {

        TaskModel task = tasks.get(position);

        //String date = DateFormat.getDateInstance().format(task.getDueDate());

        SimpleDateFormat spf = new SimpleDateFormat("MMM dd, yyyy");
        String date = spf.format(task.getDueDate());
        holder.taskDate.setText(date);

        holder.taskTitle.setText(task.getTitle());
        holder.taskNote.setText(task.getNote());
        holder.taskDue.setText("Task Due Soon");
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

        holder.taskCircle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Log.v("Task", "Task Complete");

//                int year = taskDateCalendarView.getYear();
//                int month = taskDateCalendarView.getMonth();
//                int day = taskDateCalendarView.getDayOfMonth();
//
//                Calendar calendar = Calendar.getInstance();
//                calendar.set(year, month, day);
//
//                SimpleDateFormat format = new SimpleDateFormat("MM-dd-yyyy");
//                String strDate = format.format(calendar.getTime());
//
//                try {
//                    taskDate = format.parse(strDate);
//                } catch (ParseException e) {
//                    e.printStackTrace();
//                }

                //taskDate = StringToDate(taskDateCalendarView.getDayOfMonth());


//                taskTitle = taskTitleEditText.getText().toString();
//                taskNote = taskNotesEditText.getText().toString();

                Date currentTime = Calendar.getInstance().getTime();

                taskID = tasks.get(holder.getAdapterPosition()).getTaskID();

                mDB = FirebaseFirestore.getInstance();

                DocumentReference taskRef = mDB.collection(FirebaseConstants.tasks)
                        .document(taskID);

                if (!tasks.get(holder.getAdapterPosition()).getIsDone()) {

                    taskRef.update(
                            FirebaseConstants.ISDONE, true,
                            FirebaseConstants.COMPLETEDAT, currentTime
                    ).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {

                            if (task.isSuccessful()) {

                                Log.i("TASK", "Updated Task");

                            } else {

                                Log.e("TASK", "Updated Task Failed");

                            }
                        }
                    });
                } else {

                    taskRef.update(
                            FirebaseConstants.ISDONE, false,
                            FirebaseConstants.COMPLETEDAT, currentTime
                    ).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {

                            if (task.isSuccessful()) {

                                Log.i("TASK", "Updated Task");

                            } else {

                                Log.e("TASK", "Updated Task Failed");

                            }
                        }
                    });
                }
            }
        });

        holder.calendarButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                taskTitleString = tasks.get(holder.getAdapterPosition()).getTitle();
                taskNoteString = tasks.get(holder.getAdapterPosition()).getNote();
                //taskDateString = tasks.get(holder.getAdapterPosition()).getDueDate().toDate().toString();
                taskDateString = tasks.get(holder.getAdapterPosition()).getDueDate().toString();
                taskID = tasks.get(holder.getAdapterPosition()).getTaskID();

                Intent intent = new Intent(Intent.ACTION_INSERT);
                intent.setData(CalendarContract.Events.CONTENT_URI);
                intent.putExtra(CalendarContract.Events.CALENDAR_ID, 1);
                intent.putExtra(CalendarContract.Events.TITLE, taskTitleString);
                intent.putExtra(CalendarContract.Events.DESCRIPTION, taskNoteString);
                intent.putExtra(CalendarContract.Events.DTSTART, tasks.get(holder.getAdapterPosition()).getDueDate().getTime());
                intent.putExtra(CalendarContract.Events.DTEND, tasks.get(holder.getAdapterPosition()).getDueDate().getTime());
                intent.putExtra(CalendarContract.Events.EVENT_TIMEZONE, Time.getCurrentTimezone());
                intent.putExtra(CalendarContract.Events.ALL_DAY, 1);

                if (intent.resolveActivity(context.getPackageManager()) != null) {

                    context.startActivity(intent);

                } else {

                    Toast.makeText(context, "Cannot support this action", Toast.LENGTH_SHORT).show();
                    
                }
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
        ImageView taskCircle;
        ImageButton calendarButton;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            taskTitle = itemView.findViewById(R.id.custom_item_title);
            taskNote = itemView.findViewById(R.id.custom_item_note);
            taskDue = itemView.findViewById(R.id.custom_item_due);
            taskDate = itemView.findViewById(R.id.custom_item_date);
            taskCircle = itemView.findViewById(R.id.task_circle);
            calendarButton = itemView.findViewById(R.id.addCalendarButton);

        }

    }
}
