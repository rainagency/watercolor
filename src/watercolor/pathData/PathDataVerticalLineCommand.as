package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.states.OverrideBase;

	import watercolor.math.EuclideanLine;
	import watercolor.math.StraightLine;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;
	import watercolor.utils.PathDataUtil;


	/**
	 * Vertical Line Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataVerticalLineCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * Y To draw Veritcal Line To
		 */
		public var yTo:Number;


		/**
		 * Returns A Math Euclidean Line Object Representing this Line.
		 *
		 * @return EuclideanLine represeting this line
		 */
		public function get euclideanLine():EuclideanLine
		{
			var line:StraightLine = new StraightLine();
			line.pointA = getLastPosition();
			line.pointB = new Point( line.pointA.x, yTo );

			return line;
		}


		/**
		 * Returns A Math Euclidean Line Object Representing this Line.
		 *
		 * @return EuclideanLine represeting this line
		 */
		public function set euclideanLine( value:EuclideanLine ):void
		{
			yTo = value.pointB.y;
		}


		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 * @param yTo Y this vertical line goes to.
		 */
		public function PathDataVerticalLineCommand( contour:PathDataContour, yTo:Number = 0 ):void
		{
			super( contour );
			this.yTo = yTo;
		}


		/**
		 * Returns this command ending position.
		 *
		 * @return Point represeting this commands end point
		 */
		override public function getEndingPoint():Point
		{
			return new Point( getLastPosition().x, yTo );
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

			var top:Number = Math.min( startingPoint.y, endingPoint.y );
			var bottom:Number = Math.max( startingPoint.y, endingPoint.y );

			return new Rectangle( startingPoint.x, top, 0, bottom - top );
		}


		/**
		 * Offsets all points in curve to keep visually the same structure,
		 * just in a new position
		 *
		 * @param Point represeting the offset to apply
		 */
		public function offset( offsetPoint:Point ):void
		{
			yTo += offsetPoint.y;
		}


		override public function expand( pixels:Number, newPathContour:PathDataContour ):void
		{
			//New command container for expanded line
			var newLineCommand:PathDataVerticalLineCommand = new PathDataVerticalLineCommand( newPathContour );


			//trace("Old:" + euclideanLine);
			//Create the Parrallel Line w/Growth distance
			var newLine:StraightLine = StraightLine( euclideanLine ).createParrallelLine( pixels );


			//Set the cordinate of the expanded line container.
			newLineCommand.yTo = newLine.pointB.y;

			//Connecting the dots logic
			var lastCommand:PathDataCommand = newLineCommand.getCommandBefore();

			/*
			   If the last action was a move command we change it's cordinate to the
			   Starting point of our newly parrallel line
			 */
			if( !lastCommand )
				newPathContour.startPoint = newLine.pointA;
			else
			{
				var lastLine:EuclideanLine = IPathDataVisualCommand( lastCommand ).euclideanLine;
				var connectingCommand:PathDataCommand = PathDataUtil.connectCommandTo( lastLine, newLine, newPathContour );

				if( connectingCommand )
				{
					//Curve
					connectingCommand.index = newLineCommand.index;
				}
				else
				{
					//	//Clip
					IPathDataVisualCommand( newLineCommand ).euclideanLine = newLine;
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
			return ' V' + yTo.toPrecision( 5 );
		}
	}
}