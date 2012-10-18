package watercolor.factories.svg2
{
	import watercolor.elements.BitmapImage;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark BitmapImage Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/BitmapImage.html
	 */ 
	public class BitmapImageFactory
	{
		public function BitmapImageFactory()
		{
		}
		
		/**
		 * Create Spark BitmapImage from FXG Image
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:BitmapImage = null):BitmapImage
		{
			if (!element)
			{
				element = new BitmapImage();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromSVG(node, uriManager, element);	
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		public static function createSVGFromSpark(element:BitmapImage, workarea:Workarea):XML
		{
			var image:XML = new XML("<image/>");
			
			if (element.sourceURL.length > 0) {
				image.@["xlink:href"] = element.sourceURL;
			}
			
			image.@transform = SVGAttributes.parseMatrix(element.transform.matrix);
			
			image.@width = element.width;
			image.@height = element.height;
			
			return image;
		}
	}
}