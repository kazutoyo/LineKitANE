package jp.kazutoyo {
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class LineKitANE extends EventDispatcher {

		public static const Version:String = "1";

		private static var _instance:LineKitANE;

		private var extCtx:ExtensionContext = null;

		public function LineKitANE() {
			if (!_instance) {
				if (isSupported) {
					extCtx = ExtensionContext.createExtensionContext("jp.kazutoyo.LineKitANE", null);
					if (extCtx != null) {
						extCtx.addEventListener(StatusEvent.STATUS, onStatus);
					} else {
						trace('[LineKitANE] Error - Extension Context is null.');
					}
				}
				_instance = this;
			} else {
				throw Error('This is a singleton, use getInstance(), do not call the constructor directly.');
			}
		}

		public static function getInstance():LineKitANE {
			return _instance ? _instance : new LineKitANE();
		}

		private static function get isIOS():Boolean {
			return Capabilities.manufacturer.search('iOS') > -1;
		}

		private static function get isAndroid():Boolean {
			return Capabilities.manufacturer.search('Android') > -1;
		}

		public static function get isSupported():Boolean {
			var result:Boolean = (isIOS || isAndroid);
			return result;
		}

		/**
		 * check install function
		 */
		public function isInstalled():Boolean {
			return extCtx.call('isInstalled');
		}

		/**
		 * send text to LINE.
		 * @param shareText text
		 */
		public function shareText(shareText:String):void {
			extCtx.call('shareText', shareText);
		}

		/**
		 * send image to LINE.
		 * @param shareImage text
		 */
		public function shareImage(shareImage:BitmapData):void {
			if (isAndroid) {
				var imagePath:String = saveImage(shareImage);
				extCtx.call('shareImage', imagePath);

			} else {
				extCtx.call('shareImage', shareImage);
			}
		}

		/**
		 * BitmapData output to image file
		 * @param bitmapData source BitmapData
		 */
		private function saveImage(bitmapData:BitmapData):String {

			var byteData:ByteArray;
			var fileName:String;
			if (bitmapData.transparent) {
				byteData = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions());
				fileName = "image.png";
			} else {
				byteData = bitmapData.encode(bitmapData.rect, new JPEGEncoderOptions(100));
				fileName = "image.jpg";
			}

			var imageFile:File;

			imageFile = File.userDirectory.resolvePath(fileName);

			var stream:FileStream = new FileStream();
			try {
				stream.open(imageFile, FileMode.WRITE);
				stream.writeBytes(byteData);
			} catch (e:Error) {
				//trace(e);
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false));
			}

			return imageFile.nativePath;
		}

		/**
		 * Status events allow the native part of the ANE to communicate with the ActionScript part.
		 * We use event.code to represent the type of event, and event.level to carry the data.
		 */
		private function onStatus(event:StatusEvent):void {
			if (event.code == "LOGGING") {
				trace('[LineKitANE] ' + event.level);
			}
		}
	}
}
