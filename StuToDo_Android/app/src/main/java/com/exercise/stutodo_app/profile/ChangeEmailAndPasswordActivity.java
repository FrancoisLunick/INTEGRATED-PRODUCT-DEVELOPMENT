package com.exercise.stutodo_app.profile;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.models.User;
import com.google.android.material.button.MaterialButton;

public class ChangeEmailAndPasswordActivity extends AppCompatActivity {

    MaterialButton changeEmailButton;
    MaterialButton changePasswordButton;

    private User user;
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
        setContentView(R.layout.activity_change_email_and_password);

        user = new User();

        changeEmailButton = findViewById(R.id.changeEmailButton);
        changePasswordButton = findViewById(R.id.changePasswordButton);

        Intent intent = getIntent();
        //user = intent.getParcelableExtra("user");
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

                Intent toChangeEmailIntent = new Intent(ChangeEmailAndPasswordActivity.this, ChangeEmailActivity.class);

                toChangeEmailIntent.putExtra("email", email);
                toChangeEmailIntent.putExtra("firstname", firstname);
                toChangeEmailIntent.putExtra("lastname", lastname);
                toChangeEmailIntent.putExtra("age", age);
                toChangeEmailIntent.putExtra("university", university);
                toChangeEmailIntent.putExtra("uid", uid);
                toChangeEmailIntent.putExtra("profileURL", profileURL);

                startActivity(toChangeEmailIntent);
            }
        });

        changePasswordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toChangePasswordIntent = new Intent(ChangeEmailAndPasswordActivity.this, ChangePasswordActivity.class);

                toChangePasswordIntent.putExtra("email", email);
                toChangePasswordIntent.putExtra("firstname", firstname);
                toChangePasswordIntent.putExtra("lastname", lastname);
                toChangePasswordIntent.putExtra("age", age);
                toChangePasswordIntent.putExtra("university", university);
                toChangePasswordIntent.putExtra("uid", uid);
                toChangePasswordIntent.putExtra("profileURL", profileURL);

                startActivity(toChangePasswordIntent);
            }
        });
    }
}