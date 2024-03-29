package net.tw.util.air {
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import net.tw.util.OS;
	//
	public class App {
		public function App() {}
		public static function getDescriptor():XML {
			return NativeApplication.nativeApplication.applicationDescriptor;
		}
		public static function getNamespace():Namespace {
			return getDescriptor().namespace();
		}
		public static function getName():String {
			var ns:Namespace=getNamespace();
			return getDescriptor().ns::name;
		}
		public static function getID():String {
			var ns:Namespace=getNamespace();
			return getDescriptor().ns::id;
		}
		public static function getApplicationRequiredRuntimeVersion():String {
			return String(getNamespace().uri.split('/').pop());
		}
		public static function getVersion():String {
			var ns:Namespace=getNamespace();
			return getDescriptor().ns::version.length() ? getDescriptor().ns::version : getDescriptor().ns::versionNumber;
		}
		public static function getVersionLabel():String {
			var ns:Namespace=getNamespace();
			return getDescriptor().ns::versionLabel.length() ? getDescriptor().ns::versionLabel : getVersion();
		}
		public static function getCopyright():String {
			var ns:Namespace=getNamespace();
			return getDescriptor().ns::copyright;
		}
		public static function runningOnMac():Boolean {
			return OS.isMac();
		}
		public static function runningOnLinux():Boolean {
			return OS.isLinux();
		}
		public static function runningOnWindows():Boolean {
			return OS.isWindows();
		}
		public static function fixLoadURL(fileURL:String):String {
			return ((App.runningOnLinux() || App.runningOnMac()) && fileURL.substr(0, 7)!='file://') ? 'file://'+fileURL : fileURL;
		}
		public static function getAppSchemeURL(f:File):String {
			var absAppDir:File=new File(File.applicationDirectory.nativePath);
			return File.applicationDirectory.resolvePath(absAppDir.getRelativePath(f)).url;
		}
		//
		/*public static function centerWindow(w:*, offset:Point=null):void {
			if (!(w is NativeWindow) && !(w is Window)) {
				throw(new ArgumentError());
				return;
			}
			var o:*=w is NativeWindow ? w : w.nativeWindow;
			o.x=(Screen.mainScreen.bounds.width-o.width)/2+(offset ? offset.x : 0);
			o.y=(Screen.mainScreen.bounds.height-o.height)/2+(offset ? offset.y : 0);
		}*/
		public static function centerNativeWindow(nw:NativeWindow):void {
			nw.x=(Screen.mainScreen.bounds.width-nw.width)/2;
			nw.y=(Screen.mainScreen.bounds.height-nw.height)/2;
		}
		public static function centerWindowOnWindow(toCenter:NativeWindow, centerOn:NativeWindow):void {
			toCenter.x=centerOn.x+(centerOn.width-toCenter.width)/2;
			toCenter.y=centerOn.y+(centerOn.height-toCenter.height)/2;
		}
		public static function preventClose(w:NativeWindow, activateOnHide:NativeWindow=null):void {
			w.addEventListener(Event.CLOSING, function(e:Event):void {
				e.preventDefault();
				w.visible=false;
				if (activateOnHide) activateOnHide.activate();
			});
		}
		public static function minimizeOnClose(w:NativeWindow):void {
			w.addEventListener(Event.CLOSING, function(e:Event):void {
				e.preventDefault();
				w.minimize();
			});
		}
		public static function get ctrlPrefix():String {
			return runningOnMac() ? '⌘' : 'Ctrl + ';
		}
	}
}