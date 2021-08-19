package com.sybrin.biometricsexample;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sybrin.facialrecognition.SybrinFacialRecognition;
import com.sybrin.facialrecognition.SybrinFacialRecognitionConfiguration;

public class FacialRecognitionActivity extends AppCompatActivity {

    private final static String SYBRIN_LICENSE = "qM8KTifSxjTnFo4m+rb2gSob6OXFKwF2j3BhO1XJ4g7GV5BAT0HcRWZZ9VVzBU81HUCveC5w5uxyii56Ac/b7I3Xo9OGbCD7Q+1leZ9w0K3IoKvDZLAMggEiT2OBbfxyTKq2HxHbupgzdF2nLFyMvuHZMlWYoWVVMF5noI5D62IqihqG1Z8E1oRGdzqIC2h5yc208vWms37kOi/rK7KCpnlooqiz13NMWO1g1Ywfgf2ZoDY8hWAeXPcEQYcizyIHBvOCccUIjxeULX0mU3mfaJfZbR/CeROZSEqBY4wzFvIcoC/Ew/uJ1d+ClEHpaTTmpyeZ+vcx2aTDtptqEijxC6/QOhdJZzAjfmyEIxi77vXUE68XJlZHUb2Bj8pKe98yaYowEVG8iCABhWJPzLWwlO7u5JsPF3f5gPahtw+4k1zGFtuAh5Gmwac1/0ZpPkG5RLpgekW++//BrwnJ3CShzEKEJin/Ly8IXRHAm+nnqg0tNe+t76HzhknEksFpBnr2";
    private final static String CLIENT_LICENSE = "qM8KTifSxjTnFo4m+rb2gSob6OXFKwF2j3BhO1XJ4g7GV5BAT0HcRWZZ9VVzBU81mSuqG3fcuajzilVQ7Exc3SrJi516dxX25H0XjqNjw0VUhgsEeTLO5xNZ0xK2hv9W/3ye+7j2RdIaORbIpw/CKqCSKfhOj4d8R82AdyCV4I/t4gMY624RrdooEPovktvxqYFpa8y1MGKexPIuEHM1jeUXBbmFuuBt2PgzRgA9ua7Q+m2uZuu1wWJpwyzh+zvvj6IyTsUJbB1gtsIhAc33g+fNxHDnfTFcVlPfn7SSlpP/mJPcqLuza16OdqIjLN1Of18XdmQZtLzuqZDLlPj/QHpKEguUslDoUvLkh8VSb6q8rZqv52A8JGUKINUnJgMEmpN8TG2/93ss6WSZ6GY7G1akVilfbmGgiVFPdQ19lPOgEsEl0YheD+VxEgf8wt74QAxIy4WLqSwf1eqeZmeO8vUyd3pNQEjx3sP+H9lfLZRcrb9MNacg3xqckrgx+hXg";

    EditText txtIdentifier;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_facial_recognition);

        Button btnTrainFace = findViewById(R.id.btnTrainFace);
        Button btnLoadModel = findViewById(R.id.btnLoadModel);
        Button btnAuthenticateFace = findViewById(R.id.btnAuthenticateFace);

        txtIdentifier = findViewById(R.id.txtIdentifier);

        btnTrainFace.setOnClickListener(view -> launchTrainFace());
        btnLoadModel.setOnClickListener(view -> loadModel());
        btnAuthenticateFace.setOnClickListener(view -> launchAuthenticateFace());
    }

    private void launchTrainFace() {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(CLIENT_LICENSE).build(FacialRecognitionActivity.this);

        String identifier = txtIdentifier.getText().toString();

        SybrinFacialRecognition sfr = SybrinFacialRecognition.getInstance(this, sfrc);
        sfr.trainFace(identifier)
                .addOnSuccessListener(result -> {
                    showResultTest("Model trained for " + result.getIdentifier());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Training failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Training canceled");
                });
    }

    private void loadModel() {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(SYBRIN_LICENSE).build(FacialRecognitionActivity.this);

        String identifier = txtIdentifier.getText().toString();

        SybrinFacialRecognition sfr = SybrinFacialRecognition.getInstance(this, sfrc);
        sfr.loadModel(identifier)
                .addOnSuccessListener(result -> {
                    showResultTest("Model loaded for " + result.getIdentifier());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Loading failed due to: " + e.getLocalizedMessage());
                });
    }

    private void launchAuthenticateFace() {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(SYBRIN_LICENSE).build(FacialRecognitionActivity.this);

        String identifier = txtIdentifier.getText().toString();

        SybrinFacialRecognition sfr = SybrinFacialRecognition.getInstance(this, sfrc);
        sfr.openFacialRecognition(identifier)
                .addOnSuccessListener(result -> {
                    showResultTest(result.getIdentifier() + " authenticated");
                })
                .addOnFailureListener(e -> {
                    showResultTest("Authentication failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Authentication canceled");
                });
    }

    private void showResultTest(String text) {
        runOnUiThread(() -> Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG).show());
    }
}
