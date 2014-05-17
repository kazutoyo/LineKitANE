package jp.kazutoyo.LineKitANE;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import jp.kazutoyo.LineKitANE.functions.IsInstalledFunction;
import jp.kazutoyo.LineKitANE.functions.ShareImageFunction;
import jp.kazutoyo.LineKitANE.functions.ShareTextFunction;

public class LineKitANEExtensionContext extends FREContext 
{
	private static String TAG = "[LineKitANE]";
	
	public LineKitANEExtensionContext()
	{
		Log.d(TAG, "Creating Extension Context");
	}
	
	@Override
	public void dispose() 
	{
		Log.d(TAG, "Disposing Extension Context");
		LineKitANEExtension.context = null;
	}

	/**
	 * Registers AS function name to Java Function Class
	 */
	@Override
	public Map<String, FREFunction> getFunctions() 
	{
		Log.d(TAG, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("isInstalled", new IsInstalledFunction());
		functionMap.put("shareText", new ShareTextFunction());
		functionMap.put("shareImage", new ShareImageFunction());
		// add other functions here
		return functionMap;	
	}
}
