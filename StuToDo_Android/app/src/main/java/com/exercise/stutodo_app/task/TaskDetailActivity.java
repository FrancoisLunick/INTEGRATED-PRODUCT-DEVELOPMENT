package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.provider.CalendarContract;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.text.SimpleDateFormat;

public class TaskDetailActivity extends AppCompatActivity {

    private TextView titleTextView;
    private TextView dateTextView;
    private TextView notesTextView;
    private MaterialButton editButton;
    private MaterialButton deleteButton;
    private MaterialButton cancelButton;
    private ImageButton backButton;
    //private ImageButton addToCalendarButton;

    private String taskTitle;
    private String taskNote;
    private String taskDate;
    private String taskID;

    private FirebaseFirestore mDB;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_detail);

        mDB = FirebaseFirestore.getInstance();

        titleTextView = findViewById(R.id.taskTitle_detail);
        dateTextView = findViewById(R.id.taskDate_detail);
        notesTextView = findViewById(R.id.taskNotes_detail);
        editButton = findViewById(R.id.editTaskButton);
        deleteButton = findViewById(R.id.deleteTaskButton);
        cancelButton = findViewById(R.id.cancelTaskDetailButton);
        backButton = findViewById(R.id.taskDetail_backButton);

        Intent intent = getIntent();

        taskTitle = intent.getStringExtra("taskTitle");
        taskNote = intent.getStringExtra("taskNote");
        taskDate = intent.getStringExtra("taskDate");
        taskID = intent.getStringExtra("taskID");

//        SimpleDateFormat spf = new SimpleDateFormat("MMM dd, yyyy");
//        String date = spf.format(taskDate);

        titleTextView.setText(taskTitle);
        notesTextView.setText(taskNote);
        dateTextView.setText(taskDate);

        editButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toEditIntent = new Intent(TaskDetailActivity.this, EditTaskActivity.class);

                toEditIntent.putExtra("taskTitle", taskTitle);
                toEditIntent.putExtra("taskNote", taskNote);
                toEditIntent.putExtra("taskDate", taskDate);
                toEditIntent.putExtra("taskID", taskID);
                startActivity(toEditIntent);

            }
        });

        deleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                DocumentReference taskRef = mDB.collection(FirebaseConstants.tasks)
                        .document(taskID);

                taskRef.delete()
                        .addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull Task<Void> task) {

                                if (task.isSuccessful()) {

                                    Log.i("TASK", "Task Deleted");

                                    Intent toOngoingIntent = new Intent(TaskDetailActivity.this, OnGoingTaskActivity.class);

                                    startActivity(toOngoingIntent);
                                    finish();

                                } else {

                                    Log.i("TASK", "Failed to delete task");

                                }
                            }
                        });
            }
        });

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toOngoingIntent = new Intent(TaskDetailActivity.this, OnGoingTaskActivity.class);
                startActivity(toOngoingIntent);

                finish();
            }
        });

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent backIntent = new Intent(TaskDetailActivity.this, OnGoingTaskActivity.class);

                startActivity(backIntent);
                finish();

            }
        });
    }
}