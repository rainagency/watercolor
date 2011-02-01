package watercolor.math.interfaces
{
	import flash.geom.Point;

	import watercolor.math.EuclideanLine;


	/**
	 * Interface for all Bezier Curves
	 *
	 * @author Sean Thayne
	 */
	public interface IBezierCurve
	{
		/**
		 * Finds the Point at t(time) 0.0 - 1.0
		 *
		 * @param t Timing position to find Point at.
		 *
		 * @return The Point at t(Time)
		 */
		function getPoint( t:Number ):Point;

		/**
		 * Returns Starting Point of Curve
		 *
		 * @return Starting Point
		 */
		function get pointA():Point;

		/**
		 * Set Starting Point of Curve
		 *
		 * @param Starting Point
		 */
		function set pointA( p:Point ):void;

		/**
		 * Returns Ending Point of Curve
		 *
		 * @return Ending Point
		 */
		function get pointB():Point;

		/**
		 * Sets Ending Point of Curve
		 *
		 * @param Ending Point
		 */
		function set pointB( p:Point ):void;

		/**
		 * Clip Curves Start Point.
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		function clipPointATo( time:Number, forcedPointA:Point = null ):void;

		/**
		 * Clip Curves End Point.
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		function clipPointBTo( time:Number, forcedPointB:Point = null ):void;

		/**
		 * Flattens curve into a vector of line segments.
		 *
		 * This is usefull for many things, including offsetting and finding intersections.
		 *
		 * @param tolerance Tolerance in pixels the poly-line version of curve can be incorrect.
		 *
		 * @return Vector of line segments.
		 */
		function getLineSegments( tolerance:Number ):Vector.<EuclideanLine>;
	}
}