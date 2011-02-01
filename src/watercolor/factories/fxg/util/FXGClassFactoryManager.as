package watercolor.factories.fxg.util
{
	import watercolor.factories.fxg.BitmapImageFactory;
	import watercolor.factories.fxg.ChildFactory;
	import watercolor.factories.fxg.EllipseFactory;
	import watercolor.factories.fxg.FiltersFactory;
	import watercolor.factories.fxg.GroupFactory;
	import watercolor.factories.fxg.LineFactory;
	import watercolor.factories.fxg.MaskFactory;
	import watercolor.factories.fxg.PathFactory;
	import watercolor.factories.fxg.RectFactory;
	import watercolor.factories.fxg.filters.BlurFilterFactory;
	import watercolor.factories.fxg.filters.GlowFilterFactory;
	import watercolor.factories.fxg.graphics.GradientEntryFactory;
	import watercolor.factories.fxg.graphics.LinearGradientFactory;
	import watercolor.factories.fxg.graphics.LinearGradientStrokeFactory;
	import watercolor.factories.fxg.graphics.RadialGradientFactory;
	import watercolor.factories.fxg.graphics.RadialGradientStrokeFactory;
	import watercolor.factories.fxg.graphics.SolidColorFactory;
	import watercolor.factories.fxg.graphics.SolidColorStrokeFactory;

	public class FXGClassFactoryManager
	{
		/**
		 * BaseMap of Class Factories
		 * These are constant for all projects.  You can use the customMap to define your own project
		 * specific factories.  Leave this private.
		 * 
		 * Key -> fxg node name
		 * Value -> Spark Element Factory Class
		 */ 
		private static var _baseMap:Object = { group:GroupFactory,
												bitmapimage:BitmapImageFactory,
												rect:RectFactory,						
												ellipse:EllipseFactory,
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
												filters:FiltersFactory
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
				trace("No class factory found for fxg elementType:", elementType);				
			}
			
			return classFactory;
		}
	}
}