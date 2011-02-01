package watercolor.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CoordinateUtils
	{
		/**
		 * Converts a point from the coordinate space of one DisplayObject to another.
		 * @param containerFrom The origin container.
		 * @param containerTo The destination container.
		 * @param point The point to convert (should be in containerFrom's coordinate space.)
		 */
		public static function localToLocal(containerFrom:Object, containerTo:Object, point:Point):Point
		{
			if (!point)
			{
				point = new Point();
			}

			point = containerFrom.localToGlobal(point);
			point = containerTo.globalToLocal(point);
			return point;
		}

		/**
		 * Converts a rectangle from one coordinate space to another.
		 * THIS ONLY WORKS FOR UNROTATED RECTANGLES.
		 * @param containerFrom The origin container.
		 * @param containerTo The destination container.
		 * @param rect The rectangle to convert (should be in containerFrom's coordinate space.)
		 */
		public static function localToLocalRect(containerFrom:DisplayObject, containerTo:DisplayObject,
												rect:Rectangle):Rectangle
		{
			var topLeft:Point = localToLocal(containerFrom, containerTo, rect.topLeft);
			var bottomRight:Point = localToLocal(containerFrom, containerTo, rect.bottomRight);
			return new Rectangle(topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - topLeft.
								 y);
		}
	}
}