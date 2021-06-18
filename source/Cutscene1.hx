package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

using StringTools;

class Cutscene1 extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var thankYouSoMuchAPieceOfShit:FlxSprite;
	//var blackShit:FlxSprite;
	var finishCallback:Void->Void;
	var start:Int = 0;
	var end:Int = 0;
	var fps:Int = 0;
	var startUpdate:Bool = false;
	
	public function new(?callBack:Void->Void)
	{
		super();
		
		finishCallback = callBack;
		
		bg = new FlxSprite().loadGraphic(Paths.image("cutscenes/2"));
		bg.antialiasing = true;
		bg.width = 1280;
		bg.height = 720;
		add(bg);
		
		//thankYouSoMuchAPieceOfShit = new FlxSprite(45, 46);
		thankYouSoMuchAPieceOfShit = new FlxSprite(103, 214);
		//thankYouSoMuchAPieceOfShit.frames = Paths.getSparrowAtlas("anims/Intro_Cutscene");
		thankYouSoMuchAPieceOfShit.frames = Paths.getSparrowAtlas("anims/Tabi_into");
		thankYouSoMuchAPieceOfShit.scale.set(0.6, 0.6);
		thankYouSoMuchAPieceOfShit.updateHitbox();
		//thankYouSoMuchAPieceOfShit.y -= thankYouSoMuchAPieceOfShit.height * 0.6;
		//thankYouSoMuchAPieceOfShit.x -= thankYouSoMuchAPieceOfShit.width * 0.6;
		var realFps:Int = 24;
		fps = realFps * 2;
		var fk:Array<Int> = [];
		start = 0;
		end = 93;
		for (i in start...end)
		{
			/*if (i == 0)
			{
				for (shit in 0...fps)
				{
					fk.push(i);
				}*/
			/*} else if (i >= end - 1) {
				for (shit in 0...fps)
				{
					fk.push(i);
				}*/
			//} else {
				fk.push(i);
			//}
		}
		//thankYouSoMuchAPieceOfShit.animation.addByIndices('cutscene', "Cutscene", fk, "", realFps, false);
		thankYouSoMuchAPieceOfShit.animation.addByIndices('cutscene', "Tabi Intro", fk, "", realFps, false);
		add(thankYouSoMuchAPieceOfShit);
		/*blackShit = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackShit);
		blackShit.alpha = 0;*/
		bg.visible = false;
		thankYouSoMuchAPieceOfShit.visible = false;
	}
	
	public function init():Void
	{
		bg.visible = true;
		thankYouSoMuchAPieceOfShit.visible = true;
		thankYouSoMuchAPieceOfShit.animation.play('cutscene', true);
		startUpdate = true;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		/*var fucku:Array<Bool> = [FlxG.keys.pressed.UP, FlxG.keys.pressed.LEFT, FlxG.keys.pressed.DOWN, FlxG.keys.pressed.RIGHT, FlxG.keys.justPressed.P];
		
		if (fucku[0])
		{
			thankYouSoMuchAPieceOfShit.y -= 1;
		}
		
		if (fucku[1])
		{
			thankYouSoMuchAPieceOfShit.x -= 1;
		}
		
		if (fucku[2])
		{
			thankYouSoMuchAPieceOfShit.y += 1;
		}
		
		if (fucku[3])
		{
			thankYouSoMuchAPieceOfShit.x += 1;
		}
		
		if (fucku[4])
		{
			trace("x: " + thankYouSoMuchAPieceOfShit.x + ", y: " + thankYouSoMuchAPieceOfShit.y);
		}*/

		if (ClassConductor.get() == Type.getClassName(Type.getClass(this)))
		{
			init();
		}

		if (startUpdate)
		{
		if (thankYouSoMuchAPieceOfShit.animation.curAnim != null)
		{
		/*var calculated:Int = (end - 1) + fps;
		if (thankYouSoMuchAPieceOfShit.animation.curAnim.name == "cutscene" && thankYouSoMuchAPieceOfShit.animation.curAnim.curFrame >= calculated)
		{
			if (thankYouSoMuchAPieceOfShit.visible)
			{
				blackShit.alpha = calculated / thankYouSoMuchAPieceOfShit.animation.curAnim.frames.length;
			}
			if (thankYouSoMuchAPieceOfShit.animation.curAnim.finished)
			{
				visible = false;
				finishCallback();
			}
		}*/
			if (thankYouSoMuchAPieceOfShit.animation.curAnim.name == "cutscene" && thankYouSoMuchAPieceOfShit.animation.curAnim.finished)
			{
				visible = false;
				startUpdate = false;
				finishCallback();
				kill();
			}
		}
		}
	}
}