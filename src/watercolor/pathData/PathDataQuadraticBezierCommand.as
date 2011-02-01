package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.preloaders.Preloader;

	import watercolor.math.EuclideanLine;
	import watercolor.math.QuadraticBezierCurve;
	import watercolor.math.StraightLine;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Quadratic Bezier Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataQuadraticBezierCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * Control Point for Curve
		 */
		public var controlPoint:Point;


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
			var curve:QuadraticBezierCurve = new QuadraticBezierCurve();
			curve.pointA = getLastPosition();
			curve.controlPoint = controlPoint;
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
			if( value is QuadraticBezierCurve )
			{
				controlPoint = QuadraticBezierCurve( value ).controlPoint;
				cordinate = QuadraticBezierCurve( value ).pointB;
			}
		}


		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 */
		public function PathDataQuadraticBezierCommand( contour:PathDataContour, controlPoint:Point = null, cordinate:Point = null )
		{
			this.controlPoint = controlPoint;
			this.cordinate = cordinate;
			super( contour );
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
			return;

			//New command container for expanded curve
			var newCurveCommand:PathDataQuadraticBezierCommand = new PathDataQuadraticBezierCommand( newPathContour );

			//Create a Parrallel Line w/Growth distance
			var oldControlPointLine:StraightLine = new StraightLine( getLastPosition(), cordinate );
			var newControlPointLine:StraightLine = oldControlPointLine.createParrallelLine( pixels );
			var difference:Point = newControlPointLine.pointA.subtract( oldControlPointLine.pointA );
			newCurveCommand.controlPoint = new Point( controlPoint.x + difference.x, controlPoint.y + difference.y );

			newCurveCommand.cordinate = newControlPointLine.pointB;
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

			var left:Number = Math.min( startingPoint.x, controlPoint.x, cordinate.x );
			var right:Number = Math.max( startingPoint.x, controlPoint.x, cordinate.x );
			var top:Number = Math.min( startingPoint.y, controlPoint.y, cordinate.y );
			var bottom:Number = Math.max( startingPoint.y, controlPoint.y, cordinate.y );

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
			controlPoint = controlPoint.add( offsetPoint );
			cordinate = cordinate.add( offsetPoint );
		}


		/**
		 * FXG Data Serializer
		 *
		 * @return Serialized FXG data representing this command.
		 */
		public function toString():String
		{
			var str:String = getCommandBefore() is PathDataQuadraticBezierCommand ? ' ' : 'Q';

			str += controlPoint.x.toPrecision( 5 ) + " " + controlPoint.y.toPrecision( 5 ) + " ";
			str += cordinate.x.toPrecision( 5 ) + " " + cordinate.y.toPrecision( 5 )

			return str;
		}
	}
}