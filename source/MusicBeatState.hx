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
	public var chromaticAberration(get, never):ShaderFilter;
	
	inline function get_chromaticAberration():ShaderFilter
		return ChromaHandler.chromaticAberration;
		
	/*public var shockwave(get, never):ShaderFilter;
	
	inline function get_shockwave():ShaderFilter
		return ShockwaveHandler.shockwave;*/

	public function setChrome(daChrome:Float):Void
		ChromaHandler.setChrome(daChrome);
	
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
		return BrightHandler.brightShader;
		
	public function setBrightness(brightness:Float):Void
		BrightHandler.setBrightness(brightness);
		
	public function setContrast(contrast:Float):Void
		BrightHandler.setContrast(contrast);

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();
			
		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		super.update(elapsed);
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
