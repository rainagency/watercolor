package flexUnitTests.commands.execUtils
{
	import flexunit.framework.Assert;
	
	import mx.core.IVisualElement;
	
	import org.hamcrest.mxml.object.Null;
	
	import watercolor.utils.ExecuteUtil;
	import watercolor.commands.vo.PropertyVO;
	import watercolor.elements.Element;
	import watercolor.elements.Rect;

	public class PropertyExecuteTests
	{
		public var vo:PropertyVO;

		public var element:IVisualElement;
		public var startWidth:Number = 200;
		public var startHeight:Number = 400;
		public var endWidth:Number = 500;
		public var endHeight:Number = 300;

		[Before]
		public function setUp():void
		{
			element = new Rect();
			vo = new PropertyVO();
			vo.element = element as Element;
			element.width = startWidth;
			element.height = startHeight;
			vo.originalProperties = { width: startWidth, height: startHeight };
			vo.newProperties = { width: endWidth, height: endHeight };
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
		public function propertyExecuteTest():void
		{
			ExecuteUtil.execute(vo);
			Assert.assertEquals("Properties not set correctly", element.width, endWidth);
			Assert.assertEquals("Properties not set correctly", element.height, endHeight);
		}

		[Test]
		public function propertyUndoTest():void
		{
			ExecuteUtil.execute(vo);
			ExecuteUtil.undo(vo);
			Assert.assertEquals("Properties not undone correctly", element.width, startWidth);
			Assert.assertEquals("Properties not undone correctly", element.height, startHeight);
		}
	}
}