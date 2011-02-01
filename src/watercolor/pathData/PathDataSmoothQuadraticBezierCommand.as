package watercolor.pathData
{
	import flash.geom.Point;
	
	import watercolor.math.EuclideanLine;
	import watercolor.math.QuadraticBezierCurve;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Smooth Quadratic Bezier Path Data Command
	 *
	 * @author Sean Thayne
	 */
	public class PathDataSmoothQuadraticBezierCommand extends PathDataCommand implements IPathDataVisualCommand
	{
		/**
		 * Point to draw curve to.
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
			curve.controlPoint = cordinate;
			curve.pointB = cordinate;
			
			return curve;
		}
		
		
		/**
		 * Returns A Math Euclidean Line Object Representing this Curve.
		 *
		 * @return EuclideanLine represeting this curve
		 */
		public function set euclideanLine(value:EuclideanLine):void{
			if(value is QuadraticBezierCurve) {
				cordinate = QuadraticBezierCurve(value).pointB;
			}
		}
	

		/**
		 * Constructor
		 *
		 * @param contour This command's Parent PathDataContour.
		 */
		public function PathDataSmoothQuadraticBezierCommand( contour:PathDataContour, cordinate:Point = null ):void
		{
			super( contour );
			this.cordinate = cordinate;
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
		 * FXG Data Serializer
		 *
		 * @return Serialized FXG data representing this command.
		 */
		public function toString():String
		{
			var str:String = ' T';
			str += cordinate.x.toPrecision( 5 ) + " " + cordinate.y.toPrecision( 5 )

			return str;
		}
	}
}