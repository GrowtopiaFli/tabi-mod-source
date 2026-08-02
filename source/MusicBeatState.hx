package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

import openfl.filters.ShaderFilter;

class MusicBeatState extends FlxUIState
{
	public var values:Array<Int> = [1, 42];

	public var chromaticAberration(get, never):ShaderFilter;
	
	inline function get_chromaticAberration():ShaderFilter
		return ShadersHandler.chromaticAberration;
		
	/*public var shockwave(get, never):ShaderFilter;
	
	inline function get_shockwave():ShaderFilter
		return ShockwaveHandler.shockwave;*/

	public function setChrome(daChrome:Float):Void
		ShadersHandler.setChrome(daChrome);
	
	/*public function getValue(valName:String):Array<Float>
	{
		return ShockwaveHandler.getValue(valName);
	}
	
	public function setValue(valName:String, valueData:Array<Float>):Void
	{
		ShockwaveHandler.setValue(valName, valueData);
	}*/
	
	public var brightShader(get, never):ShaderFilter;
	
	inline function get_brightShader():ShaderFilter
		return ShadersHandler.brightShader;
		
	public function setBrightness(brightness:Float):Void
		ShadersHandler.setBrightness(brightness);
		
	public function setContrast(contrast:Float):Void
		ShadersHandler.setContrast(contrast);

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	
	private var daKeys:Array<String> = [];
	private var daString:String = "valueexception";
	private var daTimer:FlxTimer;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		MLanguageDialogueParser.update();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();
			
		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		
		if (FlxG.keys.justReleased.ANY)
		{
			var prk = FlxG.keys.firstJustReleased();

			if (prk != 1 && (prk >= 65 && prk <= 90))
			{
				var str = String.fromCharCode;
				var finalprk = String.fromCharCode(prk);
				typeKey(finalprk.toLowerCase());
			}
		}
		
		if (daKeys.length > daString.length)
		{
			daKeys = [];
		}
		
		if (daKeys.join("") == daString)
		{
			daKeys = [];
			FlxG.switchState(new ValException());
		}

		super.update(elapsed);
	}
	
	private function typeKey(daKey:String):Void
	{
		if (daTimer != null)
		{
			daTimer.cancel();
			daTimer.destroy();
		}
		daTimer = new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			daKeys = [];
		}, 1);
		var daAlphabet:Array<String> = "abcdefghijklmnopqrstuvwxyz".split("");
		if (daAlphabet.contains(daKey))
		{
			var allowed:Array<String> = daString.split("");
			if (allowed.contains(daKey))
			{
				daKeys.push(daKey);
			}
		}
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
