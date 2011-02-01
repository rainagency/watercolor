package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import watercolor.math.EuclideanLine;
	import watercolor.math.StraightLine;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Horizontal Line Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataHorizontialLineCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * X to draw Horizontal Line to
		 */
		public var xTo:Number;


		/**
		 * Returns A Math Euclidean Line Object Representing this Line.
		 *
		 * @return EuclideanLine represeting this line
		 */
		public function get euclideanLine():EuclideanLine
		{
			var line:StraightLine = new StraightLine();
			line.pointA = getLastPosition();
			line.pointB = new Point( xTo, line.pointA.y );

			return line;
		}


		/**
		 * Returns A Math Euclidean Line Object Representing this Line.
		 *
		 * @return EuclideanLine represeting this line
		 */
		public function set euclideanLine(value:EuclideanLine):void
		{
			xTo = value.pointB.x;
		}


		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 * @param xTo X this horizontal line goes to.
		 */
		public function PathDataHorizontialLineCommand( contour:PathDataContour, xTo:Number = 0 ):void
		{
			super( contour );
			this.xTo = xTo;
		}


		/**
		 * Offsets all points in curve to keep visually the same structure,
		 * just in a new position
		 *
		 * @param Point represeting the offset to apply
		 */
		public function offset( offsetPoint:Point ):void
		{
			xTo += offsetPoint.x;
		}


		/**
		 * Returns this command ending position.
		 *
		 * @return Point represeting this commands end point
		 */
		override public function getEndingPoint():Point
		{
			return new Point( xTo, getLastPosition().y );
		}


		/**
		 * Returns the bounding Rectangle.
		 *
		 * @return Rectangle rectangle that contains all the elements visual components.
		 */
		override public function getBoundingRectangle():Rectangle
		{
			var startingPoint:Point = getLastPosition();
			var endingPoint:Point = getEndingPoint();

			var left:Number = Math.min( startingPoint.x, endingPoint.x );
			var right:Number = Math.max( startingPoint.x, endingPoint.x );

			return new Rectangle( left, startingPoint.y, right - left, 0 );
		}


		/**
		 * FXG Data Serializer
		 *
		 * @return Serialized FXG data representing this command.
		 */
		public function toString():String
		{
			return " H" + xTo.toPrecision( 5 );
		}
	}
}