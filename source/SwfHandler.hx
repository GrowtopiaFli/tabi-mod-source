package;

import flixel.FlxG;
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.utils.Assets;
import openfl.display.BitmapData;

class SwfHandler
{
	public var video:BitmapData = new BitmapData(GameDimensions.width, GameDimensions.height, true);
	public var initialized:Bool = false;
	public var movieClip:MovieClip = new MovieClip();
	
	public function new()
	{
	}
	
	public function update():Void
	{
		var susBitmapData:BitmapData = new BitmapData(Math.floor(movieClip.width), Math.floor(movieClip.height), true);
		susBitmapData.draw(movieClip);
		video = susBitmapData;
		if (movieClip.currentFrame == movieClip.totalFrames - 1)
		{
			stop();
			onEnd();
		}
	}
	
	public function play():Void
	{
		if (initialized)
		{
			movieClip.play();
			onPlay();
			paused = false;
		}
	}
	
	public function stop():Void
	{
		if (initialized)
		{
			movieClip.gotoAndStop(0);
			onStop();
		}
	}

	public function restart():Void
	{
		if (initialized)
		{
			movieClip.gotoAndPlay(0);
			onRestart();
		}
	}
	
	public var stopped:Bool = false;
	public var restarted:Bool = false;
	public var played:Bool = false;
	public var ended:Bool = false;
	public var paused:Bool = false;

	public function pause():Void
	{
		movieClip.stop();
		paused = true;
	}
	
	public function togglePause():Void
	{
		if (paused)
		{
			play();
		} else {
			pause();
		}
	}
	
	public function clearPause():Void
	{
		movieClip.play();
	}
	
	public function onStop():Void
	{
		stopped = true;
	}
	
	public function onRestart():Void
	{
		restarted = true;
	}
	
	public function onPlay():Void
	{
		played = true;
	}
	
	public function onEnd():Void
	{
		trace("IT ENDED!");
		ended = true;
	}
}