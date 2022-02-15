package com.exercise.stutodo_app.profile;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;

import com.exercise.stutodo_app.R;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;

public class ChangeEmailActivity extends AppCompatActivity {

    private TextInputEditText currentEmailEditText;
    private TextInputEditText currentPasswordEditText;
    private TextInputEditText newEmailEditText;
    private MaterialButton changeEmailButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_email);

        currentEmailEditText = findViewById(R.id.currentEmail_editText);
        currentPasswordEditText = findViewById(R.id.currentPassword_editText);
        newEmailEditText = findViewById(R.id.newEmail_editText);
        changeEmailButton = findViewById(R.id.changeEmail_buttonCE);

        changeEmailButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {



            }
        });

    }
}