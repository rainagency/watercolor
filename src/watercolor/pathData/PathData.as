package watercolor.pathData
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	/**
	 * Class/Container to Parse, Store, and Manipulate FXG Path Data
	 *
	 * @author Sean Thayne
	 */
	public class PathData
	{


		/**
		 * Array Collection for Path's PathDataContours
		 */
		[ArrayElementType( "watercolor.pathData.PathDataContour" )]
		/**
		 *
		 * @default
		 */
		protected var contours:ArrayCollection = new ArrayCollection();


		/**
		 * Container for loaded data that is being processed.
		 */
		private var workingData:String;


		/**
		 * Regular expression used in number parsing.
		 */
		private var numberStartRegex:RegExp = new RegExp( "([-,0-9,.]+)" );


		/**
		 * Regular expression used in number parsing.
		 */
		private var numberEndRegex:RegExp = new RegExp( "([C,c,H,h,L,l,V,v,M,m,Q,q,S,s,T,t,Z,z, ]+)" );


		/**
		 * Constructor
		 */
		public function PathData( data:String = null ):void
		{
			if( data )
			{
				this.data = data;
			}
		}


		/**
		 * Adds a pathData contour to this PathData Object
		 *
		 * @param newContour New PathDataContour to add.
		 *
		 * @return This PathData Object
		 */
		public function addContour( newContour:PathDataContour ):PathData
		{
			contours.addItem( newContour );
			return this;
		}


		/**
		 * Public access for path contours
		 *
		 * @return Array of PathDataContours
		 */
		public function get pathCountours():ArrayCollection
		{
			return contours;
		}


		/**
		 * De-Serializes a path's data string, Converts all relative paths to absolute,
		 * And parses all commands into contoured groups.
		 *
		 * @param newData FXG Path Data String
		 */
		public function set data( newData:String ):void
		{
			var commandType:String;
			var contour:PathDataContour;
			var currentPosition:Point = new Point();

			workingData = newData;

			while( workingData.length )
			{

				var nextChar:String = workingData.charAt( 0 );

				if( nextChar == ' ' )
				{
					//Skip Spaces
					workingData = workingData.substr( 1 );
					continue;
				}
				else if( isNaN( parseInt( nextChar )) && nextChar != '-' )
				{
					//We have a new command. Set it!
					commandType = nextChar;
					workingData = workingData.substr( 1 );
				}


				var pointToAdd:Point = new Point();

				switch( commandType )
				{
					case 'c':
						pointToAdd = currentPosition;
					case 'C':
						//Cubic Beizer
						var commandC:PathDataCubicBezierCommand = new PathDataCubicBezierCommand( contour );
						commandC.controlPointA = getNextPoint().add( pointToAdd );
						commandC.controlPointB = getNextPoint().add( pointToAdd );
						currentPosition = commandC.cordinate = getNextPoint().add( pointToAdd );
						break;
					case 'h':
						pointToAdd = currentPosition;
					case 'H':
						//Horizontial Line
						currentPosition = new Point( getNextNumber(), 0 ).add( pointToAdd );
						var commandH:PathDataHorizontialLineCommand = new PathDataHorizontialLineCommand( contour, currentPosition.x );
						break;
					case 'l':
						pointToAdd = currentPosition;
					case 'L':
						//Line
						currentPosition = getNextPoint().add( pointToAdd )
						new PathDataLineCommand( contour, currentPosition );
						break;
					case 'm':
						pointToAdd = currentPosition;
					case 'M':
						//Move
						currentPosition = getNextPoint().add( pointToAdd );
						contour = new PathDataContour( this, currentPosition );
						break;
					case 'q':
						pointToAdd = currentPosition;
					case 'Q':
						//Quadratic Bezier
						var commandQ:PathDataQuadraticBezierCommand = new PathDataQuadraticBezierCommand( contour );
						commandQ.controlPoint = getNextPoint().add( pointToAdd );
						currentPosition = commandQ.cordinate = getNextPoint().add( pointToAdd );
						break;
					case 's':
						pointToAdd = currentPosition;
					case 'S':
						//Quadratic Bezier
						var commandS:PathDataSmoothCubicBezierCommand = new PathDataSmoothCubicBezierCommand( contour );
						commandS.controlPoint = getNextPoint().add( pointToAdd );
						currentPosition = commandS.cordinate = getNextPoint().add( pointToAdd );
						break;
					case 't':
						pointToAdd = currentPosition;
					case 'T':
						//Smooth Quadratic Bezier
						currentPosition = getNextPoint().add( pointToAdd );
						var commandT:PathDataSmoothQuadraticBezierCommand = new PathDataSmoothQuadraticBezierCommand( contour, currentPosition );
						break;
					case 'v':
						pointToAdd = currentPosition;
					case 'V':
						//Vertical Line
						currentPosition = new Point( 0, getNextNumber()).add( pointToAdd );
						var commandV:PathDataVerticalLineCommand = new PathDataVerticalLineCommand( contour, currentPosition.y );
						break;
					case 'z':
					case 'Z':
						//Close Path
						//new PathDataClosePathCommand( contour );
						contour = null;
						break;
					default:
						throw new Error( "Uknown Command" );
				}

			}

		}


		/**
		 * Serializes the Path's Data string into FXG
		 *
		 * @return Serialized FXG Data
		 */
		public function get data():String
		{
			var dataString:String = contours.toArray().join( "" ) + "z";
			return dataString;
		}
		
		/**
		 * Clones the pathdata object
		 * @return 
		 */
		public function clone():PathData
		{
			// go through and get all of the data from the contours regardless
			// if they are visible or not
			var data:String = "";
			for each (var con:PathDataContour in contours)
			{
				data += (con.toString(true) + "z");
			}
			
			// create a new path data object
			var newData:PathData = new PathData(data);
			
			// now go through and look for contours that are hidden and 
			// set that on the new path data object
			for each (var ncon:PathDataContour in newData.contours)
			{
				for each (var ocon:PathDataContour in contours)
				{
					if (ncon.toString(true) == ocon.toString(true) && !ocon.visible)
					{
						ncon.visible = false;
					}
				}
			}
			
			return newData;
		}


		/**
		 * This function will move the path into the top left corner.
		 */
		public function rebuildPoints():void
		{
			var offset:Point;
			var contour:PathDataContour;
			var command:IPathDataVisualCommand;

			/*
			   Find the offset to apply. We do this by find the most negative
			   ending points out of all the visual commands
			 */
			for each( contour in contours )
			{
				if( !offset )
					offset = contour.startPoint.clone();

				if( contour.startPoint.x < offset.x )
					offset.x = contour.startPoint.x;

				if( contour.startPoint.y < offset.y )
					offset.y = contour.startPoint.y;

				for each( command in contour.visualCommands )
				{
					var endPoint:Rectangle = command.getBoundingRectangle();

					if( endPoint.x < offset.x )
						offset.x = endPoint.x;

					if( endPoint.y < offset.y )
						offset.y = endPoint.y;
				}
			}


			/*
			   Add offsets to all points
			 */

			offset.x *= -1;
			offset.y *= -1;

			for each( contour in contours )
			{
				contour.startPoint = contour.startPoint.add( offset );

				for each( command in contour.visualCommands )
					command.offset( offset );
			}
		}


		/**
		 * 
		 * @return 
		 */
		public function getPointsRect():Rectangle
		{
			var contour:PathDataContour;
			var command:IPathDataVisualCommand;

			var topLeft:Point = new Point();
			var bottomRight:Point = new Point();

			for each( contour in contours )
			{
				if( contour.startPoint.x > bottomRight.x )
					bottomRight.x = contour.startPoint.x;

				if( contour.startPoint.y > bottomRight.y )
					bottomRight.y = contour.startPoint.y;

				if( contour.startPoint.x < topLeft.x )
					topLeft.x = contour.startPoint.x;

				if( contour.startPoint.y < topLeft.y )
					topLeft.y = contour.startPoint.y;

				for each( command in contour.visualCommands )
				{
					var endPoint:Rectangle = command.getBoundingRectangle();

					if( endPoint.right > bottomRight.x )
						bottomRight.x = endPoint.right;

					if( endPoint.bottom > bottomRight.y )
						bottomRight.y = endPoint.bottom;

					if( endPoint.left < topLeft.x )
						topLeft.x = endPoint.right;

					if( endPoint.top < topLeft.y )
						topLeft.y = endPoint.bottom;
				}
			}

			return new Rectangle( topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - topLeft.y );
		}


		/**
		 * Returns a string to indicate which contours are hidden and which ones are showing
		 * Example: SSHS - The first two contours are displayed, but the third one is hidden.
		 * @return
		 */
		public function getShowHideList():String
		{
			var list:String = "";

			for each( var contour:PathDataContour in contours )
			{
				list += ( contour.visible ) ? "S" : "H";
			}

			return list;
		}
		
		/**
		 * Updates the contours to be hidden or shown.  
		 * @param list A string containing only h's or s's 
		 */
		public function setShowHideList(list:String):void
		{
			var array:Array = list.match(/[S,s,H,h]/g);
			
			for (var x:int = 0; x < array.length; x++)
			{
				if (array[x].toString().toLowerCase() == "h" && contours[x])
				{
					contours[x].visible = false;
				}
				else if (contours[x])
				{
					contours[x].visible = true;
				}
			}
		}


		/**
		 * Fixes X/Y Offset issues
		 *
		 * Finds how far negative the glyph is and moves the entire glyph by that offset.
		 */
		public function offsetNegativePoints():void
		{
			var offset:Point = new Point();
			var contour:PathDataContour;
			var command:IPathDataVisualCommand;

			/*
			   Find the offset to apply. We do this by find the most negative
			   ending points out of all the visual commands
			 */
			for each( contour in contours )
			{

				if( contour.startPoint.x < offset.x )
					offset.x = contour.startPoint.x;

				if( contour.startPoint.y < offset.y )
					offset.y = contour.startPoint.y;

				for each( command in contour.visualCommands )
				{
					var endPoint:Point = command.getEndingPoint();

					if( endPoint.x < offset.x )
						offset.x = endPoint.x;

					if( endPoint.y < offset.y )
						offset.y = endPoint.y;
				}
			}

			/*
			   Add offsets to all points
			 */
			offset.x = Math.abs( offset.x );
			offset.y = Math.abs( offset.y );

			for each( contour in contours )
			{

				contour.startPoint.x += offset.x;
				contour.startPoint.y += offset.y;

				for each( command in contour.visualCommands )
				{
					command.offset( offset );
				}
			}
		}


		/**
		 * Expands a path.
		 *
		 * Used in shadowing.
		 *
		 * @param pixels Number of pixels to expand by.
		 *
		 * @return A new PathData object with expanded elements.
		 */
		public function expand( pixels:Number ):PathData
		{
			var newPathData:PathData = new PathData();

			for( var i:uint = 0; i < contours.length; i++ )
				contours[ i ].expand( pixels, newPathData );

			return newPathData;
		}


		/**
		 * Parsing command for set data to get next X/Y Point.
		 *
		 * @private
		 * @return Next point in working data
		 */
		private function getNextPoint():Point
		{
			return new Point( getNextNumber(), getNextNumber());
		}


		/**
		 * Parsing command for set data to get next number.
		 *
		 * @private
		 * @return Next number in working data
		 */
		private function getNextNumber():Number
		{
			var numberStartingPosition:uint = workingData.search( numberStartRegex );

			if( numberStartingPosition > 0 )
			{
				workingData = workingData.substr( numberStartingPosition );
			}

			var numberBreakPos:uint = workingData.search( numberEndRegex );
			var nextNumber:Number = parseFloat( workingData.substr( 0, numberBreakPos ));

			workingData = workingData.substr( numberBreakPos );

			return nextNumber;
		}
	}
}