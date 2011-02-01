package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	
	import watercolor.math.EuclideanLine;
	import watercolor.math.IntersectionPoint;
	import watercolor.math.StraightLine;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;
	import watercolor.utils.IntersectionUtil;
	import watercolor.utils.PathDataUtil;


	/**
	 * Line Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataLineCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * Point to draw line to
		 */
		public var cordinate:Point;


		/**
		 * Create a line between the current pointer point and this commands ending cordinate.
		 *
		 * @return LineSegment representing this line.
		 */
		public function get euclideanLine():EuclideanLine
		{
			return new StraightLine( getLastPosition(), cordinate );
		}


		/**
		 * Create a line between the current pointer point and this commands ending cordinate.
		 *
		 * @return LineSegment representing this line.
		 */
		public function set euclideanLine( value:EuclideanLine ):void
		{
			if( value is StraightLine )
			{
				this.cordinate = value.pointB;
			}
		}


		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 * @param cordinate Point this line goes to.
		 */
		public function PathDataLineCommand( contour:PathDataContour, cordinate:Point = null ):void
		{
			this.cordinate = cordinate;
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
			var endingPoint:Point = getEndingPoint();

			var left:Number = Math.min( startingPoint.x, endingPoint.x );
			var right:Number = Math.max( startingPoint.x, endingPoint.x );
			var top:Number = Math.min( startingPoint.y, endingPoint.y );
			var bottom:Number = Math.max( startingPoint.y, endingPoint.y );

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
			//New command container for expanded line
			var newLineCommand:PathDataLineCommand = new PathDataLineCommand( newPathContour );


			//trace("Old:" + euclideanLine);
			//Create the Parrallel Line w/Growth distance
			var newLine:StraightLine = StraightLine( euclideanLine ).createParrallelLine( pixels );


			//Set the cordinate of the expanded line container.
			newLineCommand.cordinate = newLine.pointB;

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
		 * Clone this command and add to new parent contour.
		 *
		 * @param parentPathDataContour New Path Data contour to copy command to.
		 *
		 * @return new clone of this command.
		 */
		override public function clone( parentPathDataContour:PathDataContour = null ):IPathDataVisualCommand
		{
			var parent:PathDataContour = parentPathDataContour ? parentPathDataContour : parent;
			return new PathDataLineCommand( parent, cordinate.clone());
		}


		/**
		 * FXG Data Serializer
		 *
		 * @return FXG Data Serialization
		 */
		public function toString():String
		{
			var str:String = getCommandBefore() is PathDataLineCommand ? ' ' : 'L';
			
			str += cordinate.x.toPrecision( 5 ) + " " + cordinate.y.toPrecision( 5 );

			return str;
		}
	}
}