package com.exercise.stutodo_app.profile;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.exercise.stutodo_app.task.AddTaskActivity;
import com.exercise.stutodo_app.task.OnGoingTaskActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;

public class ChangeEmailActivity extends AppCompatActivity {

    private TextInputEditText currentEmailEditText;
    private TextInputEditText currentPasswordEditText;
    private TextInputEditText newEmailEditText;
    private MaterialButton changeEmailButton;
    private ImageButton backButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mDatabaseReference;

    private String firstname;
    private String lastname;
    private String age;
    private String university;
    private String email;
    private String uid;
    private String profileURL;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_email);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = mFirebaseAuth.getCurrentUser();

        mDatabaseReference = FirebaseFirestore.getInstance();

        currentEmailEditText = findViewById(R.id.currentEmail_editText);
        currentPasswordEditText = findViewById(R.id.currentPassword_editText);
        newEmailEditText = findViewById(R.id.newEmail_editText);
        changeEmailButton = findViewById(R.id.changeEmail_buttonCE);
        backButton = findViewById(R.id.changeEmail_backButton);

        Intent intent = getIntent();

        email = intent.getStringExtra("email");

        firstname = intent.getStringExtra("firstname");
        lastname = intent.getStringExtra("lastname");
        age = intent.getStringExtra("age");
        university = intent.getStringExtra("university");
        uid = intent.getStringExtra("uid");
        profileURL = intent.getStringExtra("profileURL");

        changeEmailButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (mFirebaseUser != null) {

                    AuthCredential credential = EmailAuthProvider
                            .getCredential(email, currentPasswordEditText.getText().toString());

                    mFirebaseUser.reauthenticate(credential)
                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    mFirebaseUser = mFirebaseAuth.getCurrentUser();

                                    mFirebaseUser.updateEmail(newEmailEditText.getText().toString())
                                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                @Override
                                                public void onComplete(@NonNull Task<Void> task) {

                                                    if (task.isSuccessful()) {

                                                        UserProfileChangeRequest userProfileChangeRequest = new UserProfileChangeRequest.Builder()
                                                                .build();

                                                        DocumentReference userRef = mDatabaseReference.collection(FirebaseConstants.users)
                                                                .document(uid);

                                                        mFirebaseUser.updateProfile(userProfileChangeRequest).addOnCompleteListener(new OnCompleteListener<Void>() {
                                                            @Override
                                                            public void onComplete(@NonNull Task<Void> task) {

                                                                if(task.isSuccessful()) {

                                                                    HashMap<String, String> userHashMap = new HashMap<>();

                                                                    userHashMap.put(FirebaseConstants.PROFILEIMAGEURL, profileURL);
                                                                    userHashMap.put(FirebaseConstants.FIRSTNAME, firstname);
                                                                    userHashMap.put(FirebaseConstants.LASTNAME, lastname);
                                                                    userHashMap.put(FirebaseConstants.AGE, age);
                                                                    userHashMap.put(FirebaseConstants.UNIVERSITY, university);
                                                                    userHashMap.put(FirebaseConstants.EMAIL, newEmailEditText.getText().toString());
                                                                    userHashMap.put(FirebaseConstants.UID, uid);

                                                                    userRef.set(userHashMap)
                                                                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                @Override
                                                                                public void onComplete(@NonNull Task<Void> task) {

                                                                                    if (task.isSuccessful()) {

                                                                                        Log.e("TASK", "Saved changes");

                                                                                    }  else {

                                                                                        Log.e("TASK", "Failed to save changes");
                                                                                    }

                                                                                }
                                                                            });
                                                                }
                                                            }
                                                        });


                                                        Toast.makeText(ChangeEmailActivity.this, "Email Changed", Toast.LENGTH_LONG).show();

                                                        mFirebaseAuth.signOut();

                                                        Intent backToLoginIntent = new Intent(ChangeEmailActivity.this, LoginActivity.class);

                                                        startActivity(backToLoginIntent);
                                                        finish();

                                                    } else {

                                                    }
                                                }

                                            });
                                }
                            });


                }

            }
        });

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent backIntent = new Intent(ChangeEmailActivity.this, ChangeEmailAndPasswordActivity.class);

                startActivity(backIntent);
                finish();

            }
        });

    }
}