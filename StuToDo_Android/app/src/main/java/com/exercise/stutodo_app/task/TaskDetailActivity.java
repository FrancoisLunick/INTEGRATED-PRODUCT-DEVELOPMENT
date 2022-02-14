package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

public class TaskDetailActivity extends AppCompatActivity {

    TextView titleTextView;
    TextView dateTextView;
    TextView notesTextView;
    MaterialButton editButton;
    MaterialButton deleteButton;
    MaterialButton cancelButton;

    String taskTitle;
    String taskNote;
    String taskDate;
    String taskID;

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

        Intent intent = getIntent();

        taskTitle = intent.getStringExtra("taskTitle");
        taskNote = intent.getStringExtra("taskNote");
        taskDate = intent.getStringExtra("taskDate");
        taskID = intent.getStringExtra("taskID");

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
    }
}