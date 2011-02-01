package watercolor.pathData
{
	import watercolor.pathData.interfaces.IPathDataStructuralCommand;


	/**
	 * FXG Path Data Close Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataClosePathCommand extends PathDataCommand implements IPathDataStructuralCommand
	{

		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 */
		public function PathDataClosePathCommand( contour:PathDataContour ):void
		{
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
		override public function expand( pixels:Number, newContour:PathDataContour ):void
		{
			new PathDataClosePathCommand( newContour );
		}


		/**
		 * FXG Data Serializer
		 *
		 * @return Serialized FXG data representing this command.
		 */
		public function toString():String
		{
			return 'Z';
		}
	}
}