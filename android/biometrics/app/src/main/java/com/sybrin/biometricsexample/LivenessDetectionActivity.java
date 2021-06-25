package com.sybrin.biometricsexample;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sybrin.livenessdetection.SybrinLivenessDetection;
import com.sybrin.livenessdetection.SybrinLivenessDetectionConfiguration;
import com.sybrin.livenessdetection.enums.ActiveLivenessDetectionAction;
import com.sybrin.livenessdetection.enums.ActivePassiveLivenessDetectionAction;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class LivenessDetectionActivity extends AppCompatActivity {

    public static final int PICK_IMAGE_REQUEST_CODE = 1;
    private final static String SYBRIN_LICENSE = "qM8KTifSxjTnFo4m+rb2gSob6OXFKwF2j3BhO1XJ4g7GV5BAT0HcRWZZ9VVzBU81HUCveC5w5uxyii56Ac/b7I3Xo9OGbCD7Q+1leZ9w0K3IoKvDZLAMggEiT2OBbfxyTKq2HxHbupgzdF2nLFyMvuHZMlWYoWVVMF5noI5D62IqihqG1Z8E1oRGdzqIC2h5yc208vWms37kOi/rK7KCpnlooqiz13NMWO1g1Ywfgf2ZoDY8hWAeXPcEQYcizyIHBvOCccUIjxeULX0mU3mfaJfZbR/CeROZSEqBY4wzFvIcoC/Ew/uJ1d+ClEHpaTTmpyeZ+vcx2aTDtptqEijxC6/QOhdJZzAjfmyEIxi77vXUE68XJlZHUb2Bj8pKe98yaYowEVG8iCABhWJPzLWwlO7u5JsPF3f5gPahtw+4k1zGFtuAh5Gmwac1/0ZpPkG5RLpgekW++//BrwnJ3CShzEKEJin/Ly8IXRHAm+nnqg0tNe+t76HzhknEksFpBnr2";

    private ArrayList<String> selectedActions = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_liveness_detection);

        Button btnActiveLivenessDetection = findViewById(R.id.btnActiveLivenessDetection);
        Button btnPassiveLivenessDetection = findViewById(R.id.btnPassiveLivenessDetection);
        Button btnActivePassiveLivenessDetection = findViewById(R.id.btnActivePassiveLivenessDetection);
        Button btnPassiveLivenessDetectionFromImage = findViewById(R.id.btnPassiveLivenessDetectionFromImage);

        btnActiveLivenessDetection.setOnClickListener(view -> launchActiveLivenessDetection());
        btnPassiveLivenessDetection.setOnClickListener(view -> launchPassiveLivenessDetection());
        btnActivePassiveLivenessDetection.setOnClickListener(view -> launchActivePassiveLivenessDetection());
        btnPassiveLivenessDetectionFromImage.setOnClickListener(view -> launchGallerySelector());

        initListView();
    }

    private void initListView() {
        final ListView listview = findViewById(R.id.lstActions);

        for (int i = 0; i < ActiveLivenessDetectionAction.values().length; ++i) {
            selectedActions.add(ActiveLivenessDetectionAction.values()[i].name());
        }

        final StableArrayAdapter adapter = new StableArrayAdapter(this,
                android.R.layout.simple_list_item_1, selectedActions);
        listview.setAdapter(adapter);

        listview.setOnItemClickListener((parent, view, position, id) -> {
            final String item = (String) parent.getItemAtPosition(position);
            view.animate().setDuration(200).alpha(0)
                    .withEndAction(() -> {
                        selectedActions.remove(item);
                        adapter.notifyDataSetChanged();
                        view.setAlpha(1);
                    });
        });
    }

    private ActiveLivenessDetectionAction[] getActiveLivenessDetectionActionsFromList() {
        List<ActiveLivenessDetectionAction> list = new ArrayList<>();
        for (String val : selectedActions) {
            list.add(ActiveLivenessDetectionAction.valueOf(val));
        }
        return list.toArray(new ActiveLivenessDetectionAction[0]);
    }

    private ActivePassiveLivenessDetectionAction[] getActivePassiveLivenessDetectionActionsFromList() {
        List<ActivePassiveLivenessDetectionAction> list = new ArrayList<>();
        for (String val : selectedActions) {
            list.add(ActivePassiveLivenessDetectionAction.valueOf(val));
        }
        return list.toArray(new ActivePassiveLivenessDetectionAction[0]);
    }

    private void launchGallerySelector() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Picture"), PICK_IMAGE_REQUEST_CODE);
    }

    private void launchActiveLivenessDetection() {
        SybrinLivenessDetectionConfiguration sldc = new SybrinLivenessDetectionConfiguration.Builder(SYBRIN_LICENSE).build();

        SybrinLivenessDetection sld = SybrinLivenessDetection.getInstance(this, sldc);

        ActiveLivenessDetectionAction[] actions = getActiveLivenessDetectionActionsFromList();

        sld.openActiveLivenessDetection(actions)
                .addOnSuccessListener(result -> {

                    if (result.isAlive()) {
                        showResultTest("You are alive!");
                    } else {
                        showResultTest("Spoof detected");
                    }

                })
                .addOnFailureListener(e -> {
                    showResultTest("Detection failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Detection canceled");
                });
    }

    private void launchPassiveLivenessDetection() {
        SybrinLivenessDetectionConfiguration sldc = new SybrinLivenessDetectionConfiguration.Builder(SYBRIN_LICENSE).build();

        SybrinLivenessDetection sld = SybrinLivenessDetection.getInstance(this, sldc);

        sld.openPassiveLivenessDetection()
                .addOnSuccessListener(result -> {
                    showResultTest("You are " + (result.getLivenessConfidence() * 100) + "% alive!");
                })
                .addOnFailureListener(e -> {
                    showResultTest("Detection failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Detection canceled");
                });
    }

    private void launchActivePassiveLivenessDetection() {
        SybrinLivenessDetectionConfiguration sldc = new SybrinLivenessDetectionConfiguration.Builder(SYBRIN_LICENSE).build();

        SybrinLivenessDetection sld = SybrinLivenessDetection.getInstance(this, sldc);

        ActivePassiveLivenessDetectionAction[] actions = getActivePassiveLivenessDetectionActionsFromList();

        sld.openActivePassiveLivenessDetection(actions)
                .addOnSuccessListener(result -> {
                    showResultTest("You are " + (result.getLivenessConfidence() * 100) + "% alive!");
                })
                .addOnFailureListener(e -> {
                    showResultTest("Detection failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Detection canceled");
                });
    }

    private void launchPassiveLivenessDetectionFromImage(Bitmap image) {
        SybrinLivenessDetectionConfiguration sldc = new SybrinLivenessDetectionConfiguration.Builder(SYBRIN_LICENSE).build();

        SybrinLivenessDetection sld = SybrinLivenessDetection.getInstance(this, sldc);

        sld.passiveLivenessDetectionFromImage(image)
                .addOnSuccessListener(result -> {
                    showResultTest("You are " + (result.getLivenessConfidence() * 100) + "% alive!");
                })
                .addOnFailureListener(e -> {
                    showResultTest("Detection failed due to: " + e.getLocalizedMessage());
                });
    }

    private void showResultTest(String text) {
        runOnUiThread(() -> Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG).show());
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == PICK_IMAGE_REQUEST_CODE) {
            try {
                final Uri uri = intent.getData();
                Bitmap image = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uri);

                launchPassiveLivenessDetectionFromImage(image);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private class StableArrayAdapter extends ArrayAdapter<String> {

        HashMap<String, Integer> mIdMap = new HashMap<String, Integer>();

        public StableArrayAdapter(Context context, int textViewResourceId,
                                  List<String> objects) {
            super(context, textViewResourceId, objects);
            for (int i = 0; i < objects.size(); ++i) {
                mIdMap.put(objects.get(i), i);
            }
        }

        @Override
        public long getItemId(int position) {
            String item = getItem(position);
            return mIdMap.get(item);
        }

        @Override
        public boolean hasStableIds() {
            return true;
        }

    }
}
