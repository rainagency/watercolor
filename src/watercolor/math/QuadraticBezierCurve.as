package watercolor.math
{
	import flash.geom.Point;

	import watercolor.math.interfaces.IBezierCurve;
	import watercolor.utils.IntersectionUtil;


	/**
	 * Quadratice Bezier Curve.
	 *
	 * A Quadratice Bezier has 3 points of control.
	 *
	 * @author Sean Thayne
	 */
	public class QuadraticBezierCurve extends EuclideanLine implements IBezierCurve
	{
		public var controlPoint:Point;


		public function QuadraticBezierCurve( pointA:Point = null, controlPoint:Point = null, pointB:Point = null )
		{
			this.pointA = pointA;
			this.controlPoint = controlPoint;
			this.pointB = pointB;
		}


		/**
		 * Finds the X-position at t(time) 0 <= t <= 1
		 *
		 * x = At2 + Bt + C
		 *
		 * @param t Timing position to find X at.
		 * @param coefficents Curves coefficents, you can pass this a cached value
		 *
		 * @return The X-position at T
		 */
		public function getX( t:Number, coefficents:QuadraticeBeizerCurveCoefficents = null ):Number
		{

			if( !coefficents )
			{
				coefficents = getCoefficents();
			}

			return coefficents.A * Math.pow( t, 2 ) + coefficents.B * t + coefficents.C;
		}


		/**
		 * Finds the Y-position at t(time) 0 <= t <= 1
		 *
		 * y = Dt2 + Et + F
		 *
		 * @param t Timing position to find Y at.
		 * @param coefficents Curves coefficents, you can pass this a cached value
		 *
		 * @return The Y-position at T
		 */
		public function getY( t:Number, coefficents:QuadraticeBeizerCurveCoefficents = null ):Number
		{

			if( !coefficents )
			{
				coefficents = getCoefficents();
			}

			return coefficents.D * Math.pow( t, 2 ) + coefficents.E * t + coefficents.F;
		}


		/**
		 * Finds the Point at t(time) 0 <= t <= 1
		 *
		 * x = At2 + Bt + C
		 * y = Dt2 + Et + F
		 *
		 * @param t Timing position to find Y at.
		 *
		 * @return The Point at t(Time)
		 */
		public function getPoint( t:Number ):Point
		{
			var coefficents:QuadraticeBeizerCurveCoefficents = getCoefficents();

			return new Point( getX( t, coefficents ), getY( t, coefficents ));
		}




		/**
		 * Point Aliases
		 *
		 * x0,y0 = pointA
		 * x1,y1 = controlPoint
		 * x2,y2 = pointB
		 *
		 * A = x0 - 2 * x1 + x2
		 * B = 2(x1 - x0)
		 * C = x0
		 *
		 * Y Coefficents
		 *
		 * D = y0 - 2 * y1 + y2
		 * E = 2(y1 - y0)
		 * F = y0
		 */
		public function getCoefficents():QuadraticeBeizerCurveCoefficents
		{
			var coeffectient:QuadraticeBeizerCurveCoefficents = new QuadraticeBeizerCurveCoefficents();

			coeffectient.A = pointA.x - ( 2 * controlPoint.x ) + pointB.x;
			coeffectient.B = 2 * ( controlPoint.x - pointA.x );
			coeffectient.C = pointA.x;

			coeffectient.D = pointA.y - ( 2 * controlPoint.y ) + pointB.y;
			coeffectient.E = 2 * ( controlPoint.y - pointA.y );
			coeffectient.F = pointA.y;

			return coeffectient;
		}


		//TODO:Finish this (if we ever need it)
		public function setPointsFromCoefficients( coefficents:QuadraticeBeizerCurveCoefficents ):void
		{

		}


		/**
		 * Clip A Quadratic Curves Start Point.
		 *
		 * 		If T = .5 and our original points look like this.
		 *
		 *         P(A) ->  ◎--------◎ <- CP
		 *                             \
		 * 	                            \
		 *                               ◎ <- P(B)
		 *
		 * 		Then our new points will be
		 *
		 *
		 *                           /--◎ <- CP
		 *                 P(A) -> ◎           \
		 *                                ◎ <- P(B)
		 *
		 *
		 * 	We use lerps(Linear Interpolation) to find the new control points.
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		public function clipPointATo( time:Number, forcedPointA:Point = null ):void
		{
			var controlPointLineFrom:StraightLine = new StraightLine( controlPoint, pointB );

			if( forcedPointA )
			{
				pointA = forcedPointA;
			}
			else
			{
				var controlPointLineTo:StraightLine = new StraightLine( pointA, controlPoint );
				pointA = new StraightLine( controlPointLineTo.lerp( time ), controlPointLineFrom.lerp( time )).lerp( time );
			}

			controlPoint = controlPointLineFrom.lerp( time );
		}


		/**
		 * Clip A Quadratic Curves End Point.
		 *
		 * 		If T = .5 and our original points look like this.
		 *
		 *         P(A) ->  ◎--------◎ <- CP
		 *                             \
		 * 	                            \
		 *                               ◎ <- P(B)
		 *
		 * 		Then our new points will be
		 *
		 *          P(A) -> ◎--◎-
		 *                   CP ^  \
		 *                          ◎ <- P(B)
		 *
		 *
		 *
		 *
		 *
		 * 	We use lerps(Linear Interpolation) to find the new control points.
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		public function clipPointBTo( time:Number, forcedPointB:Point = null ):void
		{
			var controlPointLineTo:StraightLine = new StraightLine( pointA, controlPoint );

			if( forcedPointB )
			{
				pointB = forcedPointB;
			}
			else
			{
				var controlPointLineFrom:StraightLine = new StraightLine( controlPoint, pointB );
				pointB = new StraightLine( controlPointLineTo.lerp( time ), controlPointLineFrom.lerp( time )).lerp( time );
			}

			controlPoint = controlPointLineTo.lerp( time );
		}


		/**
		 * Create a perfect(as close as possible) parallel curve.
		 *
		 * @param Spacing to place between the new parrallel line and the original.
		 *
		 * @return A new Straigh Line that is Parrallel to this one.
		 */
		public function createParrallelLine( difference:Number ):QuadraticBezierCurve
		{
			var lineA:StraightLine = new StraightLine( pointA, controlPoint ).createParrallelLine( difference );
			var lineB:StraightLine = new StraightLine( controlPoint, pointB ).createParrallelLine( difference );

			var intersectionPoints:Vector.<IntersectionPoint> = IntersectionUtil.getStraightLinesIntersectionPoints( lineA, lineB );
			var parrallelLine:QuadraticBezierCurve = new QuadraticBezierCurve( lineA.pointA, intersectionPoints[ 0 ], lineB.pointB );

			//			var lineC:StraightLine = new StraightLine( controlPoint, intersectionPoints[ 0 ]);
			//			if( lineC.distance > 1 )
			//				parrallelLine.controlPoint = lineC.lerp( 1.25 / lineC.distance );


			return parrallelLine;
		}


		public function getLineSegments( tolerance:Number ):Vector.<EuclideanLine>
		{
			return new Vector.<EuclideanLine>();
		}
	}
}


/**
 * A = x0 - 2 * x1 + x2
 * B = 2(x1 - x0)
 * C = x0
 *
 * Y Coefficents
 *
 * D = y0 - 2 * y1 + y2
 * E = 2(y1 - y0)
 * F = y0
 *
 * @author Sean Thayne
 */
class QuadraticeBeizerCurveCoefficents
{


	public var A:Number;


	public var B:Number;


	public var C:Number;


	public var D:Number;


	public var E:Number;


	public var F:Number;
}