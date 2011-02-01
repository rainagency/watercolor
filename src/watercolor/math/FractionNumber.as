package watercolor.math
{


	/**
	 * Fraction Number Container.
	 *
	 * @author Sean Thayne
	 */
	public class FractionNumber
	{
		public var numerator:Number;


		public var denominator:Number;


		public function FractionNumber( numerator:Number, denominator:Number )
		{
			this.numerator = numerator;
			this.denominator = denominator;
		}


		public function toNumber():Number
		{
			return ( numerator / denominator );
		}
	}
}