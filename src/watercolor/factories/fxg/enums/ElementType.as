package watercolor.factories.fxg.enums
{
	/**
	 * All supported FXG element types with their fxg type string.  The enumeration values
	 * MUST match what is dictated by the FXG specs.
	 */
	public class ElementType
	{
		public static const GRAPHIC:String = 'Graphic';
		public static const GROUP:String = 'Group';
		public static const BITMAPIMAGE:String = 'BitmapImage';
		public static const RECT:String = 'Rect';
		public static const ELLIPSE:String = 'Ellipse';
		public static const PATH:String = 'Path';
		public static const LINE:String = 'Line';
		public static const TEXTGRAPHIC:String = 'TextGraphic';
		public static const MASK:String = 'mask';
		public static const FILL:String = 'fill';
		public static const FILTERS:String = 'filters';
		public static const STROKE:String = 'stroke';
		public static const GRADIENT_ENTRY:String = 'GradientEntry';
		public static const SOLID_COLOR:String = 'SolidColor';
		public static const SOLID_COLOR_STROKE:String = 'SolidColorStroke';
		public static const LINEAR_GRADIENT:String = 'LinearGradient';
		public static const RADIAL_GRADIENT:String = 'RadialGradient';
		public static const LINEAR_GRADIENT_STROKE:String = 'LinearGradientStroke';
		public static const RADIAL_GRADIENT_STROKE:String = 'RadialGradientStroke';
	}
}