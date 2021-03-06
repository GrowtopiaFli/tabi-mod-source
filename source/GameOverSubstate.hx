package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.FlxCamera;
#if (web || android)
import ui.FlxVirtualPad;
#end

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	
	#if (web || android)
	var _pad:FlxVirtualPad;
	#end

	public function new(daBfShit:Boyfriend)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'genocide':
				daBf = 'bf-knife';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;
		
		if (stageSuffix == '-pixel')
		{
			bf = new Boyfriend(daBfShit.x, daBfShit.y, daBf);
		} else {
			bf = new Boyfriend(daBfShit.x, daBfShit.y + (daBfShit.height * daBfShit.daZoom), daBf);
		}
		
		add(bf);
		
		if (stageSuffix != '-pixel')
		{
			bf.setZoom(daBfShit.daZoom);
			bf.y -= bf.height * daBfShit.daZoom;
		}
		
		bf.scrollFactor.set(daBfShit.scrollFactor.x, daBfShit.scrollFactor.y);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		
		#if (web || android)
		_pad = new FlxVirtualPad(NONE, A_B);
		_pad.alpha = 0.75;
		add(_pad);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var accepted:Bool = false;
		var backed:Bool = false;
		
		#if (web || android)
		accepted = controls.ACCEPT || _pad.buttonA.justPressed;
		backed = controls.BACK || _pad.buttonB.justPressed;
		#if android
		if (FlxG.android.justReleased.BACK)
		{
		backed = true;
		}
		#end
		#else
		accepted = controls.ACCEPT;
		backed = controls.BACK;
		#end

		if (accepted)
		{
			endBullshit();
		}

		if (backed)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		
		cameras = [FlxG.cameras.list[0]];
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
