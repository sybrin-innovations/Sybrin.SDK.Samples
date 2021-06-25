package com.sybrin.biometricsexample;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btnLivenessDetection = findViewById(R.id.btnLivenessDetection);
        Button btnFacialRecognition = findViewById(R.id.btnFacialRecognition);
        Button btnFacialComparison = findViewById(R.id.btnFacialComparison);

        btnLivenessDetection.setOnClickListener(view -> {
            Intent i = new Intent(getApplicationContext(), LivenessDetectionActivity.class);
            startActivity(i);
        });

        btnFacialRecognition.setOnClickListener(view -> {
            Intent i = new Intent(getApplicationContext(), FacialRecognitionActivity.class);
            startActivity(i);
        });

        btnFacialComparison.setOnClickListener(view -> {
            Intent i = new Intent(getApplicationContext(), FacialComparisonActivity.class);
            startActivity(i);
        });
    }
}