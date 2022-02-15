package com.exercise.stutodo_app.profile;

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
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.models.User;
import com.exercise.stutodo_app.signup.SignUpActivity;
import com.exercise.stutodo_app.task.AddTaskActivity;
import com.exercise.stutodo_app.task.OnGoingTaskActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import org.w3c.dom.Text;

import java.util.HashMap;
import java.util.UUID;

public class ProfileActivity extends AppCompatActivity {

    private ImageView profileImageView;
    private TextView editProfileTV;
    private TextView changePassOrEmaTV;
    private TextView deleteProfileTV;
    private TextInputEditText firstNameET;
    private TextInputEditText lastNameET;
    private TextInputEditText ageET;
    private TextInputEditText universityET;
    private TextInputEditText emailET;
    private MaterialButton saveChangesButton;
    private MaterialButton logoutButton;
    private ImageButton backButton;

    private final int mRequestCode = 101;

    private Uri mLocalURI;
    private Uri mRemoteURI;

    private User user;

    private String userID;
    private String firstname;
    private String lastname;
    private String age;
    private String university;
    private String email;
    private String profileImageUrl;

    private FirebaseAuth firebaseAuth;
    private FirebaseUser firebaseUser;
    private StorageReference mStorageReference;

    private FirebaseFirestore mDatabaseReference;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        user = new User();

        firebaseAuth = FirebaseAuth.getInstance();
        firebaseUser = firebaseAuth.getCurrentUser();

        mStorageReference = FirebaseStorage.getInstance().getReference();

        mDatabaseReference = FirebaseFirestore.getInstance();

        profileImageView = findViewById(R.id.profileImageView_profilePage);
        editProfileTV = findViewById(R.id.editProfile_textView);
        changePassOrEmaTV = findViewById(R.id.changePasswordAndEmail_textView);
        deleteProfileTV = findViewById(R.id.deleteProfile_textView);
        firstNameET = findViewById(R.id.firstName_editText_profilePage);
        lastNameET = findViewById(R.id.lastName_editText_profilePage);
        ageET = findViewById(R.id.age_editText_profilePage);
        universityET = findViewById(R.id.university_editText_profilePage);
        emailET = findViewById(R.id.email_editText_profilePage);
        saveChangesButton = findViewById(R.id.saveChangesButton);
        logoutButton = findViewById(R.id.profile_logoutButton);

        userID = firebaseUser.getUid();

        mRemoteURI = firebaseUser.getPhotoUrl();

        DocumentReference userRef = mDatabaseReference.collection(FirebaseConstants.users)
                .document(userID);

        userRef.get()
                .addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
                    @Override
                    public void onComplete(@NonNull Task<DocumentSnapshot> task) {

                        if (task.isSuccessful()) {

                            firstname = task.getResult().getString("firstname");
                            lastname = task.getResult().getString("lastname");
                            age = task.getResult().getString("age");
                            university = task.getResult().getString("university");
                            email = task.getResult().getString("email");
                            profileImageUrl = task.getResult().getString("profileImageUrl");

                            user.setFirstName(firstname);
                            user.setLastName(lastname);
                            user.setAge(age);
                            user.setUniversity(university);
                            user.setEmail(email);
                            user.setProfileImageUrl(profileImageUrl);
                            user.setUid(userID);

                            firstNameET.setText(firstname);
                            lastNameET.setText(lastname);
                            ageET.setText(age);
                            universityET.setText(university);
                            emailET.setText(email);
                        }

                    }
                });

        if(mRemoteURI != null) {

            Glide.with(this)
                    .load(mRemoteURI)
                    .placeholder(R.drawable.ic_baseline_person_24)
                    .error(R.drawable.ic_baseline_person_24)
                    .into(profileImageView);

        }

//        CollectionReference userCollectionRef = mDatabaseReference.collection(FirebaseConstants.users);
//
//        Query userQuery = userCollectionRef;
//
//        userQuery.get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
//            @Override
//            public void onComplete(@NonNull Task<QuerySnapshot> task) {
//
//                if (task.isSuccessful()) {
//
//                    for(QueryDocumentSnapshot documentSnapshot: task.getResult()) {
//
//                        user = documentSnapshot.toObject(User.class);
//                    }
//
//
//                } else {
//
//                    Log.e("TASK", "Failed to query data");
//
//                }
//            }
//        });

        logoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                firebaseAuth.signOut();

                Intent toLoginIntent = new Intent(ProfileActivity.this, LoginActivity.class);

                startActivity(toLoginIntent);
                finish();
            }
        });

        saveChangesButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (mLocalURI != null) {

                    updateProfile();

                } else {

                    updateProfileWOPicture();
                }

                saveChangesButton.setVisibility(View.INVISIBLE);
                editProfileTV.setVisibility(View.VISIBLE);

                firstNameET.setEnabled(false);
                lastNameET.setEnabled(false);
                ageET.setEnabled(false);
                universityET.setEnabled(false);
            }
        });

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent backIntent = new Intent(ProfileActivity.this, OnGoingTaskActivity.class);

                startActivity(backIntent);
                finish();

            }
        });

    }

    private void updateProfile() {

        String filename = UUID.randomUUID().toString();

        StorageReference fileReference = mStorageReference.child("profile_images/" + filename);

        DocumentReference userRef = mDatabaseReference.collection(FirebaseConstants.users)
                .document(userID);

        fileReference.putFile(mLocalURI).addOnCompleteListener(new OnCompleteListener<UploadTask.TaskSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<UploadTask.TaskSnapshot> task) {

                if(task.isSuccessful()) {

                    fileReference.getDownloadUrl().addOnSuccessListener(new OnSuccessListener<Uri>() {
                        @Override
                        public void onSuccess(Uri uri) {

                            mRemoteURI = uri;

                            UserProfileChangeRequest userProfileChangeRequest = new UserProfileChangeRequest.Builder()
                                    .setPhotoUri(mRemoteURI)
                                    .build();

                            firebaseUser.updateProfile(userProfileChangeRequest).addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    if(task.isSuccessful()) {

                                        //String userID = mFirebaseUser.getUid();

                                        //DatabaseReference = FirebaseDatabase.getInstance().getReference().child(FirebaseNames.USERS);

                                        HashMap<String, String> userHashMap = new HashMap<>();

                                        userHashMap.put(FirebaseConstants.PROFILEIMAGEURL, mRemoteURI.getPath());
                                        userHashMap.put(FirebaseConstants.FIRSTNAME, firstNameET.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.LASTNAME, lastNameET.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.AGE, ageET.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.UNIVERSITY, universityET.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.EMAIL, emailET.getText().toString().trim());
                                        userHashMap.put(FirebaseConstants.UID, userID);

                                        userRef.set(userHashMap)
                                                .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                    @Override
                                                    public void onComplete(@NonNull Task<Void> task) {

                                                        if (task.isSuccessful()) {

                                                            Toast.makeText(ProfileActivity.this, "Changes Saved", Toast.LENGTH_LONG).show();

                                                            user.setFirstName(firstNameET.getText().toString().trim());
                                                            user.setLastName(lastNameET.getText().toString().trim());
                                                            user.setAge(ageET.getText().toString().trim());
                                                            user.setUniversity(universityET.getText().toString().trim());
                                                            user.setEmail(emailET.getText().toString().trim());
                                                            user.setProfileImageUrl(mRemoteURI.getPath());
                                                            user.setUid(userID);

                                                        }  else {

                                                            Log.e("TASK", "Failed to save changes");
                                                        }

                                                    }
                                                });


                                    } else {

                                        Toast.makeText(ProfileActivity.this, "Failed to save changes", Toast.LENGTH_SHORT).show();

                                    }
                                }
                            });
                        }
                    });
                }
            }
        });

    }

    private void updateProfileWOPicture() {

        UserProfileChangeRequest userProfileChangeRequest = new UserProfileChangeRequest.Builder()
                .build();

        DocumentReference userRef = mDatabaseReference.collection(FirebaseConstants.users)
                .document(userID);

        firebaseUser.updateProfile(userProfileChangeRequest).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {

                if(task.isSuccessful()) {

                    HashMap<String, String> userHashMap = new HashMap<>();

                    userHashMap.put(FirebaseConstants.PROFILEIMAGEURL, mRemoteURI.getPath());
                    userHashMap.put(FirebaseConstants.FIRSTNAME, firstNameET.getText().toString().trim());
                    userHashMap.put(FirebaseConstants.LASTNAME, lastNameET.getText().toString().trim());
                    userHashMap.put(FirebaseConstants.AGE, ageET.getText().toString().trim());
                    userHashMap.put(FirebaseConstants.UNIVERSITY, universityET.getText().toString().trim());
                    userHashMap.put(FirebaseConstants.EMAIL, emailET.getText().toString().trim());
                    userHashMap.put(FirebaseConstants.UID, userID);

                    userRef.set(userHashMap)
                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    if (task.isSuccessful()) {

                                        Toast.makeText(ProfileActivity.this, "Changes Saved", Toast.LENGTH_LONG).show();

                                        user.setFirstName(firstNameET.getText().toString().trim());
                                        user.setLastName(lastNameET.getText().toString().trim());
                                        user.setAge(ageET.getText().toString().trim());
                                        user.setUniversity(universityET.getText().toString().trim());
                                        user.setEmail(emailET.getText().toString().trim());
                                        user.setProfileImageUrl(mRemoteURI.getPath());
                                        user.setUid(userID);

                                    }  else {

                                        Log.e("TASK", "Failed to save changes");
                                    }

                                }
                            });
                } else {

                    Toast.makeText(ProfileActivity.this, "Failed to save changes", Toast.LENGTH_SHORT).show();

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

    public void editProfileTVClicked(View v) {

        editProfileTV.setVisibility(View.INVISIBLE);
        saveChangesButton.setVisibility(View.VISIBLE);

        firstNameET.setEnabled(true);
        lastNameET.setEnabled(true);
        ageET.setEnabled(true);
        universityET.setEnabled(true);

    }

    public void changePassOrEmailClicked(View v) {

         Intent toChangePassOrEmailIntent = new Intent(ProfileActivity.this, ChangeEmailAndPasswordActivity.class);

         toChangePassOrEmailIntent.putExtra("firstname", user.getFirstName());
         toChangePassOrEmailIntent.putExtra("lastname", user.getLastName());
         toChangePassOrEmailIntent.putExtra("age", user.getAge());
         toChangePassOrEmailIntent.putExtra("university", user.getUniversity());
         toChangePassOrEmailIntent.putExtra("email", user.getEmail());
         toChangePassOrEmailIntent.putExtra("uid", user.getUid());
         toChangePassOrEmailIntent.putExtra("profileURL", user.getProfileImageUrl());

         startActivity(toChangePassOrEmailIntent);
    }

    public void deleteProfileClicked(View v) {

        Intent toDeleteProfile = new Intent(ProfileActivity.this, DeleteProfileActivity.class);

        startActivity(toDeleteProfile);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == mRequestCode) {

            if(resultCode == RESULT_OK) {

                mLocalURI = data.getData();

                profileImageView.setImageURI(mLocalURI);

            }
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
}