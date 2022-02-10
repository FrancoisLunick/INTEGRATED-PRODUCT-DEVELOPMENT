package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.CalendarView;
import android.widget.TextView;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.signup.SignUpActivity;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;
import java.util.HashMap;
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
    private Date taskDueDate;

    private TaskModel task;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_task);

        task = new TaskModel();

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

//                String taskId = UUID.randomUUID().toString();
//                Date createdAt = currentTime;
//                String taskTitle = titleEditText.getText().toString().trim();
//                String taskNotes = notesEditText.getText().toString().trim();
//                boolean isDone = false;
//                //Date taskDueDate =
//                String uid = userID;

                task.setTaskID(UUID.randomUUID().toString());
                task.setCreatedAt(currentTime);
                task.setTitle(titleEditText.getText().toString().trim());
                task.setNote(notesEditText.getText().toString().trim());
                task.setIsDone(false);
                task.setUid(userID);

                if (TextUtils.isEmpty(task.getTitle())) {

                    titleEditText.setError("Title is required");

                } else if (TextUtils.isEmpty(task.getNote())) {

                    notesEditText.setError("Task note is required");

                } else {

                    HashMap<String, Object> taskHashMap = new HashMap<>();

                    taskHashMap.put(FirebaseConstants.TASKID, task.getTaskID());
                    taskHashMap.put(FirebaseConstants.CREATEDAT, task.getCreatedAt());
                    taskHashMap.put(FirebaseConstants.TITLE, task.getTitle());
                    taskHashMap.put(FirebaseConstants.NOTE, task.getNote());
                    taskHashMap.put(FirebaseConstants.ISDONE, task.getIsDone());
                    taskHashMap.put(FirebaseConstants.UID, task.getUid());

                    mDatabaseReference.collection(FirebaseConstants.tasks)
                            .add(taskHashMap)
                            .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
                                @Override
                                public void onSuccess(DocumentReference documentReference) {

                                    Intent intent = new Intent(AddTaskActivity.this, OnGoingTaskActivity.class);
                                    startActivity(intent);
                                }
                            })
                            .addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {

                                }
                            });
                }
            }
        });
    }
}