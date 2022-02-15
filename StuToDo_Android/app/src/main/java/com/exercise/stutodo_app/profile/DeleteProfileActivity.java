package com.exercise.stutodo_app.profile;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.StorageReference;

public class DeleteProfileActivity extends AppCompatActivity {

    private TextInputEditText emailET;
    private TextInputEditText passwordET;
    private MaterialButton deleteButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mFirebaseFirestore;

    private String email;
    private String password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_delete_profile);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = mFirebaseAuth.getCurrentUser();

        mFirebaseFirestore = FirebaseFirestore.getInstance();

        emailET = findViewById(R.id.deleteProfile_emailET);
        passwordET = findViewById(R.id.deleteProfile_passwordET);
        deleteButton = findViewById(R.id.deleteProfileButton);

        deleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                email = emailET.getText().toString();
                password = passwordET.getText().toString();

                AuthCredential credential = EmailAuthProvider
                        .getCredential(email, password);

                if (mFirebaseUser != null) {

                    mFirebaseUser.reauthenticate(credential)
                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    if (task.isSuccessful()) {

                                        mFirebaseUser.delete()
                                                .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                    @Override
                                                    public void onComplete(@NonNull Task<Void> task) {

                                                        if (task.isSuccessful()) {

                                                            DocumentReference userRef = mFirebaseFirestore.collection(FirebaseConstants.users)
                                                                    .document(mFirebaseUser.getUid());

                                                            userRef.delete()
                                                                    .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                        @Override
                                                                        public void onComplete(@NonNull Task<Void> task) {

                                                                            if (task.isSuccessful()) {

                                                                                Toast.makeText(DeleteProfileActivity.this, "Account Deleted", Toast.LENGTH_LONG).show();

                                                                                Intent backToLoginIntent = new Intent(DeleteProfileActivity.this, LoginActivity.class);

                                                                                startActivity(backToLoginIntent);
                                                                                finish();

                                                                            } else {

                                                                                Toast.makeText(DeleteProfileActivity.this, "Failed to delete account", Toast.LENGTH_LONG).show();

                                                                            }

                                                                        }
                                                                    });
                                                        }


                                                    }
                                                });

                                    }
                                }
                            });
                }

            }
        });
    }
}