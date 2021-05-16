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

import flixel.util.FlxTimer;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class KeysMenu extends MusicBeatState
{
	var selectMode:Bool = false;
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	
	var allowChange:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{	
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Changing Keybinds...", null);
		#end
		
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		//menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		
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
	allowChange = false;
	new FlxTimer().start(1, function(tmr:FlxTimer)
	{
	allowChange = true;
	});
	remove(grpSongs);
	grpSongs = new FlxTypedGroup<Alphabet>();
	songs.splice(0, songs.length);
	add(grpSongs);
	
	var ourFuckingList:Array<String> = [];
	var gtk = Highscore.getKeyBind;
	
	ourFuckingList.push("P ONE Up TO " + gtk(0));
	ourFuckingList.push("P ONE Left TO " + gtk(1));
	ourFuckingList.push("P ONE Down TO " + gtk(2));
	ourFuckingList.push("P ONE Right TO " + gtk(3));
	
	ourFuckingList.push("P TWO Up TO " + gtk(4));
	ourFuckingList.push("P TWO Left TO " + gtk(5));
	ourFuckingList.push("P TWO Down TO " + gtk(6));
	ourFuckingList.push("P TWO Right TO " + gtk(7));
	
	for (shit in ourFuckingList)
	{
		songs.push(new SongMetadata(shit, 1, 'gf'));
	}

	for (i in 0...songs.length)
	{
		var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, true);
		songText.isMenuItem = true;
		songText.noAnim = true;
		songText.targetY = i;
		grpSongs.add(songText);
	}
	
	/*new FlxTimer().start(0.05, function(tmr:FlxTimer)
	{
	if (FlxG.random.bool(40))
	{
		var daSound:String = "GF_";
		FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
	}
	}, "P ONE RIGHT TO RIGHT".length);*/
	
	//var daSound:String = "GF_";
	//FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
	
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
		item.color = 0xFFffff;
	}
	
	grpSongs.members[curSelected].color = 0xFFff33;
	
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (selectMode)
		{
		grpSongs.members[curSelected].color = 0x33FFFF;
		} else {
		grpSongs.members[curSelected].color = 0xFFff33;
		}
		
		var disableBoi:Bool = false;
		
		if (FlxG.keys.justReleased.ANY && selectMode)
		{
		var prk = FlxG.keys.firstJustReleased();
		if (prk != -1)
		{
		var fuckingBlacklist:Array<Int> = [13, 8];
		var fuckingWhitelist:Array<Int> = [32, 16, 17, 18, 221, 219, 222, 186, 191, 190, 188];
		if (!fuckingBlacklist.contains(prk))
		{
		if (fuckingWhitelist.contains(prk) || ((prk >= 49 && prk <= 55) || (prk >= 65 && prk <= 90) || (prk >= 37 && prk <= 40)))
		{
		var str = String.fromCharCode;
		var finalprk = String.fromCharCode(prk).toUpperCase();
		finalprk = finalprk.replace("0", "ZERO").replace("1", "ONE").replace("2", "TWO").replace("3", "THREE").replace("4", "FOUR").replace("5", "FIVE").replace("6", "SIX").replace("7", "SEVEN");
		finalprk = finalprk.replace(str(190), "PERIOD").replace(str(188), "COMMA").replace(str(191), "SLASH").replace(str(222), "QUOTE").replace(str(186), "SEMICOLON").replace(str(219), "LBRACKET").replace(str(221), "RBRACKET");
		finalprk = finalprk.replace(str(32), "SPACE").replace(str(18), "ALT").replace(str(17), "CONTROL").replace(str(16), "SHIFT");
		finalprk = finalprk.replace(str(37), "LEFT").replace(str(38), "UP").replace(str(39), "RIGHT").replace(str(40), "DOWN");
		var setKeyb = Highscore.setKeyBind;
		setKeyb(curSelected, finalprk);
		trace(finalprk);
		disableBoi = true;
		} else {
		switch(prk)
		{
		case 56:
			var setKeyb = Highscore.setKeyBind;
			setKeyb(curSelected, "NONE");
			disableBoi = true;
		case 57:
			var setKeyb = Highscore.setKeyBind;
			switch(curSelected)
			{
			case 0:
				setKeyb(0, "UP");
			case 1:
				setKeyb(1, "LEFT");
			case 2:
				setKeyb(2, "DOWN");
			case 3:
				setKeyb(3, "RIGHT");
			case 4:
				setKeyb(4, "W");
			case 5:
				setKeyb(5, "A");
			case 6:
				setKeyb(6, "S");
			case 7:
				setKeyb(7, "D");
			default:
				setKeyb(curSelected, "");
			}
			disableBoi = true;
		}
		}
		}
		}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (!selectMode)
		{
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

		if (controls.BACK)
		{
			FlxG.switchState(new SettingsMenu());
		}
		} else if (controls.BACK)
		{
		fuckTheClearance();
		selectMode = false;
		}

		if (accepted)
		{
			selectMode = true;
		}
		
		if (disableBoi)
		{
		fuckTheClearance();
		selectMode = false;
		disableBoi = false;
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (allowChange)
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
			item.color = 0xFFffff;
		}
		}
	}
}