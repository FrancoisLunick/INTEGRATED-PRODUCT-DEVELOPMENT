package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.CalendarView;
import android.widget.DatePicker;
import android.widget.ImageButton;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class EditTaskActivity extends AppCompatActivity {

    private TextInputEditText taskTitleEditText;
    private TextInputEditText taskNotesEditText;
    private DatePicker taskDateCalendarView;
    private MaterialButton updateButton;
    private ImageButton backButton;

    private String taskTitle;
    private String taskNote;
    private Date taskDate;
    private String taskID;

    private FirebaseFirestore mDB;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_task);

        mDB = FirebaseFirestore.getInstance();

        taskTitleEditText = findViewById(R.id.edit_addTitle_editText);
        taskNotesEditText = findViewById(R.id.edit_addNotes_editText);
        taskDateCalendarView = findViewById(R.id.edit_taskCalendarView);
        updateButton = findViewById(R.id.updateTaskButton);
        backButton = findViewById(R.id.editTask_backButton);

        Intent intent = getIntent();
        taskTitle = intent.getStringExtra("taskTitle");
        taskNote = intent.getStringExtra("taskNote");
        taskID = intent.getStringExtra("taskID");

        taskTitleEditText.setText(taskTitle);
        taskNotesEditText.setText(taskNote);

        updateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                int year = taskDateCalendarView.getYear();
                int month = taskDateCalendarView.getMonth();
                int day = taskDateCalendarView.getDayOfMonth();

                Calendar calendar = Calendar.getInstance();
                calendar.set(year, month, day);

                SimpleDateFormat format = new SimpleDateFormat("MM-dd-yyyy");
                String strDate = format.format(calendar.getTime());

                try {
                    taskDate = format.parse(strDate);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                //taskDate = StringToDate(taskDateCalendarView.getDayOfMonth());



                taskTitle = taskTitleEditText.getText().toString();
                taskNote = taskNotesEditText.getText().toString();

                DocumentReference taskRef = mDB.collection(FirebaseConstants.tasks)
                        .document(taskID);

                taskRef.update(
                        FirebaseConstants.TITLE, taskTitle,
                        FirebaseConstants.NOTE, taskNote,
                        FirebaseConstants.DUEDATE, taskDate
                ).addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {

                        if (task.isSuccessful()) {

                            Log.i("TASK", "Updated Task");

                            Intent goToOngoingIntent = new Intent(EditTaskActivity.this, OnGoingTaskActivity.class);

                            startActivity(goToOngoingIntent);
                            finish();

                        } else {

                            Log.e("TASK", "Updated Task Failed");

                        }
                    }
                });
            }
        });

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent backIntent = new Intent(EditTaskActivity.this, TaskDetailActivity.class);

                startActivity(backIntent);
                finish();

            }
        });
    }
}