package watercolor.elements.components
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.components.SkinnableContainer;
	import spark.events.ElementExistenceEvent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.elements.interfaces.IElementContainer;
	import watercolor.events.WorkareaEvent;


	/**
	 * The Workarea is the primary editing area for modifying design elements.
	 * It defines a document and selection layer and manages the zooming and
	 * panning of the content.
	 */
	public class Workarea extends SkinnableContainer implements IElementContainer
	{


		/**
		 * The primary content area where the document and its design elements
		 * are displayed. Should contain the content group
		 */
		[SkinPart( required="true" )]
		public var documentLayer:Group;


		/**
		 * The grid.
		 */
		[SkinPart( required="false" )]
		public var grid:Grid;


		private var _currentLayer:Layer;

		/**
		 * The currently selected layer. This layer is where new elements will be added to.
		 */
		public function get currentLayer():Layer
		{
			return _currentLayer;
		}

		/**
		 * @private
		 */
		public function set currentLayer(value:Layer):void
		{
			if (value != _currentLayer)
			{
				_currentLayer = value;
				dispatchEvent(new WorkareaEvent(WorkareaEvent.CURRENT_LAYER_CHANGED));
			}
		}


		/**
		 * Unscaled layer above the document layer where selection and other
		 * tools are drawn.
		 */
		[SkinPart( required="true" )]
		public var selectionLayer:SelectionLayer;


		/**
		 * The masked group containing the document layer, primarily used for
		 * panning (scrolling) and zooming (scaling)
		 */
		[SkinPart( required="true" )]
		public var viewport:Group;


		/**
		 * The masked group containing the document layer, primarily used for
		 * panning (scrolling) and zooming (scaling)
		 */
		[SkinPart( required="false" )]
		public var viewPortScroller:Scroller;


		[SkinPart( required="false" )]
		public var isolationLayer:IsolationLayer;


		/**
		 * Workarea's dots per inch
		 */
		private var _dpi:Number;
		
		
		protected var _editable:Boolean = true;
		
		/**
		 * Can this workarea be edited (i.e. elements selected)
		 */ 
		public function set editable(value:Boolean):void
		{
			_editable = value;
		}
		
		public function get editable():Boolean
		{
			return _editable;
		}


		public function Workarea():void
		{
			addEventListener( ElementExistenceEvent.ELEMENT_ADD, handleContentAdd );
			addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, handleContentRemove );
		}


		public function handleContentAdd( e:ElementExistenceEvent ):void
		{
			if( e.element is Layer )
			{
				currentLayer = Layer( e.element );
			}
		}


		public function handleContentRemove( e:ElementExistenceEvent ):void
		{
			if( e.element is Layer && e.element == currentLayer )
			{
				if( currentLayer == topLayer )
				{
					for( var i:int = 0; i < contentGroup.numElements; i++ )
					{
						if( contentGroup.getElementAt( i ) is Layer && contentGroup.getElementAt( i ) != currentLayer )
						{
							currentLayer = Layer( contentGroup.getElementAt( i ));
							return
						}
					}

					currentLayer = null;

				}
				else
				{
					currentLayer = topLayer;
				}
			}
		}


		public function get dpi():Number
		{
			return _dpi;
		}


		public function set dpi( value:Number ):void
		{
			if( grid )
			{
				grid.dpi = value;
			}

			_dpi = value;
		}


		[Bindable]
		public function set layers( value:ArrayCollection ):void
		{

		}


		public function get layers():ArrayCollection
		{

			var layers:ArrayCollection = new ArrayCollection();

			for( var i:int = 0; i < contentGroup.numElements; i++ )
			{
				if( contentGroup.getElementAt( i ) is Layer )
				{
					layers.addItem( Layer( contentGroup.getElementAt( i )));
				}
			}

			return layers;
		}



		public function get topLayer():Layer
		{
			for( var i:int = 0; i < contentGroup.numElements; i++ )
			{
				if( contentGroup.getElementAt( i ) is Layer )
				{
					return contentGroup.getElementAt( i ) as Layer;
				}
			}
			return null;
		}


		/**
		 * Read-only value of the document layer scale. Use zoomPoint or
		 * zoomRect to set document scale.
		 */
		public function get documentScale():Number
		{
			return documentLayer.scaleX;
		}


		/**
		 * Read-only value of the horizontal position of the document layer.
		 * Use pan to set document position.
		 */
		public function get documentX():Number
		{
			return viewport.horizontalScrollPosition / documentLayer.scaleX;
		}


		/**
		 * Read-only value of the vertical position of the document layer.
		 * Use pan to set document position.
		 */
		public function get documentY():Number
		{
			return viewport.verticalScrollPosition / documentLayer.scaleY;
		}


		/**
		 * Log of 3 over 2, used to calculate the in-between values of 2^n,used
		 * primarily in zooming. Values are in the pattern (parentheses are
		 * LOG3_2 values): 2, (3), 4, (6), 8, (12), 16, (24), 32, (48), 64...
		 */
		private const LOG3_2:Number = Math.log( 1.5 ) / Math.log( 2 );


		/**
		 * Zooms the document by scaling and centering on the selected point.
		 * ZoomPoint scaling snaps to the nearest base 2 or base 2 + half, as in
		 * 100%, 150%, 200%, 300%, 400%, 600%, 800%, etc...
		 *
		 * @param	x			Target horizontal position which to center the
		 * 						scaled view, in the document coordinate space.
		 * @param	y			Target vertical position which to center the
		 * 						scaled view, in the document coordinate space.
		 * @param	out			If true, zoomPoint zooms out or scales down.
		 */
		public function zoomPoint( x:Number, y:Number, out:Boolean = false ):void
		{
			var scale:Number = Math.log( documentLayer.scaleX ) / Math.log( 2 );
			var precision:Function = function( value:Number ):Number
			{
				return Math.round(( value < 0 ? 1 + value : value ) * 1e+12 )
			};

			if( out )
			{
				if( scale % 1 == 0 )
				{
					scale = Math.floor( scale - 1 ) + LOG3_2;
				}
				else
				{
					scale = precision( scale % 1 ) <= precision( LOG3_2 ) ? Math.floor( scale ) : Math.floor( scale ) + LOG3_2;
				}
			}
			else
			{
				scale = precision( scale % 1 ) >= precision( LOG3_2 ) ? Math.ceil( scale ) : Math.floor( scale ) + LOG3_2;
			}
			scale = Math.pow( 2, scale );
			documentLayer.scaleX = documentLayer.scaleY = scale;
			validateNow();

			viewport.horizontalScrollPosition = x * scale - ( viewport.width / 2 );
			viewport.verticalScrollPosition = y * scale - ( viewport.height / 2 );
			dispatchEvent( new WorkareaEvent( WorkareaEvent.ZOOM ));
		}
		
		public function resetZoom():void
		{
			documentLayer.scaleX = documentLayer.scaleY = 1;
			viewport.horizontalScrollPosition = 0;
			viewport.verticalScrollPosition = 0;
			validateNow();
		}


		/**
		 * Zooms the document by scaling to fit the rectangular region.
		 *
		 * @param x			Horizontal position of the viewing rectangle in the
		 * 					document coordinate space.
		 * @param y			Vertical position of the viewing rectangle in the
		 * 					document coordinate space.
		 * @param width		Horizontal size of the viewing rectangle in the
		 * 					document coordinate space.
		 * @param height	Vertical size of the viewing rectangle in the
		 * 					document coordinate space.
		 */
		public function zoomRect( x:Number, y:Number, width:Number, height:Number ):void
		{
			// normalize the rect so x,y represent the top-left corner
			if( width < 0 )
			{
				width = -width;
				x -= width;
			}
			if( height < 0 )
			{
				height = -height;
				y -= height;
			}

			var scaleX:Number = viewport.width / width;
			var scaleY:Number = viewport.height / height;
			var scale:Number = scaleX < scaleY ? scaleX : scaleY;

			documentLayer.scaleX = documentLayer.scaleY = scale;
			validateNow();

			viewport.horizontalScrollPosition = x * scale - ( 1 - scale / scaleX ) * ( viewport.width / 2 );
			viewport.verticalScrollPosition = y * scale - ( 1 - scale / scaleY ) * ( viewport.height / 2 );
			dispatchEvent( new WorkareaEvent( WorkareaEvent.ZOOM ));
		}
		
		
		/**
		 * Zoom in/out relative to the current center position of the viewport.
		 * @param out zoom out
		 */ 
		public function zoomRelativeCenter(out:Boolean = false):void
		{
			var relativeCenter:Point = new Point();
			relativeCenter.x = (viewport.horizontalScrollPosition + (viewport.width / 2)) / documentLayer.scaleX;
			relativeCenter.y = (viewport.verticalScrollPosition + (viewport.height / 2)) / documentLayer.scaleY;
			zoomPoint(relativeCenter.x, relativeCenter.y, out);
		}
		
		public function zoomToFitViewport():void
		{
			var scaleX:Number = viewport.width / documentLayer.width;
			var scaleY:Number = viewport.height / documentLayer.height;
			var scale:Number = scaleX < scaleY ? scaleX : scaleY;
			documentLayer.scaleX = documentLayer.scaleY = scale;
			dispatchEvent( new WorkareaEvent( WorkareaEvent.ZOOM ));
		}

		/**
		 * Moves the document layer within the viewport to center on the
		 * specified location within the document cooridnate space.
		 */
		public function pan( x:Number, y:Number ):void
		{
			var scale:Number = documentLayer.scaleX;
			viewport.horizontalScrollPosition = x * scale;
			viewport.verticalScrollPosition = y * scale;
			dispatchEvent( new WorkareaEvent( WorkareaEvent.PAN ));
		}
		
		/**
		 * Detect if Isolation Layer has elements
		 * @return in isolation mode
		 */
		public function get isolationMode():Boolean
		{
			if( isolationLayer && isolationLayer.elementLength() > 0 )
			{
				return true
			}
			else
			{
				return false
			}
		}


		/**
		 * @inheritDoc
		 */
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			switch( instance )
			{
				case selectionLayer:
					break;
				case documentLayer:
					break;
				case contentGroup:
					break;
				default:
					break;
			}
		}


		/**
		 * @inheritDoc
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			switch( instance )
			{
				case selectionLayer:
					break;
				case documentLayer:
					break;
				case contentGroup:
					break;
				default:
					break;
			}
			super.partRemoved( partName, instance );
		}
	}
}