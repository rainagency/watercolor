package flexUnitTests.utils
{
	import flash.geom.Matrix;

	import flexunit.framework.Assert;

	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Ellipse;
	import watercolor.elements.Element;
	import watercolor.elements.Path;
	import watercolor.elements.Rect;
	import watercolor.utils.TransformUtil;


	public class TransformUtilTests
	{
		private var element:Element;


		private var elements:Vector.<Element>;


		[Before]
		public function setUp():void
		{
			elements = new Vector.<Element>;
			element = new Rect();
			element.width = 200;
			element.height = 100;
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


		[Test]
		public function testFlipElementHz():void
		{
			//var command:CommandVO = TransformUtil.Flip(elements, TransformUtil.HORIZONTAL);
			//Assert.assertTrue("Not a transformVO", command is TransformVO);
		}


		[Test]
		public function testAlign():void
		{

		}


		[Test]
		public function Distribute():void
		{

		}


		[Test]
		public function rotateSingleTest():void
		{
			var elementVector:Vector.<Element> = new Vector.<Element>();
			elementVector.push( element );
			var transformVO:TransformVO = TransformVO( TransformUtil.rotate( elementVector, 45 ));
			Assert.assertFalse( "Matrix not changed", transformVO.newMatrix.toString() == transformVO.originalMatrix.toString());
		}


		[Test]
		public function Move():void
		{

		}


		[Test]
		public function Scale():void
		{

		}


		[Test]
		public function ApplyMatrix():void
		{
			var mat:Matrix = new Matrix();
			var myEllipse:Ellipse = new Ellipse();
			myEllipse.width = 500;
			myEllipse.height = 300;
			mat.translate( myEllipse.width / -2, myEllipse.height / -2 );
			mat.rotate( Math.PI / 4 );
			mat.scale( .5, .5 );
			mat.translate( myEllipse.width / 2, myEllipse.height / 2 );

			var matrices:Vector.<Matrix> = new Vector.<Matrix>;
			matrices.push( mat );

			var addedPath:Path = TransformUtil.applyMatrix( myEllipse, matrices );

			Assert.assertFalse( "path not created", addedPath.data == "" );
		}
	}
}