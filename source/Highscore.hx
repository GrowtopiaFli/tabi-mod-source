package;

import flixel.FlxG;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
import openfl.Lib;

class Highscore
{
	public static var weekData:Array<String> = [
	'tutorial',
	'week1',
	'week2',
	'week3',
	'week4',
	'week5',
	'week6',
	'curse'
	];
	
	public static var storyWeekNames:Array<String> = [
	'Tutorial',
	'Week 1',
	'Week 2',
	'Week 3',
	'Week 4',
	'Week 5',
	'Week 6',
	'Curse'
	];

	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var miscData:Map<String, Bool> = new Map();
	public static var visualEffects:Map<String, String> = new Map();
	public static var keyb:Map<Int, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var miscData:Map<String, Bool> = new Map<String, Bool>();
	public static var visualEffects:Map<String, String> = new Map<String, String>();
	public static var keyb:Map<Int, String> = new Map<Int, String>();
	#end
	
	public static function toggleEffect(effect:Int):Void
	{
	
	var effects:Array<String> = getEffectKeys();
	var myEffects:Array<String> = getEffects();
	var myEffects2:Array<String> = [];
	var myEffects3:Array<String> = [];
	var myEffects4:Array<String> = [];
	
	for (eff in myEffects)
	{
	if (!myEffects2.contains(eff))
	{
	myEffects2.push(eff);
	}
	}
	
	for (eff in effects)
	{
	if (!myEffects2.contains(eff))
	{
	myEffects3.push("NULLIFIED_DATA_IGNOREIT");
	} else {
	myEffects3.push(eff);
	}
	}
	
	if (effect <= effects.length)
	{
	
	if (myEffects3[effect] == "NULLIFIED_DATA_IGNOREIT")
	{
	myEffects3[effect] = effects[effect];
	} else {
	myEffects3[effect] = "NULLIFIED_DATA_IGNOREIT";
	}
	
	for (eff in myEffects3)
	{
	if (eff != "NULLIFIED_DATA_IGNOREIT")
	{
	myEffects4.push(eff);
	}
	}
	
	setEffects(myEffects4);
	
	}
	
	}
	
	public static function getEffects():Array<String>
	{
	if (!visualEffects.exists('Effects'))
		setEffects([]);

	return parseEffects(visualEffects.get('Effects'));
	}
	
	public static function parseEffects(toParse:String):Array<String>
	{
	return haxe.Json.parse(haxe.crypto.Base64.decode(toParse).toString());
	}
	
	public static function setEffects(effects:Array<String>):Void
	{
	visualEffects.set("Effects", haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(haxe.Json.stringify(effects))).toString());
	FlxG.save.data.Effects = visualEffects;
	FlxG.save.flush();
	}
	
	public static function getEffectKeys():Array<String>
	{
	var theKeys:Array<String> = [];
	for (key in getEffectList().keys())
	{
	theKeys.push(key);
	}
	return theKeys;
	}
	
	public static function getEffectList():Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>
	{
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [
			"Scanline" => {
				filter: new ShaderFilter(new Scanline()),
			}, "Hq2x" => {
				filter: new ShaderFilter(new Hq2x()),
			}, "Tiltshift" => {
				filter: new ShaderFilter(new Tiltshift()),
			},
			"Blur" => {
				filter: new BlurFilter(),
			},
			"Grayscale" => {
				var matrix:Array<Float> = [
					0.3, 0.3, 0.3, 0, 0,
					0.3, 0.3, 0.3, 0, 0,
					0.3, 0.3, 0.3, 0, 0,
					  0,   0,   0, 1, 0,
				];

				{filter: new ColorMatrixFilter(matrix)}
			},
			"Invert" => {
				var matrix:Array<Float> = [
					-1,  0,  0, 0, 255,
					 0, -1,  0, 0, 255,
					 0,  0, -1, 0, 255,
					 0,  0,  0, 1,   0,
				];

				{filter: new ColorMatrixFilter(matrix)}
			},
			"Deuteranopia" => {
				var matrix:Array<Float> = [
					0.43, 0.72, -.15, 0, 0,
					0.34, 0.57, 0.09, 0, 0,
					-.02, 0.03,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];

				{filter: new ColorMatrixFilter(matrix)}
			},
			"Protanopia" => {
				var matrix:Array<Float> = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];

				{filter: new ColorMatrixFilter(matrix)}
			},
			"Tritanopia" => {
				var matrix:Array<Float> = [
					0.97, 0.11, -.08, 0, 0,
					0.02, 0.82, 0.16, 0, 0,
					0.06, 0.88, 0.18, 0, 0,
					   0,    0,    0, 1, 0,
				];

				{filter: new ColorMatrixFilter(matrix)}
			}
		];
		
		return filterMap;
	}
	
	public static function getKeyBind(keyNum:Int):String
	{
	if (!keyb.exists(keyNum))
	{
		switch(keyNum)
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
			setKeyb(keyNum, "NONE");
		}
	}
	
	removeExistingKeyBind(keyNum, keyb.get(keyNum));

	return keyb.get(keyNum);
	}
	
	public static function setKeyBind(keyNum:Int, keyVal:String):Void
	{
		removeExistingKeyBind(keyNum, keyVal);
		setKeyb(keyNum, keyVal);
	}
	
	public static function setKeyb(keyNum:Int, keyVal:String):Void
	{
	keyb.set(keyNum, keyVal);
	FlxG.save.data.KEYBINDINGS = keyb;
	FlxG.save.flush();
	}
	
	public static function removeExistingKeyBind(keyNum:Int, keyVal:String):Void
	{
		/*var level:Int = 1;
		if (keyNum > 3)
		{
			level = 2;
		}
		var maxLengthShit:Int = 4 * level;
		var startShit:Int = 4 * (level - 1);*/
		//for (i in startShit...maxLengthShit)
		for (i in 0...8)
		{
			if (keyb.get(i) == keyVal && i != keyNum && keyVal != "NONE")
			{
				setKeyb(i, "NONE");
			}
		}
	}

	public static function getDownscroll():Bool
	{
	if (!miscData.exists('downscroll'))
		setKey('downscroll', false);

	return miscData.get('downscroll');
	}
	
	public static function setKey(whatkey:String, what:Bool):Void
	{
	miscData.set(whatkey, what);
	FlxG.save.data.misc = miscData;
	FlxG.save.flush();
	}
	
	public static function toggleDownscroll():Void
	{
	setKey('downscroll', !miscData.get('downscroll'));
	}
	
	public static function getInput():Bool
	{
	if (!miscData.exists('inputsys'))
		setKey('inputsys', false);

	return miscData.get('inputsys');
	}
	
	public static function getVoice():Bool
	{
	if (!miscData.exists('voicelinemode'))
		setKey('voicelinemode', true);

	return miscData.get('voicelinemode');
	}
	
	public static function getRus():Bool
	{
	if (!miscData.exists('russianmode'))
		setKey('russianmode', false);

	return miscData.get('russianmode');
	}
	
	public static function getPhoto():Bool
	{
	if (!miscData.exists('photosensitive'))
		setKey('photosensitive', false);

	return miscData.get('photosensitive');
	}
	
	public static function toggleInput():Void
	{
	setKey('inputsys', !miscData.get('inputsys'));
	}
	
	public static function toggleVoice():Void
	{
	setKey('voicelinemode', !miscData.get('voicelinemode'));
	}
	
	public static function toggleRus():Void
	{
	setKey('russianmode', !miscData.get('russianmode'));
	}

	public static function togglePhoto():Void
	{
	setKey('photosensitive', !miscData.get('photosensitive'));
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?mode:Int = -1):Void
	{
		var daSong:String = formatSong2(song, diff, mode);

		/*#if !switch
		NGio.postScore(score, song);
		#end*/


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0, ?mode:Int = -1):Void
	{
		trace("WEEK SCORE SAVED?");

		/*#if !switch
		NGio.postScore(score, "Week " + week);
		#end*/


		var daWeek:String = formatSong2('week' + week, diff, mode);

		//More like da weekend am i right lol
		//OOOOOOOOOOOOOO IM BLINDED BY THE LIGHTS

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}
	
	public static function formatSong2(song:String, diff:Int, ?mode:Int = -1):String
	{
		if (mode == null)
		{
		mode = -1;
		}
		var parsedMode = "-." + Std.string(mode);
		var daSong:String = song;
		
		daSong += parsedMode;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int, ?mode:Int = -1):Int
	{
		if (!songScores.exists(formatSong2(song, diff, mode)))
			setScore(formatSong2(song, diff, mode), 0);

		return songScores.get(formatSong2(song, diff, mode));
	}

	public static function getWeekScore(week:Int, diff:Int, ?mode:Int = -1):Int
	{
		if (!songScores.exists(formatSong2('week' + week, diff, mode)))
			setScore(formatSong2('week' + week, diff, mode), 0);

		return songScores.get(formatSong2('week' + week, diff, mode));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.misc != null)
		{
			miscData = FlxG.save.data.misc;
		}
		if (FlxG.save.data.KEYBINDINGS != null)
		{
			keyb = FlxG.save.data.KEYBINDINGS;
		}
		if (FlxG.save.data.Effects != null)
		{
			visualEffects = FlxG.save.data.Effects;
		}
	}
}
