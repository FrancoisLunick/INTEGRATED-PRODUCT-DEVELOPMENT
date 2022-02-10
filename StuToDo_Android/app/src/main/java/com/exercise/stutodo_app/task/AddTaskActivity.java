package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.CalendarView;
import android.widget.TextView;

import com.exercise.stutodo_app.R;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;
import java.util.UUID;

public class AddTaskActivity extends AppCompatActivity {

    private TextInputEditText titleEditText;
    private CalendarView taskCalendarView;
    private TextInputEditText notesEditText;
    private MaterialButton addTaskButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mDatabaseReference;
    private StorageReference mStorageReference;

    private String userID;
    Date taskDueDate;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_task);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        userID = mFirebaseUser.getUid();
        mDatabaseReference = FirebaseFirestore.getInstance();

        titleEditText = findViewById(R.id.addTitle_editText);
        taskCalendarView = findViewById(R.id.taskCalendarView);
        notesEditText = findViewById(R.id.addNotes_editText);
        addTaskButton = findViewById(R.id.addTaskButton);

        addTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

//                taskCalendarView.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
//                    @Override
//                    public void onSelectedDayChange(@NonNull CalendarView calendarView, int i, int i1, int i2) {
//
//                        taskDueDate = calendarView.getDate();
//                    }
//                });

                Date currentTime = Calendar.getInstance().getTime();

                String taskId = UUID.randomUUID().toString();
                Date createdAt = currentTime;
                String taskTitle = titleEditText.getText().toString().trim();
                String taskNotes = notesEditText.getText().toString().trim();
                boolean isDone = false;
                //Date taskDueDate =
                String uid = userID;



            }
        });
    }
}