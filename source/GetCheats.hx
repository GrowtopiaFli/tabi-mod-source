package;

import flixel.FlxG;

class GetCheats
{	
	public static var isCheating(get, never):Bool;
	
	inline static function get_isCheating()
		return CheatChecker.check();
		
	public static var probably(get, never):Bool;
	
	inline static function get_probably()
		return CheatChecker.isProb();
}
