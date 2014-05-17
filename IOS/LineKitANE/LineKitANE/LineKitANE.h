#import "FlashRuntimeExtensions.h"
#import "Line.h"
#import <UIKit/UIKit.h>

@interface LineKitANE : NSObject

+ (LineKitANE *)sharedInstance;

@end


// C interface

/* This is a sample function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
*/
DEFINE_ANE_FUNCTION(LineIsInstalled);
DEFINE_ANE_FUNCTION(ShareText);
DEFINE_ANE_FUNCTION(ShareImage);



// ANE setup

/* LineKitANEExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
*/
void LineKitANEExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);

/* LineKitANEExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
*/
void LineKitANEExtFinalizer(void* extData);

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
*/
void LineKitANEContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
*/
void LineKitANEContextFinalizer(FREContext ctx);


