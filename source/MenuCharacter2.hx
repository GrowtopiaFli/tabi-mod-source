package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter2 extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);
		
		character = 'tabi';

		this.character = character;

		var tex = Paths.getSparrowAtlas('Tabi_lines');
		frames = tex;

		animation.addByPrefix('tabi', "Tabi Lines", 24);

		animation.play(character);
		updateHitbox();
	}
}
