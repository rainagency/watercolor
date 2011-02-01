package watercolor.utils
{
	import flash.utils.Dictionary;

	import watercolor.elements.Element;

	public class SVGUtil
	{

		public var SVGtoWCmap:Dictionary = new Dictionary();

		public function SVGUtil()
		{
			SVGtoWCmap['rect'] = rectFactory;
		}

		public static function convertSVGtoWatercolor(data:XML, map:Dictionary = null):Vector.<Element>
		{
			var result:Vector.<Element>;
			return result;
		}

		public static function rectFactory(data:XML):Element
		{
			var result:Element;
			return result;
		}
	}
}