package watercolor.elements
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.graphics.BitmapFill;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.primitives.Rect;
	
	import watercolor.elements.interfaces.IElementGraphic;
	
	/**
	 * Watercolor's BitmapImage element encapsulates a Flex-based Rect,
	 * defining a rectangular region in its parent element's coordinate space,
	 * filled with bitmap data drawn from a source file.
	 * 
	 * @see spark.primitives.Rect
	 */
	public class BitmapImage extends Element implements IElementGraphic
	{
		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		protected var bitmapImage:spark.primitives.Rect;
		protected var loader:Loader;
		
		public function BitmapImage()
		{
			bitmapImage = new spark.primitives.Rect();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement(bitmapImage);
		}
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number { return bitmapImage.width; }
		override public function set width(value:Number):void { super.width = value; bitmapImage.width = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number { return bitmapImage.height; }
		override public function set height(value:Number):void { super.height = value; bitmapImage.height = value; }
		
		// :: BitmapImage Properties :: //
		
		/**
		 * @copy spark.primitives.BitmapImage#fillMode;
		 */
		public function get fillMode():String { return BitmapFill(bitmapImage.fill).fillMode; }
		public function set fillMode(value:String):void { BitmapFill(bitmapImage.fill).fillMode = value; }
		
		/**
		 * @copy spark.primitives.BitmapImage#smooth;
		 */
		public function get smooth():Boolean { return BitmapFill(bitmapImage.fill).smooth; }
		public function set smooth(value:Boolean):void { BitmapFill(bitmapImage.fill).smooth = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.FilledElement#fill;
		 */
		public function get fill():IFill { return bitmapImage.fill; }
		public function set fill(value:IFill):void { bitmapImage.fill = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.StrokedElement#stroke;
		 */
		public function get stroke():IStroke { return bitmapImage.stroke; }
		public function set stroke(value:IStroke):void { bitmapImage.stroke = value; }
		
		private var _sourceURL:String = "";
		public function get sourceURL():String { return _sourceURL; }

		/**
		 * @copy spark.primitives.BitmapImage#source;
		 */
		public function get source():Object { return BitmapFill(bitmapImage.fill).source; }
		public function set source(value:Object):void {						
			bitmapImage.fill = new BitmapFill();
			if (value is Bitmap) {
				BitmapFill(bitmapImage.fill).source = value;
				dispatchEvent(new Event(Event.COMPLETE));
			} else if (value is ByteArray) {
				loadBytes(value as ByteArray);
			} else {
				loadSource(value.toString());
			}
		}
		
		//public function get displayObject():Object { return bitmapImage.displayObject; }
		
		/**
		 * Bleed color used for overprint
		 */
		public var backgroundColor:uint;

		private function loadBytes(value:ByteArray):void {
			
			_sourceURL = "";
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, sourceLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.loadBytes(value);
		}
		
		private function loadSource(url:String):void {
			
			_sourceURL = url;
			
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.applicationDomain = new ApplicationDomain();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, sourceLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.load(new URLRequest(url), context);						
		}
		
		private function sourceLoaded(event:Event):void {
			trace("completeHandler: " + event);
			
			event.currentTarget.removeEventListener(Event.COMPLETE, sourceLoaded);
			
			var content:Bitmap = Bitmap(event.currentTarget.content);
			
			if (width == 0 && height == 0) {
				width = content.width;
				height = content.height;
			}
			
			BitmapFill(bitmapImage.fill).source = content;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			dispatchEvent(event.clone());
			
			trace("ioErrorHandler: " + event);
		}
	}
}