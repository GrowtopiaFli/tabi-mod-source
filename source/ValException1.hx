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

class ValException1 extends MusicBeatState
{
	public var SONG:SwagSong;
	public var commandNotes:Array<Array<Dynamic>> = [];
	public var genocideNotes:Array<Array<Dynamic>> = [];
	public var valueExceptions:FlxTypedGroup<FlxSprite>;
	public var valueExceptionSlow:FlxTypedGroup<FlxSprite>;
	public var valueExceptionRight:FlxTypedGroup<FlxSprite>;
	public var valueExceptionLeft:FlxTypedGroup<FlxSprite>;
	public var valueExceptionOverlay:FlxTypedGroup<FlxSprite>;
	public var exceptions:FlxTypedGroup<FlxSprite>;
	var filters:Array<BitmapFilter> = [];
	var chromeValue:Float = 0;
	var justCrashIt:Bool = false;
	var invertedX:Bool = false;
	var invertedY:Bool = false;

	override function create()
	{
		SONG = Song.loadFromJson('genocide-hard', 'genocide');
		
		valueExceptionOverlay = new FlxTypedGroup<FlxSprite>();
		add(valueExceptionOverlay);
		
		valueExceptions = new FlxTypedGroup<FlxSprite>();
		add(valueExceptions);
		
		valueExceptionSlow = new FlxTypedGroup<FlxSprite>();
		add(valueExceptionSlow);
		
		valueExceptionLeft = new FlxTypedGroup<FlxSprite>();
		add(valueExceptionLeft);
		
		valueExceptionRight = new FlxTypedGroup<FlxSprite>();
		add(valueExceptionRight);
		
		exceptions = new FlxTypedGroup<FlxSprite>();
		add(exceptions);
		
		FlxG.sound.playMusic(Paths.inst('valueexception'), 1, false);
		FlxG.sound.music.onComplete = preCrashGame;
		
		Conductor.changeBPM(SONG.bpm);
		//trace(SONG.bpm);
		
		if (!Highscore.getDS() && !Highscore.getPhoto())
		{
			filters = [ShadersHandler.chromaticAberration];
			FlxG.camera.setFilters(filters);
			FlxG.camera.filtersEnabled = true;
		}
		
		if (SONG.notes.length > 0)
		{
			genocideNotes = [];
			for (shitnote in SONG.notes)
			{
				for (somemoreshit in shitnote.sectionNotes)
				{
					genocideNotes.push(somemoreshit);
				}
			}
		}
		
		var loadedSong:SwagSong = Song.loadFromJson('commands', 'genocide');
		if (loadedSong.notes.length > 0)
		{
			commandNotes = [];
			for (shitnote in loadedSong.notes)
			{
				for (somemoreshit in shitnote.sectionNotes)
				{
					commandNotes.push(somemoreshit);
				}
			}
		}
		
		FlxG.camera.bgColor = 0xff36393f;
		
		//preCrashGame();
		
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
		
		if (justCrashIt)
		{
			crashGame();
		}
		
		if (!Highscore.getDS() && !Highscore.getPhoto())
		{
			setChrome(chromeValue);
		}
		
		FlxG.sound.volume = 1;
		
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
		
		valueExceptionLeft.forEach(function(spr:FlxSprite)
		{
			spr.x -= 100;
			if (spr.x < 0)
			{
				spr.kill();
				valueExceptionLeft.remove(spr, true);
				spr.destroy();
			}
		});
		
		valueExceptionRight.forEach(function(spr:FlxSprite)
		{
			spr.x += 100;
			if (spr.x > FlxG.width)
			{
				spr.kill();
				valueExceptionRight.remove(spr, true);
				spr.destroy();
			}
		});
		
		if (0 < genocideNotes.length && Conductor.songPosition > genocideNotes[0][0])
		{
			var newFlxSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("ValueException/" + FlxG.random.int(values[0], values[1])));
			newFlxSprite.scale.set(2, 2);
			newFlxSprite.y = FlxG.random.float(0, FlxG.height - (newFlxSprite.height * 2));
			newFlxSprite.x = (newFlxSprite.width * 2) * -1;
			if (FlxG.random.bool(50))
			{
				newFlxSprite.x = FlxG.width + (newFlxSprite.width * 2);
				valueExceptionLeft.add(newFlxSprite);
			} else {
				valueExceptionRight.add(newFlxSprite);
			}
			genocideNotes.shift();
		}
		
		if (0 < commandNotes.length && Conductor.songPosition > commandNotes[0][0])
		{
			var newFlxSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("ValueException/" + FlxG.random.int(values[0], values[1])));
			newFlxSprite.x = FlxG.random.float(0, FlxG.width - newFlxSprite.width);
			newFlxSprite.y = FlxG.random.float(0, FlxG.height - newFlxSprite.height);
			valueExceptionOverlay.add(newFlxSprite);
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				newFlxSprite.kill();
				valueExceptionOverlay.remove(newFlxSprite, true);
				newFlxSprite.destroy();
			}, 1);
			commandNotes.shift();
		}

			#if desktop
			if (!FlxG.fullscreen && !justCrashIt)
			{
			var resX:Int = Std.int(Capabilities.screenResolutionX);
			var resY:Int = Std.int(Capabilities.screenResolutionY);
			//trace(resX);
			//trace(resY);
			var resXDivide:Int = Std.int(Capabilities.screenResolutionX / 350);
			var resYDivide:Int = Std.int(Capabilities.screenResolutionY / 350);
			if (Lib.application.window.x + Lib.application.window.width > resX)
			{
				invertedX = true;
			} else if (Lib.application.window.x < 0)
			{
				invertedX = false;
			}
			if (Lib.application.window.y + Lib.application.window.height > resY)
			{
				invertedY = true;
			} else if (Lib.application.window.y < 0)
			{
				invertedY = false;
			}
			if (invertedX)
			{
			Lib.application.window.x -= resXDivide;
			} else {
			Lib.application.window.x += resXDivide;
			}
			if (invertedY)
			{
			Lib.application.window.y -= resYDivide;
			} else {
			Lib.application.window.y += resYDivide;
			}
			}
			#end
	}
	
	override function beatHit()
	{
		super.beatHit();
	
		//trace("yes");
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
		//newFlxSprite.y -= newFlxSprite.height;
		newFlxSprite.x = FlxG.random.float(0, FlxG.width - newFlxSprite.width);
		valueExceptionSlow.add(newFlxSprite);
	}
}