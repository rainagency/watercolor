package watercolor.factories.svg
{
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;
	
	import watercolor.factories.svg.namespaces.ns_xlink;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark BitmapImage Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/struct.html#ImageElement
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/BitmapImage.html
	 */ 
	public class BitmapImageFactory
	{
		public function BitmapImageFactory()
		{
		}
		
		/**
		 * Create Spark BitmapImage from SVG Image
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:BitmapImage = null):BitmapImage
		{
			if (!element)
			{
				element = new BitmapImage();
			}
			
			// Decorate through parents
			GraphicElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// fillmode - The default value is BitmapFillMode.SCALE.
			
			// TODO: svg preserveAspectRatio - Look into supporting all the various 
			// 		 values such as meet, slice, xMin, xMid, etc.
			// 		 @see http://www.w3.org/TR/SVG/coords.html#PreserveAspectRatioAttribute
			
			// smooth - The default value is false.
			
			// source
			var qnEntity:QName = new QName(ns_xlink, "href"); 
			var xlinkEntity:XMLList = node.attribute(qnEntity);
			
			// TODO: Figure out why old svg library had both xLinkEntity and @ns_xlink::href
			if(xlinkEntity.length() > 0)
			{
				element.source = xlinkEntity;
			}
			
			if(node.@ns_xlink::href.length() > 0)
			{
				element.source = node.@ns_xlink::href;
			}
			
			return element;
		}
		
		public static function createSVGFromSpark(element:BitmapImage):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}