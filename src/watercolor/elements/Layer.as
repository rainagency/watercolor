package watercolor.elements
{
	import flash.display.DisplayObject;
	import flash.sampler.getInvocationCount;
	
	import mx.core.IVisualElement;
	import mx.graphics.SolidColor;
	
	import watercolor.elements.interfaces.IElementContainer;
	import watercolor.events.LayerElementEvent;

	[Event(name="waterColorLayerAddingElement",type="watercolor.events.LayerElementEvent")]
	[Event(name="waterColorLayerAddedElement",type="watercolor.events.LayerElementEvent")]
	[Event(name="waterColorLayerRemovingElement",type="watercolor.events.LayerElementEvent")]
	[Event(name="waterColorLayerRemovedElement",type="watercolor.events.LayerElementEvent")]
	public class Layer extends Element implements IElementContainer
	{
		private var _color:int;


		public function Layer()
		{
			super();
		}


		[Bindable]
		public function get color():int
		{
			return _color;
		}


		public function set color( value:int ):void
		{
			_color = value;
		}


		[Bindable]
		override public function get name():String
		{
			return super.name;
		}


		override public function set name( value:String ):void
		{
			super.name = value;
		}
		
		override public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			if (element is Element)
			{
				dispatchEvent(new LayerElementEvent(LayerElementEvent.ADDING_ELEMENT, Element(element)));
				super.addElementAt(element, index);
				dispatchEvent(new LayerElementEvent(LayerElementEvent.ADDED_ELEMENT, Element(element)));
			}
			else
			{
				super.addElementAt(element, index);
			}
			
			return element;
		}
		
		override public function removeElementAt(index:int):IVisualElement
		{
			var element:IVisualElement = getElementAt(index);
			
			if (element is Element)
			{
				dispatchEvent(new LayerElementEvent(LayerElementEvent.REMOVING_ELEMENT, Element(element)));
				super.removeElementAt(index);
				dispatchEvent(new LayerElementEvent(LayerElementEvent.REMOVED_ELEMENT, Element(element)));
			}
			else
			{
				super.removeElementAt(index);
			}
			
			return element;
		}
	}
}