package watercolor.transform
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.supportClasses.GraphicElement;
	
	import watercolor.elements.Element;
	import watercolor.events.TransformLayerEvent;
	import watercolor.utils.CoordinateUtils;
	import watercolor.utils.VisualElementUtil;
	
	
	/**
	 * Transformation layer. This handles rotation, skew and scale at the same time.
	 * Type of operation depends on where mouse down event occures, active areas are illustrated below
	 *
	 * <pre>
	 * (  r  )  skX       skX   (  r  )
	 *  -- [sc]-----[sc]------[sc] --
	 *  skY  |                  |  skY
	 *       |                  |
	 *     [sc]     [pv]      [sc]
	 *       |                  |
	 *  skY  |                  |  skY
	 *  -- [sc]-----[sc]------[sc] --
	 * (  r  )  skX       skX   (  r  )
	 *
	 * (r) - rotation
	 * (sc) - scale
	 * (sk) - skew X/Y
	 * (pv) - pivot point
	 * 	</pre>
	 *
	 */
	public class TransformLayer extends SkinnableComponent
	{		
		/**
		 * Dictionary list of selected elements with their original matrices
		 */
		private var matrices:Dictionary;
		
		
		/**
		 * Objects total transformation matrix
		 */
		private var totalMatrix:Matrix;
		
		
		/**
		 * Invertion of the total transformation matrix
		 */
		private var totalMatrixInversion:Matrix;
		
		
		/**
		 * Current transformation matrix. This is transformation
		 * matrix is calculated when user moves mouse
		 */
		private var currentMatrix:Matrix;
		
		
		/**
		 * transformation center points
		 */
		private var ctrp1:Point;
		
		
		private var ctrp2:Point;
		
		
		/**
		 * global center of transformed elements
		 */
		private var pcenter:Point;
		
		
		/**
		 * mouse down coordinates in
		 * transform coordinate space
		 */
		private var localMouseDownPoint:Point;
		
		
		/**
		 * global mouse down coordinates
		 */
		private var globalMouseDownPoint:Point;
		
		
		private var _topLeft:Point = new Point();
		private var _topRight:Point = new Point();	
		private var _bottomRight:Point = new Point();	
		private var _bottomLeft:Point = new Point();			
		private var _center:Point = new Point();
		
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] public function get topLeft():Point { return _topLeft; }
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] public function get topRight():Point { return _topRight; }
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] public function get bottomRight():Point { return _bottomRight; }
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] public function get bottomLeft():Point { return _bottomLeft; }
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] /**
		[Bindable]  * 
		[Bindable]  * @return 
		[Bindable]  */
		[Bindable] public function get center():Point { return _center; }		
		
		/**
		 * 
		 * @param value
		 */
		public function set bottomLeft(value:Point):void { _bottomLeft = value; }
		/**
		 * 
		 * @param value
		 */
		public function set bottomRight(value:Point):void { _bottomRight = value; }
		/**
		 * 
		 * @param value
		 */
		public function set topRight(value:Point):void { _topRight = value; }
		/**
		 * 
		 * @param value
		 */
		public function set topLeft(value:Point):void { _topLeft = value; }
		/**
		 * 
		 * @param value
		 */
		public function set center(value:Point):void { _center = value; }
		
		
		/**
		 *
		 */
		private var cMode:String;
		
		
		/**
		 * level where all transformed objects are placed
		 */
		private var _parentContainer:DisplayObjectContainer;
		
		
		/**
		 * containers for keeping track of mouse move and mouse up listeners
		 */
		private var listenerArray:Array;
		
		
		private var uplistenerArray:Array;
		
		
		private var xPadding:Number = 0;
		
		
		private var yPadding:Number = 0;
		
		private var _elements:Vector.<Element>;	
		private var _rect:Rectangle;
		
		/**
		 * 
		 * @return 
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		private var _identityBounds:Boolean;
		
		private var dict:Dictionary;
		private var transformMatrix:Matrix;
		
		/**
		 * These are used to determine if the handles should maintain their position 
		 * if elements have been scaled into the negative.  
		 */ 
		private var flipA:Boolean = false;
		private var flipD:Boolean = false;
		
		private var buttonOffset:Point = new Point();
		
		private var currentBox:Rectangle = new Rectangle();
		
		/**
		 * This value determines if we want to maintain the positions of the handles
		 * If the user scales the element into a negative scale then the handles will
		 * snap back to their original position upon the completion of the transformation.
		 * If the user flips the element, the handles will stay in the same place.
		 */ 
		private var _maintainHandlePosition:Boolean = false;
		/**
		 * Return if we want to maintain the positions of the handles
		 * @return 
		 */
		public function get maintainHandlePosition():Boolean
		{
			return _maintainHandlePosition;
		}
		/**
		 * If we want to maintain the positions of the handles
		 * @param value
		 */
		public function set maintainHandlePosition(value:Boolean):void
		{
			_maintainHandlePosition = value;
		}
		
		/**
		 * Indicates if the center btn should be moveable
		 */ 
		private var _centerMoveable:Boolean = false;
		/**
		 * 
		 * @return 
		 */
		public function get centerMoveable():Boolean
		{
			return _centerMoveable;
		}
		/**
		 * 
		 * @param value
		 */
		public function set centerMoveable(value:Boolean):void
		{
			_centerMoveable = value;
			
			if (centerBtn)
			{
				if (value)
				{
					centerBtn.doubleClickEnabled = true;
					centerBtn.addEventListener(MouseEvent.DOUBLE_CLICK, centerDblClickHandler, false, 0, true);
					centerBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
				}
				else
				{
					centerBtn.doubleClickEnabled = false;
					centerBtn.removeEventListener(MouseEvent.DOUBLE_CLICK, centerDblClickHandler);
					centerBtn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				}
			}
		}
		
		
		[SkinPart(type="spark.primitives.supportClasses.GraphicElement",required="false")]
		/**
		 * 
		 * @default 
		 */
		public var selectionBounds:GraphicElement;
		
		/**
		 * The top right button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var topRightBtn:Handle = new Handle();
		
		
		/**
		 * The top left button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var topLeftBtn:Handle = new Handle();
		
		
		/**
		 * The bottom right button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var bottomRightBtn:Handle = new Handle();
		
		
		/**
		 * The bottom left button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var bottomLeftBtn:Handle = new Handle();
		
		
		/**
		 * The top right rotation button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var topRightRotateBtn:Handle = new Handle();
		
		
		/**
		 * The top left rotation button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var topLeftRotateBtn:Handle = new Handle();
		
		
		/**
		 * The bottom right rotation button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var bottomRightRotateBtn:Handle = new Handle();
		
		
		/**
		 * The bottom left rotation button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var bottomLeftRotateBtn:Handle = new Handle();
		
		
		/**
		 * The top middle button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var topMiddleBtn:Handle = new Handle();
		
		
		/**
		 * The right middle button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var rightMiddleBtn:Handle = new Handle();
		
		
		/**
		 * The bottom middle button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var bottomMiddleBtn:Handle = new Handle();
		
		
		/**
		 * The left middle button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var leftMiddleBtn:Handle = new Handle();
		
		
		/**
		 * The center button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var centerBtn:Handle = new Handle();
		
		
		/**
		 * The skew X Top button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var skewTopBtn:Handle = new Handle();
		
		
		/**
		 * The skew X Bottom button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var skewBottomBtn:Handle = new Handle();
		
		
		/**
		 * The skew Y Left button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var skewLeftBtn:Handle = new Handle();
		
		
		/**
		 * The skew Y Right button
		 */
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var skewRightBtn:Handle = new Handle();
		
		/**
		 * SkewLocked
		 */
		private var skewLocked:Boolean = false;
		
		/**
		 * SkewVertical when Locked
		 * If false, skew will be locked horizontal.
		 */ 	
		private var skewVertical:Boolean = true;
		
		[SkinState("selected", "nonselected")]
		
		
		private var _scaleProportional:Boolean = false;
		
		/**
		 *
		 * @return
		 */
		public function get scaleProportional():Boolean
		{
			return _scaleProportional;
		}
		
		
		/**
		 *
		 * @param value
		 */
		public function set scaleProportional(value:Boolean):void
		{
			_scaleProportional = value;
		}
		
		/**
		 * Sets the elements
		 * @param value A vector containing the selected elements
		 */
		public function set elements(value:Object):void
		{
			_elements = value as Vector.<Element>;
			
			// reset the dictionary list
			for (var key:* in dict)
			{
				delete dict[key];
			}
			
			// update the transformation matrix
			updateTransformMatrix();
		}		
		
		/**
		 * Used for obtaining the list of elements in the transformer
		 * @return
		 */
		public function get elements():Object
		{
			return _elements;
		}
		
		
		/**
		 * This is used for keeping track if we are in the selected or nonselected states
		 * @default
		 */
		protected var selected:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function TransformLayer()
		{
			super();
		}
		
		
		override protected function getCurrentSkinState():String
		{
			return selected ? "selected" : "nonselected";
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			// go through each handle and set the appropriate event listeners
			switch(instance)
			{
				case skewTopBtn:
				case skewBottomBtn:
				case skewRightBtn:
				case skewLeftBtn:
				case topLeftBtn:
				case topRightBtn:
				case bottomLeftBtn:
				case bottomRightBtn:
				case topLeftRotateBtn:
				case topRightRotateBtn:
				case bottomLeftRotateBtn:
				case bottomRightRotateBtn:
				case leftMiddleBtn:
				case rightMiddleBtn:
				case topMiddleBtn:
				case bottomMiddleBtn:
					instance.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
					break;
				case centerBtn:					
					if (_centerMoveable)
					{
						centerBtn.doubleClickEnabled = true;
						centerBtn.addEventListener(MouseEvent.DOUBLE_CLICK, centerDblClickHandler, false, 0, true);
						centerBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
					}
					break;
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			// go through each Handle and remove the appropriate event listeners
			switch(instance)
			{
				case skewTopBtn:
				case skewBottomBtn:
				case skewRightBtn:
				case skewLeftBtn:
				case topLeftBtn:
				case topRightBtn:
				case bottomLeftBtn:
				case bottomRightBtn:
				case topLeftRotateBtn:
				case topRightRotateBtn:
				case bottomLeftRotateBtn:
				case bottomRightRotateBtn:
				case leftMiddleBtn:
				case rightMiddleBtn:
				case topMiddleBtn:
				case bottomMiddleBtn:
					instance.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					break;
				case centerBtn:
					centerBtn.doubleClickEnabled = false;
					centerBtn.removeEventListener(MouseEvent.DOUBLE_CLICK, centerDblClickHandler);
					centerBtn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					break;
			}
		}
		
		/**
		 * Function for activating the selection box after a selection has been made in the work area
		 * @param oparent The parent to the elements
		 */
		public function select(parentContainer:DisplayObjectContainer, objects:Vector.<Element>, identityBounds:Boolean, listenForMove:Boolean = true):void
		{
			_identityBounds = identityBounds;
			_parentContainer = parentContainer;
			
			// the elements that are to be transformed
			_elements = new Vector.<Element>();
			
			//flipA = flipD = false;
			
			// a dictionary list of elements and their original matrix
			dict = new Dictionary(true);
			
			// the transformed matrix
			transformMatrix = new Matrix();
			
			// sets the elements
			elements = objects;
			
			currentBox = getCurrentRect();
			
			begin(listenForMove);
			
			// dispatch an event to inidicate that a selection has been made
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_INIT, matrices, _elements, getCurrentRect()));
		}
		
		/**
		 * 
		 * @param listenForMove
		 */
		public function begin(listenForMove:Boolean = true):void
		{
			if (_elements && _elements.length > 0 && _parentContainer)
			{
				// initialize global variables
				currentMatrix = new Matrix();
				topLeft = new Point();
				topRight = new Point();
				bottomRight = new Point();
				bottomLeft = new Point();
				pcenter = new Point();
				
				listenerArray = new Array();
				uplistenerArray = new Array();
				
				// set the selected state to 'selected'
				selected = true;
				invalidateSkinState();
				
				// listen for the mouse move event
				// this is for moving an element in the workarea
				if(listenForMove)
				{
					addMouseMoveGlobalListener(mouseDownHandler, mouseMoveUp);
				}
				
				// Handle Skins need to have a width so they can be positioned correctly.
				validateNow();
				
				// display the selection box with the center button in the right place
				redrawSelectionBox();
				
				// initialize the global matrix variables
				totalMatrix = transformMatrix;
				currentMatrix = totalMatrix.clone();
				totalMatrixInversion = totalMatrix.clone();
				totalMatrixInversion.invert();
				
				center = globalToLocal(pcenter);
				adjustBtnByRotation(center, centerBtn);
				
				// get the current elements and their new and old matrices
				matrices = getTransformations();
			}
		}
		
		
		/**
		 * Function for deactivating the selection box or turning it off
		 *
		 */
		public function unSelect(clearItems:Boolean = true):void
		{
			// remove any mouse move listeners
			removeMouseMoveGlobalListener();
			totalMatrix = null;
			totalMatrixInversion = null;
			currentBox = null;
			
			// clear any graphics on the transformation later
			graphics.clear();
			
			if(clearItems && elements)
			{
				_elements.splice(0, _elements.length);
			}
			
			// set the selected state to 'nonselected'
			selected = false;
			invalidateSkinState();
			
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_DEACTIVATED, null, null, null));
		}
		
		
		/**
		 * Public function that can be called to update the selection box.
		 * This is useful for when applying transformations outside of the selection box.
		 * Call this after making a transformation so that the selection box stays current
		 * @param identityBounds If the selection box should display the identity bounds
		 */
		public function update(updateCenter:Boolean = true, identityBounds:Boolean = false):void
		{
			if (_elements && _elements.length > 0 && _parentContainer)
			{
				// set the selected state to 'selected'
				selected = true;
				invalidateSkinState();
				
				// update the display of the selection box
				redrawSelectionBox(updateCenter, identityBounds);
				
				// update the global matrices from the selected elements 
				totalMatrix = transformMatrix;
				totalMatrixInversion = totalMatrix.clone();
				totalMatrixInversion.invert();
				currentMatrix = totalMatrix.clone();
				
				currentBox = getCurrentRect();
			}
		}
		
		/**
		 * The function for grabbing the four corners of a rectangle around the selected elements
		 * @param topLeft 
		 * @param topRight
		 * @param bottomRight
		 * @param bottomLeft
		 * @param resetBounds
		 */
		protected function findCorners(updateBounds:Boolean = false):void
		{			
			// if we want to update the selection box
			if (updateBounds)
			{
				updateTransformMatrix();
			}
			
			var topLeftTemp:Point;
			var topRightTemp:Point;
			var bottomRightTemp:Point;
			var bottomLeftTemp:Point;
			
			var temp:Rectangle;
			if (_elements.length > 1 || _identityBounds)
			{
				temp = new Rectangle(0,0,dict[this].width,dict[this].height);
			}
			else
			{
				temp = _rect.clone();
			}
			
			// if we want to maintain the handle positions
			if (maintainHandlePosition)
			{
				var bc:Point = temp.bottomRight.clone();
				var tc:Point = temp.topLeft.clone();
				
				// if the x scale is in the negative 
				if (flipA)
				{		
					// swap the x positions between the top left and bottom right
					temp.bottomRight = new Point(tc.x, temp.bottomRight.y);
					temp.topLeft = new Point(bc.x, temp.topLeft.y);
				}
				
				// if the y scale is in the negative
				if (flipD)
				{
					// swap the y positions between the top left and bottom right
					temp.bottomRight = new Point(temp.bottomRight.x, tc.y);
					temp.topLeft = new Point(temp.topLeft.x, bc.y);
				}
			}
			
			// find the four corners around the element
			topLeftTemp = transformMatrix.transformPoint(temp.topLeft);
			topRightTemp = transformMatrix.transformPoint(new Point(temp.bottomRight.x, temp.topLeft.y));
			bottomRightTemp = transformMatrix.transformPoint(temp.bottomRight);
			bottomLeftTemp = transformMatrix.transformPoint(new Point(temp.topLeft.x, temp.bottomRight.y));
			
			topLeft.x = topLeftTemp.x;
			topLeft.y = topLeftTemp.y;
			topRight.x = topRightTemp.x;
			topRight.y = topRightTemp.y;
			bottomRight.x = bottomRightTemp.x;
			bottomRight.y = bottomRightTemp.y;
			bottomLeft.x = bottomLeftTemp.x;
			bottomLeft.y = bottomLeftTemp.y;
		}
		
		/**
		 * 
		 * @return 
		 */
		protected function getCurrentRect():Rectangle
		{
			return VisualElementUtil.getElementsRectangle(_elements, _parentContainer, true);
		}
		
		/**
		 * Function for appending a matrix to all of the selected elements
		 * @param mtx The matrix to be used for appending to the selected elements
		 */
		protected function addTransformation(mtx:Matrix):void
		{
			var element:Element;
			var matrix:Matrix;
			
			if (_elements.length > 1 || _identityBounds)
			{
				// go through each element and append the transformation for each element
				for each (element in _elements)
				{
					matrix = dict[element].clone();
					matrix.concat(mtx);
					element.transform.matrix = matrix;
				}
			}
			else if (_elements.length == 1)
			{
				_elements[0].transform.matrix = mtx;
			}
			
			transformMatrix = mtx.clone();
		}
		
		/**
		 *
		 * @return
		 */
		public function currentTransformation():Matrix
		{
			
			// find the updated rectangle and return the transformation matrix
			return transformMatrix;
		}
		
		/**
		 * Function for creating a dictionary list of elements
		 * Also used for setting the transformation matrix 
		 * 
		 */ 
		protected function updateTransformMatrix():void
		{
			
			// make sure that we have elements
			if (_elements && _elements.length > 0)
			{
				
				// find the bounding rectangle
				updateRect();
				
				// go through each element and set it in the dictionary list
				for each (var element:Element in _elements)
				{
					// the original matrix adjusted to the bounding rectangle
					dict[element] = element.transform.matrix.clone();
					dict[element].tx -= _rect.x;
					dict[element].ty -= _rect.y;
				}
				
				// record the bounding rectangle
				dict[this] = _rect.clone();
				
				// get the identity bounding box and set its position to the rectangle
				
				if (_elements.length > 1 || _identityBounds)
				{
					transformMatrix.identity();
					transformMatrix.tx = _rect.x;
					transformMatrix.ty = _rect.y;
				}
				else if (_elements.length == 1)
				{
					transformMatrix = _elements[0].transform.matrix;
				}
				
				// update the global matrices from the selected elements 
				totalMatrix = transformMatrix;
				totalMatrixInversion = totalMatrix.clone();
				totalMatrixInversion.invert();
			}
		}
		
		/** 
		 * Function used for refreshing the bounding rectangle over the elements
		 * 
		 */ 
		protected function updateRect():void
		{
			_rect = (_elements.length > 1 || _identityBounds) ? VisualElementUtil.getElementsRectangle(_elements, _parentContainer) : VisualElementUtil.getElementRectangle(_elements[0], _parentContainer, false);
		}
		
		/**
		 * This function returns a boolean value to indicate if a point is located within a selection box or an element
		 * @param point The point to test. This point must already have been converted to a local point within the work area or transform layer.
		 * @return A boolean value to indicate if the point is within the selection box.
		 */
		public function isPointInsideOfElement(point:Point):Boolean
		{
			
			var isInside:Boolean = false;
			
			if (_elements && _elements.length > 0 && _parentContainer)
			{
				// get the corners for the selection box
				findCorners(false);
				
				topLeft = CoordinateUtils.localToLocal(_parentContainer, this, topLeft);
				topRight = CoordinateUtils.localToLocal(_parentContainer, this, topRight);
				bottomLeft = CoordinateUtils.localToLocal(_parentContainer, this, bottomLeft);
				bottomRight = CoordinateUtils.localToLocal(_parentContainer, this, bottomRight);
				
				// put all x-values in an array
				var xArray:Array = new Array();
				xArray.push(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
				
				// put all y-values in an array
				var yArray:Array = new Array();
				yArray.push(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
				
				// loop through the coordinates and check each side of the selection box to see if the mouse click was inside
				var j:int = 3;
				for(var i:int = 0; i < 4; i++)
				{
					if(yArray[ i ] < point.y && yArray[ j ] >= point.y || yArray[ j ] < point.y && yArray[ i ] >= point.y)
					{
						if(xArray[ i ] + (point.y - yArray[ i ]) / (yArray[ j ] - yArray[ i ]) * (xArray[ j ] - xArray[ i ]) < point.x)
						{
							isInside = !isInside;
						}
					}
					j = i;
				}
			}
			
			return isInside;
		}
		
		/**
		 * Returns the current matrix of the selected elements
		 * @return 
		 */
		public function getCurrentRotation():Number
		{
			if (totalMatrixInversion && transformMatrix)
			{			
				var crt:Point = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(center)));
				var um:Matrix = transformMatrix.clone();
				
				if (flipA)
				{
					um.translate(-crt.x, -crt.y);			
					um.scale(-1, 1);
					um.translate(crt.x, crt.y);
				}
				
				if (flipD)
				{
					um.translate(-crt.x, -crt.y);			
					um.scale(1, -1);
					um.translate(crt.x, crt.y);
				}
				
				var scaleX:Number = Math.sqrt(Math.pow(um.a, 2) + Math.pow(um.b, 2));
				var r:Number = Math.acos(um.a / scaleX);				
				if(Math.asin(um.b / scaleX) < 0)
				{
					r *= -1;
				}
				
				return r;
			}
			else
			{
				return 0; 
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getSkewX():Number
		{
			var um:Matrix = removeRotation(transformMatrix);			
			var vSkewX:Number = Math.atan(-um.c / um.d);
			
			if (um.d < 0)
			{
				vSkewX *= -1;
			}
			
			return vSkewX;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getSkewY():Number
		{		
			// This doesn't quite work yet
			
			/*var crt:Point = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(center)));
			var um:Matrix = transformMatrix.clone();
			
			if (um.a < 0)
			{
			um.translate(-crt.x, -crt.y);			
			um.scale(-1, 1);
			um.translate(crt.x, crt.y);
			}
			
			if (um.d < 0)
			{
			um.translate(-crt.x, -crt.y);			
			um.scale(1, -1);
			um.translate(crt.x, crt.y);
			}
			
			var offSet:Number = getSkewX();
			var rot:Number = getCurrentRotation();
			
			var r:Number = rot + offSet;
			
			// remove the rotation from the matrix
			um.translate(-crt.x, -crt.y);	
			um.rotate(-r);
			um.translate(crt.x, crt.y);
			
			var vSkewY:Number = Math.atan(-um.b / um.a);
			
			if (um.a < 0)
			{
			vSkewY *= -1;
			}
			
			return vSkewY;*/
			
			return 0;
		}
		
		private function removeRotation(m:Matrix):Matrix
		{
			var um:Matrix = m.clone();
			
			if (totalMatrixInversion)
			{			
				var crt:Point = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(center)));
				
				if (um.a < 0)
				{
					um.translate(-crt.x, -crt.y);			
					um.scale(-1, 1);
					um.translate(crt.x, crt.y);
				}
				
				if (um.d < 0)
				{
					um.translate(-crt.x, -crt.y);			
					um.scale(1, -1);
					um.translate(crt.x, crt.y);
				}
				
				// remove the rotation from the matrix
				var scalerX:Number = Math.sqrt(Math.pow(um.a, 2) + Math.pow(um.b, 2));
				var r:Number = Math.acos(um.a / scalerX);				
				if(Math.asin(um.b / scalerX) < 0)
				{
					r *= -1;
				}			
				
				// remove the rotation from the matrix
				um.translate(-crt.x, -crt.y);					
				um.rotate(-r);
				um.translate(crt.x, crt.y);
			}
			
			return um;
		}
		
		/**
		 * This function is used for updating the display of the selection box
		 * @param updateRefPoint If the center button should go back to the center
		 * @param isSkew If the transformation was a skew
		 * @param identityBounds If the selection box should display the identity bounds
		 */
		protected function redrawSelectionBox(updateRefPoint:Boolean = true, identityBounds:Boolean = false):void
		{
			var tmp:Point;
			
			// get the four corners of the selected elements
			findCorners(identityBounds);
			
			// find these points globally
			topLeft = _parentContainer.localToGlobal(topLeft);
			topRight = _parentContainer.localToGlobal(topRight);
			bottomRight = _parentContainer.localToGlobal(bottomRight);
			bottomLeft = _parentContainer.localToGlobal(bottomLeft);
			
			// find the global center point
			tmp = new Point(0.25 * (topLeft.x + topRight.x + bottomRight.x + bottomLeft.x), 0.25 * (topLeft.y + topRight.y + bottomRight.y + bottomLeft.y));
			
			pcenter.x = tmp.x;
			pcenter.y = tmp.y;
			
			// if we want the center point to stay in the center
			if(updateRefPoint)
			{
				// update the center point's location
				tmp = new Point(pcenter.x, pcenter.y);
				tmp = globalToLocal(tmp);
				center.x = tmp.x;
				center.y = tmp.y;
			}
			
			// convert these points back to local coordinates
			topLeft = globalToLocal(topLeft);
			topRight = globalToLocal(topRight);
			bottomRight = globalToLocal(bottomRight);
			bottomLeft = globalToLocal(bottomLeft);
			
			if (selectionBounds)
			{
				selectionBounds.width = _rect.width;
				selectionBounds.height = _rect.height;
				
				var sm:Matrix = transformMatrix.clone();				
				sm.concat(_parentContainer.transform.concatenatedMatrix);
				
				var temp:Rectangle;
				if (_elements.length > 1 || _identityBounds)
				{
					temp = new Rectangle(0,0,dict[this].width,dict[this].height);
				}
				else
				{
					temp = _rect.clone();
				}
				
				with (globalToLocal(_parentContainer.localToGlobal(transformMatrix.transformPoint(temp.topLeft))))
				{
					sm.ty = y;
					sm.tx = x;
				}
				
				selectionBounds.transform.matrix = sm;
			}
			
			// some fancy math to make sure the corner buttons are rotated properly
			// This is so that if the buttons have graphics, then the graphics will 
			// always display according to the transformation.
			var tmp2:Point = new Point();
			tmp.x = topLeft.x - topRight.x;
			tmp.y = topLeft.y - topRight.y;
			tmp2.x = topLeft.x - bottomLeft.x;
			tmp2.y = topLeft.y - bottomLeft.y;
			tmp.normalize(1);
			tmp2.normalize(1);
			tmp.x += tmp2.x;
			tmp.y += tmp2.y;
			tmp2.x = Math.atan2(tmp.y, tmp.x) * 180 / Math.PI;
			
			if (topLeftBtn.rotateWithSelectionBox)	
				topLeftBtn.rotation = (tmp2.x + 135);
			if (topLeftRotateBtn.rotateWithSelectionBox)  
				topLeftRotateBtn.rotation = (tmp2.x + 135);
			
			if (bottomRightBtn.rotateWithSelectionBox)  
				bottomRightBtn.rotation = (tmp2.x + 135);
			if (bottomRightRotateBtn.rotateWithSelectionBox)  
				bottomRightRotateBtn.rotation = (tmp2.x + 135);
			
			// top left
			adjustBtnByRotation(topLeft, topLeftBtn);			
			adjustBtnByRotation(topLeft, topLeftRotateBtn);
			adjustBtnByRotation(bottomRight, bottomRightBtn);
			adjustBtnByRotation(bottomRight, bottomRightRotateBtn);
			
			tmp.x = topRight.x - topLeft.x;
			tmp.y = topRight.y - topLeft.y;
			tmp2.x = topRight.x - bottomRight.x;
			tmp2.y = topRight.y - bottomRight.y;
			tmp.normalize(1);
			tmp2.normalize(1);
			tmp.x += tmp2.x;
			tmp.y += tmp2.y;
			tmp2.x = Math.atan2(tmp.y, tmp.x) * 180 / Math.PI;
			
			
			if (topRightBtn.rotateWithSelectionBox)
				topRightBtn.rotation = (tmp2.x + 45);
			if (topRightRotateBtn.rotateWithSelectionBox)
				topRightRotateBtn.rotation = (tmp2.x + 45);
			
			if (bottomLeftBtn.rotateWithSelectionBox)
				bottomLeftBtn.rotation = (tmp2.x + 45);
			if (bottomLeftRotateBtn.rotateWithSelectionBox)
				bottomLeftRotateBtn.rotation = (tmp2.x + 45);
			
			adjustBtnByRotation(topRight, topRightBtn);			
			adjustBtnByRotation(topRight, topRightRotateBtn);
			adjustBtnByRotation(bottomLeft, bottomLeftBtn);
			adjustBtnByRotation(bottomLeft, bottomLeftRotateBtn);
			
			// calculate the rotation between topLeft and topRight
			var btnRotation:Number = Math.atan2(topRight.y - topLeft.y, topRight.x - topLeft.x) * 180 / Math.PI;
			
			// calculate the rotation between topLeft and bottomLeft
			var btnRotation2:Number = (Math.atan2(bottomLeft.y - topLeft.y, bottomLeft.x - topLeft.x) * 180 / Math.PI) - 90;
			
			// use the rotations calculated above to determine the rotation of the middle and skew buttons
			// only rotate if it is a Handle and is allowed to rotate
			if (rightMiddleBtn.rotateWithSelectionBox) 
				rightMiddleBtn.rotation = btnRotation;
			if (topMiddleBtn.rotateWithSelectionBox) 
				topMiddleBtn.rotation = btnRotation;
			if (bottomMiddleBtn.rotateWithSelectionBox) 
				bottomMiddleBtn.rotation = btnRotation2;
			if (leftMiddleBtn.rotateWithSelectionBox) 
				leftMiddleBtn.rotation = btnRotation2;
			
			if (skewRightBtn.rotateWithSelectionBox)
				skewRightBtn.rotation = btnRotation;
			if (skewTopBtn.rotateWithSelectionBox)
				skewTopBtn.rotation = btnRotation;
			if (skewBottomBtn.rotateWithSelectionBox)
				skewBottomBtn.rotation = btnRotation2;
			if (skewLeftBtn.rotateWithSelectionBox)
				skewLeftBtn.rotation = btnRotation2;
			
			adjustBtnByRotation(Point.interpolate(topRight, bottomRight, 0.5), rightMiddleBtn);
			adjustBtnByRotation(Point.interpolate(topRight, bottomRight, 0.5), skewRightBtn);			
			adjustBtnByRotation(Point.interpolate(topLeft, topRight, 0.5), topMiddleBtn);
			adjustBtnByRotation(Point.interpolate(topLeft, topRight, 0.5), skewTopBtn);			
			adjustBtnByRotation(Point.interpolate(bottomRight, bottomLeft, 0.5), bottomMiddleBtn);
			adjustBtnByRotation(Point.interpolate(bottomRight, bottomLeft, 0.5), skewBottomBtn);		
			adjustBtnByRotation(Point.interpolate(bottomLeft, topLeft, 0.5), leftMiddleBtn);
			adjustBtnByRotation(Point.interpolate(bottomLeft, topLeft, 0.5), skewLeftBtn);
			
			// also rotate the center button
			if (centerBtn.rotateWithSelectionBox)
				centerBtn.rotation = btnRotation;
			adjustBtnByRotation(center, centerBtn);
		}
		
		private function adjustBtnByRotation(btnp:Point, btn:Sprite, width:Boolean = true, height:Boolean = true):void
		{
			var tempM:Matrix = new Matrix();
			tempM.translate(-btnp.x, -btnp.y);
			tempM.rotate(btn.rotation * (Math.PI / 180));
			tempM.translate(btnp.x, btnp.y);	
			
			var tempP:Point = tempM.transformPoint(new Point((width) ? (btnp.x - (btn.width / 2)) : btnp.x, (height) ? (btnp.y - (btn.height / 2)) : btnp.y));			
			btn.x = tempP.x;
			btn.y = tempP.y;
		}
		
		
		/**
		 * Handler function for when the mouse is pressed down on one of the selection box handlers
		 * @param event The mouse down event
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget.visible && totalMatrixInversion)
			{			
				// remove any mouse move listeners
				removeMouseMoveGlobalListener();
				
				ctrp1 = new Point();
				ctrp2 = center.clone();
				ctrp2 = localToGlobal(ctrp2);
				
				// grab the global mouse down location
				globalMouseDownPoint = new Point(event.stageX, event.stageY);
				
				// determine the local mouse down location
				localMouseDownPoint = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(globalMouseDownPoint));
				
				// offset for when the user clicks anyway inside the handle
				buttonOffset = CoordinateUtils.localToLocal(event.currentTarget, this, new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
				
				cMode = TransformMode.MODE_IDLE;
				
				// check which button was clicked on
				if (event.currentTarget is Handle)
				{
					var btn:Handle = Handle(event.currentTarget);
					switch(btn)
					{
						case skewTopBtn:
							with (Point.interpolate(topLeft, topRight, 0.5)) 
							{ 
								ctrp1.x = x; 
								ctrp1.y = y; 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y; 
							}
							cMode = TransformMode.MODE_SKEWX;
							break;
						case skewBottomBtn:
							with (Point.interpolate(bottomRight, bottomLeft, 0.5)) 
							{ 
								ctrp1.x = x; 
								ctrp1.y = y; 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y; 
							}
							cMode = TransformMode.MODE_SKEWX;
							break;
						case skewRightBtn:
							with (Point.interpolate(topRight, bottomRight, 0.5)) 
							{ 
								ctrp1.x = x; 
								ctrp1.y = y; 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y; 
							}
							cMode = TransformMode.MODE_SKEWY;
							break;
						case skewLeftBtn:
							with (Point.interpolate(bottomLeft, topLeft, 0.5)) 
							{ 
								ctrp1.x = x; 
								ctrp1.y = y; 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y; 
							}
							cMode = TransformMode.MODE_SKEWY;
							break;
						case topLeftRotateBtn:
							buttonOffset.x = topLeft.x - buttonOffset.x;
							buttonOffset.y = topLeft.y - buttonOffset.y;
							ctrp1 = bottomRight;
							cMode = TransformMode.MODE_ROTATE;
							break;
						case topLeftBtn:
							buttonOffset.x = topLeft.x - buttonOffset.x;
							buttonOffset.y = topLeft.y - buttonOffset.y;
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : bottomRight;
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALE;
							break;
						case topRightRotateBtn:
							buttonOffset.x = topRight.x - buttonOffset.x;
							buttonOffset.y = topRight.y - buttonOffset.y;
							ctrp1 = bottomLeft;
							cMode = TransformMode.MODE_ROTATE;
							break;
						case topRightBtn:
							buttonOffset.x = topRight.x - buttonOffset.x;
							buttonOffset.y = topRight.y - buttonOffset.y;
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : bottomLeft;
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALE;
							break;
						case bottomLeftRotateBtn:
							buttonOffset.x = bottomLeft.x - buttonOffset.x;
							buttonOffset.y = bottomLeft.y - buttonOffset.y;
							ctrp1 = topRight;
							cMode = TransformMode.MODE_ROTATE;
							break;
						case bottomLeftBtn:
							buttonOffset.x = bottomLeft.x - buttonOffset.x;
							buttonOffset.y = bottomLeft.y - buttonOffset.y;
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : topRight;
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALE;
							break;
						case bottomRightRotateBtn:
							buttonOffset.x = bottomRight.x - buttonOffset.x;
							buttonOffset.y = bottomRight.y - buttonOffset.y;
							ctrp1 = topLeft;
							cMode = TransformMode.MODE_ROTATE;
							break;
						case bottomRightBtn:
							buttonOffset.x = bottomRight.x - buttonOffset.x;
							buttonOffset.y = bottomRight.y - buttonOffset.y;
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : topLeft;
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALE;
							break;
						case topMiddleBtn:	
							with (Point.interpolate(topRight, topLeft, 0.5)) 
							{ 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y;
							}	
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : Point.interpolate(bottomRight, bottomLeft, 0.5);
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALEY;					
							break;
						case bottomMiddleBtn:
							with (Point.interpolate(bottomRight, bottomLeft, 0.5)) 
							{ 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y;
							}
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : Point.interpolate(topLeft, topRight, 0.5);
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALEY;		
							break;
						case rightMiddleBtn:							
							with (Point.interpolate(bottomRight, topRight, 0.5)) 
							{ 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y;
							}							
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : Point.interpolate(bottomLeft, topLeft, 0.5);
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALEX;		
							break;
						case leftMiddleBtn:
							with (Point.interpolate(topLeft, bottomLeft, 0.5)) 
							{ 
								buttonOffset.x = x - buttonOffset.x; 
								buttonOffset.y = y - buttonOffset.y;
							}
							ctrp1 = (btn.anchorPoint) ? convertCenterPointEnumToPoint(btn.anchorPoint) : Point.interpolate(topRight, bottomRight, 0.5);
							cMode = (btn.transformMode) ? btn.transformMode : TransformMode.MODE_SCALEX;		
							break;
						case centerBtn:
							cMode = TransformMode.MODE_CENTER_POINT;
							break;
						default:
							ctrp1.x = mouseX;
							ctrp1.y = mouseY;
							cMode = TransformMode.MODE_MOVE;
					}
				}
				else
				{
					// Stage is CurrentTarget
					ctrp1.x = mouseX;
					ctrp1.y = mouseY;
					cMode = TransformMode.MODE_MOVE;
				}
				
				ctrp1 = localToGlobal(ctrp1);
				
				// set the appropriate listeners depending on what type of transformation is being performed
				switch(cMode)
				{
					case TransformMode.MODE_SCALE:
						addMouseMoveGlobalListener(onMouseScale, deactivateHandler);
						break;
					case TransformMode.MODE_SCALEX:
						addMouseMoveGlobalListener(onMouseScaleX, deactivateHandler);
						break;
					case TransformMode.MODE_SCALEY:
						addMouseMoveGlobalListener(onMouseScaleY, deactivateHandler);
						break;
					case TransformMode.MODE_ROTATE:
						addMouseMoveGlobalListener(onMouseRotate, deactivateHandler);
						break;
					case TransformMode.MODE_SKEW:
						addMouseMoveGlobalListener(onMouseSkew, deactivateHandler);
						break;
					case TransformMode.MODE_SKEWY:
						addMouseMoveGlobalListener(onMouseSkewY, deactivateHandler);
						break;
					case TransformMode.MODE_SKEWX:
						addMouseMoveGlobalListener(onMouseSkewX, deactivateHandler);
						break;
					case TransformMode.MODE_MOVE:
						addMouseMoveGlobalListener(onMouseMove, deactivateHandler);
						break;
					case TransformMode.MODE_MOVE_X:
						addMouseMoveGlobalListener(onMouseMoveX, deactivateHandler);
						break;
					case TransformMode.MODE_MOVE_Y:
						addMouseMoveGlobalListener(onMouseMoveY, deactivateHandler);
						break;
					case TransformMode.MODE_CENTER_POINT:
						addMouseMoveGlobalListener(centerPointMouseMove, mouseMoveUp);
						break;
				}
				
				if(cMode != TransformMode.MODE_ROTATE)
				{
					ctrp1 = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(ctrp1));
					ctrp2 = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(ctrp2));
				}
				
				//localMouseDownPoint = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localMouseDownPoint));
				
				event.stopImmediatePropagation();
				
				// grab the matrices for the elements
				matrices = getTransformations();
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_BEGIN, matrices, _elements, getCurrentRect(), cMode));
			}
		}
		
		/**
		 * Convert Enums to Actual Points from handles in a custom TransformLayerSkin
		 */ 
		private function convertCenterPointEnumToPoint(centerPointEnum:String):Point
		{
			switch (centerPointEnum)
			{
				case HandleCenterPointEnum.TOP_LEFT:
					return topLeft;
				case HandleCenterPointEnum.TOP_MIDDLE:
					return Point.interpolate(topLeft, topRight, 0.5);
				case HandleCenterPointEnum.TOP_RIGHT:
					return topRight;
				case HandleCenterPointEnum.LEFT_MIDDLE:
					return Point.interpolate(topLeft, bottomLeft, 0.5);
				case HandleCenterPointEnum.CENTER:
					return center;
				case HandleCenterPointEnum.BOTTOM_LEFT:
					return bottomLeft;
				case HandleCenterPointEnum.BOTTOM_MIDDLE:
					return Point.interpolate(bottomLeft, bottomRight, 0.5);
				case HandleCenterPointEnum.BOTTOM_RIGHT:
					return bottomRight;
			}
			return null;
		}
		
		
		/**
		 * Function called when the mouse button is let go after clicking on a handler
		 * @param event The mouse up event
		 */
		private function deactivateHandler(event:MouseEvent):void
		{
			// remove any mouse move listeners
			removeMouseMoveGlobalListener();
			
			// grab the transformation and identity transformation matrices for the element(s)
			totalMatrix = transformMatrix;
			totalMatrixInversion = totalMatrix.clone();
			totalMatrixInversion.invert();
			ctrp1 = null;
			ctrp2 = null;
			localMouseDownPoint = null;
			currentMatrix.identity();
			
			// Remove SkewLock
			skewLocked = false;
			
			// if we want to maintain the handle positions and the transformation was a scale
			if (maintainHandlePosition && (cMode == TransformMode.MODE_SCALE || cMode == TransformMode.MODE_SCALEX || cMode == TransformMode.MODE_SCALEY))
			{
				flipA = (transformMatrix.a < 0) ? true : false;
				flipD = (transformMatrix.d < 0) ? true : false;
			}
			
			// dispatch an event to indicate that the transformation is finished
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect()));
		}
		
		
		/**
		 * Function for adding a global mouse move and mouse up listener
		 * @param listener The function to call when the mouse is pressed down on a handler
		 * @param uplistener The function to call when the mouse is let go
		 */
		private function addMouseMoveGlobalListener(listener:Function, uplistener:Function = null):void
		{
			// if the global collection does not contain the listener then add it
			if(listenerArray.indexOf(listener) == -1)
			{
				listenerArray.push(listener);
			}
			
			// add the listener to the stage
			stage.addEventListener(MouseEvent.MOUSE_MOVE, listener, false, 0, false);
			
			// an up listener was specified
			if(uplistener != null)
			{
				// if the global collection does not contain the listener then add it
				if(uplistenerArray.indexOf(listener) == -1)
				{
					uplistenerArray.push(uplistener);
				}
				
				// add the listener to the stage
				stage.addEventListener(MouseEvent.MOUSE_UP, uplistener, false, 0, false);
			}
		}
		
		
		/**
		 * Method removes all global mouse move listeners
		 *
		 */
		private function removeMouseMoveGlobalListener():void
		{
			var func:Function;
			
			// if the array isn't null
			if(listenerArray != null)
			{
				// go through each function in the array and remove it
				for each(func in listenerArray)
				{
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, func);
				}
				
				// empty the array
				listenerArray.splice(0, listenerArray.length);
			}
			
			// if the array isn't null
			if(uplistenerArray != null)
			{
				// go through each function in the array and remove it
				for each(func in uplistenerArray)
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, func);
				}
				
				// empty the array
				uplistenerArray.splice(0, uplistenerArray.length);
			}
		}
		
		
		/**
		 * Function for creating the dictionary list of elements and their original matrices
		 *
		 */
		private function getTransformations():Dictionary
		{
			// create a new dictionary
			var dict:Dictionary = new Dictionary();
			
			// go through each element and add it to the dictionary
			for each(var element:Element in elements)
			{
				dict[ element ] = { matrix:element.transform.matrix.clone(), concatenatedMatrix:element.transform.concatenatedMatrix.clone()};
			}
			
			return dict;
		}
		
		
		/**
		 * General function for when a mouse button is let go
		 *
		 */
		private function mouseMoveUp(event:Event):void
		{
			// remove any mouse move listeners
			removeMouseMoveGlobalListener();
		}
		
		
		/**
		 * Function that is called when the center button is double clicked.
		 */
		private function centerDblClickHandler(event:MouseEvent):void
		{
			// grab the center point on the stage and convert it locally for setting the center button
			center = new Point(pcenter.x, pcenter.y);
			center = globalToLocal(center);
			adjustBtnByRotation(center, centerBtn);
		}
		
		
		/**
		 * Function to call when moving the center button
		 * @param The mouse click event
		 *
		 */
		private function centerPointMouseMove(event:MouseEvent):void
		{
			// move the center button to where ever the mouse is
			center = globalToLocal(new Point(event.stageX, event.stageY));
			adjustBtnByRotation(center, centerBtn);
		}
		
		
		/**
		 * Mouse move handler function
		 * @param The mouse click event
		 */
		private function onMouseMove(event:MouseEvent):void
		{
			// get the center point
			var gp:Point = ctrp1;
			
			// calculate the new location
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			currentMatrix.identity();
			p.x = (gp.x - p.x);
			p.y = (gp.y - p.y);
			
			// alter the element's location
			currentMatrix.translate(-p.x, -p.y);
			currentMatrix.concat(totalMatrix);
			addTransformation(currentMatrix);
			
			// update the selection box and dispatch an event
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		/**
		 * Mouse move handler function
		 * @param The mouse click event
		 */
		private function onMouseMoveX(event:MouseEvent):void
		{
			// Calculate Mouse Delta from MouseDown
			var mouseDownPoint:Point = _parentContainer.globalToLocal(globalMouseDownPoint);
			var mouseMovePoint:Point = new Point(_parentContainer.mouseX, _parentContainer.mouseY);
			var delta:Point = new Point();
			delta.x = mouseMovePoint.x - mouseDownPoint.x;
			delta.y = mouseMovePoint.y - mouseDownPoint.y;
			
			currentMatrix = totalMatrix.clone();
			currentMatrix.translate(delta.x, 0);
			
			addTransformation(currentMatrix);
			
			// update the selection box and dispatch an event
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		/**
		 * Mouse move handler function
		 * @param The mouse click event
		 */
		private function onMouseMoveY(event:MouseEvent):void
		{
			// Calculate Mouse Delta from MouseDown
			var mouseDownPoint:Point = _parentContainer.globalToLocal(globalMouseDownPoint);
			var mouseMovePoint:Point = new Point(_parentContainer.mouseX, _parentContainer.mouseY)
			var delta:Point = new Point();
			delta.x = mouseMovePoint.x - mouseDownPoint.x;
			delta.y = mouseMovePoint.y - mouseDownPoint.y;
			
			currentMatrix = totalMatrix.clone();
			currentMatrix.translate(0, delta.y);
			
			addTransformation(currentMatrix);
			
			// update the selection box and dispatch an event
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		/**
		 * Moves the elements the amount specified from the current position
		 * @param moveX
		 * @param moveY
		 */
		public function nudge(moveX:Number, moveY:Number):void
		{
			if(elements)
			{
				matrices = getTransformations();
				
				// alter the element's location
				currentMatrix.identity();
				currentMatrix.translate(moveX, moveY);
				currentMatrix.concat(totalMatrix);
				addTransformation(currentMatrix);
				
				// update the selection box and dispatch an event
				redrawSelectionBox();
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_NUDGE));
			}
		}
		
		/**
		 * Moves the elements to the specified point
		 * @param p
		 */
		public function moveTo(p:Point, byBoundingBox:Boolean = false):void
		{
			if(elements)
			{
				var changed:Boolean = false;
				if (byBoundingBox && !_identityBounds)
				{					
					changed = true;
					_identityBounds = true;
					updateTransformMatrix();
				} 
				else if (byBoundingBox)
				{
					updateTransformMatrix();
				}
				
				matrices = getTransformations();
				
				if (totalMatrix)
				{				
					currentMatrix = totalMatrix.clone();
					currentMatrix.tx = p.x;
					currentMatrix.ty = p.y;
					addTransformation(currentMatrix);
				}
				
				if (byBoundingBox && changed)
				{
					_identityBounds = false;
					updateTransformMatrix();
				}
				
				// update the selection box and dispatch an event
				redrawSelectionBox();
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_MOVETO));
			}
		}
		
		/**
		 * 
		 * @param axis
		 */
		public function flip(axis:String):void
		{
			if(elements)
			{
				matrices = getTransformations();
				
				var gp:Point = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(center)));
				
				currentMatrix.identity();
				currentMatrix.translate(-gp.x, -gp.y);			
				currentMatrix.scale((axis == TransformFlip.HORIZONTAL || axis == TransformFlip.BOTH) ? -1 : 1, (axis == TransformFlip.VERTICAL || axis == TransformFlip.BOTH) ? -1 : 1);
				currentMatrix.translate(gp.x, gp.y);
				currentMatrix.concat(totalMatrix);
				addTransformation(currentMatrix);
				
				// if we want to maintain the handle positions
				if (maintainHandlePosition)
				{
					if ((axis == TransformFlip.HORIZONTAL || axis == TransformFlip.BOTH))
					{
						flipA = !flipA;
					}
					
					if ((axis == TransformFlip.VERTICAL || axis == TransformFlip.BOTH))
					{
						flipD = !flipD;
					}
				}
				
				redrawSelectionBox();
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_FLIP));
			}
		}
		
		/**
		 * Rotate handling function
		 * @param The mouse click event
		 */
		private function onMouseRotate(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp1.clone() : ctrp2.clone();
			var ms:Point = new Point(event.stageX - gp.x, event.stageY - gp.y);
			var md:Point = new Point(globalMouseDownPoint.x - gp.x, globalMouseDownPoint.y - gp.y);
			
			var alfa:Number = Math.atan2(md.x * ms.y - md.y * ms.x, md.x * ms.x + md.y * ms.y);
			
			if(event.shiftKey)
			{
				alfa = -(Math.PI * (-(int(Math.floor(4 * (alfa) / Math.PI))) + 3)) / 4;
			}
			
			rotate(alfa, gp);
			
			redrawSelectionBox(event.altKey);
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}	
		
		/**
		 * Public function to rotate the elements
		 * @param angle The angle by which to rotate the elements
		 */
		public function rotateElements(angle:Number, fromOrigin:Boolean = false):void
		{
			if(elements)
			{
				matrices = getTransformations();
				rotate(angle * (Math.PI / 180), localToGlobal(center), fromOrigin);
				
				redrawSelectionBox(false);
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_ROTATE));
			}
		}
		
		private function rotate(angle:Number, anchor:Point, fromOrigin:Boolean = false):void
		{
			var m:Matrix = _parentContainer.transform.concatenatedMatrix.clone();
			m.tx = _parentContainer.transform.matrix.tx;
			m.ty = _parentContainer.transform.matrix.ty;
			
			anchor = m.transformPoint(_parentContainer.globalToLocal(anchor));
			
			var localMatrix:Matrix = new Matrix();			
			localMatrix.translate(-anchor.x, -anchor.y);
			
			if (fromOrigin)
			{
				if (localMatrix.a < 0)
				{			
					localMatrix.scale(-1, 1);
				}
				
				if (localMatrix.d < 0)
				{			
					localMatrix.scale(1, -1);
				}
				
				localMatrix.rotate(-(getCurrentRotation()));			
			}
			
			localMatrix.rotate(angle);
			localMatrix.translate(anchor.x, anchor.y);
			
			currentMatrix = totalMatrix.clone();
			currentMatrix.concat(m);
			currentMatrix.concat(localMatrix);
			m.invert();
			currentMatrix.concat(m);
			
			addTransformation(currentMatrix);
		}
		
		
		/**
		 * Y scale handling function
		 * @param The mouse click event
		 */
		private function onMouseScaleY(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp2 : ctrp1;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			currentMatrix.identity();
			p.y = ((gp.y - p.y) - buttonOffset.y) / ((gp.y - localMouseDownPoint.y) - buttonOffset.y);
			
			currentMatrix.translate(0, -gp.y);
			currentMatrix.scale(1, p.y);
			currentMatrix.translate(0, gp.y);
			currentMatrix.concat(totalMatrix);
			addTransformation(currentMatrix);
			
			redrawSelectionBox(!event.altKey);
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		
		/**
		 * X scale handling function
		 * @param The mouse click event
		 */
		private function onMouseScaleX(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp2 : ctrp1;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			currentMatrix.identity();
			p.x = ((gp.x - p.x) - buttonOffset.x) / ((gp.x - localMouseDownPoint.x) - buttonOffset.x);
			
			currentMatrix.translate(-gp.x, 0);
			currentMatrix.scale(p.x, 1);
			currentMatrix.translate(gp.x, 0);
			currentMatrix.concat(totalMatrix);
			
			addTransformation(currentMatrix);
			
			redrawSelectionBox(!event.altKey);
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		
		/**
		 * X and Y scale handling function
		 * @param The mouse click event
		 */
		private function onMouseScale(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp2 : ctrp1;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			currentMatrix.identity();
			p.x = ((gp.x - p.x) - buttonOffset.x) / ((gp.x - localMouseDownPoint.x) - buttonOffset.x);
			p.y = ((gp.y - p.y) - buttonOffset.y) / ((gp.y - localMouseDownPoint.y) - buttonOffset.y);
			
			if((scaleProportional && !event.shiftKey) || (!scaleProportional && event.shiftKey))
			{
				p.x = Math.min(p.x, p.y);
				p.y = p.x;
			}
			
			currentMatrix.translate(-gp.x, -gp.y);
			currentMatrix.scale(p.x, p.y);
			currentMatrix.translate(gp.x, gp.y);
			currentMatrix.concat(totalMatrix);
			addTransformation(currentMatrix);
			
			redrawSelectionBox(!event.altKey);
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		/**
		 * Scales the elements based on the bounding box
		 * @param anchor
		 * @param x
		 * @param y
		 */
		public function scaleByBoundingBox(anchor:String, x:Number = 1, y:Number = 1):void
		{
			if(elements)
			{
				var gp:Point = convertCenterPointEnumToPoint(anchor);
				
				if (gp)
				{																						
					// updates values on the transform layer for use by the bounding box
					var changed:Boolean = false;
					if (!_identityBounds)
					{					
						changed = true;
						_identityBounds = true;
					} 
					
					updateTransformMatrix();
					
					// grab the anchor point and make the transformation
					gp = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(gp)));					
					matrices = getTransformations();					
					scaleRecursive(gp, x, y);
					
					if (changed)
					{
						_identityBounds = false;
						updateTransformMatrix();
					}
					
					redrawSelectionBox();
					
					dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_SCALE));
				}
			}
		}
		
		/**
		 * 
		 * @param anchor
		 * @param x
		 * @param y
		 */
		public function scale(anchor:String, x:Number = 1, y:Number = 1):void
		{
			if(elements)
			{
				var gp:Point = convertCenterPointEnumToPoint(anchor);
				
				if (gp)
				{																						
					gp = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(localToGlobal(gp)));
					
					matrices = getTransformations();
					
					currentMatrix.identity();
					currentMatrix.translate(-gp.x, -gp.y);
					currentMatrix.scale(x, y);
					currentMatrix.translate(gp.x, gp.y);
					currentMatrix.concat(totalMatrix);
					
					addTransformation(currentMatrix);	
					
					redrawSelectionBox();
					
					dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_SCALE));
				}
			}
		}
		
		/**
		 * Public function to scale the elements
		 * @param x The scale along the x axis
		 * @param y The scale along the y axis
		 */
		private function scaleRecursive(gp:Point, x:Number = 1, y:Number = 1, iteration:int = 0):void
		{
			var ic:Rectangle = getCurrentRect();	
			
			currentMatrix.identity();
			currentMatrix.translate(-gp.x, -gp.y);
			currentMatrix.scale(x, y);
			currentMatrix.translate(gp.x, gp.y);
			currentMatrix.concat(totalMatrix);
			
			addTransformation(currentMatrix);	
			
			var rect:Rectangle = getCurrentRect();
			
			var nextIteration:int = iteration;
			nextIteration++;
			
			if (iteration == 10)
			{
				return;
			}			
			
			if (rect.width.toFixed(3) != (ic.width * x).toFixed(3))
			{
				updateTransformMatrix();
				scaleRecursive(gp, ((ic.width * x) / rect.width), 1, nextIteration);
			}
			
			if (rect.height.toFixed(3) != (ic.height * y).toFixed(3))
			{
				updateTransformMatrix();
				scaleRecursive(gp, 1, ((ic.height * y) / rect.height), nextIteration);
			}
		}
		
		
		/**
		 * Mouse Skew handling function
		 * Detects if mouseY or mouseX is greater and only skews on that axis unless alt key is pressed.
		 * @param The mouse click event
		 */
		private function onMouseSkew(event:MouseEvent):void
		{
			var gp:Point = ctrp1;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			var delta:Point = new Point();
			delta.x = p.x - localMouseDownPoint.x;
			delta.y = p.y - localMouseDownPoint.y;
			
			currentMatrix.identity();
			currentMatrix.translate(-gp.x, -gp.y);
			
			// Both X and Y
			if (event.altKey)
			{
				currentMatrix.concat(new Matrix(1, ((localMouseDownPoint.y - p.y) - buttonOffset.y) / ((gp.x - localMouseDownPoint.x) - buttonOffset.x), -(buttonOffset.x + (p.x - localMouseDownPoint.x)) / ((gp.y - localMouseDownPoint.y) - buttonOffset.y), 1)); // SkewX and Y at the same time
			}
			else if ( (skewLocked && !skewVertical) || (!skewLocked && (Math.abs(delta.x) > Math.abs(delta.y)) ))
			{
				// X Only
				if (!skewLocked)
				{
					skewLocked = true;
					skewVertical = false;
				}
				currentMatrix.concat(new Matrix(1, 0, -(buttonOffset.x + (p.x - localMouseDownPoint.x)) / ((gp.y - localMouseDownPoint.y) - buttonOffset.y), 1));
			}
			else
			{
				// Y Only
				if (!skewLocked)
				{
					skewLocked = true;
					skewVertical = true;
				}
				currentMatrix.concat(new Matrix(1, ((localMouseDownPoint.y - p.y) - buttonOffset.y) / ((gp.x - localMouseDownPoint.x) - buttonOffset.x)));
			}
			
			currentMatrix.translate(gp.x, gp.y);
			currentMatrix.concat(totalMatrix);
			
			addTransformation(currentMatrix);
			
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		/**
		 * X skew handling function
		 * @param The mouse click event
		 */
		private function onMouseSkewX(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp1 : ctrp2;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			currentMatrix.identity();
			currentMatrix.translate(-gp.x, -gp.y);
			currentMatrix.concat(new Matrix(1, 0, -(buttonOffset.x + (p.x - localMouseDownPoint.x)) / ((gp.y - localMouseDownPoint.y) - buttonOffset.y), 1));
			currentMatrix.translate(gp.x, gp.y);
			currentMatrix.concat(totalMatrix);
			
			addTransformation(currentMatrix);
			
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		
		/**
		 * Y skew handling function
		 * @param The mouse click event
		 */
		private function onMouseSkewY(event:MouseEvent):void
		{
			var gp:Point = (event.altKey) ? ctrp1 : ctrp2;
			var p:Point = totalMatrixInversion.transformPoint(new Point(_parentContainer.mouseX, _parentContainer.mouseY));
			
			currentMatrix.identity();
			currentMatrix.translate(-gp.x, -gp.y);
			currentMatrix.concat(new Matrix(1, ((localMouseDownPoint.y - p.y) - buttonOffset.y) / ((gp.x - localMouseDownPoint.x) - buttonOffset.x)));
			currentMatrix.translate(gp.x, gp.y);
			currentMatrix.concat(totalMatrix);
			
			addTransformation(currentMatrix);
			
			redrawSelectionBox();
			dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_COMMIT, matrices, _elements, getCurrentRect(), cMode));
		}
		
		
		/**
		 * public function to skew the elements
		 * @param skewX The skew value along the x axis
		 * @param skewY The skew value along the y axis
		 */
		public function skew(skewX:Number = 0, skewY:Number = 0, fromOrigin:Boolean = false):void
		{
			if(elements)
			{
				matrices = getTransformations();
				
				var px:Point = new Point(Point.interpolate(bottomRight, bottomLeft, 0.5).x, Point.interpolate(bottomRight, bottomLeft, 0.5).y);
				px = localToGlobal(px);
				px = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(px));
				
				var py:Point = new Point(Point.interpolate(topLeft, bottomLeft, 0.5).x, Point.interpolate(topLeft, bottomLeft, 0.5).y);
				py = localToGlobal(py);
				py = totalMatrixInversion.transformPoint(_parentContainer.globalToLocal(py));
				
				currentMatrix.identity();
				
				if (fromOrigin)
				{
					var tm:Matrix = removeRotation(totalMatrix);
					var d:Number = tm.d;
					var sd:Number = (-(Math.tan(skewX) * ((d < 0) ? d *= -1 : d)) - tm.c) / tm.a;
					
					//var a:Number = tm.a;
					//var sa:Number = (-(Math.tan(skewY) * ((a < 0) ? a *= -1 : a)) - tm.b) / tm.d;
					
					currentMatrix.translate(-px.x, -px.y);
					currentMatrix.concat(new Matrix(1, 0, sd, 1));
					currentMatrix.translate(px.x, px.y);
					//currentMatrix.translate(-py.x, -py.y);
					//currentMatrix.concat(new Matrix(1, sa));
					//currentMatrix.translate(py.x, py.y);
				}
				else
				{
					currentMatrix.translate(-px.x, -px.y);
					currentMatrix.concat(new Matrix(1, 0, -skewX, 1));
					currentMatrix.translate(px.x, px.y);
					currentMatrix.translate(-py.x, -py.y);
					currentMatrix.concat(new Matrix(1, -skewY));
					currentMatrix.translate(py.x, py.y);
				}
				
				currentMatrix.concat(totalMatrix);			
				addTransformation(currentMatrix);
				
				redrawSelectionBox();
				dispatchEvent(new TransformLayerEvent(TransformLayerEvent.TRANSFORM_FINISH, matrices, _elements, getCurrentRect(), TransformMode.MODE_SKEW));
			}
		}
	}
}