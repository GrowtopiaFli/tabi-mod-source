package;

import flixel.FlxG;
import flixel.FlxSprite;

class TabiFire extends FlxSprite
{
	public function new(a:Float, b:Float, ?c:Float = 1, ?d:Float = 1)
	{
		super(a, b);
		
		scale.set(c, d);
		
		loadGraphic(Paths.image('tabi/mad/fireshit'), true, 433, 400);
		
		antialiasing = true;
		animation.add('fire', [0, 1, 2], 15, true);
		animation.play('fire');
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}