package com.exercise.stutodo_app.profile;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.exercise.stutodo_app.R;
import com.exercise.stutodo_app.login.LoginActivity;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class ChangePasswordActivity extends AppCompatActivity {

    private TextInputEditText currentPasswordET;
    private TextInputEditText newPasswordET;
    private MaterialButton changePasswordButton;

    private FirebaseAuth mFirebaseAuth;
    private FirebaseUser mFirebaseUser;

    private String email;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_password);

        Intent intent = getIntent();
        //user = intent.getParcelableExtra("user");
        email = intent.getStringExtra("email");

        mFirebaseAuth = FirebaseAuth.getInstance();
        mFirebaseUser = mFirebaseAuth.getCurrentUser();

        currentPasswordET = findViewById(R.id.currentPass_editText);
        newPasswordET = findViewById(R.id.newPass_editText);
        changePasswordButton = findViewById(R.id.changePass_buttonCE);

        changePasswordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (mFirebaseUser != null) {

                    AuthCredential credential = EmailAuthProvider
                            .getCredential(email, currentPasswordET.getText().toString());

                    mFirebaseUser.reauthenticate(credential)
                            .addOnCompleteListener(new OnCompleteListener<Void>() {
                                @Override
                                public void onComplete(@NonNull Task<Void> task) {

                                    if(task.isSuccessful()) {

                                        mFirebaseUser.updatePassword(newPasswordET.getText().toString())
                                                .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                    @Override
                                                    public void onComplete(@NonNull Task<Void> task) {

                                                        if(task.isSuccessful()) {

                                                            mFirebaseAuth.signOut();

                                                            Intent backToLoginIntent = new Intent(ChangePasswordActivity.this, LoginActivity.class);

                                                            startActivity(backToLoginIntent);
                                                            finish();

                                                            Log.i("USER", "Password Changed");
                                                            Toast.makeText(ChangePasswordActivity.this, "Password Changed", Toast.LENGTH_SHORT).show();

                                                        } else {

                                                            Log.i("USER", "Password could not be Changed");

                                                        }

                                                    }
                                                });

                                    } else {

                                        Log.i("USER", "Reauthentication Failed");

                                    }

                                }
                            });
                }

            }
        });
    }
}