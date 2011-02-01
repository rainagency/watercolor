package watercolor.utils
{
	import flash.geom.Matrix;


	public class MatrixUtil
	{
		/**
		 * Compares to matrixes
		 *
		 * @param a First Matrix to compare
		 * @param b Second Matrix to compare
		 *
		 * @return Boolean True if equal
		 */
		public static function compare( a:Matrix, b:Matrix ):Boolean
		{
			return ( a.a == b.a && a.b == b.b && a.c == b.c && a.d == b.d && a.tx == b.tx && a.ty == b.ty )
		}
	}
}