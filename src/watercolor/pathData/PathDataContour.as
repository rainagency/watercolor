package watercolor.pathData
{
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	import watercolor.math.EuclideanLine;
	import watercolor.math.IntersectionPoint;
	import watercolor.math.QuadraticBezierCurve;
	import watercolor.math.interfaces.IBezierCurve;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;
	import watercolor.utils.IntersectionUtil;
	import watercolor.utils.PathDataUtil;


	/**
	 * Path Data Command container/manipulator.
	 *
	 * A contour is any complete graphic. This consists of at least one move command, and a
	 * combination of N lines and/or curves.
	 *
	 * @author Sean Thayne
	 */
	public class PathDataContour
	{
		/**
		 * Contour's parent PathDataObject
		 */
		protected var parent:PathData


		/**
		 * The starting point of this contour. Represents the Move Command.
		 */
		public var startPoint:Point;


		/**
		 * Visibility boolean.
		 *
		 * If false, the command will not output when serialized.
		 */
		public var visible:Boolean = true;


		/**
		 * Collection of PathDataCommand(s)
		 */
		protected var commands:ArrayCollection = new ArrayCollection();


		/**
		 * Constructor
		 *
		 * @param parent PathData this contour will belong to.
		 * @param startPoint The starting point of this contour. Usually the Move's Point.
		 */
		public function PathDataContour( parent:PathData, startPoint:Point )
		{
			this.parent = parent.addContour( this );
			this.startPoint = startPoint;
		}


		/**
		 * Adds a new PathDataCommand to this Contour.
		 *
		 * @param command New PathDataCommand to add to this contour.
		 *
		 * @return This PathDataContour.
		 */
		public function addCommand( command:PathDataCommand ):PathDataContour
		{
			commands.addItem( command );
			return this;
		}


		/**
		 * Adds a new PathDataCommand to this Contour in a specific index.
		 *
		 * @param command New PathDataCommand to add to this contour.
		 * @param index Index to add new command to.
		 *
		 * @return This PathDataContour.
		 */
		public function addCommandAt( command:PathDataCommand, index:uint ):PathDataContour
		{
			if( commands.contains( command ))
			{
				commands.removeItemAt( command.index );
			}

			commands.addItemAt( command, index );
			return this;
		}


		/**
		 * Remove command from Contour.
		 *
		 * @param command PathDataCommand to remove from contour.
		 */
		public function removeCommand( command:PathDataCommand ):void
		{
			commands.removeItemAt( commands.getItemIndex( command ));
		}


		/**
		 * Remove command at a specific index from this contour.
		 *
		 * @param index Index of PathDataCommand to remove.
		 *
		 * @return PathDataCommand that was removed.
		 */
		public function removeCommandAt( index:uint ):PathDataCommand
		{
			return PathDataCommand( commands.removeItemAt( index ));
		}


		/**
		 * Returns the index of PathDataCommand in this Contour.
		 *
		 * @param PathDataCommand to find index of.
		 *
		 * @return The Index of given PathDataCommand.
		 */
		public function getCommandIndex( command:PathDataCommand ):int
		{
			return commands.getItemIndex( command );
		}


		/**
		 * Returns the Command at a given Index.
		 *
		 * @param index Index of command to return.
		 *
		 * @return PathDataCommand at given index.(if exists) Null otherwise
		 */
		public function getCommandAt( index:uint ):PathDataCommand
		{
			if( index < commands.length && index >= 0 )
			{
				return PathDataCommand( commands.getItemAt( index ));
			}
			else
			{
				return null;
			}
		}


		/**
		 * Expand a Contour by a certain amount of pixels.
		 *
		 * Usefull for shadowing.
		 *
		 * @param pixels Number of pixels to expand this contour by.
		 * @param newPathData New PathData to add newly expanded PathDataContour to.
		 *
		 * @return Newly Created PathDataContour that has been expanded.
		 */
		public function expand( pixels:Number, newPathData:PathData ):PathDataContour
		{
			var newPathContour:PathDataContour = new PathDataContour( newPathData, startPoint.clone());

			for( var i:uint = 0; i < commands.length; i++ )
				commands[ i ].expand( pixels, newPathContour );

			PathDataUtil.connectCommandTo( newPathContour.lastVisualCommand.euclideanLine, newPathContour.firstVisualCommand.euclideanLine, newPathContour );



			//var close:PathDataClosePathCommand = new PathDataClosePathCommand(newPathContour);


			//newPathContour.clipIntersections();

			return newPathContour;
		}


		/**
		 * Clip Intersections after expanding.
		 *
		 * Used to clip commandds that may intersect other commands within the same contour.
		 *
		 * If you don't clip then the expanded PathDataContour will have transparent bleeds
		 * wherever they intersect.
		 *
		 * This will loop through all the commands and clip there length to meet at there
		 * intersection points.
		 *
		 * This is a work in progress thou and is not complete right now.
		 *
		 */
		public function clipIntersections():void
		{
			var VCs:Vector.<IPathDataVisualCommand> = visualCommands;

			//Loop through all the lines/curves
			for( var i:uint = 0; i < VCs.length; i++ )
			{
				var euclideanA:EuclideanLine = VCs[ i ].euclideanLine;

				//Loop through all the lines/curves
				for( var ii:uint = i + 1; ii < VCs.length; ii++ )
				{
					var euclideanB:EuclideanLine = VCs[ ii ].euclideanLine;
					var interSections:Vector.<IntersectionPoint> = IntersectionUtil.getIntersectionPoints( euclideanA, euclideanB );

					if( interSections )
					{
						for( var iii:uint = 0; iii < interSections.length; iii++ )
						{
							if( !interSections[ iii ].equals( euclideanA.pointA ) && !interSections[ iii ].equals( euclideanA.pointB ))
							{
								removeCommandsBetween( VCs[ i ], VCs[ ii ]);
							}
						}
					}
				}
			}
		}


		/**
		 * Remove all commands between two commands.
		 *
		 * @param commandA PathDataCommand to use as starting point.
		 * @param commandA PathDataCommand to use as ending point.
		 *
		 */
		public function removeCommandsBetween( commandA:IPathDataVisualCommand, commandB:IPathDataVisualCommand ):void
		{
			var startClip:uint = commands.getItemIndex( commandA );
			var endClip:uint = commands.getItemIndex( commandB );

			for( var i:uint = startClip; i < endClip; i++ )
			{
				//commands.removeItemAt( startClip + 1 );
			}
		}


		/**
		 * Serialize this contour to FXG String Data.
		 *
		 * If Visibility is set to false. Then it will just create a move command.
		 * Otherwise it will serialize all the PathDataCommands and return a String.
		 *
		 *
		 * @param forceVisibile Boolean to force the Contour to serialize completely.
		 * 			This is usefull for creating masks while editing contours.
		 *
		 * @return FXG Serialized Data String
		 */
		public function toString( forceVisible:Boolean = false ):String
		{
			if( visible || forceVisible )
			{
				var previousContour:PathDataContour = getPreviousContour();
				var returnData:String = ( !previousContour || !previousContour.empty ) ? 'M' : ' ';
				returnData += startPoint.x.toPrecision( 5 ) + ' ' + startPoint.y.toPrecision( 5 ) + commands.toArray().join( '' );

/*				if( !empty )
					returnData += 'z';
*/
				return returnData;
			}
			else
			{
				return '';
			}

		}


		/**
		 * Returns all Visual Path Data Commands of this contour.
		 *
		 * @return A Vector of all IPathDataVisualCommand in this contour.
		 */
		public function get visualCommands():Vector.<IPathDataVisualCommand>
		{
			var lines:Vector.<IPathDataVisualCommand> = new Vector.<IPathDataVisualCommand>();

			for( var i:uint = 0; i < commands.length; i++ )
			{
				if( commands[ i ] is IPathDataVisualCommand )
				{
					lines.push( commands[ i ]);
				}
			}

			return lines;
		}


		/**
		 * Returns first IPathDataVisualCommand in this contour.
		 *
		 * Maybe useless now, was originally used when we had PathDataMoveCommand.
		 *
		 * @return First IPathDataVisualCommand Command
		 */
		public function get firstVisualCommand():IPathDataVisualCommand
		{
			for( var i:uint = 0; i < commands.length; i++ )
			{
				if( commands.getItemAt( i ) is IPathDataVisualCommand )
				{
					return IPathDataVisualCommand( commands.getItemAt( i ));
				}
			}

			return null;
		}


		/**
		 * Returns last IPathDataVisualCommand in this contour.
		 *
		 * Maybe useless now, was originally used when we had PathDataMoveCommand.
		 *
		 * @return Last IPathDataVisualCommand Command
		 */
		public function get lastVisualCommand():IPathDataVisualCommand
		{
			for( var i:uint = commands.length - 1; i >= 0; i-- )
			{
				if( commands.getItemAt( i ) is IPathDataVisualCommand )
				{
					return IPathDataVisualCommand( commands.getItemAt( i ));
				}
			}

			return null;
		}


		public function get empty():Boolean
		{
			return ( commands.length == 0 );
		}


		public function getPreviousContour():PathDataContour
		{
			var currentIndex:Number = parent.pathCountours.getItemIndex( this );

			if( currentIndex == 0 )
				return null;
			else
				return parent.pathCountours[ currentIndex - 1 ]
		}
	}
}