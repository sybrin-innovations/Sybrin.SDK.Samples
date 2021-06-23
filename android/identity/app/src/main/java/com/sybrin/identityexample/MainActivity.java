package com.sybrin.identityexample;

import android.os.Bundle;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sybrin.identity.SybrinIdentity;
import com.sybrin.identity.SybrinIdentityConfiguration;
import com.sybrin.identity.countries.Philippines.DriversLicense.PhilippinesDriversLicenseModel;
import com.sybrin.identity.countries.SouthAfrica.GreenBook.SouthAfricaGreenBookModel;
import com.sybrin.identity.countries.SouthAfrica.IDCard.SouthAfricaIDCardModel;
import com.sybrin.identity.countries.SouthAfrica.Passport.SouthAfricaPassportModel;
import com.sybrin.identity.enums.Country;
import com.sybrin.identity.enums.Document;

public class MainActivity extends AppCompatActivity {

    private final static String SYBRIN_LICENSE = "rOiMrNdXa7lCfobiQYufh0/xUCQuiZdyJbVttqO6DVIXUjtHq13vHPJTEXvck1ecIBbMEBzzhzIG3wHgCxjEYfsH9N2K6EnVQgP637LZ0UFKw5qYftMPH9byai/NUc3p9FeCkepSX+aJYcueK4qqldZTy0doEwKik64xNhfKasyA5fLZFSbVbRrs4ghD5zp4L2AFBXL9XqVnB9ai+M7AF4x/1uJDIsJi6ts4M+tglqqIc9BFhCw8z/z8lnI0M/6L0SHsPa/ye14cD9x20Zd8N0zkAkQPt1zPRQ4H2WCYo1le6nfnLvVxyd/OMYA8ZPzt7UkjJ1KQGpWhnY6ZoOc8G2jDCY0RVBYc6XxJBHZD6vPm11Z+VYJXxwd7zymcrfSjxLtaDbDx402/1EhN1Vy2Zb1ZYSAJ/WhMOEcktmeai/M6sZiQ9/qABpFLI2xGDjUqnE59XwXkjMbL3FRlD46D3zIQW1vLEycwyUz3Jgo1o6fRgA7azMf54mG6Q3HXs1i/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btnScanDocument = findViewById(R.id.btnScanDocument);
        Button btnScanIDCard = findViewById(R.id.btnScanIDCard);
        Button btnScanPassport = findViewById(R.id.btnScanPassport);
        Button btnScanGreenBook = findViewById(R.id.btnScanGreenBook);
        Button btnScanDriversLicense = findViewById(R.id.btnScanDriversLicense);

        btnScanDocument.setOnClickListener(view -> scanDocument());
        btnScanIDCard.setOnClickListener(view -> scanIDCard());
        btnScanPassport.setOnClickListener(view -> scanPassport());
        btnScanGreenBook.setOnClickListener(view -> scanGreenBook());
        btnScanDriversLicense.setOnClickListener(view -> scanDriversLicense());

    }

    private void scanDocument() {
        SybrinIdentityConfiguration sic = new SybrinIdentityConfiguration.Builder(SYBRIN_LICENSE).build();
        SybrinIdentity si = SybrinIdentity.getInstance(MainActivity.this, sic);

        si.scanDocument(Document.SouthAfricaPassport)
                .addOnSuccessListener(result -> {
                    SouthAfricaPassportModel saModel = result.castToModel(SouthAfricaPassportModel.class);
                    showResultTest("Scan successful for " + saModel.getIdentityNumber());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Scan failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Scan canceled");
                });
    }

    private void scanIDCard() {
        SybrinIdentityConfiguration sic = new SybrinIdentityConfiguration.Builder(SYBRIN_LICENSE).build();
        SybrinIdentity si = SybrinIdentity.getInstance(MainActivity.this, sic);

        si.scanIDCard(Country.SouthAfrica)
                .addOnSuccessListener(result -> {
                    SouthAfricaIDCardModel saModel = result.castToModel(SouthAfricaIDCardModel.class);
                    showResultTest("Scan successful for " + saModel.getIdentityNumber());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Scan failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Scan canceled");
                });
    }

    private void scanPassport() {
        SybrinIdentityConfiguration sic = new SybrinIdentityConfiguration.Builder(SYBRIN_LICENSE).build();
        SybrinIdentity si = SybrinIdentity.getInstance(MainActivity.this, sic);

        si.scanPassport(Country.SouthAfrica)
                .addOnSuccessListener(result -> {
                    SouthAfricaPassportModel saModel = result.castToModel(SouthAfricaPassportModel.class);
                    showResultTest("Scan successful for " + saModel.getIdentityNumber());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Scan failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Scan canceled");
                });
    }

    private void scanGreenBook() {
        SybrinIdentityConfiguration sic = new SybrinIdentityConfiguration.Builder(SYBRIN_LICENSE).build();
        SybrinIdentity si = SybrinIdentity.getInstance(MainActivity.this, sic);

        si.scanGreenBook()
                .addOnSuccessListener(result -> {
                    SouthAfricaGreenBookModel saModel = result.castToModel(SouthAfricaGreenBookModel.class);
                    showResultTest("Scan successful for " + saModel.getIdentityNumber());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Scan failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Scan canceled");
                });
    }

    private void scanDriversLicense() {
        SybrinIdentityConfiguration sic = new SybrinIdentityConfiguration.Builder(SYBRIN_LICENSE).build();
        SybrinIdentity si = SybrinIdentity.getInstance(MainActivity.this, sic);

        si.scanDriversLicense(Country.Philippines)
                .addOnSuccessListener(result -> {
                    PhilippinesDriversLicenseModel philModel = result.castToModel(PhilippinesDriversLicenseModel.class);
                    showResultTest("Scan successful for " + philModel.getFullName());
                })
                .addOnFailureListener(e -> {
                    showResultTest("Scan failed due to: " + e.getLocalizedMessage());
                })
                .addOnCancelListener(() -> {
                    showResultTest("Scan canceled");
                });
    }

    private void showResultTest(String text){
        Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG).show();
    }
}