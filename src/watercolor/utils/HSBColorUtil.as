package watercolor.utils
{
	import flash.geom.Point;
	
	import mx.utils.HSBColor;
	
	/**
	 * Utility class for calculating various HSB values.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @author Tyler Chesley
	 * 
	 */	
	public class HSBColorUtil
	{
		
		/**
		 * Returns a HSB color for the given point on the color wheel and brigthnes. 
		 *  
		 * @param point The point on the color wheel used to caclulate the hue and saturation.
		 * @param radius The radius of the color wheel used to caclulate the hue and saturation.
		 * @param brightness The brightness value for the HSB color. Defaults to 1.
		 * 
		 * @return The HSB color for the given point and brightness.
		 * 
		 */		
		public static function getHSBColor(point:Point, radius:Number, brightness:Number = 1):HSBColor
		{
			var color:HSBColor = new HSBColor();
			color.brightness = brightness;
			color.hue = calculateHue(point, radius);
			color.saturation = calculateSaturation(point, radius);
			return color;
		}
		
		/**
		 * Calculates the saturation of a given point on the color wheel. 
		 * 
		 * <p>If the point is outside the bounds of the color wheel the saturation 
		 * is always 1.</p> 
		 * 
		 * @param point The point on the color wheel used to calculate the saturation.
		 * @param radius The radius of the color wheel used to calculate the saturation.
		 * 
		 * @return Returns the saturation for the given point.
		 * 
		 */		
		public static function calculateSaturation(point:Point, radius:Number):Number
		{
			var x:Number = point.x - radius;
			var y:Number = point.y - radius;
			var saturation:Number = Math.sqrt((x / radius) * (x / radius) + (y / radius) * (y / radius));
			return saturation > 1 ? 1 : saturation;
		}
		
		/**
		 * Calculates the hue for a given point on the color wheel.
		 * 
		 * <p>If the point is outside the color wheel the hue will returned will 
		 * still be correct because hue is calculated based on the angle from the 
		 * the center of the color wheel.</p>
		 * 
		 * @param point The point on the color wheel used to calculate the hue.
		 * @param radius The radius of the color wheel used to calculate the hue.
		 * 
		 * @return Returns the hue for the given point.
		 * 
		 */		
		public static function calculateHue(point:Point, radius:Number):Number
		{
			// Caclulate distance from center
			var x:Number = point.x - radius;
			var y:Number = point.y - radius;
			var hue:Number;
			
			if (x != 0)
			{
				//Must avoid division by 0.
				hue = Math.atan(y / x);
			}
			else
			{
				//x is equal to zero
				if (y >= 0)
				{
					hue = Math.PI / 2;
				}
				else
				{
					hue = 2 * Math.PI - Math.PI / 2;
				}
			}
			
			if ((x < 0) && (y <= 0))
			{
				hue = Math.PI + hue;
			}
			else if ((x > 0) && (y < 0))
			{
				hue = 2 * Math.PI + hue;
			}
			else if ((x < 0) && (y > 0))
			{
				hue = Math.PI + hue;
			}
			
			return hue * 180 / Math.PI;
		}
	}
}