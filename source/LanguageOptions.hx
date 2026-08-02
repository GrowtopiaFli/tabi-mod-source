package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxCamera;
#if (web || android)
import ui.FlxVirtualPad;
#end

using StringTools;

class LanguageOptions extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	
	var mainCam:FlxCamera;
	var higherCam:FlxCamera;
	
	#if (web || android)
	var _pad:FlxVirtualPad;
	#end

	override function create()
	{
		mainCam = new FlxCamera();
		higherCam = new FlxCamera();
		higherCam.bgColor.alpha = 0;
	
		FlxG.cameras.reset(mainCam);
		FlxG.cameras.add(higherCam);
		
		FlxCamera.defaultCameras = [mainCam];
		
		#if (web || android)
		_pad = new FlxVirtualPad(LEFT_RIGHT, A_B);
		_pad.alpha = 0.65;
		add(_pad);
		_pad.cameras = [higherCam];
		#end
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Inside Settings...", null);
		#end
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);
		
		grpSongs = new FlxTypedGroup<Alphabet>();

		fuckTheClearance();

		if (!FlxG.sound.music.playing)
		{
		FlxG.sound.playMusic(Paths.music('options'), 0, true);
		FlxG.sound.music.fadeIn(2, 0, 0.8);
		}
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}
	
	public function fuckTheClearance():Void
	{
	remove(grpSongs);
	grpSongs = new FlxTypedGroup<Alphabet>();
	songs.splice(0, songs.length);
	add(grpSongs);
	
	var ourFuckingList:Array<String> = MLanguageDialogueParser.getList();

	for (shit in ourFuckingList)
	{
		songs.push(new SongMetadata(shit, 1, 'gf'));
	}

	for (i in 0...songs.length)
	{
		//var songText:Alphabet = new Alphabet(-1000, (70 * i) + 30, songs[i].songName, true, false);
		var songText:Alphabet = new Alphabet(0, FlxG.height / 2, songs[i].songName, true, false);
		songText.isMenuItem = true;
		songText.horizontal = true;
		songText.targetY = i;
		songText.visible = false;
		grpSongs.add(songText);
	}
	curSelected = Highscore.getLang();
	changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP:Bool = false;
		var downP:Bool = false;
		var accepted:Bool = false;
		var LEFT_P:Bool = false;
		var RIGHT_P:Bool = false;
		var backed:Bool = false;
		
		#if (web || android)
		upP = controls.LEFT_P || _pad.buttonLeft.justPressed;
		downP = controls.RIGHT_P || _pad.buttonRight.justPressed;
		accepted = controls.ACCEPT || _pad.buttonA.justPressed;
		backed = controls.BACK || _pad.buttonB.justPressed;
		#if android
		if (FlxG.android.justReleased.BACK)
		{
		backed = true;
		}
		#end
		#else
		upP = controls.LEFT_P;
		downP = controls.RIGHT_P;
		accepted = controls.ACCEPT;
		backed = controls.BACK;
		#end

		if (upP)
		{
			changeSelection(-1);
			Highscore.setLang(curSelected);
		}
		if (downP)
		{
			changeSelection(1);
			Highscore.setLang(curSelected);
		}
		
		if (Highscore.getInput() && FlxG.mouse.wheel != 0)
		{
			changeSelection(FlxG.mouse.wheel * -1);
		}

		if (backed)
		{
			FlxG.switchState(new SettingsMenu());
		}

		if (accepted)
		{
			switch(curSelected)
			{

			}
			fuckTheClearance();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.visible = true;
			item.targetY = bullShit - curSelected;
			if (grpSongs.members.length > 1)
			{
				/*if (bullShit == songs.length - 1 && curSelected == 1)
				{
					item.targetY = -2;
					var halfW:Float = FlxG.width / 2 - item.width / 2;
					item.y = FlxG.height / 2 - Math.abs(item.targetY * 70);
					item.x = item.targetY * halfW + halfW;
				}
				else if (bullShit == 0 && curSelected == songs.length - 2)
				{
					item.targetY = 2;
					var halfW:Float = FlxG.width / 2 - item.width / 2;
					item.y = FlxG.height / 2 - Math.abs(item.targetY * 70);
					item.x = item.targetY * halfW + halfW;
				}
				if (bullShit == 0 && curSelected == songs.length - 1)
				{
					item.targetY = 1;
				}
				else if (bullShit == songs.length - 1 && curSelected == 0)
				{
					item.targetY = -1;
				}*/
				if (item.targetY < -1)
				{
					item.targetY = -2;
					var halfW:Float = FlxG.width / 2 - item.width / 2;
					item.y = FlxG.height / 2 - Math.abs(item.targetY * 70);
					item.x = item.targetY * halfW + halfW;
				}
				else if (item.targetY > 1)
				{
					item.targetY = 2;
					var halfW:Float = FlxG.width / 2 - item.width / 2;
					item.y = FlxG.height / 2 - Math.abs(item.targetY * 70);
					item.x = item.targetY * halfW + halfW;
				}
			}
			bullShit++;

			item.alpha = 0.5;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}