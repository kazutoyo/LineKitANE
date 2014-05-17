package jp.kazutoyo.LineKitANE.functions;

import jp.kazutoyo.LineKitANE.LineKitActivity;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

/**
 * Send Text function.
 *
 * Create a new class for each function in your API. Don't forget to add them in
 * LineKitANEExtensionContext.getFunctions().
 */
public class ShareImageFunction implements FREFunction
{	
	private static String TAG = "[LineKitANE] ShareImage -";
	
	public FREObject call(FREContext context, FREObject[] args)
	{
		Activity activity = context.getActivity();
		String imagePath = "";
		
		// Get text
		if(args.length > 0) {
			try {
				imagePath = args[0].getAsString();
			} catch (IllegalStateException e) {
				Log.e(TAG, e.toString());
			} catch (FRETypeMismatchException e) {
				Log.e(TAG, e.toString());
			} catch (FREInvalidObjectException e) {
				Log.e(TAG, e.toString());
			} catch (FREWrongThreadException e) {
				Log.e(TAG, e.toString());
			}
		}
		
		// Send Image
		try {
			Intent intent = new Intent(activity, LineKitActivity.class);
			intent.putExtra("imagePath", imagePath);
			activity.startActivity(intent);
		} catch (Exception e) {  
			Log.e(TAG, e.toString());
		} 
		
		return null;
	}

}
