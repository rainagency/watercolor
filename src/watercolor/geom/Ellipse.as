package watercolor.geom
{
	
	/**
	 * The Ellipse class is used to represent the properties of an ellipse and has 
	 * a method to detect if a point falls within the bounds of the ellipse. 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @see watercolor.components.suppportClasses.ColorWheelBitmap
	 * 
	 * @author Tyler Chesley
	 * 
	 */	
	public class Ellipse
	{
		
	//------------------------------------------------------------------------------
	//	Constructor
	//------------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * 
		 * @param x The x value of the ellipse.
		 * @param y The y value of the ellipse.
		 * @param width The width of the ellipse.
		 * @param height The height of the ellipse.
		 * 
		 */		
		public function Ellipse(x:Number, y:Number, width:Number, height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
	//------------------------------------------------------------------------------
	//	Properties
	//------------------------------------------------------------------------------
		
		/**
		 * The x value of the ellipse.
		 */		
		public var x:Number;
		
		/**
		 * The y value of the ellipse.
		 */		
		public var y:Number;
		
		/**
		 * The width value of the ellipse.
		 */		
		public var width:Number;
		
		/**
		 * The height value of the ellipse.
		 */		
		public var height:Number;
		
	//------------------------------------------------------------------------------
	//	Methods
	//------------------------------------------------------------------------------
		
		/**
		 * Method to check if a point falls within the bounds of the ellipse.
		 * 
		 * @param x The x value of the point
		 * @param y The y value of the point
		 * 
		 * @return Returns whether the point is within the bounds of the ellipse.
		 * 
		 */		
		public function contains(x:Number, y:Number):Boolean 
		{
			var xRadius:Number = this.width * 0.5;
			var yRadius:Number = this.height * 0.5;
			var xTar:Number    = x - this.x - xRadius;
			var yTar:Number    = y - this.y - yRadius;
			
			return Math.pow(xTar / xRadius, 2) + Math.pow(yTar / yRadius, 2) <= 1;
		}
		
	}
}