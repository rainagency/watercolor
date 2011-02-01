package watercolor.factories.svg.util
{
	import flash.utils.Dictionary;
	
	import watercolor.factories.svg.EllipseFactory;
	import watercolor.factories.svg.GraphicFactory;
	import watercolor.factories.svg.GroupFactory;
	import watercolor.factories.svg.LineFactory;
	import watercolor.factories.svg.PathFactory;
	import watercolor.factories.svg.RectFactory;
	import watercolor.factories.svg.enums.ElementType;
	import watercolor.factories.svg.graphics.GradientEntryFactory;
	import watercolor.factories.svg.graphics.LinearGradientFactory;
	import watercolor.factories.svg.graphics.RadialGradientFactory;

	public class SVGClassFactoryManager
	{
		/**
		 * BaseMap of Class Factories
		 * These are constant for all projects.  You can use the customMap to define your own project
		 * specific factories.  Leave this private.
		 * 
		 * Key -> svg node name or rain type
		 * Value -> Spark Element Factory Class
		 */ 
		private static var _baseMap:Object = {svg:GraphicFactory,
												group:GroupFactory,
												rect:RectFactory,
												circle:EllipseFactory,
												ellipse:EllipseFactory,
												path:PathFactory,
												line:LineFactory,
												stop:GradientEntryFactory,
												lineargradient:LinearGradientFactory,
												radialgradient:RadialGradientFactory
									  		 };
		
// 				TODO
//				_classFactories[ElementType.IMAGE] = new ClassFactory(Image);
		//				_classFactories[ElementType.SWITCH] = new ClassFactory(Switch);
//				_classFactories[ElementType.TEXT] = new ClassFactory(Text);
//				_classFactories[ElementType.PATTERN] = new ClassFactory(Pattern);
//				_classFactories[ElementType.FOREIGN_OBJECT] = new ClassFactory(ForeignObject);
//				_classFactories[ElementType.MASK] = new ClassFactory(Mask);
//				_classFactories[ElementType.CLIP_PATH] = new ClassFactory(Mask);
//				_classFactories[ElementType.DEFS] = new ClassFactory(Defs);
//				_classFactories[ElementType.FILTER] = new ClassFactory(Filter);
//				_classFactories[ElementType.IMAGE_WELL] = new ClassFactory(ImageWell);
//				_classFactories[ElementType.DESC] = new ClassFactory(Desc);		
		
// 				Fonts
//				_classFactories[ElementType.FONT] = new ClassFactory(Font);
//				_classFactories[ElementType.FONT_FACE] = new ClassFactory(FontFace);
//				_classFactories[ElementType.GLYPH] = new ClassFactory(Glyph);
//				_classFactories[ElementType.MISSING_GLYPH] = new ClassFactory(MissingGlyph);

// 				Unsupported
//				_classFactories[ElementType.POLYLINE] = new ClassFactory(Polyline);
//				_classFactories[ElementType.POLYGON] = new ClassFactory(Polygon);
		
		/**
		 * CustomMap of Class Factories
		 * You can use the customMap to define your own project specific factories.  ElementFactory
		 * first checks the customMap for the appropriate factory before it checks the baseMap
		 * 
		 * Key -> svg node name or rain type
		 * Value -> Spark Element Factory Class
		 */ 
		public static var _customMap:Object = {};

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