package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.adapter.HistoryTaskAdapter;
import com.exercise.stutodo_app.adapter.TaskAdapter;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.profile.ProfileActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;

public class TaskHistoryActivity extends AppCompatActivity {

    private RecyclerView mRecyclerView;
    private FloatingActionButton mAddTaskButton;
    private FloatingActionButton mHistoryTaskButton;
    private FloatingActionButton mHomeTaskButton;
    private ImageButton profileImageButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mDatabaseReference;

    private String userID;

    private ArrayList<TaskModel> tasks;

    //private HistoryTaskAdapter historyTaskAdapter;

    private TaskAdapter historyTaskAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_history);

        mRecyclerView = findViewById(R.id.historyRecyclerview);
        mAddTaskButton = findViewById(R.id.historyAddTaskFloatingButton);
        mHistoryTaskButton = findViewById(R.id.historyFloatingButton);
        mHomeTaskButton = findViewById(R.id.historyHomeFloatingButton);
        profileImageButton = findViewById(R.id.historyProfileButton);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);

        mRecyclerView.setHasFixedSize(true);
        mRecyclerView.setLayoutManager(linearLayoutManager);

        userID = mFirebaseUser.getUid();
        mDatabaseReference = FirebaseFirestore.getInstance();

        tasks = new ArrayList<TaskModel>();
        //historyTaskAdapter = new HistoryTaskAdapter(TaskHistoryActivity.this, tasks);
        historyTaskAdapter = new TaskAdapter(TaskHistoryActivity.this, tasks);

        mRecyclerView.setAdapter(historyTaskAdapter);

        EventChangeListener();

        mAddTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(TaskHistoryActivity.this, AddTaskActivity.class);

                startActivity(intent);
            }
        });

        mHistoryTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(TaskHistoryActivity.this, TaskHistoryActivity.class);

                startActivity(intent);

            }
        });

        mHomeTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(TaskHistoryActivity.this, OnGoingTaskActivity.class);

                startActivity(intent);

            }
        });

        profileImageButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toProfileIntent = new Intent(TaskHistoryActivity.this, ProfileActivity.class);

                startActivity(toProfileIntent);

            }
        });
    }

    private void EventChangeListener() {

        CollectionReference taskCollectionRef = mDatabaseReference.collection(FirebaseConstants.tasks);

        Query taskHistoryQuery = taskCollectionRef
                .whereEqualTo(FirebaseConstants.UID, userID)
                .whereEqualTo(FirebaseConstants.ISDONE, true)
                .orderBy(FirebaseConstants.DUEDATE, Query.Direction.ASCENDING);

        taskHistoryQuery.get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
            @Override
            public void onComplete(@NonNull Task<QuerySnapshot> task) {

                if (task.isSuccessful()) {

                    for (QueryDocumentSnapshot documentSnapshot : task.getResult()) {

                        tasks.add(documentSnapshot.toObject(TaskModel.class));
                    }

                    historyTaskAdapter.notifyDataSetChanged();

                } else {

                    Log.e("TASK", "Failed to query data");

                }
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }
}