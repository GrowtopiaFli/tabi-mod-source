package;

class ClassConductor
{
	private static var myShit:String = "";
	public static function set(urShit:String):Void
	{
		myShit = urShit;
	}
	public static function get():String
	{
		var crap:String = myShit;
		myShit = "";
		return crap;
	}
}