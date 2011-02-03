package watercolor.elements.interfaces
{
	import flash.events.IEventDispatcher;
	
	import watercolor.elements.TextGroup;

	/**
	 * Interface for defining how the text group should load stuff.
	 * The class that inherits this interface will need to implement
	 * the createLetter function to define what to load and how to load
	 * it.  The class that implements this interface must dispatch a TextGroupEvent
	 * once a letter is loaded.  If the class does not dispatch this event
	 * then the text group element will not know that a letter has been loaded.
	 * @author mediarain
	 */
	public interface ITextGroup extends IEventDispatcher
	{
		function get spaceWidth():Number;					
		function createLetter(char:String, lettersByIndex:Array, index:int):void;	
	}
}