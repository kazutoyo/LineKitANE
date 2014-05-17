#import "LineKitANE.h"

FREContext LineKitANECtx = nil;


@implementation LineKitANE

#pragma mark - Singleton

static LineKitANE *sharedInstance = nil;

+ (LineKitANE *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

@end


#pragma mark - C interface

DEFINE_ANE_FUNCTION(LineIsInstalled)
{
    NSLog(@"Entering LineIsInstalled()");
    
    FREObject fo;
    
    FREResult aResult = FRENewObjectFromBool([Line isLineInstalled], &fo);
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting LineIsInstalled()");
    
    return fo;
}

DEFINE_ANE_FUNCTION(ShareText)
{
    FREObject fo;
    
    FRENewObjectFromBool(YES, &fo);
    
    if([Line isLineInstalled]) {
        //値を取得
        if(argc > 0) {
            // 変数定義
            NSString* text;
            uint32_t textLength;
            const uint8_t *textPointer;
            
            textLength = strlen((const char*)argv[0]) + 1;
            if (FRE_OK == FREGetObjectAsUTF8(argv[0], &textLength, &textPointer)) {
                text = [NSString stringWithUTF8String:(char*)textPointer];
                [Line shareText:text];
            }
        }
    }
    
    return fo;
}

DEFINE_ANE_FUNCTION(ShareImage)
{
    FREObject fo;
    
    FRENewObjectFromBool(YES, &fo);
    
    if([Line isLineInstalled]) {
        //値を取得
        if(argc > 0) {
            // 変数定義
            UIImage* image;
            FREBitmapData bitmapData;
            if (FRE_OK == FREAcquireBitmapData(argv[0], &bitmapData))
            {
                int width       = bitmapData.width;
                int height      = bitmapData.height;
                
                CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
                
                int                     bitsPerComponent    = 8;
                int                     bitsPerPixel        = 32;
                int                     bytesPerRow         = 4 * width;
                CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();
                CGBitmapInfo            bitmapInfo;
                
                if (bitmapData.hasAlpha)
                {
                    if (bitmapData.isPremultiplied)
                        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
                    else
                        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
                }
                else
                {
                    bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
                }
                
                CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
                CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
                
                image = [UIImage imageWithCGImage:imageRef];
                
                FREReleaseBitmapData(argv[0]);
                CGColorSpaceRelease(colorSpaceRef);
                CGImageRelease(imageRef);
                CGDataProviderRelease(provider);
                
                [Line shareImage:image];
            }
        }
    }
    
    return fo;
}

#pragma mark - ANE setup

/* LineKitANEExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void LineKitANEExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering LineKitANEExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &LineKitANEContextInitializer;
    *ctxFinalizerToSet = &LineKitANEContextFinalizer;

    NSLog(@"Exiting LineKitANEExtInitializer()");
}

/* LineKitANEExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void LineKitANEExtFinalizer(void* extData) 
{
    NSLog(@"Entering LineKitANEExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting LineKitANEExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void LineKitANEContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");

    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     * As a sample, the function isSupported is being provided.
     */
    *numFunctionsToTest = 3;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    func[0].name = (const uint8_t*) "isInstalled";
    func[0].functionData = NULL;
    func[0].function = &LineIsInstalled;
    func[1].name = (const uint8_t*) "shareText";
    func[1].functionData = NULL;
    func[1].function = &ShareText;
    func[2].name = (const uint8_t*) "shareImage";
    func[2].functionData = NULL;
    func[2].function = &ShareImage;

    *functionsToSet = func;

    LineKitANECtx = ctx;

    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void LineKitANEContextFinalizer(FREContext ctx)
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


