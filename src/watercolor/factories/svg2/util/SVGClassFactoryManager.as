package watercolor.factories.svg2.util
{
	import watercolor.factories.svg2.BitmapImageFactory;
	import watercolor.factories.svg2.ChildFactory;
	import watercolor.factories.svg2.EllipseFactory;
	import watercolor.factories.svg2.FiltersFactory;
	import watercolor.factories.svg2.GraphicsFactory;
	import watercolor.factories.svg2.GroupFactory;
	import watercolor.factories.svg2.LayerFactory;
	import watercolor.factories.svg2.LineFactory;
	import watercolor.factories.svg2.MaskFactory;
	import watercolor.factories.svg2.PathFactory;
	import watercolor.factories.svg2.RectFactory;
	import watercolor.factories.svg2.TSpanFactory;
	import watercolor.factories.svg2.TextAreaFactory;
	import watercolor.factories.svg2.filters.BlurFilterFactory;
	import watercolor.factories.svg2.filters.GlowFilterFactory;
	import watercolor.factories.svg2.graphics.GradientEntryFactory;
	import watercolor.factories.svg2.graphics.LinearGradientFactory;
	import watercolor.factories.svg2.graphics.LinearGradientStrokeFactory;
	import watercolor.factories.svg2.graphics.RadialGradientFactory;
	import watercolor.factories.svg2.graphics.RadialGradientStrokeFactory;
	import watercolor.factories.svg2.graphics.SolidColorFactory;
	import watercolor.factories.svg2.graphics.SolidColorStrokeFactory;
	import watercolor.factories.svg2.text.ParagraphElementFactory;
	import watercolor.factories.svg2.text.SpanElementFactory;

	public class SVGClassFactoryManager
	{
		/**
		 * BaseMap of Class Factories
		 * These are constant for all projects.  You can use the customMap to define your own project
		 * specific factories.  Leave this private.
		 * 
		 * Key -> fxg node name
		 * Value -> Spark Element Factory Class
		 */ 
		private static var _baseMap:Object = { svg:GraphicsFactory,
												defs:ChildFactory,
												text:TextAreaFactory,
												layer:LayerFactory,
												tspan:TSpanFactory,
												group:GroupFactory,
												g:GroupFactory,
												bitmapimage:BitmapImageFactory,
												image:BitmapImageFactory,
												rect:RectFactory,
												ellipse:EllipseFactory,
												circle:EllipseFactory,
												path:PathFactory,
												line:LineFactory,
												gradiententry:GradientEntryFactory,
												lineargradient:LinearGradientFactory,
												radialgradient:RadialGradientFactory,
												solidcolor:SolidColorFactory,
												solidcolorstroke:SolidColorStrokeFactory,
												lineargradientstroke:LinearGradientStrokeFactory,
												radialgradientstroke:RadialGradientStrokeFactory,
												fill:ChildFactory,
												stroke:ChildFactory,
												mask:MaskFactory,
												blurfilter:BlurFilterFactory,
												glowfilter:GlowFilterFactory,
												filters:FiltersFactory,
												paragraphelement:ParagraphElementFactory,
												spanelement:SpanElementFactory
									  		 };
			
		/**
		 * CustomMap of Class Factories
		 * You can use the customMap to define your own project specific factories.  ElementFactory
		 * first checks the customMap for the appropriate factory before it checks the baseMap
		 * 
		 * Key -> fxg node name or rain type
		 * Value -> Spark Element Factory Class
		 */
		private static var _customMap:Object = {};
		
		public static function get customMap():Object
		{
			return _customMap;
		}

		/**
		 * @private
		 */
		public static function set customMap(value:Object):void
		{
			_customMap = value;
		}


		/**
		 * Gets the class factory for an element type.  First checks the customMap, then the baseMap
		 * @param elementType The element type.
		 * @return The factory class associated with the element type.
		 */
		public static function getClassFactory(elementType:String):Class
		{
			var classFactory:Class = _customMap[elementType];
			
			if (!classFactory)
			{
				classFactory = _baseMap[elementType];
			}
			
			if (!classFactory)
			{
				trace("No class factory found for svg elementType:", elementType);				
			}
			
			return classFactory;
		}
	}
}