package com.sybrin.biometricsexample;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sybrin.facecomparison.SybrinFacialComparison;
import com.sybrin.facecomparison.SybrinFacialComparisonConfiguration;

import java.io.IOException;
import java.util.ArrayList;

public class FacialComparisonActivity extends AppCompatActivity {

    public static final int PICK_IMAGE_REQUEST_CODE = 1;
    private final static String SYBRIN_LICENSE = "qM8KTifSxjTnFo4m+rb2gSob6OXFKwF2j3BhO1XJ4g7GV5BAT0HcRWZZ9VVzBU81HUCveC5w5uxyii56Ac/b7I3Xo9OGbCD7Q+1leZ9w0K3IoKvDZLAMggEiT2OBbfxyTKq2HxHbupgzdF2nLFyMvuHZMlWYoWVVMF5noI5D62IqihqG1Z8E1oRGdzqIC2h5yc208vWms37kOi/rK7KCpnlooqiz13NMWO1g1Ywfgf2ZoDY8hWAeXPcEQYcizyIHBvOCccUIjxeULX0mU3mfaJfZbR/CeROZSEqBY4wzFvIcoC/Ew/uJ1d+ClEHpaTTmpyeZ+vcx2aTDtptqEijxC6/QOhdJZzAjfmyEIxi77vXUE68XJlZHUb2Bj8pKe98yaYowEVG8iCABhWJPzLWwlO7u5JsPF3f5gPahtw+4k1zGFtuAh5Gmwac1/0ZpPkG5RLpgekW++//BrwnJ3CShzEKEJin/Ly8IXRHAm+nnqg0tNe+t76HzhknEksFpBnr2";

    private ArrayList<Bitmap> faces = new ArrayList<>();
    private Bitmap targetImage;
    private ImageListAdapter faceListAdapter;

    private Button btnSelectTarget;

    private SelectionType selectionType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_facial_comparison);

        Button btnAddFaces = findViewById(R.id.btnAddFaces);
        btnSelectTarget = findViewById(R.id.btnSelectTarget);
        Button btnCompareFaces = findViewById(R.id.btnCompareFaces);

        btnAddFaces.setOnClickListener(view -> launchGallerySelector(SelectionType.Faces));
        btnSelectTarget.setOnClickListener(view -> launchGallerySelector(SelectionType.Target));
        btnCompareFaces.setOnClickListener(view -> launchFaceCompare());

        initListView();
    }

    private void launchFaceCompare() {
        if (targetImage != null && faces.size() != 0) {
            SybrinFacialComparisonConfiguration sfcc = new SybrinFacialComparisonConfiguration.Builder(SYBRIN_LICENSE).build();

            SybrinFacialComparison sfc = SybrinFacialComparison.getInstance(FacialComparisonActivity.this, sfcc);

            sfc.compareFaces(targetImage, faces.toArray(new Bitmap[0]))
                    .addOnSuccessListener(result -> {
                        showResultTest("Faces are " + result.getAverageConfidence() + "% similar on average");
                    })
                    .addOnFailureListener(e -> {
                        showResultTest("Comparison failed due to: " + e.getLocalizedMessage());
                    });
        } else {
            showResultTest("No faces selected");
        }
    }

    private void launchGallerySelector(SelectionType selectionType) {
        this.selectionType = selectionType;

        Intent intent = new Intent();
        intent.setType("image/*");

        if (selectionType == SelectionType.Faces) {
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
        }

        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Picture"), PICK_IMAGE_REQUEST_CODE);
    }

    private void initListView() {
        final ListView listview = findViewById(R.id.lstFaces);

        faceListAdapter = new ImageListAdapter(FacialComparisonActivity.this, faces);
        listview.setAdapter(faceListAdapter);

        listview.setOnItemClickListener((parent, view, position, id) -> {
            final Bitmap item = (Bitmap) parent.getItemAtPosition(position);
            view.animate().setDuration(200).alpha(0)
                    .withEndAction(() -> {
                        faces.remove(item);
                        faceListAdapter.notifyDataSetChanged();
                        view.setAlpha(1);
                    });
        });
    }

    private void setTargetImage(Bitmap image) {
        this.targetImage = image;
        BitmapDrawable bdrawable = new BitmapDrawable(this.getResources(), image);
        btnSelectTarget.setBackground(bdrawable);
    }

    private void showResultTest(String text) {
        runOnUiThread(() -> Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG).show());
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == PICK_IMAGE_REQUEST_CODE) {
            try {
                if (resultCode == Activity.RESULT_OK) {
                    if (intent.getClipData() != null) {
                        int count = intent.getClipData().getItemCount();
                        for (int i = 0; i < count; i++) {
                            Uri imageUri = intent.getClipData().getItemAt(i).getUri();
                            Bitmap image = MediaStore.Images.Media.getBitmap(this.getContentResolver(), imageUri);

                            switch (this.selectionType) {
                                case Faces:
                                    faceListAdapter.addItem(image);
                                    break;
                                case Target:
                                    setTargetImage(image);
                                    break;
                            }
                        }
                    } else if (intent.getData() != null) {
                        final Uri uri = intent.getData();
                        Bitmap image = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uri);

                        switch (this.selectionType) {
                            case Faces:
                                faceListAdapter.addItem(image);
                                break;
                            case Target:
                                setTargetImage(image);
                                break;
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public enum SelectionType {
        Target,
        Faces
    }

    public class ImageListAdapter extends ArrayAdapter<Bitmap> {
        private ArrayList<Bitmap> images;
        private Activity context;

        public ImageListAdapter(Activity context, ArrayList<Bitmap> images) {
            super(context, R.layout.image_list_item, images);
            this.context = context;
            this.images = images;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View row = convertView;
            LayoutInflater inflater = context.getLayoutInflater();
            if (convertView == null)
                row = inflater.inflate(R.layout.image_list_item, null, true);
            ImageView face = row.findViewById(R.id.imgFace);
            face.setImageBitmap(images.get(position));
            return row;
        }

        public void addItem(Bitmap image) {
            images.add(image);
            this.notifyDataSetChanged();
        }
    }
}
