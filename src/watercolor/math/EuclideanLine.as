package watercolor.math
{
	import flash.geom.Point;


	/**
	 * A "line" in Euclid can be either straight or curved
	 *
	 * @author Sean Thayne
	 */
	public class EuclideanLine
	{
		/**
		 * This can either be the starting point of a line
		 * or can just be another point on a endless line.
		 */
		private var _pointA:Point;


		/**
		 * This can either be the ending point of a line
		 * or can just be another point on a endless line.
		 */
		private var _pointB:Point;


		public function EuclideanLine(pointA:Point=null, pointB:Point=null) {
			this.pointA = pointA;
			this.pointB = pointB;
		}
		
		public function get pointA():Point
		{
			return _pointA;
		}


		public function set pointA( p:Point ):void
		{
			_pointA = p;
		}


		public function get pointB():Point
		{
			return _pointB;
		}


		public function set pointB( p:Point ):void
		{
			_pointB = p;
		}
	}
}