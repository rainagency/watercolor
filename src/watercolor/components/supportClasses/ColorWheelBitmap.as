package watercolor.components.supportClasses
{
	import watercolor.geom.Ellipse;
	import watercolor.utils.HSBColorUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import mx.utils.HSBColor;
	
	/**
	 * The ColorWheelBitmap class is responsible for drawing the color spectrum at a 
	 * given brightness. 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @author Tyler Chesley
	 * 
	 */	
	public class ColorWheelBitmap extends BitmapData
	{
		
	//------------------------------------------------------------------------------
	//	Constructor
	//------------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * 
		 * @param radius The radius of the color wheel.
		 * 
		 */		
		public function ColorWheelBitmap(radius:Number = 100)
		{
			super(radius * 2, radius * 2, true);
			
			this.radius = radius;
			this.ellipse = new Ellipse(0, 0, radius * 2, radius * 2);
			drawColorWheel();
		}
		
	//------------------------------------------------------------------------------
	//	Variables
	//------------------------------------------------------------------------------
		
		/**
		 * @private
		 */		
		private var radius:Number;
		
		/**
		 * @private
		 */		
		private var ellipse:Ellipse;
		
	//------------------------------------------------------------------------------
	//	Properties
	//------------------------------------------------------------------------------
		
		/**
		 * @private 
		 * Storage of the brightness property.
		 */		
		private var _brightness:Number = 1;
		
		/**
		 * The brightness value to draw the color wheel at.
		 * 
		 * <p>In the cylindalical HSB model the brightness value controls the depth  
		 * at which the color wheel is drawn. Changing this value will cause the 
		 * the color wheel to be redrawn.</p>
		 * 
		 * @default 1
		 * 
		 */		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		/**
		 * @private
		 */		
		public function set brightness(value:Number):void
		{
			if (_brightness == value)
				return;
			
			_brightness = value;
			drawColorWheel();
		}
		
	//------------------------------------------------------------------------------
	//	Methods
	//------------------------------------------------------------------------------
		
		/**
		 * Method responsible for drawing the color wheel. 
		 */		
		protected function drawColorWheel():void
		{
			for (var col:int = 0; col < width; col++)
			{
				for (var row:int = 0; row < height; row++)
				{
					if (ellipse.contains(col, row))
					{
						var point:Point = new Point(col, row);
						var color:HSBColor = HSBColorUtil.getHSBColor(point, radius, brightness)
						setPixel(col, row, HSBColor.convertHSBtoRGB(color.hue, color.saturation, brightness));
					}
					else
					{
						// Make pixels outside the color wheel transparent.
						setPixel32(col, row, 0x00000000);
					}
				}
			}
			
		}
		
	}
}