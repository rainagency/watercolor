package watercolor.factories.svg.enums
{
	/**
	 * All supported SVG element types with their svg type string.  The enumeration values
	 * MUST match what is dictated by the SVG specs.
	 */
	public class ElementType
	{
		public static const SVG:String = 'svg';
		public static const GROUP:String = 'g';
		public static const SWITCH:String = 'switch';
		public static const IMAGE:String = 'image';
		public static const TEXT:String = 'text';
		public static const RECT:String = 'rect';
		public static const CIRCLE:String = 'circle';
		public static const ELLIPSE:String = 'ellipse';
		public static const PATH:String = 'path';
		public static const LINE:String = 'line';
		public static const POLYLINE:String = 'polyline';
		public static const POLYGON:String = 'polygon';
		public static const LINEAR_GRADIENT:String = 'linearGradient';
		public static const RADIAL_GRADIENT:String = 'radialGradient';
		public static const PATTERN:String = 'pattern';
		public static const FOREIGN_OBJECT:String = 'foreignObject';
		public static const MASK:String = 'mask';
		public static const CLIP_PATH:String = 'clipPath';
		public static const DEFS:String = 'defs';
		public static const FILTER:String = 'filter';
		public static const IMAGE_WELL:String = 'imageWellContainer';
		public static const DESC:String = 'desc';
		
		// -------------------------------------------------------------
		// Fonts
		public static const FONT:String = 'font';
		public static const FONT_FACE:String = 'font-face';
		public static const GLYPH:String = 'glyph';
		public static const MISSING_GLYPH:String = 'missing-glyph';
		
		/**
		 * Only used in SVGTreatment.
		 * @see svg.utils.SVGTreatment#treatOutgoingForMaskedFilters()
		 * @see svg.utils.SVGTreatment#treatIncomingForMaskedFilters()
		 */
		public static const FAUX_GROUP:String = 'fauxGroup';
	}
}