package com.exercise.stutodo_app.task;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import com.exercise.stutodo_app.R;
import com.google.android.material.button.MaterialButton;

public class TaskDetailActivity extends AppCompatActivity {

    TextView titleTextView;
    TextView dateTextView;
    TextView notesTextView;
    MaterialButton editButton;
    MaterialButton deleteButton;

    String taskTitle;
    String taskNote;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_detail);

        titleTextView = findViewById(R.id.taskTitle_detail);
        dateTextView = findViewById(R.id.taskDate_detail);
        notesTextView = findViewById(R.id.taskNotes_detail);
        editButton = findViewById(R.id.editTaskButton);

        Intent intent = getIntent();

        taskTitle = intent.getStringExtra("taskTitle");
        taskNote = intent.getStringExtra("taskNote");

        titleTextView.setText(taskTitle);
        notesTextView.setText(taskNote);
    }
}