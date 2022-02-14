package com.exercise.stutodo_app.profile;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.exercise.stutodo_app.FirebaseConstants;
import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.exercise.stutodo_app.models.TaskModel;
import com.exercise.stutodo_app.models.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import org.w3c.dom.Text;

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

    private FirebaseFirestore mDatabaseReference;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        user = new User();

        firebaseAuth = FirebaseAuth.getInstance();
        firebaseUser = firebaseAuth.getCurrentUser();

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

                            firstNameET.setText(firstname);
                            lastNameET.setText(lastname);
                            ageET.setText(age);
                            universityET.setText(university);
                            emailET.setText(email);
                        }

                    }
                });

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

    }
}