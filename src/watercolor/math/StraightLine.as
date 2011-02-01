package watercolor.math
{
	import flash.geom.Point;


	/**
	 * Container/Utility For Mathmatical Lines
	 *
	 * @author Sean Thayne
	 */
	public class StraightLine extends EuclideanLine
	{

		/**
		 * Constructor
		 *
		 * @param pointA Starting/Midway point of this segment.
		 * @param pointB Ending/Midway point of this segment.
		 */
		public function StraightLine( pointA:Point = null, pointB:Point = null )
		{
			this.pointA = pointA;
			this.pointB = pointB;
		}


		/**
		 * The Rise(Y) of the line segment's slope.
		 *
		 * @return Rise of this line's slope.
		 */
		public function get rise():Number
		{
			return ( pointA.y - pointB.y );
		}


		/**
		 * The Run(X) of the line segment's slope.
		 *
		 * @return Run of this line's slope.
		 */
		public function get run():Number
		{
			return ( pointA.x - pointB.x );
		}


		/**
		 * The line segment's slope (Rise over Run)
		 *
		 * @return The Slope of this line
		 */
		public function get slope():FractionNumber
		{
			return new FractionNumber( rise, run );
		}


		/**
		 * The line segment's perpindicular slope (-Run over Rise)
		 *
		 * @return The Perpindular Slope of this line
		 */
		public function get perpendicularSlope():FractionNumber
		{
			return new FractionNumber( -run, rise );
		}


		/**
		 * The line segment's y-Intercept (The Y value where X is zero)
		 *
		 * @return Y Intercept of this line
		 */
		public function get yIntercept():Number
		{
			return ( -1 * slope.toNumber()) * pointA.x + pointA.y;
		}


		public function get distance():Number
		{
			return Math.sqrt( Math.pow( rise, 2 ) * Math.pow( run, 2 ));
		}


		/**
		 * The perpindicular line segment's y-Intercept (The Y value where X is zero)
		 *
		 * @return Perpindicular Y Intercept of this line
		 */
		public function get perpindicularYIntercept():Number
		{
			return ( perpendicularSlope.toNumber() * pointA.x - pointA.y ) * -1;
		}


		/**
		 * True if line is vertical
		 *
		 * @boolean True if line is Vertical
		 */
		public function get isVertical():Boolean
		{
			return pointA.x == pointB.x;
		}


		/**
		 * True if line is horizontal
		 *
		 * @boolean True if line is Horizontial
		 */
		public function get isHorizontal():Boolean
		{
			return pointA.y == pointB.y;
		}


		/**
		 * Move to position t along this line
		 *
		 * @param t Time to find point at.
		 *
		 * @return Point at given time.
		 */
		public function lerp( t:Number ):Point
		{
			return new Point( pointA.x + ( pointB.x - pointA.x ) * t, pointA.y + ( pointB.y - pointA.y ) * t );

		}


		/**
		 * Finds the line->line interception point.
		 *
		 * @param line Line to find Intersection Point with.
		 *
		 * @return Point where intersection happens.
		 */
		//TODO: Depricate this function for the new IntersectionUtility.
		public function getCollisionPoint( line:StraightLine ):Point
		{
			var point:Point = new Point();

			if( isVertical && line.isVertical || isHorizontal && line.isHorizontal || slope.toNumber() == line.slope.toNumber())
			{
				return null;
			}

			if( isVertical )
			{
				point.x = pointB.x;
				point.y = line.isHorizontal ? line.pointB.y : (( line.slope.toNumber() * point.x ) + line.yIntercept );
			}
			else if( line.isVertical )
			{
				point.x = line.pointA.x;
				point.y = isHorizontal ? pointA.y : (( slope.toNumber() * point.x ) + yIntercept );
			}
			else
			{
				point.x = ( yIntercept - line.yIntercept ) / ( line.slope.toNumber() - slope.toNumber());
				point.y = point.x * slope.toNumber() + yIntercept;
			}

			if( point.x == Infinity || point.x == -Infinity || point.y == Infinity || point.y == -Infinity )
			{
				throw new Error( "Infinity Solution" );
			}

			return point;
		}


		/**
		 * Create a perfect parallel line.
		 *
		 * The Slope will be the same.
		 * The Length of the line will be the same.
		 * The distance of the new line will be exactly the difference.
		 *
		 * @param Spacing to place between the new parrallel line and the original.
		 *
		 * @return A new Straigh Line that is Parrallel to this one.
		 */
		public function createParrallelLine( difference:Number ):StraightLine
		{
			var perp_x:Number = -rise
			var perp_y:Number = run;
			var len:Number = Math.sqrt(( perp_x * perp_x ) + ( perp_y * perp_y ));

			perp_x = ( perp_x / len ) * difference;
			perp_y = ( perp_y / len ) * difference;

			var parrallelLine:StraightLine = new StraightLine( new Point( pointA.x - perp_x, pointA.y - perp_y ), new Point( pointB.x - perp_x, pointB.y - perp_y ));

			return parrallelLine;
		}


		public function toString():String
		{
			return pointA + " -> " + pointB;
		}
	}
}
