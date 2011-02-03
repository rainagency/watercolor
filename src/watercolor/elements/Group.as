package watercolor.elements
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayList;
	import mx.core.IVisualElement;
	
	import watercolor.elements.interfaces.IElementContainer;
	import watercolor.utils.VisualElementUtil;


	public class Group extends Element implements IElementContainer
	{
		private var _currentChildren:Vector.<Element>;
		
		public function Group()
		{
			_currentChildren = new Vector.<Element>();
			
			super();
		}
		
		public override function addElement(element:IVisualElement):IVisualElement
		{
			var val:IVisualElement = super.addElement(element);
			
			checkChild(false, val);
			
			return val;
		}
		
		public override function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			var val:IVisualElement = super.addElementAt(element, index);
			
			checkChild(false, val);
			
			return val;
		}
		
		public override function removeElement(element:IVisualElement):IVisualElement
		{
			var val:IVisualElement = super.removeElement(element);
			
			checkChild(true, val);
			
			return val;
		}
		
		public override function removeElementAt(index:int):IVisualElement
		{
			var val:IVisualElement = super.removeElementAt(index);
			
			checkChild(true, val);
			
			return val;
		}
		
		protected function checkChild(remove:Boolean, element:IVisualElement):void
		{
			if (element is Element)
			{
				if (!remove)
				{
					if (_currentChildren.indexOf(element) == -1)
					{
						_currentChildren.push(element);
					}
				}
				else
				{
					if (_currentChildren.indexOf(element) != -1)
					{
						_currentChildren.splice(_currentChildren.indexOf(element as Element), 1);
					}
				}
			}
		}

		public function get currentChildren():Vector.<Element>
		{
			return _currentChildren;
		}


	}
}