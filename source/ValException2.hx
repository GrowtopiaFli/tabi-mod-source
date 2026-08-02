package;

import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import haxe.ValueException;
import openfl.Lib;
#if desktop
import openfl.system.Capabilities;
#end
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ValException2 extends MusicBeatState
{
	var filters:Array<BitmapFilter> = [];
	var stickmin:FlxSprite;
	var chromeValue:Float = 0;
	var valueExceptions:FlxTypedGroup<FlxSprite>;
	var valueExceptionSlow:FlxTypedGroup<FlxSprite>;
	var exceptions:FlxTypedGroup<FlxSprite>;
	var justCrashIt:Bool = false;
	var updateVal:Int = 0;
	var updateValed:Bool = false;
	var distracted:FlxText;

	override function create()
	{
		valueExceptions = new FlxTypedGroup<FlxSprite>();
		add(valueExceptions);
		
		valueExceptionSlow = new FlxTypedGroup<FlxSprite>();
		add(valueExceptionSlow);
		
		stickmin = new FlxSprite();
		stickmin.frames = Paths.getPackerAtlas("ValueException/stickmin");
		stickmin.animation.addByPrefix('dance', "stickmin_", 0, true);
		stickmin.animation.play('dance', true);
		stickmin.y = FlxG.height / 2 - stickmin.height / 2;
		stickmin.x = FlxG.width / 2 - stickmin.width / 2;
		add(stickmin);
		
		distracted = new FlxText(0, stickmin.y + stickmin.height, Std.int(FlxG.width * 0.6), "", 32);
		distracted.setFormat(Paths.font("15111.ttf"), 32, FlxColor.WHITE, CENTER);
		distracted.text = "You Have Been ValueExceptioned";
		distracted.x = FlxG.width / 2 - distracted.width / 2;
		add(distracted);
	
		exceptions = new FlxTypedGroup<FlxSprite>();
		add(exceptions);
	
		FlxG.sound.playMusic(Paths.inst('stickmin'), 1, false);
		FlxG.sound.music.onComplete = preCrashGame;
	
		Conductor.changeBPM(130);
		
		if (!Highscore.getDS() && !Highscore.getPhoto())
		{
			filters.push(ShadersHandler.chromaticAberration);
			FlxG.camera.setFilters(filters);
			FlxG.camera.filtersEnabled = true;
		}
	
		super.create();
	}
	
	public function preCrashGame():Void
	{
		chromeValue = 2 / 1000;
	
		var daVals:Array<Int> = [];
		
		for (i in values[0]...values[1])
		{
			daVals.push(i);
		}
		
		//trace(daVals);
		
		FlxG.random.shuffle(daVals);
		FlxG.random.shuffle(daVals);
		FlxG.random.shuffle(daVals);
		
		var daVals2:Array<Int> = [];
		
		for (shit in daVals)
		{
			daVals2.push(shit);
		}
		
		//trace(daVals);
	
		for (i in 0...6)
		{
			for (j in 0...7)
			{
				if (daVals.length <= 0)
				{
					for (shit in daVals2)
					{
						daVals.push(shit);
					}
				}
				var daVal:Int = daVals[0];
				//trace(daVal);
				var newFlxSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("ValueException/" + daVal));
				newFlxSprite.x = (FlxG.width / 7) * j;
				newFlxSprite.y = (FlxG.height / 6) * i;
				if (newFlxSprite.x > FlxG.width - newFlxSprite.width)
				{
					newFlxSprite.x = FlxG.width - newFlxSprite.width;
				}
				if (newFlxSprite.y > FlxG.height - newFlxSprite.height)
				{
					newFlxSprite.y = FlxG.height - newFlxSprite.height;
				}
				exceptions.add(newFlxSprite);
				daVals.shift();
			}
		}
		//crashGame();
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			justCrashIt = true;
		}, 1);
	}
	
	public function crashGame():Void
	{
		throw new ValueException("ValueException");
		openfl.system.System.exit(0);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!updateValed)
		{
			stickmin.animation.curAnim.curFrame = 0;
		}
		
		updateVal++;
		updateValed = true;
		
		if (updateVal / 60 >= (1 / (Conductor.bpm / 30)) / 30)
		{
			updateVal = 0;
			if (stickmin.animation.curAnim.curFrame >= stickmin.animation.curAnim.frames.length - 1)
				stickmin.animation.curAnim.curFrame = 0;
			 else
				stickmin.animation.curAnim.curFrame += 1;
		}
		
		FlxG.sound.volume = 1;

		if (justCrashIt)
		{
			crashGame();
		}
		
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		
		valueExceptions.forEach(function(spr:FlxSprite)
		{
			spr.y += 30;
			if (spr.y > FlxG.height)
			{
				spr.kill();
				valueExceptions.remove(spr, true);
				spr.destroy();
			}
		});
		
		valueExceptionSlow.forEach(function(spr:FlxSprite)
		{
			spr.y += 20;
			if (spr.y > FlxG.height)
			{
				spr.kill();
				valueExceptionSlow.remove(spr, true);
				spr.destroy();
			}
		});
		
		if (!Highscore.getDS() && !Highscore.getPhoto())
		{
			setChrome(chromeValue);
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		
		//stickmin.animation.curAnim.curFrame = 0;
		
		FlxG.camera.zoom += 0.2;
		FlxG.camera.shake(0.005, 0.05);
		FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);
		for (i in 0...4)
		{
			var newFlxSprite:FlxSprite = new FlxSprite((FlxG.width / 4) * i, 0).loadGraphic(Paths.image("ValueException/" + FlxG.random.int(values[0], values[1])));
			newFlxSprite.y -= newFlxSprite.height;
			valueExceptions.add(newFlxSprite);
		}
		chromeValue += 5 / 1000;
		FlxTween.tween(this, { chromeValue: 0 }, 0.2);
	}
	
	override function stepHit()
	{
		super.stepHit();
		
		var newFlxSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("ValueException/" + FlxG.random.int(values[0], values[1])));
		newFlxSprite.x = FlxG.random.float(0, FlxG.width - newFlxSprite.width);
		valueExceptionSlow.add(newFlxSprite);
	}
}