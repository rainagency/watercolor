package watercolor.utils
{
	import flash.geom.Point;

	import watercolor.math.EuclideanLine;
	import watercolor.math.IntersectionPoint;
	import watercolor.math.QuadraticBezierCurve;
	import watercolor.math.StraightLine;
	import watercolor.math.interfaces.IBezierCurve;


	/**
	 * Utility for finding Intersections between lines and curves
	 *
	 * @author Sean Thayne
	 */
	public class IntersectionUtil
	{

		/**
		 * Find all intersections points between to Euclidean Lines. You can
		 * pass any combination of curves or lines to this function.
		 *
		 * @param lineA First Euclidean Line
		 * @param lineB Second Euclidean Line
		 *
		 * @return A Vector containing all intersection points. NULL if none.
		 */
		public static function getIntersectionPoints( lineA:EuclideanLine, lineB:EuclideanLine ):Vector.<IntersectionPoint>
		{
			if( lineA is StraightLine && lineB is StraightLine )
			{
				return getStraightLinesIntersectionPoints( StraightLine( lineA ), StraightLine( lineB ), true );
			}
			else if( lineA is StraightLine && lineB is IBezierCurve )
			{
				return getStraightLineToBezierCurveIntersectionPoints( StraightLine( lineA ), IBezierCurve( lineB ));
			}
			else if( lineA is IBezierCurve && lineB is StraightLine )
			{
				return getStraightLineToBezierCurveIntersectionPoints( StraightLine( lineB ), IBezierCurve( lineA ));
			}
			else if( lineA is IBezierCurve && lineB is IBezierCurve )
			{
				return getBezierCurveIntersectionPoints( IBezierCurve( lineA ), IBezierCurve( lineB ));
			}

			return null;
		}


		/**
		 * Figures out if a Point is inside of the segment.
		 *
		 * @param line The Line Segment to check.
		 * @param point The Point to check.
		 *
		 * @return True if Point is inside the segment.
		 */
		public static function pointInsideLineSegment( line:StraightLine, point:Point ):Boolean
		{
			//Distance Checks
			var interSectionPointDistanceA:Number = Math.pow( point.x - line.pointB.x, 2 ) + Math.pow( point.y - line.pointB.y, 2 );
			var lineSegmentPointDistanceA:Number = Math.pow( line.pointA.x - line.pointB.x, 2 ) + Math.pow( line.pointA.y - line.pointB.y, 2 );
			var interSectionPointDistanceB:Number = Math.pow( point.x - line.pointA.x, 2 ) + Math.pow( point.y - line.pointA.y, 2 );
			var lineSegmentPointDistanceB:Number = Math.pow( line.pointA.x - line.pointB.x, 2 ) + Math.pow( line.pointA.y - line.pointB.y, 2 );

			var distanceFailCheckA:Boolean = interSectionPointDistanceA > lineSegmentPointDistanceA;
			var distanceFailCheckB:Boolean = interSectionPointDistanceB > lineSegmentPointDistanceB;

			return ( distanceFailCheckA || distanceFailCheckB ) ? false : true;
		}


		/**
		 * Find all intersections points between two Lines.
		 *
		 * @param lineA First Straight Line
		 * @param lineB Second Straight Line
		 *
		 * @return A Vector containing all intersection points. NULL if none.
		 */
		public static function getStraightLinesIntersectionPoints( lineA:StraightLine, lineB:StraightLine, inSegmentOnly:Boolean = false ):Vector.<IntersectionPoint>
		{
			var point:IntersectionPoint = new IntersectionPoint();

			if( lineA.isVertical && lineB.isVertical || lineA.isHorizontal && lineB.isHorizontal || lineA.slope.toNumber() == lineB.slope.toNumber())
			{
				return null;
			}

			if( lineA.isVertical )
			{
				point.x = lineA.pointB.x;
				point.y = lineB.isHorizontal ? lineB.pointB.y : (( lineB.slope.toNumber() * point.x ) + lineB.yIntercept );
			}
			else if( lineB.isVertical )
			{
				point.x = lineB.pointA.x;
				point.y = lineA.isHorizontal ? lineA.pointA.y : (( lineA.slope.toNumber() * point.x ) + lineA.yIntercept );
			}
			else
			{
				point.x = ( lineA.yIntercept - lineB.yIntercept ) / ( lineB.slope.toNumber() - lineA.slope.toNumber());
				point.y = point.x * lineA.slope.toNumber() + lineA.yIntercept;
			}

			if( point.x == Infinity || point.x == -Infinity || point.y == Infinity || point.y == -Infinity )
			{
				throw new Error( "Infinity Solution" );
			}

			//Figure out if point are in actual segments.
			point.inSegment = ( pointInsideLineSegment( lineA, point ) && pointInsideLineSegment( lineB, point ));

			if( !point.inSegment && inSegmentOnly )
			{
				return null;
			}
			else
			{
				var intersectionPoints:Vector.<IntersectionPoint> = new Vector.<IntersectionPoint>();
				intersectionPoints.push( point );
				return intersectionPoints;
			}
		}


		/**
		 * Find all intersections points between a Line and Bezier Curves.
		 *
		 * @param line Straight Line
		 * @param curve Bezier Curve
		 *
		 * @return A Vector containing all intersection points. NULL if none.
		 */
		public static function getStraightLineToBezierCurveIntersectionPoints( line:StraightLine, curve:IBezierCurve ):Vector.<IntersectionPoint>
		{
			//Rez is how many pieces we will cut the curve into
			var rez:uint = 5;
			var intersectionPoints:Vector.<IntersectionPoint> = new Vector.<IntersectionPoint>();
			var currentPoint:Point = curve.pointA;

			//Loop through all the curve's pieces/segments.
			for( var i:uint = 1; i <= rez; i++ )
			{
				var t:Number = i * ( 100 / rez / 100 ); // 0 < t < 1
				var nextPoint:Point = curve.getPoint( t );
				var curveSlice:StraightLine = new StraightLine( currentPoint, nextPoint );
				var lineIntersectionPoints:Vector.<IntersectionPoint> = getStraightLinesIntersectionPoints( line, curveSlice, true );

				if( lineIntersectionPoints )
				{
					/*
					   I set both because I'm not sure which is truly the lineA or lineB because of
					   the way getIntersectionPoints() calls this function ambiguously
					 */
					lineIntersectionPoints[ 0 ].lineAIntersectionTime = lineIntersectionPoints[ 0 ].lineBIntersectionTime = i / rez;
					intersectionPoints.push( lineIntersectionPoints[ 0 ]);
				}

				currentPoint = nextPoint;
			}

			return intersectionPoints.length ? intersectionPoints : null;
		}


		/**
		 * Find all intersections points between to Bezier Curves.
		 *
		 * @param curveA First Bezier Curve
		 * @param curveB Second Bezier Curve
		 *
		 * @return A Vector containing all intersection points. NULL if none.
		 */
		public static function getBezierCurveIntersectionPoints( curveA:IBezierCurve, curveB:IBezierCurve ):Vector.<IntersectionPoint>
		{

			var rez:uint = 5;
			var intersectionPoints:Vector.<IntersectionPoint> = new Vector.<IntersectionPoint>();

			var curveALines:Vector.<StraightLine> = new Vector.<StraightLine>();
			var currentPoint:Point = curveA.pointA;

			//Build lines for Curve A
			for( var i:uint = 1; i <= rez; i++ )
			{
				var t:Number = i * ( 100 / rez / 100 );
				var nextPointA:Point = curveA.getPoint( t );
				curveALines.push( new StraightLine( currentPoint, nextPointA ));
				currentPoint = nextPointA;
			}

			curveALines.push( new StraightLine( currentPoint, curveA.pointB ));
			currentPoint = curveB.pointA;

			//Test Curve B's Lines to Curve A's
			for( i = 1; i <= rez; i++ )
			{
				var bT:Number = i * ( 100 / rez / 100 );
				var nextPointB:Point = curveB.getPoint( bT );
				var curveSlice:StraightLine = new StraightLine( currentPoint, nextPointB );

				for( var ii:uint = 0; ii < rez; ii++ )
				{
					var lineIntersectionPoints:Vector.<IntersectionPoint> = getStraightLinesIntersectionPoints( curveALines[ ii ], curveSlice, true );

					if( lineIntersectionPoints )
					{
						lineIntersectionPoints[ 0 ].lineAIntersectionTime = ii / rez;
						lineIntersectionPoints[ 0 ].lineBIntersectionTime = i / rez;

						intersectionPoints.push( lineIntersectionPoints[ 0 ]);
					}
				}

				currentPoint = nextPointB;
			}

			return intersectionPoints.length ? intersectionPoints : null;
		}
	}
}