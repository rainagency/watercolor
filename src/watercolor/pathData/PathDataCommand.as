package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.containers.ControlBar;

	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Base class of all PathDataCommands
	 *
	 * Shouldn't be used by it's self.
	 *
	 * @abstract
	 * @author Sean Thayne
	 */
	public class PathDataCommand
	{
		/**
		 * Parent PathDataContour this command belongs to.
		 */
		protected var contour:PathDataContour;


		/**
		 * Construct
		 *
		 * @param contour Parent contour to add command to.
		 */
		public function PathDataCommand( contour:PathDataContour ):void
		{
			this.contour = contour.addCommand( this );
		}


		/**
		 * Expand Function
		 *
		 * Adds new close command to newContour of expanded PathData.
		 *
		 * @param pixels Amount of pixels to expand command by.
		 * @param newContour Contour to add expanded command to.
		 */
		public function expand( pixels:Number, newContour:PathDataContour ):void
		{
			throw new Error( "This command doesn't have the expand functionality yet." );
		}


		/**
		 * Returns the ending position of the last command.
		 *
		 * Finds the current position of the calling command. Then Finds the
		 * command before and finds it's ending position.
		 *
		 * @return The ending position of the last command.
		 */
		public function getLastPosition():Point
		{
			var lastCommand:PathDataCommand = getCommandBefore();
			return lastCommand ? lastCommand.getEndingPoint() : contour.startPoint;
		}


		/**
		 * Returns this command ending position.
		 *
		 * @return Point represeting this commands end point
		 */
		public function getEndingPoint():Point
		{
			return getLastPosition();
		}


		/**
		 * Returns the bounding Rectangle.
		 *
		 * @return Rectangle rectangle that contains all the elements visual components.
		 */
		public function getBoundingRectangle():Rectangle
		{
			var lastPosition:Point = getLastPosition();
			return new Rectangle( lastPosition.x, lastPosition.y, 0, 0 )
		}


		/**
		 * Gets the command before this one.
		 *
		 * Finds the current position of the calling command. Then returns the
		 * previous command in the contour.
		 *
		 * @return The previous command.
		 */
		public function getCommandBefore():PathDataCommand
		{
			return contour.getCommandAt( contour.getCommandIndex( this ) - 1 );
		}


		/**
		 * Gets the command after this one.
		 *
		 * Finds the current position of the calling command. Then returns the
		 * next command in the contour.
		 *
		 * @return The next command.
		 */
		public function getCommandAfter():PathDataCommand
		{
			return contour.getCommandAt( contour.getCommandIndex( this ) + 1 );
		}


		/**
		 * Returns current command's index.
		 *
		 * @return Command's Index
		 */
		public function get index():int
		{
			return contour.getCommandIndex( this );
		}


		/**
		 * Set's current command's index.
		 *
		 * Usefull for offset a command if your planning on adding a new command
		 * in before this one.
		 */
		public function set index( newIndex:int ):void
		{
			contour.addCommandAt( this, newIndex );
		}


		/**
		 * Clone this command and add to new parent contour.
		 *
		 * @param parentPathDataContour New Path Data contour to copy command to.
		 *
		 * @return new clone of this command.
		 */
		public function clone( parentPathDataContour:PathDataContour = null ):IPathDataVisualCommand
		{
			return null;
		}
	}
}