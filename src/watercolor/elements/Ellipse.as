package watercolor.elements
{
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.primitives.Ellipse;
	
	import watercolor.elements.interfaces.IElementGraphic;
	
	/**
	 * Watercolor's Ellipse element encapsulates a Flex-based Ellipse, a filled
	 * graphic element that draws an ellipse.
	 * 
	 * @see spark.primitives.Ellipse
	 */
	public class Ellipse extends Element implements IElementGraphic
	{
		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		protected var ellipse:spark.primitives.Ellipse;
		
		public function Ellipse()
		{
			ellipse = new spark.primitives.Ellipse();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement(ellipse);
		}
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number { return ellipse.width; }
		override public function set width(value:Number):void { super.width = value; ellipse.width = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number { return ellipse.height; }
		override public function set height(value:Number):void { super.height = value; ellipse.height = value; }
		
		// :: Ellipse Properties :: //
		
		// :: Fill and Stroke Properties :: //
		
		/**
		 * @copy spark.primitives.supportClasses.FilledElement#fill;
		 */
		public function get fill():IFill { return ellipse.fill; }
		public function set fill(value:IFill):void { ellipse.fill = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.StrokedElement#stroke;
		 */
		public function get stroke():IStroke { return ellipse.stroke; }
		public function set stroke(value:IStroke):void { ellipse.stroke = value; }
	}
}