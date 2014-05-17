package jp.kazutoyo.LineKitANE;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class LineKitANEExtension implements FREExtension 
{
	private static String TAG = "[LineKitANE]";

	public static FREContext context;
	
	/**
	 * Create the context (AS to Java).
	 */
	public FREContext createContext(String extId)
	{
		Log.d(TAG, "Extension.createContext extId: " + extId);
		return context = new LineKitANEExtensionContext();
	}

	/**
	 * Dispose the context.
	 */
	public void dispose() 
	{
		Log.d(TAG, "Extension.dispose");
		context = null;
	}
	
	/**
	 * Initialize the context.
	 * Doesn't do anything for now.
	 */
	public void initialize() 
	{
		Log.d(TAG, "Extension.initialize");
	}
}
