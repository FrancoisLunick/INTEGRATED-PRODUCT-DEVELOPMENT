package com.exercise.stutodo_app.task;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.adapter.TaskAdapter;
import com.exercise.stutodo_app.login.LoginActivity;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.profile.ProfileActivity;
import com.exercise.stutodo_app.signup.SignUpActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentChange;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.storage.StorageReference;

import java.util.ArrayList;

public class OnGoingTaskActivity extends AppCompatActivity {

    private Toolbar mToolbar;
    private RecyclerView mRecyclerView;
    private FloatingActionButton mAddTaskButton;
    private ImageButton profileImageButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mDatabaseReference;
    private StorageReference mStorageReference;

    private String userID;

    private ArrayList<TaskModel> tasks;

    private TaskAdapter taskAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_on_going_task);

        mRecyclerView = findViewById(R.id.onGoingRecyclerview);
        mAddTaskButton = findViewById(R.id.onGoingFloatingButton);
        profileImageButton = findViewById(R.id.profileButton);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
//        linearLayoutManager.setReverseLayout(true);
//        linearLayoutManager.setStackFromEnd(true);

        mRecyclerView.setHasFixedSize(true);
        mRecyclerView.setLayoutManager(linearLayoutManager);

        userID = mFirebaseUser.getUid();
        mDatabaseReference = FirebaseFirestore.getInstance();

        tasks = new ArrayList<TaskModel>();
        taskAdapter = new TaskAdapter(OnGoingTaskActivity.this, tasks);

        mRecyclerView.setAdapter(taskAdapter);

        EventChangeListener();

        mAddTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(OnGoingTaskActivity.this, AddTaskActivity.class);

                startActivity(intent);
            }
        });

        profileImageButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toProfileIntent = new Intent(OnGoingTaskActivity.this, ProfileActivity.class);

                startActivity(toProfileIntent);

            }
        });

    }

    private void EventChangeListener() {

        CollectionReference taskCollectionRef = mDatabaseReference.collection(FirebaseConstants.tasks);

        Query taskQuery = taskCollectionRef
                .whereEqualTo(FirebaseConstants.UID, mFirebaseUser.getUid())
                .whereEqualTo(FirebaseConstants.ISDONE, false)
                .orderBy(FirebaseConstants.DUEDATE, Query.Direction.ASCENDING);

        taskQuery.get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
            @Override
            public void onComplete(@NonNull Task<QuerySnapshot> task) {

                if (task.isSuccessful()) {

                    for(QueryDocumentSnapshot documentSnapshot: task.getResult()) {

                        tasks.add(documentSnapshot.toObject(TaskModel.class));
                    }

                    taskAdapter.notifyDataSetChanged();

                } else {

                    Log.e("TASK", "Failed to query data");

                }
            }
        });

//        mDatabaseReference.collection(FirebaseConstants.tasks).orderBy(FirebaseConstants.TITLE, Query.Direction.ASCENDING)
//                .addSnapshotListener(new EventListener<QuerySnapshot>() {
//                    @Override
//                    public void onEvent(@Nullable QuerySnapshot value, @Nullable FirebaseFirestoreException error) {
//
//                        if (error != null) {
//
//                            Log.e("error", error.getMessage());
//
//                            return;
//                        }
//
//                        for (DocumentChange dc: value.getDocumentChanges()) {
//
//                            if (dc.getType() == DocumentChange.Type.ADDED) {
//
//                                tasks.add(dc.getDocument().toObject(TaskModel.class));
//
//                            }
//
//                            taskAdapter.notifyDataSetChanged();
//
//                        }
//                    }
//                });
    }

    @Override
    protected void onStart() {
        super.onStart();

    }
}