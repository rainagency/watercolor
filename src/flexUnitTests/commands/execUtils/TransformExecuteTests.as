package flexUnitTests.commands.execUtils
{
	import flash.geom.Matrix;
	
	import flexunit.framework.Assert;
	
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Rect;
	import watercolor.utils.ExecuteUtil;

	public class TransformExecuteTests
	{
		public var element:Rect;

		public var matrix:Matrix;

		[Before]
		public function setUp():void
		{
			element = new Rect();
			element.width = 100;
			element.height = 200;
			matrix = new Matrix(1.5, 0.2, 0.3, 1.2, 20, 30);
		}
		[Test]
		public function transformExecuteTest():void{
			var transformVO:TransformVO = new TransformVO();
			transformVO.element = element;
			transformVO.newMatrix = matrix;
			Assert.assertEquals("Original Matrix not set by the TransformVO correctly", element.transform.matrix.toString(), transformVO.originalMatrix.toString());
			ExecuteUtil.execute(transformVO);
			Assert.assertEquals("Transformation Matrix not applied correctly", element.transform.matrix.toString(), matrix.toString());
		}
		[Test]
		public function transformUndoTest():void{
			var transformVO:TransformVO = new TransformVO();
			transformVO.element = element;
			transformVO.newMatrix = matrix;
			ExecuteUtil.execute(transformVO);
			ExecuteUtil.undo(transformVO);
			var originalMatrix:Matrix = new Matrix(1,0,0,1,0,0);
			Assert.assertEquals("Transformation Matrix not undone correctly", element.transform.matrix.toString(), originalMatrix.toString());
		}
	}
}