package jp.kazutoyo.LineKitANE.functions;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/**
 * Check Install function.
 *
 * Create a new class for each function in your API. Don't forget to add them in
 * LineKitANEExtensionContext.getFunctions().
 */
public class IsInstalledFunction implements FREFunction 
{
	private static String TAG = "[LineKitANE] IsInstalledFunction -";
	
	public FREObject call(FREContext context, FREObject[] args) 
	{
		FREObject result = null;
		try {
			result = FREObject.newObject(true);
		} catch (FREWrongThreadException e1) {
			Log.e(TAG, e1.toString());
		}
		
		Activity activity = context.getActivity();
		
		// app installed check
		String appId = "jp.naver.line.android";
		try {
		    PackageManager pm = activity.getPackageManager();
		    pm.getApplicationInfo(appId, PackageManager.GET_META_DATA);
		} catch(NameNotFoundException e) {
			// Not Installed
			try {
				result = FREObject.newObject(false);
			} catch (FREWrongThreadException e1) {
				Log.e(TAG, e1.toString());
			}
			
			return result;
		}
		
		return result;
	}
}
