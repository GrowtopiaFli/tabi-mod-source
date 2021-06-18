package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
//import io.newgrounds.NG;
import lime.app.Application;

import flixel.FlxCamera;
#if (web || android)
import ui.FlxVirtualPad;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var mainCam:FlxCamera;
	var higherCam:FlxCamera;
	
	#if (web || android)
	var _pad:FlxVirtualPad;
	#end

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		mainCam = new FlxCamera();
		higherCam = new FlxCamera();
		higherCam.bgColor.alpha = 0;
	
		FlxG.cameras.reset(mainCam);
		FlxG.cameras.add(higherCam);
		
		FlxCamera.defaultCameras = [mainCam];
		
		#if (web || android)
		_pad = new FlxVirtualPad(UP_DOWN, A_B);
		_pad.alpha = 0.75;
		add(_pad);
		_pad.cameras = [higherCam];
		#end
		
		higherCam.y -= 100;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);
		
		var daMultiplier:Float = 2;
		var daString:String = "Tabi v" + CurrentVersion.get() + "\nFNF v" + Application.current.meta.get('version') + " Commit d3cd2e2";

		#if (web || android)
		daMultiplier++;
		daString += "\nVisual Controls by luckydog7";
		#end

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18 * daMultiplier, 0, daString, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var upped:Bool = false;
			var downed:Bool = false;
			var accepted:Bool = false;
			var backed:Bool = false;
			
			#if (web || android)
			accepted = controls.ACCEPT || _pad.buttonA.justPressed;
			backed = controls.BACK || _pad.buttonB.justPressed;
			upped = controls.UP_P || _pad.buttonUp.justPressed;
			downed = controls.DOWN_P || _pad.buttonDown.justPressed;
			#if android
			if (FlxG.android.justReleased.BACK)
			{
			backed = true;
			}
			#end
			#else
			accepted = controls.ACCEPT;
			backed = controls.BACK;
			upped = controls.UP_P;
			downed = controls.DOWN_P;
			#end
		
			if (upped)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (downed)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			
			if (Highscore.getInput() && FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(FlxG.mouse.wheel * -1);
			}

			if (backed)
			{
				FlxTween.tween(FlxG.camera, { x: FlxG.width, zoom: 0.5 }, 1, { ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
				{
					FlxG.switchState(new TitleState());
				} });
			}

			if (accepted)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false);
							var daChoice:String = optionShit[curSelected];

							//FlxG.camera.focusOn(menuItems.members[curSelected].getGraphicMidpoint());

							var daZoom:Float = 1.5;
							var daY:Float = 0;
							
							switch (daChoice)
							{
								case 'story mode':
									daZoom = 0.5;
									daY = FlxG.height;
								case 'options':
									daZoom = 0.5;
									daY = FlxG.height * -1;
							}
							
							var daAngle:Float = 0;
							if (daChoice == 'freeplay')
							{
								daAngle = 45;
							}

							FlxTween.tween(FlxG.camera, { zoom: daZoom, y: daY, angle: daAngle }, 1, { ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
							{
								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new SettingsMenu());
								}
								FlxTween.tween(FlxG.camera, { zoom: 1 }, 1.5, { ease: FlxEase.quadIn });
							} });
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
