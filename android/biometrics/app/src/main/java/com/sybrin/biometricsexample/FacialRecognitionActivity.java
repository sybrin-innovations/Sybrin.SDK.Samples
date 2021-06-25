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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_facial_recognition);

        Button btnTrainFace = findViewById(R.id.btnTrainFace);
        Button btnLoadModel = findViewById(R.id.btnLoadModel);
        Button btnAuthenticateFace = findViewById(R.id.btnAuthenticateFace);

        EditText txtIdentifier = findViewById(R.id.txtIdentifier);

        String identifier = txtIdentifier.getText().toString();

        btnTrainFace.setOnClickListener(view -> launchTrainFace(identifier));
        btnLoadModel.setOnClickListener(view -> loadModel(identifier));
        btnAuthenticateFace.setOnClickListener(view -> launchAuthenticateFace(identifier));
    }

    private void launchTrainFace(String identifier) {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(SYBRIN_LICENSE).build(FacialRecognitionActivity.this);

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

    private void loadModel(String identifier) {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(SYBRIN_LICENSE).build(FacialRecognitionActivity.this);

        SybrinFacialRecognition sfr = SybrinFacialRecognition.getInstance(this, sfrc);
        sfr.loadModel(identifier)
                .addOnSuccessListener(result -> {
                    showResultTest("Model loaded for " + result.getIdentifier());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Loading failed due to: " + e.getLocalizedMessage());
                });
    }

    private void launchAuthenticateFace(String identifier) {
        SybrinFacialRecognitionConfiguration sfrc = new SybrinFacialRecognitionConfiguration.Builder(SYBRIN_LICENSE).build(FacialRecognitionActivity.this);

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
