package watercolor.math
{
	import flash.geom.Point;

	import watercolor.math.interfaces.IBezierCurve;
	import watercolor.utils.IntersectionUtil;


	/**
	 * A Bezier Curve
	 *
	 * A Bezier Bezier has 4 points of control.
	 *
	 * @author Sean Thayne
	 */
	public class CubicBezierCurve extends EuclideanLine implements IBezierCurve
	{
		public var controlPointA:Point;


		public var controlPointB:Point;



		public function CubicBezierCurve( pointA:Point = null, controlPointA:Point = null, controlPointB:Point = null, pointB:Point = null )
		{
			this.pointA = pointA;
			this.controlPointA = controlPointA;
			this.controlPointB = controlPointB;
			this.pointB = pointB;
		}


		/**
		 * Finds the X-position at t(time) 0.0 - 1.0
		 *
		 * x = At3 + Bt2 + Ct + D
		 *
		 * @param t Timing position to find X at.
		 * @param coefficents Curves coefficents, you can pass this a cached value
		 *
		 * @return The X-position at T
		 */
		public function getX( t:Number, coefficents:CubicBeizerCurveCoefficents = null ):Number
		{

			if( !coefficents )
			{
				coefficents = getCoefficents();
			}

			return coefficents.A * Math.pow( t, 3 ) + ( coefficents.B * Math.pow( t, 2 )) + ( coefficents.C * t ) + coefficents.D;
		}


		/**
		 * Finds the Y-position at t(time) 0.0 - 1.0
		 *
		 * y = Et3 + Ft2 + Gt + H
		 *
		 * @param t Timing position to find Y at.
		 * @param coefficents Curves coefficents, you can pass this a cached value
		 *
		 * @return The Y-position at T
		 */
		public function getY( t:Number, coefficents:CubicBeizerCurveCoefficents = null ):Number
		{

			if( !coefficents )
			{
				coefficents = getCoefficents();
			}

			return coefficents.E * Math.pow( t, 3 ) + ( coefficents.F * Math.pow( t, 2 )) + ( coefficents.G * t ) + coefficents.H;
		}


		/**
		 * Finds the Point at t(time) 0.0 - 1.0
		 *
		 * x = At3 + Bt2 + Ct + D
		 * y = Et3 + Ft2 + Gt + H
		 *
		 * @param t Timing position to find Y at.
		 *
		 * @return The Point at t(Time)
		 */
		public function getPoint( t:Number ):Point
		{
			var coefficents:CubicBeizerCurveCoefficents = getCoefficents();

			return new Point( getX( t, coefficents ), getY( t, coefficents ));
		}




		/**
		 * Point Aliases
		 *
		 * x0,y0 = pointA
		 * x1,y1 = controlPointA
		 * x2,y2 = controlPointB
		 * x3,y3 = pointB
		 *
		 * X Coefficents
		 *
		 * A = x3 - 3 * x2 + 3 * x1 - x0
		 * B = 3 * x2 - 6 * x1 + 3 * x0
		 * C = 3 * x1 - 3 * x0
		 * D = x0
		 *
		 * Y Coefficents
		 *
		 * E = y3 - 3 * y2 + 3 * y1 - y0
		 * F = 3 * y2 - 6 * y1 + 3 * y0
		 * G = 3 * y1 - 3 * y0
		 * H = y0
		 */
		public function getCoefficents():CubicBeizerCurveCoefficents
		{
			var coeffectient:CubicBeizerCurveCoefficents = new CubicBeizerCurveCoefficents();

			coeffectient.A = pointB.x - 3 * controlPointB.x + 3 * controlPointA.x - pointA.x;
			coeffectient.B = 3 * controlPointB.x - 6 * controlPointA.x + 3 * pointA.x;
			coeffectient.C = 3 * controlPointA.x - 3 * pointA.x;
			coeffectient.D = pointA.x;

			coeffectient.E = pointB.y - 3 * controlPointB.y + 3 * controlPointA.y - pointA.y;
			coeffectient.F = 3 * controlPointB.y - 6 * controlPointA.y + 3 * pointA.y;
			coeffectient.G = 3 * controlPointA.y - 3 * pointA.y;
			coeffectient.H = pointA.y;

			return coeffectient;
		}


		/**
		 * x0 = D;
		 * x1 = D + C / 3
		 * x2 = D + 2 * C / 3 + B / 3
		 * x3 = D + C + B + A
		 *
		 * y0 = H;
		 * y1 = H + G / 3
		 * y2 = H + 2 * G / 3 + F / 3
		 * y3 = H + G + F + E
		 */
		public function setPointsFromCoefficients( coefficents:CubicBeizerCurveCoefficents ):void
		{
			pointA = new Point( coefficents.D );
			pointA.y = coefficents.H;

			controlPointA = new Point( coefficents.D + coefficents.C / 3 );
			controlPointA.y = coefficents.H + coefficents.G / 3;

			controlPointB = new Point( coefficents.D + 2 * coefficents.C / 3 + coefficents.B / 3 );
			controlPointB.y = coefficents.H + 2 * coefficents.G / 3 + coefficents.F / 3;

			pointB = new Point( coefficents.D + coefficents.C + coefficents.B + coefficents.A );
			pointB.y = coefficents.H + coefficents.G + coefficents.F + coefficents.E;
		}




		/**
		 * Clip A Cubic Curves Start Point.
		 *
		 * 		If T = .5 and our original points look like this.
		 *
		 *        CP(A) ->  ◎--------◎ <- CP(B)
		 *                 /           \
		 * 	              /             \
		 *      P(A) ->  ◎_             ◎ <- P(B)
		 *
		 * 		Then our new points will be
		 *
		 *            CP(A) ->  ◎----
		 *                            \
		 * 	          P(A) ->   ◎      ◎   \ <- CP(B)
		 *                              ◎ <- P(B)
		 *
		 * 	We use lerps(Linear Interpolation) to find the new control points.
		 *
		 * 	CP(A) = lerp( CP(A), CP(B), t)
		 *  CP(B) = lerp( CP(B), P(B), t)
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		public function clipPointATo( time:Number, forcedPointA:Point = null ):void
		{

			//Outside Guide Lines
			var outerA:StraightLine = new StraightLine( pointA, controlPointA );
			var outerBridge:StraightLine = new StraightLine( controlPointA, controlPointB );
			var outerB:StraightLine = new StraightLine( controlPointB, pointB );

			//Inner Guide Lines
			var innerA:StraightLine = new StraightLine( outerA.lerp( time ), outerBridge.lerp( time ));
			var innerB:StraightLine = new StraightLine( outerBridge.lerp( time ), outerB.lerp( time ));

			if( forcedPointA )
			{
				pointA = forcedPointA;
			}
			else
			{
				pointA = new StraightLine( innerA.lerp( time ), innerB.lerp( time )).lerp( time );
			}


			controlPointA = innerB.lerp( time );
			controlPointB = outerB.lerp( time );
		}


		/**
		 * Clip A Cubic Curves End Point.
		 *
		 * 		If T = .5 and our original points look like this.
		 *
		 *        CP(A) ->  ◎--------◎ <- CP(B)
		 *                 /           \
		 * 	              /             \
		 *      P(A) ->  ◎_             ◎ <- P(B)
		 *
		 * 		Then our new points will be
		 *
		 *          		/--◎ <- CP(B)
		 *        CP(A) -> ◎        \
		 * 	              /      ◎ <- P(B)
		 *      P(A) ->  ◎
		 *
		 * 	We use lerps(Linear Interpolation) to find the new control points.
		 *
		 * 	CP(A) = lerp( P(A), CP(A), t)
		 *  CP(B) = lerp( CP(A), CP(B), t)
		 *
		 * @param time Time Position to clip at
		 * @param forcedPointA An inaccurate point to clip to, useful for intersections.
		 */
		public function clipPointBTo( time:Number, forcedPointB:Point = null ):void
		{
			//Outside Guide Lines
			var outerA:StraightLine = new StraightLine( pointA, controlPointA );
			var outerBridge:StraightLine = new StraightLine( controlPointA, controlPointB );
			var outerB:StraightLine = new StraightLine( controlPointB, pointB );

			//Inner Guide Lines
			var innerA:StraightLine = new StraightLine( outerA.lerp( time ), outerBridge.lerp( time ));
			var innerB:StraightLine = new StraightLine( outerBridge.lerp( time ), outerB.lerp( time ));

			if( forcedPointB )
			{
				pointB = forcedPointB;
			}
			else
			{
				pointB = new StraightLine( innerA.lerp( time ), innerB.lerp( time )).lerp( time );
			}

			controlPointA = outerA.lerp( time );
			controlPointB = innerA.lerp( time );
		}


		public function subDivide( time:Number ):Vector.<CubicBezierCurve>
		{
			//Outside Guide Lines
			var outerA:StraightLine = new StraightLine( pointA, controlPointA );
			var outerBridge:StraightLine = new StraightLine( controlPointA, controlPointB );
			var outerB:StraightLine = new StraightLine( controlPointB, pointB );

			//Inner Guide Lines
			var innerA:StraightLine = new StraightLine( outerA.lerp( time ), outerBridge.lerp( time ));
			var innerB:StraightLine = new StraightLine( outerBridge.lerp( time ), outerB.lerp( time ));

			//Point at time
			var newPoint:Point = new StraightLine( innerA.lerp( time ), innerB.lerp( time )).lerp( time );

			//Return Vector
			var newCurves:Vector.<CubicBezierCurve> = new Vector.<CubicBezierCurve>();

			//Left Curve
			var leftCurve:CubicBezierCurve = new CubicBezierCurve();
			leftCurve.pointA = pointA;
			leftCurve.controlPointA = outerA.lerp( time );
			leftCurve.controlPointB = innerA.lerp( time );
			leftCurve.pointB = newPoint;
			newCurves.push( leftCurve );

			//Right Curve
			var rightCurve:CubicBezierCurve = new CubicBezierCurve();
			rightCurve.pointA = newPoint;
			rightCurve.controlPointA = innerB.lerp( time );
			rightCurve.controlPointB = outerB.lerp( time );
			rightCurve.pointB = pointB;
			newCurves.push( rightCurve );

			//Return Vector containing new curves.
			return newCurves;
		}


		/**
		 * Create a perfect(as close as possible) parallel curve.
		 *
		 * @param Spacing to place between the new parrallel line and the original.
		 *
		 * @return A new Straigh Line that is Parrallel to this one.
		 */
		public function createParrallelLine( difference:Number ):CubicBezierCurve
		{
			var lineA:StraightLine;
			var lineB:StraightLine;
			var lineC:StraightLine;

			var parrallelLine:StraightLine = new StraightLine( pointA, pointB ).createParrallelLine( 1 );
			var offset:Point = parrallelLine.pointA.subtract( pointA );

			lineA = new StraightLine( getPoint( 0 ), getPoint( 0.00001 )).createParrallelLine( difference );
			lineB = new StraightLine( getPoint( .99999 ), getPoint( 1 )).createParrallelLine( difference );

			return new CubicBezierCurve( lineA.pointA, controlPointA.add( offset ), controlPointB.add( offset ), lineB.pointB );
		}


		public function getLineSegments( tolerance:Number ):Vector.<EuclideanLine>
		{
			var vector:Vector.<EuclideanLine> = new Vector.<EuclideanLine>();
			var clone:CubicBezierCurve = clone();

			vector.push( clone );
			convertToLineSegments( tolerance, vector, clone );

			return vector;
		}


		private function convertToLineSegments( tolerance:Number, vector:Vector.<EuclideanLine>, segment:CubicBezierCurve ):void
		{
			if( segment.flatness > tolerance )
			{
				var splits:Vector.<CubicBezierCurve> = segment.subDivide( .5 );
				var index:uint = vector.indexOf( segment );
				vector.splice( index, 1, splits[ 0 ], splits[ 1 ]);

				convertToLineSegments( tolerance, vector, splits[ 0 ]);
				convertToLineSegments( tolerance, vector, splits[ 1 ]);
			}
		}


		/**
		 * Returns the flatness value of a curve.
		 *
		 * Our definition of flatness quite nicely matches the one used in Adobe's
		 * PostScript language [1] (page 669, operator setflat flatness): Flatness is the
		 * error tolerance of this approximation; it is the maximum allowable distance of
		 * any point of the approximation from the corresponding point on the true curve,
		 * measured in output device pixels." So our number tol has the same semantics
		 * as the argument flatness to the operator setflat.
		 */
		public function get flatness():Number
		{
			var ux:Number = Math.pow( 3 * controlPointA.x - 2 * pointA.x - pointB.x, 2 );
			var uy:Number = Math.pow( 3 * controlPointA.y - 2 * pointA.y - pointB.y, 2 );
			var vx:Number = Math.pow( 3 * controlPointB.x - 2 * pointB.x - pointA.x, 2 );
			var vy:Number = Math.pow( 3 * controlPointB.y - 2 * pointB.y - pointA.y, 2 );

			if( ux < vx )
				ux = vx;

			if( uy < vy )
				uy = vy;

			return ux + uy;
		}


		/**
		 * Clones this Cubic Curve
		 *
		 * @return Cloned copy of this curve.
		 */
		public function clone():CubicBezierCurve
		{
			return new CubicBezierCurve( pointA.clone(), controlPointA.clone(), controlPointB.clone(), pointB.clone());
		}
	}
}


/**
 *
 * A = x3 - 3 * x2 + 3 * x1 - x0
 * B = 3 * x2 - 6 * x1 + 3 * x0
 * C = 3 * x1 - 3 * x0
 * D = x0
 *
 * Y Coefficents
 *
 * E = y3 - 3 * y2 + 3 * y1 - y0
 * F = 3 * y2 - 6 * y1 + 3 * y0
 * G = 3 * y1 - 3 * y0
 * H = y0
 *
 * @author Sean Thayne
 */
class CubicBeizerCurveCoefficents
{


	public var A:Number;


	public var B:Number;


	public var C:Number;


	public var D:Number;


	public var E:Number;


	public var F:Number;


	public var G:Number;


	public var H:Number;
}