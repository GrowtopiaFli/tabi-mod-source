package;

import flixel.FlxG;

class ValException extends MusicBeatState
{
	override function create()
	{
		switch(Highscore.getVal())
		{
			case 0:
				FlxG.switchState(new ValException1());
			case 1:
				FlxG.switchState(new ValException2());
			case 2:
				FlxG.switchState(new ValException3());
			default:
				FlxG.switchState(new ValException4());
		}
	
		Highscore.moveVal();
	
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}