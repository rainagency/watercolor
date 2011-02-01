package watercolor.elements
{
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.primitives.Line;
	
	/**
	 * Watercolor's Line element encapsulates a Flex-based Line, a graphic
	 * element that draws a line between two points.
	 * 
	 * @see spark.primitives.Line
	 */
	public class Line extends Element
	{
		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		protected var line:spark.primitives.Line;
		
		public function Line()
		{
			line = new spark.primitives.Line();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement(line);
		}
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number { return line.width; }
		override public function set width(value:Number):void { super.width = value; line.width = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number { return line.height; }
		override public function set height(value:Number):void { super.height = value; line.height = value; }
		
		// :: Line Properties :: //
		
		/**
		 * @copy spark.primitives.Line#xFrom;
		 */
		public function get xFrom():Number { return line.xFrom; }
		public function set xFrom(value:Number):void { line.xFrom = value; }
		
		/**
		 * @copy spark.primitives.Line#xTo;
		 */
		public function get xTo():Number { return line.xTo; }
		public function set xTo(value:Number):void { line.xTo = value; }
		
		/**
		 * @copy spark.primitives.Line#yFrom;
		 */
		public function get yFrom():Number { return line.yFrom; }
		public function set yFrom(value:Number):void { line.yFrom = value; }
		
		/**
		 * @copy spark.primitives.Line#yTo;
		 */
		public function get yTo():Number { return line.yTo; }
		public function set yTo(value:Number):void { line.yTo = value; }
		
		// :: Fill and Stroke Properties :: //
		
		/**
		 * @copy spark.primitives.supportClasses.StrokedElement#stroke;
		 */
		public function get stroke():IStroke { return line.stroke; }
		public function set stroke(value:IStroke):void { line.stroke = value; }
	}
}