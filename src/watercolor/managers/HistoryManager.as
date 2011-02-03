package watercolor.managers
{
	import flash.events.EventDispatcher;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.events.HistoryManagerEvent;
	import watercolor.utils.ExecuteUtil;


	/**
	 * The HistoryManager manages the commands that are executed to enable undo and redo.
	 *
	 */
	public class HistoryManager extends EventDispatcher
	{
		/**
		 * Enabled/Disabled
		 *
		 * When the history manager is disabled, no commands added to history.
		 */
		public var enabled:Boolean = true;


		private var _commandVOs:Vector.<CommandVO> = new Vector.<CommandVO>;



		/**
		 * The commands that have been executed are stored in a vector to more readily undo
		 * and redo them.
		 */
		public function get commandVOs():Vector.<CommandVO>
		{
			return _commandVOs;
		}


		/**
		 *  @private
		 */
		protected var _index:int = -1;


		/**
		 * A convenient function to add a command to the commands vector.
		 * @param command
		 *
		 */
		public function addCommand( command:CommandVO ):void
		{
			if( enabled )
			{
				_commandVOs.splice( _index + 1, _commandVOs.length - ( _index + 1 ));
				_commandVOs.push( command );
				_index = _commandVOs.length - 1;

				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.INDEX_CHANGE, this ));
				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.COMMAND_ADDED, this ));
			}
		}


		/**
		 * A read only property that returns the current index.  Used to find the current command.
		 * @return Current index
		 *
		 */
		public function get index():int
		{
			return _index;
		}


		public function removeCommand( command:CommandVO ):void
		{

			if( _commandVOs.indexOf( command ) != -1 )
			{
				_commandVOs.splice( _commandVOs.indexOf( command ), 1 );
				_index--;

				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.INDEX_CHANGE, this ));
				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.COMMAND_REMOVED, this ));
			}
		}
		
		public function removeAllCommands():void
		{
			_commandVOs.splice(0, _commandVOs.length);
			_index = -1;
			
			dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.INDEX_CHANGE, this ));
			dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.COMMAND_REMOVED, this ));
		}


		/**
		 * Redo augments the selected index and dispatches a <code>HistoryManagerEvent</code> with
		 * a type of <code>HistoryManagerEvent.REDO</code>
		 */
		public function redo():void
		{
			if( _index < _commandVOs.length - 1 )
			{
				( _index == -1 ) ? _index = 0 : _index++;
				ExecuteUtil.execute( _commandVOs[ _index ]);

				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.REDO, this ));
				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.INDEX_CHANGE, this ));
			}
		}


		/**
		 * Undo decrements the selected index and dispatches a <code>HistoryManagerEvent</code> with
		 * a type of <code>HistoryManagerEvent.UNDO</code>
		 *
		 */
		public function undo():void
		{
			if( _index != -1 )
			{

				ExecuteUtil.undo( _commandVOs[ _index ]);
				_index--;

				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.UNDO, this ));
				dispatchEvent( new HistoryManagerEvent( HistoryManagerEvent.INDEX_CHANGE, this ));
			}
		}
	}
}