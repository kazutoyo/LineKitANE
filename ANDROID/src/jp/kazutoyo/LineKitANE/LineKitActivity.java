package jp.kazutoyo.LineKitANE;

import java.io.File;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;

public class LineKitActivity extends Activity {
	
	private static final int LINE_INTENT_CODE = 0;
	private static String TAG = "[LineKitANE] LineKitActivity -";
	private File _imageFile;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        
        Intent intent = getIntent();
        String imagePath = intent.getStringExtra("imagePath");
        
        if(imagePath != null && !imagePath.equals("")) {
	        _imageFile = new File(imagePath);
	        
	        Uri imageUri = Uri.fromFile(_imageFile);
	        
			Intent shareIntent = new Intent(Intent.ACTION_SEND);
			shareIntent.setPackage("jp.naver.line.android");
        	shareIntent.setType("image/*");
			shareIntent.putExtra(Intent.EXTRA_STREAM, imageUri);
			 try {
				startActivityForResult(shareIntent, LINE_INTENT_CODE);
			} catch (ActivityNotFoundException e) {
				Log.e(TAG, e.toString());
			}
        }
    }
	
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
    	
    	// delete image file
    	if(_imageFile != null) {
    		_imageFile.delete();
    	}
    	
        super.onActivityResult(requestCode, resultCode, intent);
        finish();
    }

}
