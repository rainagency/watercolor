package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import watercolor.math.CubicBezierCurve;
	import watercolor.math.EuclideanLine;
	import watercolor.math.StraightLine;
	import watercolor.math.interfaces.IBezierCurve;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;
	import watercolor.utils.IntersectionUtil;
	import watercolor.utils.PathDataUtil;


	/**
	 * Cubic Bezier Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataCubicBezierCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * First Control Point of Curve
		 */
		public var controlPointA:Point;


		/**
		 * Second Control Point of Curve
		 */
		public var controlPointB:Point;


		/**
		 * Point to draw curve to
		 */
		public var cordinate:Point;


		/**
		 * Returns A Math Euclidean Line Object Representing this Curve.
		 *
		 * @return EuclideanLine represeting this curve
		 */
		public function get euclideanLine():EuclideanLine
		{
			var curve:CubicBezierCurve = new CubicBezierCurve();
			curve.pointA = getLastPosition();
			curve.controlPointA = controlPointA;
			curve.controlPointB = controlPointB;
			curve.pointB = cordinate;

			return curve;
		}


		/**
		 * Returns A Math Euclidean Line Object Representing this Curve.
		 *
		 * @return EuclideanLine represeting this curve
		 */
		public function set euclideanLine( value:EuclideanLine ):void
		{
			if( value is CubicBezierCurve )
			{
				controlPointA = CubicBezierCurve( value ).controlPointA;
				controlPointB = CubicBezierCurve( value ).controlPointB;
				cordinate = CubicBezierCurve( value ).pointB;
			}
		}



		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 */
		//TODO: Add constructor params for the 3 points.
		public function PathDataCubicBezierCommand( contour:PathDataContour ):void
		{
			super( contour );
		}


		/**
		 * Returns this command ending position.
		 *
		 * @return Point represeting this commands end point
		 */
		override public function getEndingPoint():Point
		{
			return cordinate;
		}


		/**
		 * Returns the bounding Rectangle.
		 *
		 * @return Rectangle rectangle that contains all the elements visual components.
		 */
		override public function getBoundingRectangle():Rectangle
		{
			var startingPoint:Point = getLastPosition();

			var left:Number = Math.min( startingPoint.x, controlPointA.x, controlPointB.x, cordinate.x );
			var right:Number = Math.max( startingPoint.x, controlPointA.x, controlPointB.x, cordinate.x );
			var top:Number = Math.min( startingPoint.y, controlPointA.y, controlPointB.y, cordinate.y );
			var bottom:Number = Math.max( startingPoint.y, controlPointA.y, controlPointB.y, cordinate.y );

			return new Rectangle( left, top, right - left, bottom - top );
		}


		/**
		 * Offsets all points in curve to keep visually the same structure,
		 * just in a new position
		 *
		 * @param Point represeting the offset to apply
		 */
		public function offset( offsetPoint:Point ):void
		{
			controlPointA = controlPointA.add( offsetPoint );
			controlPointB = controlPointB.add( offsetPoint );
			cordinate = cordinate.add( offsetPoint );
		}


		/**
		 * Expand Function
		 *
		 * Adds new close command to newContour of expanded PathData.
		 *
		 * @param pixels Amount of pixels to expand command by.
		 * @param newContour Contour to add expanded command to.
		 */
		override public function expand( pixels:Number, newPathContour:PathDataContour ):void
		{
			//New command container for expanded curve
			var newCommand:PathDataCubicBezierCommand = new PathDataCubicBezierCommand( newPathContour );

			//Create the Parrallel Lines w/Growth distance
			var lastPosition:Point = getLastPosition();
			var cordinateLine:StraightLine;
			var controlLine:StraightLine

			/*
			   Sometimes the first control point will be zero, in this case we
			   are force to treat this like a quad, and don't account for the first control point.
			 */
			if( controlPointA.equals( lastPosition ))
			{
				controlLine = new StraightLine( lastPosition, controlPointB ).createParrallelLine( pixels );
				cordinateLine = new StraightLine( controlPointB, cordinate ).createParrallelLine( pixels );

				//Set the cordinate of the expanded line container.
				newCommand.controlPointA = newCommand.getLastPosition();
				newCommand.controlPointB = IntersectionUtil.getStraightLinesIntersectionPoints( controlLine, cordinateLine )[ 0 ];
				newCommand.cordinate = cordinateLine.pointB;
			}
			else
			{
				controlLine = new StraightLine( lastPosition, controlPointA ).createParrallelLine( pixels );
				var controlLineB:StraightLine = new StraightLine( controlPointA, controlPointB ).createParrallelLine( pixels );
				cordinateLine = new StraightLine( controlPointB, cordinate ).createParrallelLine( pixels );

				//Set the cordinate of the expanded line container.
				newCommand.controlPointA = IntersectionUtil.getStraightLinesIntersectionPoints( controlLine, controlLineB )[ 0 ];
				newCommand.controlPointB = IntersectionUtil.getStraightLinesIntersectionPoints( controlLineB, cordinateLine )[ 0 ];
				newCommand.cordinate = cordinateLine.pointB;
			}




			//Connecting the dots logic
			var lastCommand:PathDataCommand = newCommand.getCommandBefore();

			/*
			   If the last action was a move command we change it's cordinate to the
			   Starting point of our newly parrallel line
			 */
			if( !lastCommand )
				newPathContour.startPoint = controlLine.pointA;
			else
			{
				var lastLine:EuclideanLine = IPathDataVisualCommand( lastCommand ).euclideanLine;
				var connectingCommand:PathDataCommand = PathDataUtil.connectCommandTo( lastLine, controlLine, newPathContour );

				if( connectingCommand )
				{
					//Curve
					connectingCommand.index = newCommand.index;
				}
				else
				{
					//	//Clip
					IPathDataVisualCommand( newCommand ).euclideanLine = controlLine;
					IPathDataVisualCommand( lastCommand ).euclideanLine = lastLine;
				}
			}
		}


		/**
		 * FXG Data Serializer
		 *
		 * @return Serialized FXG data representing this command.
		 */
		public function toString():String
		{
			var str:String = getCommandBefore() is PathDataCubicBezierCommand ? ' ' : 'C';

			str += controlPointA.x.toPrecision( 5 ) + " " + controlPointA.y.toPrecision( 5 ) + " ";
			str += controlPointB.x.toPrecision( 5 ) + " " + controlPointB.y.toPrecision( 5 ) + " ";
			str += cordinate.x.toPrecision( 5 ) + " " + cordinate.y.toPrecision( 5 )

			return str;
		}
	}
}