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
    private String email;

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


        changeEmailButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toChangeEmailIntent = new Intent(ChangeEmailAndPasswordActivity.this, ChangeEmailActivity.class);

                startActivity(toChangeEmailIntent);
            }
        });

        changePasswordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent toChangePasswordIntent = new Intent(ChangeEmailAndPasswordActivity.this, ChangePasswordActivity.class);

                toChangePasswordIntent.putExtra("email", email);
                startActivity(toChangePasswordIntent);
            }
        });
    }
}