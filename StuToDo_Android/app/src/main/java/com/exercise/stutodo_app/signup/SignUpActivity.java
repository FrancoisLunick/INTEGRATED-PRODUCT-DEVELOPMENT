package com.exercise.stutodo_app.signup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.exercise.stutodo_app.task.OnGoingTaskActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.HashMap;
import java.util.UUID;

public class SignUpActivity extends AppCompatActivity {

    private TextInputEditText mFirstNameEditText;
    private TextInputEditText mLastNameEditText;
    private TextInputEditText mAgeEditText;
    private TextInputEditText mUniversityEditText;
    private TextInputEditText mEmailEditText;
    private TextInputEditText mPasswordEditText;
    private ImageView mProfileImageView;
    private MaterialButton mSignUpButton;

    private String mFirstName;
    private String mLastName;
    private String mAge;
    private String mUniversity;
    private String mEmail;
    private String mPassword;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private FirebaseFirestore mDatabaseReference;
    private StorageReference mStorageReference;

    private final int mRequestCode = 101;

    private Uri mLocalURI;
    private Uri mRemoteURI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        mFirebaseAuth = FirebaseAuth.getInstance();
        mDatabaseReference = FirebaseFirestore.getInstance();
        mStorageReference = FirebaseStorage.getInstance().getReference();


        mFirstNameEditText = findViewById(R.id.firstName_editText);
        mLastNameEditText = findViewById(R.id.lastName_editText);
        mAgeEditText = findViewById(R.id.age_editText);
        mUniversityEditText = findViewById(R.id.university_editText);
        mEmailEditText = findViewById(R.id.register_email_editText);
        mPasswordEditText = findViewById(R.id.register_password_editText);
        mProfileImageView = findViewById(R.id.profileImageView);
        mSignUpButton = findViewById(R.id.register_SignupButton);

        mSignUpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                registerUser(view);
            }
        });

        //createProfile();
    }

    public void registerUser(View v) {

        mFirstName = mFirstNameEditText.getText().toString().trim();
        mLastName = mLastNameEditText.getText().toString().trim();
        mAge = mAgeEditText.getText().toString().trim();
        mUniversity = mUniversityEditText.getText().toString().trim();
        mEmail = mEmailEditText.getText().toString().trim();
        mPassword = mPasswordEditText.getText().toString().trim();

        if (TextUtils.isEmpty(mFirstName)) {

            mFirstNameEditText.setError("First Name is required");

        } else if (TextUtils.isEmpty(mLastName)) {

            mLastNameEditText.setError("Last Name is required");

        } else if (TextUtils.isEmpty(mAge)) {

            mAgeEditText.setError("Age is required");

        } else if (TextUtils.isEmpty(mUniversity)) {

            mUniversityEditText.setError("University is required");

        } else if (TextUtils.isEmpty(mEmail)) {

            mEmailEditText.setError("Email is required");

        } else if (TextUtils.isEmpty(mPassword)) {

            mPasswordEditText.setError("Password is required");

        } else {

            mFirebaseAuth.createUserWithEmailAndPassword(mEmail, mPassword).addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                @Override
                public void onComplete(@NonNull Task<AuthResult> task) {

                    if (task.isSuccessful()) {

                        mFirebaseUser = mFirebaseAuth.getCurrentUser();

                        //if(mLocalURI != null) {
                            createProfile();
                        //}

                    } else {

                        Toast.makeText(SignUpActivity.this, "Account Could Not Be Created", Toast.LENGTH_SHORT).show();


                    }

                }
            });

        }
    }

    public void createProfile() {

        String filename = UUID.randomUUID().toString();
        //Toast.makeText(SignUpActivity.this, filename, Toast.LENGTH_SHORT).show();

        StorageReference fileReference = mStorageReference.child("profile_images/" + filename);

        fileReference.putFile(mLocalURI).addOnCompleteListener(new OnCompleteListener<UploadTask.TaskSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<UploadTask.TaskSnapshot> task) {

                if (task.isSuccessful()) {

                    fileReference.getDownloadUrl().addOnSuccessListener(new OnSuccessListener<Uri>() {
                        @Override
                        public void onSuccess(Uri uri) {

                            mRemoteURI = uri;

                            UserProfileChangeRequest userProfileChangeRequest = new UserProfileChangeRequest.Builder()
                                    .setPhotoUri(mRemoteURI)
                                    .build();

                            mFirebaseUser.updateProfile(userProfileChangeRequest).addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    if (task.isSuccessful()) {

                                        String userID = mFirebaseUser.getUid();

                                        //mDatabaseReference = FirebaseFirestore.getInstance().get

                                        HashMap<String, String> userHashMap = new HashMap<>();

                                        userHashMap.put(FirebaseConstants.PROFILEIMAGEURL, mRemoteURI.getPath());
                                        userHashMap.put(FirebaseConstants.FIRSTNAME, mFirstNameEditText.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.LASTNAME, mLastNameEditText.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.AGE, mAgeEditText.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.UNIVERSITY, mUniversityEditText.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.EMAIL, mEmailEditText.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.UID, userID);

                                        mDatabaseReference.collection(FirebaseConstants.users)
                                                .add(userHashMap)
                                                .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
                                                    @Override
                                                    public void onSuccess(DocumentReference documentReference) {

                                                        Toast.makeText(SignUpActivity.this, "Account Created", Toast.LENGTH_SHORT).show();

                                                        Intent intent = new Intent(SignUpActivity.this, OnGoingTaskActivity.class);
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
                    });

                }

            }
        });

    }

    public void profileImageClicked(View v) {

        if(ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {

            Uri mediaURI = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

            Intent pictureIntent = new Intent(Intent.ACTION_PICK, mediaURI);
            startActivityForResult(pictureIntent, mRequestCode);

        } else {

            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.READ_EXTERNAL_STORAGE}, 102);
        }



    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if(requestCode == 102) {

            if(grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                Uri mediaURI = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

                Intent pictureIntent = new Intent(Intent.ACTION_PICK, mediaURI);
                startActivityForResult(pictureIntent, mRequestCode);

            } else {

                Toast.makeText(this, "Permission is Required", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == mRequestCode) {

            if(resultCode == RESULT_OK) {

                mLocalURI = data.getData();

                mProfileImageView.setImageURI(mLocalURI);

            }
        }
    }
}