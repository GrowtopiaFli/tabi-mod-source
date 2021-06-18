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

class SettingsMenu extends MusicBeatState
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
		_pad = new FlxVirtualPad(UP_DOWN, A_B);
		_pad.alpha = 0.65;
		add(_pad);
		_pad.cameras = [higherCam];
		#end
	
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		
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
		FlxG.sound.playMusic(Paths.music('brosucks'), 0, true);
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
	
	var ourFuckingList:Array<String> = [];
	
	var downScrollShit:String = (Highscore.getDownscroll()) ? "On" : "Off";
	var inputShit:String = (Highscore.getInput()) ? "On" : "Off";
	/*var voiceShit:String = "Off";
	var rusShit:String = "Off";
	
	if (Highscore.getVoice())
	{
		voiceShit = "On";
		rusShit = "Disabled";
	}
	
	if (Highscore.getRus())
	{
		rusShit = "On";
		voiceShit = "Disabled";
	}*/

	var voiceShit:String = (Highscore.getVoice()) ? "On" : "Off";
	var rusShit:String = (Highscore.getRus()) ? "On" : "Off";

	var photoShit:String = (Highscore.getPhoto()) ? "On" : "Off";
	var dsShit:String = (Highscore.getDS()) ? "On" : "Off";
	
	ourFuckingList.push('Downscroll $downScrollShit');
	ourFuckingList.push('New Input System $inputShit');
	ourFuckingList.push('Custom Keybindings');
	ourFuckingList.push('Visual Effects');
	ourFuckingList.push('Voicelines $voiceShit');
	ourFuckingList.push('Russian Language $rusShit');
	ourFuckingList.push('Photosensitive Mode $photoShit');
	ourFuckingList.push('Disable Shaders $dsShit');

	#if (android || web)
	ourFuckingList.push('Customize Controls');
	#end
	
	for (shit in ourFuckingList)
	{
		songs.push(new SongMetadata(shit, 1, 'gf'));
	}
	
	var fuckingBool:Array<Bool> = [
	Highscore.getDownscroll(),
	Highscore.getInput(),
	false,
	false,
	Highscore.getVoice(),
	Highscore.getRus(),
	Highscore.getPhoto(),
	Highscore.getDS(),
	false
	];

	for (i in 0...songs.length)
	{
		var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
		songText.isMenuItem = true;
		songText.noAnim = true;
		songText.targetY = i;
		#if !web
		if (fuckingBool[i])
		{
			songText.color = 0xffff33;
		}
		#end
		/*if (songs[i].songName.endsWith('Disabled'))
		{
			songText.color = 0xff3333;
		}*/
		grpSongs.add(songText);
	}
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
		upP = controls.UP_P || _pad.buttonUp.justPressed;
		downP = controls.DOWN_P || _pad.buttonDown.justPressed;
		accepted = controls.ACCEPT || _pad.buttonA.justPressed;
		backed = controls.BACK || _pad.buttonB.justPressed;
		#if android
		if (FlxG.android.justReleased.BACK)
		{
		backed = true;
		}
		#end
		#else
		upP = controls.UP_P;
		downP = controls.DOWN_P;
		accepted = controls.ACCEPT;
		backed = controls.BACK;
		#end

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		
		if (Highscore.getInput() && FlxG.mouse.wheel != 0)
		{
			changeSelection(FlxG.mouse.wheel * -1);
		}

		if (backed)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			switch(curSelected)
			{
			case 0:
				Highscore.toggleDownscroll();
			case 1:
				Highscore.toggleInput();
			case 2:
				FlxG.switchState(new KeysMenu());
			case 3:
				FlxG.switchState(new EffectsMenu());
			case 4:
				/*if (!(Highscore.getRus() && !Highscore.getVoice()))
				{*/
					Highscore.toggleVoice();
				//}
			case 5:
				/*if (!(Highscore.getVoice() && !Highscore.getRus()))
				{*/
					Highscore.toggleRus();
				//}
			case 6:
				Highscore.togglePhoto();
			case 7:
				Highscore.toggleDS();
			case 8:
				#if (android || web)
				FlxG.switchState(new CustomControlsState());
				#end
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
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}