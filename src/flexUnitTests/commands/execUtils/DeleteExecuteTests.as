package flexUnitTests.commands.execUtils
{
	import flexunit.framework.Assert;

	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	import watercolor.utils.ExecuteUtil;
	import watercolor.commands.vo.DeleteVO;
	import watercolor.commands.vo.Position;
	import watercolor.elements.Group;
	import watercolor.elements.Element;
	import watercolor.elements.Rect;

	public class DeleteExecuteTests
	{

		public var vo:DeleteVO;

		public var element:IVisualElement;

		public var parent:IVisualElementContainer;

		[Before]
		public function setUp():void
		{
			vo = new DeleteVO();
			element = new Rect();
			parent = new Group();
			parent.addElement(element);
			vo.element = element as Element;
			vo.position = new Position(parent, 0);
		}

		[After]
		public function tearDown():void
		{
		}

		[BeforeClass]
		public static function saetUpBeforeClass():void
		{
		}

		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}

		[Test]
		public function deleteExecuteTest():void
		{
			ExecuteUtil.execute(vo);
			var error:Error;
			try
			{
				vo.position.parent.getElementIndex(element as IVisualElement);
			}
			catch (errObject:Error)
			{
				error = errObject;

			}
			Assert.assertNotNull("Child not removed correctly", error);
		}

		[Test]
		public function deleteUndoTest():void
		{
			ExecuteUtil.execute(vo);
			ExecuteUtil.undo(vo);
			var error:Error;
			try
			{
				vo.position.parent.getElementIndex(element as IVisualElement);
			}
			catch (errObject:Error)
			{
				error = errObject;
			}
			Assert.assertNull("Child not returned correctly", error);
		}
	}
}