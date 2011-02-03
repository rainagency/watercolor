package watercolor.elements
{
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.primitives.Rect;
	
	import watercolor.elements.interfaces.IElementGraphic;
	
	/**
	 * Watercolor's Rect element encapsulates a Flex-based Rect, a filled
	 * graphic element that draws a rectangle.
	 * 
	 * @see spark.primitives.Rect
	 */
	public class Rect extends Element implements IElementGraphic
	{
		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		protected var rect:spark.primitives.Rect;
		
		public function Rect()
		{
			rect = new spark.primitives.Rect();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement(rect);
		}
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number { return rect.width; }
		override public function set width(value:Number):void { super.width = value; rect.width = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number { return rect.height; }
		override public function set height(value:Number):void { super.height = value; rect.height = value; }
		
		// :: Rect Properties :: //
		
		/**
		 * @copy spark.primitives.Rect#bottomLeftRadiusX;
		 */
		public function get bottomLeftRadiusX():Number { return rect.bottomLeftRadiusX; }
		public function set bottomLeftRadiusX(value:Number):void { rect.bottomLeftRadiusX = value; }
		
		/**
		 * @copy spark.primitives.Rect#bottomLeftRadiusY;
		 */
		public function get bottomLeftRadiusY():Number { return rect.bottomLeftRadiusY; }
		public function set bottomLeftRadiusY(value:Number):void { rect.bottomLeftRadiusY = value; }
		
		/**
		 * @copy spark.primitives.Rect#bottomRightRadiusX;
		 */
		public function get bottomRightRadiusX():Number { return rect.bottomRightRadiusX; }
		public function set bottomRightRadiusX(value:Number):void { rect.bottomRightRadiusX = value; }
		
		/**
		 * @copy spark.primitives.Rect#bottomRightRadiusY;
		 */
		public function get bottomRightRadiusY():Number { return rect.bottomRightRadiusY; }
		public function set bottomRightRadiusY(value:Number):void { rect.bottomRightRadiusY = value; }
		
		/**
		 * @copy spark.primitives.Rect#radiusX;
		 */
		public function get radiusX():Number { return rect.radiusX; }
		public function set radiusX(value:Number):void { rect.radiusX = value; }
		
		/**
		 * @copy spark.primitives.Rect#radiusY;
		 */
		public function get radiusY():Number { return rect.radiusY; }
		public function set radiusY(value:Number):void { rect.radiusY = value; }
		
		/**
		 * @copy spark.primitives.Rect#topLeftRadiusX;
		 */
		public function get topLeftRadiusX():Number { return rect.topLeftRadiusX; }
		public function set topLeftRadiusX(value:Number):void { rect.topLeftRadiusX = value; }
		
		/**
		 * @copy spark.primitives.Rect#topLeftRadiusY;
		 */
		public function get topLeftRadiusY():Number { return rect.topLeftRadiusY; }
		public function set topLeftRadiusY(value:Number):void { rect.topLeftRadiusY = value; }
		
		/**
		 * @copy spark.primitives.Rect#topRightRadiusX;
		 */
		public function get topRightRadiusX():Number { return rect.topRightRadiusX; }
		public function set topRightRadiusX(value:Number):void { rect.topRightRadiusX = value; }
		
		/**
		 * @copy spark.primitives.Rect#topRightRadiusY;
		 */
		public function get topRightRadiusY():Number { return rect.topRightRadiusY; }
		public function set topRightRadiusY(value:Number):void { rect.topRightRadiusY = value; }
		
		// :: Fill and Stroke Properties :: //
		
		/**
		 * @copy spark.primitives.supportClasses.FilledElement#fill;
		 */
		public function get fill():IFill { return rect.fill; }
		public function set fill(value:IFill):void { rect.fill = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.StrokedElement#stroke;
		 */
		public function get stroke():IStroke { return rect.stroke; }
		public function set stroke(value:IStroke):void { rect.stroke = value; }
	}
}