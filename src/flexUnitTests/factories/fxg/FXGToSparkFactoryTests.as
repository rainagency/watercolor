package flexUnitTests.factories.fxg
{
	import flash.display.GraphicsPathWinding;
	
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	import watercolor.elements.Group;
	import watercolor.elements.Path;
	import watercolor.elements.Rect;
	import watercolor.factories.fxg.GroupFactory;
	import watercolor.factories.fxg.PathFactory;
	import watercolor.factories.fxg.RectFactory;
	import watercolor.factories.fxg.util.URIManager;
	
	public class FXGToSparkFactoryTests
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
		 * Test to make sure a path is created and has the correct path, winding, and x properties.
		 */ 
		[Test]
		public function createPathElement():void
		{
			var fxg:XML = <Path id="myPath" transform="matrix(1,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z"/>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Path = PathFactory.createSparkFromFXG(fxg, uriManager);
			assertEquals("Error asserting data", "M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z", element.data);
			assertEquals("Error asserting winding", GraphicsPathWinding.NON_ZERO, element.winding);
			assertEquals("Error asserting x", element.x, 9.25);
		}	
		
		/**
		 * Test to make sure a group is created with a path inside
		 */ 
		[Test]
		public function createGroupElement():void
		{
			var fxg:XML = <Graphic><Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z"/></Graphic>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Group = GroupFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Group contains one child", element.numElements == 1);
		}
		
		/**
		 * Test to make sure a transformation matrix is applied to a rectangle
		 */ 
		[Test]
		public function testTransformation():void
		{
			var fxg:XML = 	<Rect x="0.5" y="0.5" width="106.931" height="60.3965" transform="matrix(2,3,5,1,-50,-50)">
						        <fill>
						          	<SolidColor/>
						        </fill>									    
							</Rect>
			var uriManager:URIManager = new URIManager(fxg);
			var element:Rect = RectFactory.createSparkFromFXG(fxg, uriManager);
			assertEquals("Transformation test a", element.transform.matrix.a, 2);
			assertEquals("Transformation test b", element.transform.matrix.b, 3);
			assertEquals("Transformation test c", element.transform.matrix.c, 5);
			assertEquals("Transformation test d", element.transform.matrix.d, 1);
			assertEquals("Transformation test tx", element.transform.matrix.tx, -50);
			assertEquals("Transformation test ty", element.transform.matrix.ty, -50);
		}	
		
		/**
		 * Test to make sure a linear gradient fill is applied to a path
		 */ 
		[Test]
		public function checkPathFill():void
		{
			var fxg:XML =	<Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z">
								<fill>
										<LinearGradient x="0.5" y="30.6982" scaleX="106.931" rotation="0">
							           		<GradientEntry color="#2bb673" ratio="0"/>
							            	<GradientEntry color="#006838" ratio="1"/>
							          	</LinearGradient>
								</fill>
							</Path>
										
			var uriManager:URIManager = new URIManager(fxg);
			var element:Path = PathFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Path contains fill", element.fill != null);
			assertEquals("Error asserting gradient entry color", (element.fill as LinearGradient).entries[0].color, "2864755");
		}
		
		/**
		 * Test to make sure a radial gradient fill is applied to a path
		 */ 
		[Test]
		public function checkPathFill2():void
		{
			var fxg:XML =	<Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z">
								<fill>
										<RadialGradient x="0.5" y="30.6982" blah="blah" scaleX="106.931" rotation="0">
											<GradientEntry color="#2bb673" ratio="0"/>
											<GradientEntry color="#006838" ratio="1"/>
										</RadialGradient>
								</fill>
							</Path>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Path = PathFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Path contains fill", element.fill != null);
		}
		
		/**
		 * Test to make sure a solid color fill is applied to a path
		 */ 
		[Test]
		public function checkPathFill3():void
		{
			var fxg:XML =	<Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z">
								<fill>
									<SolidColor color="#BBAABB" caps="none" weight="1" joints="miter" miterLimit="4"/>
								</fill>
							</Path>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Path = PathFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Path contains fill", element.fill != null);
			assertEquals("Error asserting solid color", (element.fill as SolidColor).color, "12298939");
		}
		
		/**
		 * Test to make sure a mask is applied to a group and that the group contains only one child element
		 */ 
		[Test]
		public function checkPathMask():void
		{
			var fxg:XML =	<Group>
								<mask>
									<Rect x="0.5" y="0.5" width="106.931" height="60.3965">
								        <fill>
								          <SolidColor/>
								        </fill>									    
									</Rect>
								</mask>
								<Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z">								
									<fill>
										<SolidColor color="#BBAABB" caps="none" weight="1" joints="miter" miterLimit="4"/>
									</fill>
								</Path>
							</Group>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Group = GroupFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Group contains mask", element.mask != null);
			assertTrue("Group mask contains fill", (element.mask as Rect).fill != null);
			assertTrue("Group contains one child", element.numElements == 1);
		}
		
		/**
		 * Test URIManager
		 * Get two elements by same URI and test the cache
		 */ 
		[Test]
		public function createURIManager():void
		{
			var fxg:XML = 	<Group>
								<Rect id="myRect" x="0.5" y="0.5" width="106.931" height="60.3965">
							        <fill>
							          <SolidColor/>
							        </fill>									    
								</Rect>
							</Group>;
			
			var uriManager:URIManager = new URIManager(fxg);
			var rect1:Object = uriManager.getURElement("myRect");
			var rect2:Object = uriManager.getURElement("myRect");
			assertNotNull(rect1);
			assertEquals("Error asserting Rect1 is the same object as Rect2", rect1, rect2);
		}
		
		/**
		 * Test to make sure a filter is set on a rectangle
		 */ 
		[Test]
		public function testFilters():void
		{
			var fxg:XML = 	<Rect id="myRect" x="0.5" y="0.5" width="106.931" height="60.3965">
								<filters>
									<BlurFilter/>
							  	</filters>								    
							</Rect>;
										
			var uriManager:URIManager = new URIManager(fxg);
			var rect:Rect = RectFactory.createSparkFromFXG(fxg, uriManager);
			assertNotNull(rect);
			assertNotNull(rect.filters);
			assertTrue("Rectangle contains a filter", rect.filters.length == 1);
		}
		
		/**
		 * Test to make sure multiple filters are applied to a rectangle
		 */ 
		[Test]
		public function testMultipleFilters():void
		{
			var fxg:XML = 	<Rect id="myRect" x="0.5" y="0.5" width="106.931" height="60.3965">
								<filters>
									<BlurFilter/>
									<GlowFilter/>
								</filters>								    
							</Rect>;
						
			var uriManager:URIManager = new URIManager(fxg);
			var rect:Rect = RectFactory.createSparkFromFXG(fxg, uriManager);
			assertNotNull(rect);
			assertNotNull(rect.filters);
			assertTrue("Rectangle contains a filter", rect.filters.length == 2);
		}
		
		/**
		 * Test to make sure multiple filters are applied to a group
		 */ 
		[Test]
		public function testGroupFilters():void
		{
			var fxg:XML = 	<Group>
								<filters>
									<BlurFilter/>
									<GlowFilter/>
								</filters>
								<Rect id="myRect" x="0.5" y="0.5" width="106.931" height="60.3965"/>
								<Path id="myPath" transform="matrix(2,0,0,1,-113,-113.8)" x="9.29199" y="6.03195" winding="nonZero" data="M0 0.842565 0 7.23172C0 8.03837 0.554688 8.41337 1.125 7.84305 1.69531 7.27274 4.94238 4.04325 4.94238 4.04325 4.94238 4.04325 1.69238 0.790807 1.16406 0.26444 0.640625 -0.263881 0 0.0354357 0 0.842565Z">								
									<fill>
										<SolidColor color="#BBAABB" caps="none" weight="1" joints="miter" miterLimit="4"/>
									</fill>
								</Path>
							</Group>;
			
			
			var uriManager:URIManager = new URIManager(fxg);
			var group:Group = GroupFactory.createSparkFromFXG(fxg, uriManager);
			assertNotNull(group);
			assertNotNull(group.filters);
			assertTrue("Rectangle contains a filter", group.filters.length == 2);
			assertTrue("Group contains multiple children", group.numElements > 0);
		}
		
		/**
		 * Test to make sure a mask is applied to a group and with seven children
		 */ 
		[Test]
		public function checkBeachBall():void
		{
			var fxg:XML =	<Graphic version="2.0" viewHeight="150" viewWidth="150" xmlns="http://ns.adobe.com/fxg/2008" xmlns:pfx="http://ns.provocraft.com/provocraft/2010">
									<mask>
										<Path winding="nonZero" data="M150 75C150 93.4473 143.34 110.338 132.293 123.4 118.536 139.67 97.9746 150 75 150 53.2729 150 33.7041 140.762 20.0068 125.998 7.59082 112.616 0 94.6943 0 75 0 57.5449 5.96289 41.4824 15.9629 28.7388 29.6934 11.2412 51.0337 0 75 0 116.421 0 150 33.5786 150 75Z">
											<fill>
												<SolidColor/>
											</fill>
										</Path>
									</mask>
									<Path x="27.3042" y="-47.415" winding="nonZero" data="M47.6958 0C30.7852 0 14.665 3.42773 0 9.63965L17.2817 50.5C17.2695 50.5083 4.71143 62.7686 2.19287 83.0093 1.63428 87.5132 1.55664 92.4004 2.2417 97.6499 6.25244 97.6499 9.89209 99.7573 12.5859 103.173L12.5942 103.165C12.5942 103.165 47.9399 63.1313 104.375 68.7803L136.583 38.3052C114.295 14.7344 82.7319 0 47.6958 0Z">
							        <fill>
							          <SolidColor color="#FBEB00"/>
							        </fill>
							      </Path>
							      <Path x="14.4937" y="50.2349" winding="nonZero" data="M25.3965 5.52295C22.7026 2.10742 19.063 0 15.0522 0 8.74658 0 3.3623 5.16406 1.1167 12.5049 0.39502 14.8364 0 17.3877 0 20.0576 0 24.6919 1.18213 28.9224 3.15869 32.314 5.90967 37.0659 10.2017 40.1147 15.0522 40.1147 16.1401 40.1147 17.2041 39.9683 18.2354 39.6665 23.8726 38.0366 28.3188 32.2241 29.6641 24.7651 29.937 23.2573 30.0923 21.6836 30.0923 20.0576 30.0923 14.3311 28.2866 9.1792 25.3965 5.52295Z">
							        <fill>
							          <SolidColor color="#74A93D"/>
							        </fill>
							      </Path>
							      <Path x="39.8901" y="-9.10986" winding="nonZero" data="M123.997 0 91.7896 30.4751C35.354 24.8262 0.00830078 64.8594 0.00830078 64.8594L0 64.8677C2.89014 68.5239 4.6958 73.6758 4.6958 79.4023 4.6958 81.0283 4.54053 82.6021 4.26758 84.1099L4.6958 84.1099C4.6958 84.1099 43.5308 102.664 106.878 114.867 L147.653 132.344C153.987 117.516 157.525 101.237 157.525 84.1099 157.525 51.5229 144.784 21.9487 123.997 0Z">
							        <fill>
							          <RadialGradient x="-10.9927" y="72.0215" scaleX="309.609" scaleY="309.609" rotation="43.9949">
							            <GradientEntry ratio="0" color="#FFFFFF"/>
							            <GradientEntry ratio="1" color="#E6E6E6"/>
							          </RadialGradient>
							        </fill>
							      </Path>
							      <Path x="32.729" y="75" winding="nonZero" data="M114.04 30.7568C50.6919 18.5537 11.8569 0 11.8569 0L11.4287 0C11.0088 2.32324 10.21 4.39355 9.24805 6.31738 7.12061 10.5811 3.88428 13.7764 0 14.9014L0 14.9092C6.52539 51.6006 43.9253 75.1025 48.4097 77.8008L51.8979 122.008C54.0669 121.812 56.2183 121.608 58.354 121.314L72.0815 118.73C109.384 109.389 139.897 82.9688 154.814 48.2344L114.04 30.7568Z">
							        <fill>
							          <SolidColor color="#E21B22"/>
							        </fill>
							      </Path>
							      <Path x="-34.2051" y="82.5488" winding="nonZero" data="M115.344 70.252C110.859 67.5537 73.4595 44.0518 66.9341 7.36035L66.9341 7.35254C65.9028 7.6543 64.8389 7.80078 63.751 7.80078 58.9004 7.80078 54.6084 4.75195 51.8574 0L51.8491 0.0244141C48.7188 5.2168 45.6538 12.1377 43.3672 17.7627 41.1499 23.208 39.6621 27.4551 39.5684 27.7158L0 47.7529C20.2124 87.5742 61.5049 114.866 109.205 114.866 112.449 114.866 115.645 114.687 118.832 114.459L115.344 70.252Z">
							        <fill>
							          <RadialGradient x="-79.2212" y="-220.128" scaleX="2100.25" scaleY="2100.25" rotation="43.9949">
							            <GradientEntry ratio="0" color="#FFFFFF"/>
							            <GradientEntry ratio="1" color="#E6E6E6"/>
							          </RadialGradient>
							        </fill>
							      </Path>
							      <Path x="-47.415" y="41.9814" winding="nonZero" data="M61.9087 28.311C61.9087 25.6411 62.3037 23.0898 63.0254 20.7583L63.0215 20.7544 47.2559 11.9624 4.55273 0C1.60596 10.4995 0 21.5693 0 33.0186 0 52.9492 4.78125 71.6904 13.21 88.3203L52.7783 68.2832C52.9658 67.7529 58.9004 50.8135 65.0591 40.5918 L65.0674 40.5674C63.0908 37.1758 61.9087 32.9453 61.9087 28.311Z">
							        <fill>
							          <SolidColor color="#3CABE0"/>
							        </fill>
							      </Path>
							      <Path x="-42.8623" y="-37.7754" winding="nonZero" data="M87.4482 40.8604 70.1665 0C64.3784 2.44922 58.917 5.48193 53.6265 8.75879L51.6416 9.81055 51.666 10.0142C26.8721 26.0322 8.13965 50.6182 0 79.7568L27.3125 87.4072 42.7031 91.7192 58.4688 100.511 58.4727 100.515C60.7183 93.1743 66.1025 88.0103 72.4082 88.0103 69.502 65.7314 80.0342 49.7783 84.9863 43.6567L87.4482 40.8604Z">
							        <fill>
							          <RadialGradient x="10.8257" y="68.2373" scaleX="925.716" scaleY="925.716" rotation="43.9949">
							            <GradientEntry ratio="0" color="#FFFFFF"/>
							            <GradientEntry ratio="1" color="#E6E6E6"/>
							          </RadialGradient>
							        </fill>
							      </Path>							
							</Graphic>
			
			var uriManager:URIManager = new URIManager(fxg);
			var element:Group = GroupFactory.createSparkFromFXG(fxg, uriManager);
			assertTrue("Group contains mask", element.mask != null);
			assertTrue("Group mask contains fill", (element.mask as Path).fill != null);
			assertTrue("Group contains one child", element.numElements == 7);
		}
	}
}