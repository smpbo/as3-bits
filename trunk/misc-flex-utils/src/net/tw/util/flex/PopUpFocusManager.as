package net.tw.util.flex {
	import mx.events.FlexEvent;
	import flash.utils.Dictionary;
	import flash.events.*;
	import spark.components.*;
	import mx.managers.IFocusManagerComponent;
	//
	public class PopUpFocusManager {
		public function PopUpFocusManager() {}
		protected static var _focuses:Dictionary=new Dictionary();
		public static function setDefaultFocus(o:TitleWindow, f:IFocusManagerComponent):void {
			if (!(f is EventDispatcher)) throw new ArgumentError("Second parameter must be an EventDispatcher!");
			_focuses[o]=f;
			o.addEventListener(FlexEvent.ADD, setFocus);
			EventDispatcher(f).addEventListener(FocusEvent.FOCUS_OUT, setFocus);
			setFocus(null, f);
		}
		protected static function setFocus(e:Event=null, f:IFocusManagerComponent=null):void {
			var tg:*;
			if (e) {
				tg=e.target;
				if (tg is TitleWindow) tg=_focuses[tg];
				else if (e is FocusEvent && (e as FocusEvent).relatedObject!=null) return;
			} else {
				tg=f;
			}
			IFocusManagerComponent(tg).setFocus();
		}
	}
}