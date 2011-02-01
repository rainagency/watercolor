package watercolor.pathData
{
	import flash.geom.Point;
	
	import watercolor.math.CubicBezierCurve;
	import watercolor.math.EuclideanLine;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Smooth Cubic Bezier Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataSmoothCubicBezierCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * Control point of curve
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
			var curve:CubicBezierCurve = new CubicBezierCurve();
			curve.pointA = getLastPosition();
			curve.controlPointA = controlPoint;
			curve.controlPointB = controlPoint;
			curve.pointB = cordinate;

			return curve;
		}


		/**
		 * Returns A Math Euclidean Line Object Representing this Curve.
		 *
		 * @return EuclideanLine represeting this curve
		 */
		public function set euclideanLine(value:EuclideanLine):void 
		{
			if(value is CubicBezierCurve) {
				cordinate = CubicBezierCurve(value).pointB;
			}
		}


		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 */
		public function PathDataSmoothCubicBezierCommand( contour:PathDataContour ):void
		{
			super( contour );
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
			return null;
		}
	}
}