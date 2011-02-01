package watercolor.math
{
	import flash.geom.Point;


	/**
	 * Intersection Point Class
	 *
	 * This class extends the standard geom.Point by adding a few extra variables to
	 * help describe the type of intersection. And add clues to where the intersection
	 * happened inside of curves.
	 *
	 * @author Sean Thayne.
	 */
	public class IntersectionPoint extends Point
	{

		/**
		 * Boolean describing if the intersection happened inside of the segment.
		 */
		public var inSegment:Boolean = false;


		/**
		 * The T(time) where the intersection was found inside of the first line.
		 */
		public var lineAIntersectionTime:Number;


		/**
		 * The T(time) where the intersection was found inside of the second line.
		 */
		public var lineBIntersectionTime:Number;


		/**
		 * Constructor
		 *
		 * @param x X Position of intersection.
		 * @param y Y Position of intersection.
		 */
		public function IntersectionPoint( x:Number = 0, y:Number = 0 )
		{
			super( x, y );
		}
	}
}