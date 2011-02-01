package watercolor.pathData.interfaces
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import watercolor.math.EuclideanLine;
	import watercolor.pathData.PathDataContour;


	/**
	 * Interface for Visual Path Data Commands
	 *
	 * @author Sean Thayne
	 */
	public interface IPathDataVisualCommand
	{
		/**
		 * Returns A Math Euclidean Line Object Representing this command.
		 *
		 * @return EuclideanLine represeting this command
		 */
		function get euclideanLine():EuclideanLine;
		
		/**
		 * Sets properties of the command to match that of a Math Euclidean Line.
		 * 
		 * @param value Euclidean Line Object
		 */
		function set euclideanLine(value:EuclideanLine):void;

		/**
		 * Clone this command and add to new parent contour.
		 *
		 * @param parentPathDataContour New Path Data contour to copy command to.
		 *
		 * @return new clone of this command.
		 */
		function clone( parentPathDataContour:PathDataContour = null ):IPathDataVisualCommand;

		/**
		 * Returns this command ending position.
		 *
		 * @return Point represeting this commands end point
		 */
		function getEndingPoint():Point;



		/**
		 * Returns the bounding Rectangle.
		 *
		 * @return Rectangle rectangle that contains all the elements visual components.
		 */
		function getBoundingRectangle():Rectangle;


		/**
		 * Offsets all points in command to keep visually the same structure,
		 * just in a new position
		 *
		 * @param Point represeting the offset to apply
		 */
		function offset( offsetPoint:Point ):void;
	}
}