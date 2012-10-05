package flexUnitTests.factories.svg
{
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.GraphicsPathWinding;
	import flash.display.JointStyle;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.core.IVisualElement;
	import mx.graphics.GradientBase;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.RadialGradient;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	import spark.primitives.Ellipse;
	import spark.primitives.Graphic;
	import spark.primitives.Line;
	import spark.primitives.Path;
	import spark.primitives.Rect;
	import spark.primitives.supportClasses.FilledElement;
	import spark.primitives.supportClasses.GraphicElement;
	import spark.primitives.supportClasses.StrokedElement;
	
	import watercolor.factories.svg.BitmapImageFactory;
	import watercolor.factories.svg.EllipseFactory;
	import watercolor.factories.svg.FilledElementFactory;
	import watercolor.factories.svg.GraphicElementFactory;
	import watercolor.factories.svg.GraphicFactory;
	import watercolor.factories.svg.GroupFactory;
	import watercolor.factories.svg.LineFactory;
	import watercolor.factories.svg.PathFactory;
	import watercolor.factories.svg.RectFactory;
	import watercolor.factories.svg.StrokedElementFactory;
	import watercolor.factories.svg.graphics.GradientBaseFactory;
	import watercolor.factories.svg.graphics.GradientEntryFactory;
	import watercolor.factories.svg.graphics.LinearGradientFactory;
	import watercolor.factories.svg.graphics.RadialGradientFactory;
	import watercolor.factories.svg.util.URIManager;

	public class SVGToSparkFactoryTests
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		/**
		 * Currently tests id, height, width, opacity, display, display(inline)
		 */ 
		[Test]
		public function createGraphicElement():void
		{
			var svg:XML = <rect id="myRect" 
								x="7"
								y="17"
								height="100" 
								width="200" 
								opacity=".5"
								display="inline"></rect>;
			
			var uriManager:URIManager = new URIManager(svg);
			var element:GraphicElement = new GraphicElement();
			GraphicElementFactory.createSparkFromSVG(svg, uriManager, element);
			assertEquals("Error asserting id", "myRect", element.id);
			assertEquals("Error asserting x", 7, element.x);
			assertEquals("Error asserting y", 17, element.y);
			assertEquals("Error asserting height", 100, element.height);
			assertEquals("Error asserting width", 200, element.width);
			assertEquals("Error asserting opacity", .5, element.alpha);
			// Display "inline" should result in visible = true
			assertTrue("Error asserting display visible", element.visible);
		}
		
		/**
		 * Currently tests id, height, width, opacity, display, display(inline), transform
		 */ 
		[Test]
		public function createGraphicElementWithTransform():void
		{
			var svg:XML = <rect transform="matrix(20, 2, 45, 5, 10, 15)"></rect>;
			var uriManager:URIManager = new URIManager(svg);
			var element:GraphicElement = new GraphicElement();
			GraphicElementFactory.createSparkFromSVG(svg, uriManager, element);
			
			// Transform Assertion
			var transform:Matrix = new Matrix(20, 2, 45, 5, 10, 15);
			assertEquals("Error asserting transform a", transform.a, element.transform.matrix.a);
			assertEquals("Error asserting transform b", transform.b, element.transform.matrix.b);
			assertEquals("Error asserting transform c", transform.c, element.transform.matrix.c);
			assertEquals("Error asserting transform d", transform.d, element.transform.matrix.d);
			assertEquals("Error asserting transform tx", transform.tx, element.transform.matrix.tx);
			assertEquals("Error asserting transform ty", transform.ty, element.transform.matrix.ty);
		}
		
		/**
		 * Create Graphic Element
		 * - Visibility Hidden Test
		 */ 
		[Test]
		public function createHiddenGraphicElement():void
		{
			var svg:XML = <rect visibility="hidden"></rect>;
			var uriManager:URIManager = new URIManager(svg);
			var element:GraphicElement = new GraphicElement();
			GraphicElementFactory.createSparkFromSVG(svg, uriManager, element);
			assertFalse("Error asserting svg visibility", element.visible);
		}
		
		/**
		 * Create Graphic Element
		 * - Display None
		 */ 
		[Test]
		public function createDisplayNoneGraphicElement():void
		{
			var svg:XML = <rect display="none"></rect>;
			var uriManager:URIManager = new URIManager(svg);
			var element:GraphicElement = new GraphicElement();
			GraphicElementFactory.createSparkFromSVG(svg, uriManager, element);
			assertFalse("Error asserting display visibility", element.visible);
		}
		
		/**
		 * Create Stroked Element
		 * Tests stroke color, caps, joints, miterLimit, weight, alpha
		 * TODO: stroke-dasharray, stroke-dashoffset
		 */ 
		[Test]
		public function createStrokedElement():void
		{
			var svg:XML = <rect stroke="red"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="bevel"
								stroke-miterlimit="8"
								stroke-opacity=".5"
								stroke-dasharray="5,3,2"
								stroke-dashoffset="2"
								></rect>;
			var element:StrokedElement = new StrokedElement();
			var uriManager:URIManager = new URIManager(svg);
			StrokedElementFactory.createSparkFromSVG(svg, uriManager, element);
			assertEquals("Error asserting stroke color", 0xFF0000, SolidColorStroke(element.stroke).color);
			assertEquals("Error asserting stroke caps", CapsStyle.ROUND, SolidColorStroke(element.stroke).caps);
			assertEquals("Error asserting stroke joints", JointStyle.BEVEL, SolidColorStroke(element.stroke).joints);
			assertEquals("Error asserting stroke caps", 8, SolidColorStroke(element.stroke).miterLimit);
			assertEquals("Error asserting stroke alpha", .5, SolidColorStroke(element.stroke).alpha);
//			assertEquals("Error asserting stroke dasharray", (5,3,2), SolidColorStroke(element.stroke).???);
//			assertEquals("Error asserting stroke dashoffset", 2, SolidColorStroke(element.stroke).???);
		}
		
		/**
		 * Create Filled Element
		 * Tests SolidColor fill, color, alpha
		 * TODO: BitmapFill, LinearGradient, RadialGradient, #url reference
		 */ 
		[Test]
		public function createFilledElementWithSolidColorFill():void
		{
			var svg:XML = <rect fill="blue"
								fill-opacity=".47"
								></rect>;
			var uriManager:URIManager = new URIManager(svg);
			var element:FilledElement = new FilledElement();
			FilledElementFactory.createSparkFromSVG(svg, uriManager, element);
			assertEquals("Error asserting fill color", 0x0000FF, SolidColor(element.fill).color);
			assertEquals("Error asserting fill alpha", .47, SolidColor(element.fill).alpha);
		}
		
		/**
		 * Create Rect
		 * Tests rx, ry
		 */ 
		[Test]
		public function createRect():void
		{
			var svg:XML = <rect rx="40"	
								ry="50"	
								></rect>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Rect = RectFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting rx", 40, element.radiusX);
			assertEquals("Error asserting ry", 50, element.radiusY);
		}
		
		/**
		 * Create Path
		 * Tests d, winding (fill-rule)
		 */ 
		[Test]
		public function createPath():void
		{
			var svg:XML = <path d="M 250,75 L 323,301 131,161 369,161 177,301 z"
								fill-rule="evenodd"	
								></path>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Path = PathFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting d", "M 250,75 L 323,301 131,161 369,161 177,301 z", element.data);
			assertEquals("Error asserting winding", GraphicsPathWinding.EVEN_ODD, element.winding);
		}
		
		/**
		 * Create Ellipse from Circle
		 * Tests cx, cy, r
		 * TODO: Test tx, ty transform
		 */ 
		[Test]
		public function createEllipseFromCircle():void
		{
			var svg:XML = <circle r="20" cx="25" cy="35"
								></circle>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Ellipse = EllipseFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting width", 20*2, element.width);
			assertEquals("Error asserting height", 20*2, element.height);
			assertEquals("Error asserting x", 5, element.x); // 25 - 20
			assertEquals("Error asserting y", 15, element.y); // 35 - 20
		}
		
		/**
		 * Create Ellipse from Ellipse
		 * Tests cx, cy, rx, ry
		 * TODO: Test tx, ty transform
		 */ 
		[Test]
		public function createEllipseFromEllipse():void
		{
			var svg:XML = <ellipse rx="20" ry="30" cx="25" cy="35"
								></ellipse>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Ellipse = EllipseFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting width", 20*2, element.width);
			assertEquals("Error asserting height", 30*2, element.height);
			assertEquals("Error asserting x", 5, element.x); // 25 - 20
			assertEquals("Error asserting y", 5, element.y); // 35 - 30
		}
		
		/**
		 * Create Line
		 * Tests xFrom, xTo, yFrom, yTo
		 */ 
		[Test]
		public function createLine():void
		{
			var svg:XML = <line x1="5" x2="10" y1="15" y2="20"
								></line>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Line = LineFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting xFrom", 5, element.xFrom);
			assertEquals("Error asserting xTo", 10, element.xTo);
			assertEquals("Error asserting yFrom", 15, element.yFrom); 
			assertEquals("Error asserting yTo", 20, element.yTo);
		}
		
		/**
		 * Create a Group
		 */ 
		[Test]
		public function createGroup():void
		{
			var svg:XML = <g id="myGroup"></g>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Group = GroupFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting id", "myGroup", element.id);
		}
		
		/**
		 * Create a Group with Children
		 */ 
		[Test]
		public function createGroupWithChildren():void
		{
			var svg:XML = <g>
							<circle r="20" cx="25" cy="35" fill="red" />
							<line x1="5" x2="10" y1="15" y2="20" />
						  </g>;
			var uriManager:URIManager = new URIManager(svg);
			var element:Group = GroupFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Error asserting group num children", 2, element.numElements);
		}
		
		/**
		 * Create a Graphic
		 */ 
		[Test]
		public function createGraphic():void
		{
			var svg:XML = <svg />;
			var uriManager:URIManager = new URIManager(svg);
			var element:Object = GraphicFactory.createSparkFromSVG(svg, uriManager);
			assertNotNull(element);
		}
		
		/**
		 * Test GradientEntry using normal attributes
		 * TODO: % values for ratio (currently not supported in SVGAttributes)
		 */ 
		[Test]
		public function createGradientEntry():void
		{
			var svg:XML = <stop offset="0" stop-color="#2BB673" stop-opacity=".5"/>;
			var uriManager:URIManager = new URIManager(svg);
			var element:GradientEntry = GradientEntryFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Failure asserting stop color", 0x2BB673, element.color);
			assertEquals("Failure asserting stop alpha", .5, element.alpha);
		}
		
		/**
		 * Test GradientEntry using style attribute
		 * TODO: % values for ratio (currently not supported in SVGAttributes)
		 */ 
		[Test]
		public function createGradientEntryUsingStyle():void
		{
			var svg:XML = <stop offset="0" style="stop-color:#2BB673;stop-opacity:.5;"/>;
			var uriManager:URIManager = new URIManager(svg);
			var element:GradientEntry = GradientEntryFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Failure asserting stop color", 0x2BB673, element.color);
			assertEquals("Failure asserting stop alpha", .5, element.alpha);
		}
		
		/**
		 * Test GradientBase
		 */ 
		[Test]
		public function createGradientBase():void
		{
			var svg:XML = <linearGradient spreadMethod="pad">
					        <stop offset=".05" stop-color="#F60" />
					        <stop offset=".95" stop-color="#FF6" />
					      </linearGradient>;
			var element:LinearGradient = new LinearGradient(); // Abstract Class needs LinearGradient passed in
			var uriManager:URIManager = new URIManager(svg);
			GradientBaseFactory.createSparkFromSVG(svg, uriManager, element);
			assertEquals("Failure asserting entries length", 2, element.entries.length);
			assertEquals("Failure asserting spread method", SpreadMethod.PAD, element.spreadMethod);
		}
		
		/**
		 * Test URIManager
		 * Get two elements by same URI and test the cache
		 * Test an element without an id
		 */ 
		[Test]
		public function createURIManager():void
		{
			var svg:XML = <svg>
							<linearGradient id="myLinearGradient" />	
							<rect />
		 				  </svg>;
			var uriManager:URIManager = new URIManager(svg);
			var linearGradient1:Object = uriManager.getURElement("myLinearGradient");
			var linearGradient2:Object = uriManager.getURElement("myLinearGradient");
			assertNotNull(linearGradient1);
			// Ensure linearGradient2 is not a new object since it is referencing the same URI as linearGradient1
			assertEquals("Error asserting linearGradient1 is the same object as linearGradient2", linearGradient1, linearGradient2);
		}
		
		/**
		 * Test BitmapImage
		 */ 
		[Test]
		public function createBitmapImage():void
		{
			var svg:XML = <image x="50" y="150" width="100px" height="200px" xmlns:xlink="http://www.w3.org/1999/xlink"
         					xlink:href="myimage.png"></image>;
			var uriManager:URIManager = new URIManager(svg);
			var element:BitmapImage = BitmapImageFactory.createSparkFromSVG(svg, uriManager);
			assertEquals("Failure asserting xlink href", "myimage.png", element.source);
//			assertEquals("Failure asserting stop alpha", .5, element.alpha);
		}
		
		
		/////////////////////////////////////////////////
		// Unfinished tests requiring work
		/////////////////////////////////////////////////
		
		/**
		 * Tests an element with an x and y that has a transform xOffset and yOffset
		 */ 
		[Test]
		public function createGraphicElementXandYOffsetWithTransform():void
		{
			var svg:XML = <rect x="5"
								y="10"
								transform="matrix(1, 0, 0, 1, 10, 10)"
								></rect>;
			// TODO: Write test that transforms an element with a tx, ty which also
			//		 has a set x and y value.  Our old SVG library never handled this.
			//			assertEquals("Error asserting x", 15, element.x); // 15 may be wrong
			//			assertEquals("Error asserting y", 20, element.y); // 20 may be wrong
		}
		
		/**
		 * Test LinearGradient
		 * TODO: Test gradientTransform and gradientUnits, and % values for x1, x2, y1, y2
		 */ 
		[Test]
		public function createLinearGradient():void
		{
			var svg:XML = <linearGradient id="myLinearGradient"
								x1="0" y1="0"
								x2="100" y2="100">
							  <stop offset="0" stop-color="#00cc00" stop-opacity="1"/>
							  <stop offset="1" stop-color="#006600" stop-opacity="1"/>
						  </linearGradient>;
			var uriManager:URIManager = new URIManager(svg);
			var element:LinearGradient = LinearGradientFactory.createSparkFromSVG(svg, uriManager);
			assertNotNull(element);
			
			// TODO: Create better asserts here
			//			assertEquals("Failure asserting rotation", 45, element.rotation);
		}
		
		/**
		 * Test RadialGradient
		 * TODO: Test gradientTransform and gradientUnits, and % values for x1, x2, y1, y2
		 */ 
		[Test]
		public function createRadialGradient():void
		{
			var svg:XML = <radialGradient id="SVGID_2_" cx="349.0098" cy="-101.7944" r="30.3662" >
								<stop offset="0" style="stop-color:#2BB673"/>
								<stop offset="1" style="stop-color:#006838"/>
						  </radialGradient> ;
			var uriManager:URIManager = new URIManager(svg);
			var element:RadialGradient = RadialGradientFactory.createSparkFromSVG(svg, uriManager);
			assertNotNull(element);
			
			// TODO: Create better asserts here
			//			assertEquals("Failure asserting rotation", 45, element.rotation);
		}
		
		/**
		 * Create an Graphic from <svg> with Children
		 */ 
		[Test]
		public function createBasicShapesSvg():void
		{
			var svg:XML = <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				width="495px" height="284.581px" viewBox="0 0 495 284.581" enable-background="new 0 0 495 284.581" xml:space="preserve">
				
					<rect x="23.274" y="23.515" fill="#4AB749" stroke="#000000" width="106.931" height="102.971"/>
					<ellipse fill="#375FAC" stroke="#000000" cx="301.536" cy="75" rx="32.509" ry="51.485"/>
					<circle fill="#ED1C24" stroke="#000000" cx="391.16" cy="75" r="29.043"/>
					<line fill="none" stroke="#B3499B" x1="460.739" y1="38.211" x2="460.739" y2="115.109"/>
				
					<linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="23.2744" y1="203.2275" x2="130.2051" y2="203.2275">
						<stop  offset="0" style="stop-color:#2BB673"/>
						<stop  offset="1" style="stop-color:#006838"/>
					</linearGradient>

					<rect x="23.274" y="173.029" fill="url(#SVGID_1_)" stroke="#000000" width="106.931" height="60.396"/>
				
					<radialGradient id="SVGID_2_" cx="200.5098" cy="205.375" r="30.366" gradientUnits="userSpaceOnUse">
						<stop  offset="0" style="stop-color:#2BB673"/>
						<stop  offset="1" style="stop-color:#006838"/>
					</radialGradient>
				
					<circle fill="url(#SVGID_2_)" stroke="#000000" cx="200.51" cy="205.375" r="30.366"/>
				
					<path fill="none" stroke="#000000" d="M319.931,231.115c-16.404,4.01-32.954-6.038-36.964-22.442c-3.208-13.124,4.83-26.363,17.954-29.571c10.499-2.566,21.09,3.864,23.656,14.363c2.054,8.399-3.091,16.872-11.49,18.926c-6.719,1.643-13.498-2.474-15.141-9.192c-1.313-5.376,1.979-10.799,7.354-12.112c4.3-1.052,8.639,1.582,9.689,5.883c0.841,3.44-1.266,6.911-4.706,7.752c-2.752,0.673-5.529-1.013-6.202-3.765c-0.538-2.202,0.811-4.424,3.013-4.962c1.761-0.431,3.538,0.648,3.969,2.409c0.345,1.409-0.519,2.831-1.928,3.176c-1.127,0.275-2.265-0.414-2.54-1.542c-0.221-0.901,0.332-1.812,1.233-2.032"/>

					<path fill="#2DBEC1" stroke="#000000" d="M372.211,180.95c-0.66,5.941,0,36.964,0,36.964v17.827h10.754c0,0,1.787,2.634,1.787-12.877s12.092-14.434,12.092-14.434s15.094-1.077,13.877-14.938s-9.379-12.542-13.879-12.542S372.211,180.95,372.211,180.95z"/>
				
					<text transform="matrix(1 0 0 1 65.73 150.8516)" font-family="'MyriadPro-Regular'" font-size="12">Rect</text>
					<text transform="matrix(1 0 0 1 163.5522 150.8516)" font-family="'MyriadPro-Regular'" font-size="12">Rounded Rect</text>
					<text transform="matrix(1 0 0 1 285.5527 149.9072)" font-family="'MyriadPro-Regular'" font-size="12">Ellipse</text>
					<text transform="matrix(1 0 0 1 377.2832 149.9072)" font-family="'MyriadPro-Regular'" font-size="12">Circle</text>
					<text transform="matrix(1 0 0 1 450.168 149.9072)" font-family="'MyriadPro-Regular'" font-size="12">Line</text>
								
					<text transform="matrix(1 0 0 1 38.2563 255.8018)" font-family="'MyriadPro-Regular'" font-size="12">Linear Gradient</text>
					<text transform="matrix(1 0 0 1 162.1641 255.8018)" font-family="'MyriadPro-Regular'" font-size="12">Radial Gradient</text>
					<text transform="matrix(1 0 0 1 277.0898 255.8018)" font-family="'MyriadPro-Regular'" font-size="12">Open Path</text>
					<text transform="matrix(1 0 0 1 365.1348 255.8018)" font-family="'MyriadPro-Regular'" font-size="12">Filled Path</text>
				
				</svg>;
			
			var uriManager:URIManager = new URIManager(svg);
			var element:Object = GraphicFactory.createSparkFromSVG(svg, uriManager);
			
			// Currently all text and gradients will be ignored, so children should only be rect, ellipse, etc
			assertEquals("Error asserting Graphic children", 8, element.numElements);
		}
		
	}
}