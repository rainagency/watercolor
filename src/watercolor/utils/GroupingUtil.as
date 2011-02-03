package watercolor.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElementContainer;
	import mx.graphics.SolidColorStroke;
	
	import spark.primitives.Rect;
	
	import watercolor.commands.vo.ArrangeVO;
	import watercolor.commands.vo.CreateVO;
	import watercolor.commands.vo.DeleteVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.Position;
	import watercolor.commands.vo.PropertyVO;
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Element;
	import watercolor.elements.Group;

	/**
	 * 
	 * @author mediarain
	 */
	public class GroupingUtil
	{
		/**
		 * Public static function for grouping some elements into a group
		 * @param parent The parent element that will contain the group
		 * @param elements The group of elements that we want to group together
		 * @return A group command vo to be exectured
		 */
		public static function group(parent:IVisualElementContainer, elements:Vector.<Element>):GroupCommandVO {
			
			// create a new group command vo
			var groupCommand:GroupCommandVO = new GroupCommandVO();
			var arrange:ArrangeVO;
			var transform:TransformVO;
			
			// get the rectangle area for the elements
			var rect:Rectangle = VisualElementUtil.getElementsRectangle(elements, parent as DisplayObject);
			
			// create a new group and disable the mouse for all the children
			var newGroup:Group = new Group();
			newGroup.mouseChildren = false;
			
			// set the x and y to match the rectangular region of the elements
			newGroup.x = rect.x;
			newGroup.y = rect.y;
			
			// set up a create vo for creating the new group
			var groupCreate:CreateVO = new CreateVO();
			groupCreate.element = newGroup;
			groupCreate.position = new Position(parent, parent.numElements);			
			
			groupCommand.commands.push(groupCreate);
			
			// go through each element in the list
			for each (var element:Element in elements.sort(sortElements)) {
				
				// set up an adjustment matrix to adjust the element for insertion into the group
				var m:Matrix = element.transform.matrix;
				m.tx -= rect.x;
				m.ty -= rect.y;
				
				// set up a property vo command for changing the element's matrix
				transform = new TransformVO();
				transform.element = element;
				transform.originalMatrix = element.transform.matrix;
				transform.newMatrix = m;
				groupCommand.commands.push(transform);
				
				// reset the child matrix
				element.childMatrix = m;
				
				// create a new arrange vo for putting the element into the new group
				arrange = new ArrangeVO();
				arrange.element = element;
				
				// record the original position so that this can be undone
				arrange.originalPosition = new Position(element.parent as IVisualElementContainer, element.parent.getChildIndex(element));
				arrange.newPosition = new Position(newGroup, 0);
				
				groupCommand.commands.push(arrange);				
			}
			
			// return the group command vo
			return groupCommand;
		}
		
		/**
		 * Public static function for un-grouping a bunch of elements
		 * @param parent The parent element that should contain other elements.  This should always be a group or something that extends group.
		 * @return The group command vo to be executed
		 */
		public static function ungroup(parent:IVisualElementContainer, element:Element):GroupCommandVO {
			
			var child:Element;
			var m:Matrix;
			var transform:TransformVO;
			var newPoint:Point;
			var arrange:ArrangeVO;
			var pm:Matrix;
			
			// put all imediate children in a vector collection
			var elements:Vector.<Element> = new Vector.<Element>();
			for (var x:int = 0; x < element.numElements; x++) {
				if (element.getChildAt(x) is Element) {
					elements.push(element.getChildAt(x));
				}
			}
		
			// create a new group command vo
			var groupCommand:GroupCommandVO = new GroupCommandVO();
			
			// go through each child element
			for (var y:int = 0; y < elements.length; y++) {
				
				child = elements[y];
				
				// take into account the concatenated matrix
				m = new Matrix();
				m.tx = child.transform.matrix.tx;
				m.ty = child.transform.matrix.ty;
								
				m.a = child.transform.concatenatedMatrix.a;
				m.b = child.transform.concatenatedMatrix.b;
				m.c = child.transform.concatenatedMatrix.c;
				m.d = child.transform.concatenatedMatrix.d;
				
				// get the parent's concatenated matrix and invert it
				pm = DisplayObject(parent).transform.concatenatedMatrix.clone();
				pm.invert();
				
				// add the inversion of the parent's concatenated matrix
				m.concat(pm);
				
				newPoint = CoordinateUtils.localToLocal(element, parent, new Point(child.x, child.y));
				
				transform = new TransformVO();
				transform.element = child;
				
				var nm:Matrix = m.clone();
				nm.tx = newPoint.x;
				nm.ty = newPoint.y;
				
				transform.originalMatrix = child.transform.matrix.clone();
				transform.newMatrix = nm;
				
				// create a new arrange vo
				arrange = new ArrangeVO();
				arrange.element = child;
				arrange.originalPosition = new Position(element, 0);
				arrange.newPosition = new Position(parent, parent.numElements + y);
				
				// add the arrange vo and the property vo to the group command vo
				groupCommand.commands.push(arrange);
				groupCommand.commands.push(transform);
			}
			
			// set up a delete vo for the element
			var deleteVO:DeleteVO = new DeleteVO();
			deleteVO.element = element; 
			deleteVO.position = new Position(parent as IVisualElementContainer, parent.getElementIndex(element));
			
			groupCommand.commands.push(deleteVO);
			
			// return the group command vo
			return groupCommand;
		}
		
		/**
		 * Private sort function for arranging the elements in a certain order
		 * The elements need to be listed in reverse so that they get stacked in the right
		 * order when being moved to a group.
		 */ 
		private static function sortElements(item1:Element, item2:Element):Number {
			
			// if element 1 appears below element 2 then stack element 1 after element 2
			if (item1.parent.getChildIndex(item1) < item2.parent.getChildIndex(item2)) {
				return 1;
			} else {
				return -1;
			} 
		}
	}
}