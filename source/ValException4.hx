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
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ValException4 extends MusicBeatState
{
	var filters:Array<BitmapFilter> = [];
	var stickbug:FlxSprite;
	var valueException:FlxText;
	var exceptionWindows:FlxTypedGroup<FlxSprite>;
	var exceptions:FlxTypedGroup<FlxSprite>;
	var justCrashIt:Bool = false;
	var chromeValue:Float = 0;
	var vel:Float = 700;

	override function create()
	{
		exceptionWindows = new FlxTypedGroup<FlxSprite>();
		add(exceptionWindows);
		
		valueException = new FlxText(0, FlxG.height * 0.9, Std.int(FlxG.width * 0.6), "", 32);
		valueException.setFormat(Paths.font("15111.ttf"), 32, FlxColor.WHITE, CENTER);
		valueException.text = "ValueException";
		valueException.x = FlxG.width / 2 - valueException.width / 2;
		add(valueException);
	
		exceptions = new FlxTypedGroup<FlxSprite>();
		add(exceptions);
	
		FlxG.sound.playMusic(Paths.inst('exceptioniliketo'), 1, false);
		FlxG.sound.music.onComplete = preCrashGame;
	
		Conductor.changeBPM(Song.loadFromJson('milf', 'milf').bpm);
		
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
		
		FlxG.random.shuffle(daVals);
		FlxG.random.shuffle(daVals);
		FlxG.random.shuffle(daVals);
		
		var daVals2:Array<Int> = [];
		
		for (shit in daVals)
		{
			daVals2.push(shit);
		}
	
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
		
		FlxG.sound.volume = 1;

		if (justCrashIt)
		{
			crashGame();
		}
		
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		
		exceptionWindows.forEach(function(spr:FlxSprite)
		{
			if (spr.x < 0)
			{
				spr.velocity.x = vel;
			} 
			else if (spr.x > FlxG.width - spr.width)
			{
				spr.velocity.x = -vel;
			}
			
			if (spr.y < 0)
			{
				spr.velocity.y = vel;
			}
			else if (spr.y > FlxG.height - spr.height)
			{
				spr.velocity.y = -vel;
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
		
		FlxG.camera.zoom += 0.2;
		FlxG.camera.shake(0.005, 0.05);
		FlxTween.tween(FlxG.camera, { zoom: 1 }, 0.1);

		var newFlxSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("ValueException/11"));
		newFlxSprite.y = FlxG.random.float(0, FlxG.height - newFlxSprite.height);
		newFlxSprite.x = FlxG.random.float(0, FlxG.width - newFlxSprite.width);
		newFlxSprite.velocity.x = vel;
		newFlxSprite.velocity.y = vel;
		exceptionWindows.add(newFlxSprite);

		chromeValue += 5 / 1000;
		FlxTween.tween(this, { chromeValue: 0 }, 0.2);
	}
	
	override function stepHit()
	{
		super.stepHit();
	}
}