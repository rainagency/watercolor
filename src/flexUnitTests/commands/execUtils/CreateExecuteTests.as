package flexUnitTests.commands.execUtils
{
	import flexunit.framework.Assert;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import watercolor.utils.ExecuteUtil;
	import watercolor.commands.vo.CreateVO;
	import watercolor.commands.vo.Position;
	import watercolor.elements.Group;
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.elements.Rect;

	public class CreateExecuteTests
	{
		public var element:Element;

		public var parentOne:IVisualElementContainer;

		public var vo:CreateVO;

		[Before]
		public function setUp():void
		{
			parentOne = new Group();
			element = new Rect();
			parentOne.addElement(element as IVisualElement);
			
			
			vo = new CreateVO();
			vo.element = element;
			vo.position = new Position(parentOne, 0);
			vo.position.index = 0;
			vo.position.parent = parentOne;
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
		public function testCreateExecute():void
		{
			ExecuteUtil.execute(vo);
			Assert.assertEquals("Child not added correctly", vo.position.parent.getElementIndex(element as IVisualElement), vo.position.index);
		}

		[Test]
		public function testUndoExecute():void
		{
			ExecuteUtil.execute(vo);
			ExecuteUtil.undo(vo);
			var error:Error;
			try{
				vo.position.parent.getElementIndex(element as IVisualElement)
			} catch(errObject:Error){
				error = errObject;
				
			}
			Assert.assertNotNull("Child not removed correctly", error);
		}

	}
}