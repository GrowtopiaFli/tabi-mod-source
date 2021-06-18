package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import lime.app.Promise;
import lime.app.Future;
import openfl.events.Event;
import openfl.display.Loader;
import openfl.display.MovieClip;
import openfl.utils.ByteArray;
import openfl.system.ApplicationDomain;
import openfl.system.LoaderContext;

import openfl.Lib;

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var musicPaused:Bool = false;
	public var video:SwfHandler;
	public var videoSprite:FlxSprite;
	public var frameRate:Float = 30;
	public var useSound:Bool = false;
	public var wasFuckingHit:Bool = false;

	public function new(source:String, toTrans:FlxState, fRate:Float)
	{
		super();
		
		leSource = source;
		transClass = toTrans;
		frameRate = fRate;
	}
	
	override function create()
	{
		super.create();
		FlxG.autoPause = false;
		doShit = false;
		
		/*if (GlobalVideo.isWebm)
		{
		videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		}*/
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		txt.visible = false;
		
		if (!Assets.exists(leSource, BINARY))
		{
			throw new haxe.ValueException("Dude, Please Follow Instructions LOL");
		}

		/*if (GlobalVideo.isWebm)
		{*/
			if (Assets.exists(leSource.replace(".swf", '.${Paths.SOUND_EXT}'), MUSIC) || Assets.exists(leSource.replace(".swf", '.${Paths.SOUND_EXT}'), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".swf", ".ogg"));
			}
		//}

		/*video.source(leSource);
		video.clearPause();
		if (GlobalVideo.isWebm)
		{
			video.updatePlayer();
		}
		if (GlobalVideo.isWebm)
		{
			video.restart();
		} else {
			video.play();
		}*/
		
		/*if (useSound)
		{*/
			//vidSound = FlxG.sound.play(leSource.replace(".swf", ".ogg"));
		
			/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{*/
				vidSound.time = vidSound.length * soundMultiplier;
				/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}, 0);*/
				//doShit = true;
			//}, 1);
		//}
		
		/*if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}*/
		
		video = new SwfHandler();
		
		videoSprite = new FlxSprite();
		add(videoSprite);
		
		videoSprite.visible = false;

		var daByteArray:ByteArray = Assets.getBytes(leSource);
		var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
		lc.allowCodeImport = true;
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_)
		{
			try {
				video.movieClip = cast(loader.content, MovieClip);
				txt.visible = true;
				videoSprite.visible = true;
				new FlxTimer().start(1 / frameRate, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						if (video.movieClip.currentFrame > 0)
						{
							wasFuckingHit = true;
						}
						soundMultiplier = video.movieClip.currentFrame / video.movieClip.totalFrames;
				
						if (soundMultiplier > 1)
						{
							soundMultiplier = 1;
						}
						if (soundMultiplier < 0)
						{
							soundMultiplier = 0;
						}
						if (doShit)
						{
							var compareShit:Float = 50;
							if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
								vidSound.time = vidSound.length * soundMultiplier;
						}
						if (wasFuckingHit)
						{
							if (soundMultiplier == 0)
							{
								if (prevSoundMultiplier != 0)
								{
									vidSound.pause();
									vidSound.time = 0;
								}
							} else {
								if (prevSoundMultiplier == 0)
								{
									vidSound.resume();
									vidSound.time = vidSound.length * soundMultiplier;
								}
							}
							prevSoundMultiplier = soundMultiplier;
						}
					}
				}, 0);
				doShit = true;

			}
			catch(e:Dynamic)
			{
				throw new haxe.ValueException("Video Loading Failed LMAO!");
			}
		});
		loader.loadBytes(daByteArray, lc);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (doShit)
		{
			if (notDone)
			{
				FlxG.sound.music.volume = 0;
			}

			videoSprite.x = GlobalVideo.calc(0);
			videoSprite.y = GlobalVideo.calc(1);
			video.movieClip.width = GlobalVideo.calc(2);
			video.movieClip.height = GlobalVideo.calc(3);
			
			video.update();
			
			videoSprite.pixels = video.video;

			if (controls.RESET)
			{
				video.restart();
			}
		
			if (FlxG.keys.justPressed.P)
			{
				txt.text = pauseText;
				trace("PRESSED PAUSE");
				video.togglePause();
				if (video.paused)
				{
					videoSprite.alpha = GlobalVideo.daAlpha1;
				} else {
					videoSprite.alpha = GlobalVideo.daAlpha2;
					txt.text = defaultText;
				}
			}
		
			if (controls.ACCEPT || video.ended || video.stopped)
			{
				txt.visible = false;
				videoSprite.visible = false;
				video.stop();
			}
		
			if (controls.ACCEPT || video.ended)
			{
				notDone = false;
				FlxG.sound.music.volume = fuckingVolume;
				txt.text = pauseText;
				if (musicPaused)
				{
					musicPaused = false;
					FlxG.sound.music.resume();
				}
				FlxG.autoPause = true;
				FlxG.switchState(transClass);
			}
		
			video.restarted = false;
			video.played = false;
			video.stopped = false;
			video.ended = false;
		}
	}
}
