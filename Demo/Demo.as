package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import jp.kazutoyo.LineKitANE;

	public class Demo extends Sprite {
		public function Demo() {
			send_text_btn.addEventListener(MouseEvent.CLICK, onClickSendText);
			send_image_btn.addEventListener(MouseEvent.CLICK, onClickSendImage);
		}

		private function onClickSendText(e:MouseEvent):void {
			if (LineKitANE.isSupported) {
				if (LineKitANE.getInstance().isInstalled()) {
					LineKitANE.getInstance().shareText("LineKitANE Demo.");
				}
			}
		}

		private function onClickSendImage(e:MouseEvent):void {
			if (LineKitANE.isSupported) {
				if (LineKitANE.getInstance().isInstalled()) {
					LineKitANE.getInstance().shareImage(new KazutoyoProfileImage());
				}
			}
		}
	}
}
