package com.exercise.stutodo_app.signup;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;

import com.exercise.stutodo_app.R;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;

public class SignUpActivity extends AppCompatActivity {

    private TextInputEditText mFirstNameEditText;
    private TextInputEditText mLastNameEditText;
    private TextInputEditText mAgeEditText;
    private TextInputEditText mUniversityEditText;
    private TextInputEditText mEmailEditText;
    private TextInputEditText mPasswordEditText;
    private MaterialButton mSignUpButton;

    private String mFirstName;
    private String mLastName;
    private String mAge;
    private String mUniversity;
    private String mEmail;
    private String mPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        mFirstNameEditText = findViewById(R.id.firstName_editText);
        mLastNameEditText = findViewById(R.id.lastName_editText);
        mAgeEditText = findViewById(R.id.age_editText);
        mUniversityEditText = findViewById(R.id.university_editText);
        mEmailEditText = findViewById(R.id.register_email_editText);
        mPasswordEditText = findViewById(R.id.register_password_editText);
        mSignUpButton = findViewById(R.id.register_SignupButton);

        mSignUpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                registerUser(view);
            }
        });
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
        }
    }
}