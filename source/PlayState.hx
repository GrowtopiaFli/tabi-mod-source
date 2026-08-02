package;

import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;

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

#if desktop
import Discord.DiscordClient;
#end

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxAxes;

import Cutscene1;
import Cutscene2;

//import ChromaticAberration;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var showCutscene:Bool = true;
	public var genocideCommands:Array<Array<Dynamic>> = [];
	
	//public var chromaticAberration:ShaderFilter;
	
	//public var hasShocked:Bool = false;

	public var screenDanced:Bool = false;
	public var chromDanced:Bool = false;

	public var vignette:FlxSprite;

	public var noteShaked:Bool = false;
	public var crazyMode:Bool = false;
	public var isGenocide:Bool = false;
	public var minusHealth:Bool = false;
	public var justDoItMakeYourDreamsComeTrue:Bool = false;
	public var doIt:Bool = true;
	public var samShit:FlxSprite;

	var filters:Array<BitmapFilter> = [];
	var filterList:Array<BitmapFilter> = [];
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var doof:DialogueBox;
	
	public var prevAnim:String = "";
	public var tonNoteMode:Bool = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	/*private var goBf:Boyfriend;
	private var someCrap:FlxSprite;*/

	private var notes:FlxTypedGroup<Note>;
	private var daAnims:Array<String> = [];
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private var camFollow2:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var strumLineX:Array<Float> = [];
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var dadStrums:FlxTypedGroup<FlxSprite>;
	
	public var doIdle:Bool = false;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	
	private var misses:Int = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var vignetteCamera:FlxCamera;
	private var camHUD:FlxCamera;
	//private var camHUD2:FlxCamera;
	private var camHUD3:FlxCamera;
	private var camHUD4:FlxCamera;
	private var camHUD5:FlxCamera;
	private var cutsceneCam:FlxCamera;
	private var noteCam:FlxCamera;
	//private var noteCam2:FlxCamera;
	private var camGame:FlxCamera;
	private var camIllusion:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;
	
	var dadTimers:Array<FlxTimer> = [new FlxTimer(), new FlxTimer(), new FlxTimer(), new FlxTimer()];
	var chromeTimer:FlxTimer;
	var plzListen:Bool = true;
	var listenTimer:FlxTimer;
	
	private var cheatString:String = "NO";
	
	var notesHit:Float = 0;
	var notesPassing:Float = 0;
	
	var baseText2:String = "Accuracy: ";
	var daShitText:String = "Score: 0 | Misses: 0 | Health: 100% | Accuracy: ";
	var genocideBG:FlxSprite;
	var genocideBoard:FlxSprite;
	var siniFireBehind:FlxTypedGroup<SiniFire>;
	var siniFireFront:FlxTypedGroup<SiniFire>;
	
	#if desktop
	var iconRPC:String = "";
	var iconRPCBefore:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var storyText:String = "NORMAL";
	#end

	override public function create()
	{
		resetChromeShit2();
	
		/*if (SONG.song.toLowerCase() == 'genocide')
		{
			trace('RIP RAM lol');
		}*/
		doIdle = false;
		isGenocide = (SONG.song.toLowerCase() == 'genocide');
		crazyMode = (SONG.song.toLowerCase() == 'genocide' && storyDifficulty >= 2);
		if (crazyMode)
		{
			health = 2;
		}
		minusHealth = false;
		justDoItMakeYourDreamsComeTrue = false;
		doIt = true;
		#if desktop
		iconRPCBefore = SONG.player2;
		
		switch(iconRPCBefore)
		{
		case 'senpai-angry':
			iconRPCBefore = 'senpai';
		case 'monster-christmas':
			iconRPCBefore = 'monster';
		case 'mom-car':
			iconRPCBefore = 'mom';
		}
		
		iconRPC = iconRPCBefore;
		
		switch(storyDifficulty)
		{
		case 0:
			storyText = "EASY";
		case 2:
			storyText = "HARD";
		}
		
		if (isStoryMode)
		{
			detailsText = "(Story Mode: " + Highscore.storyWeekNames[storyWeek] + " " + '($storyText))';
		} else {
			detailsText = "(Freeplay " + '($storyText))';
		}
		
		DiscordClient.changePresence("Tabi v" + CurrentVersion.get() + " " + detailsText + " " + SONG.song, daShitText , iconRPC);
		#end
		
		//FUCKING SHITTY SHADER CODE
		filterMap = Highscore.getEffectList();
		
		FlxG.game.setFilters(filters);
		
		FlxG.game.filtersEnabled = false;
		
		var bullshitKeys:Array<String> = Highscore.getEffectKeys();
		
		for (key in filterMap.keys())
		{
			filterList.push(filterMap.get(key).filter);
		}
		
		trace(bullshitKeys);
		
		//FlxG.game.filtersEnabled = true;
		//FUCKING SHADERS CRAP
	
		misses = 0;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camIllusion = new FlxCamera();
		camIllusion.bgColor.alpha = 0;
		camGame = new FlxCamera();
		vignetteCamera = new FlxCamera();
		vignetteCamera.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		//camHUD2 = new FlxCamera();
		//camHUD2.bgColor.alpha = 0;
		camHUD3 = new FlxCamera();
		camHUD3.bgColor.alpha = 0;
		camHUD4 = new FlxCamera();
		camHUD4.bgColor.alpha = 0;
		camHUD5 = new FlxCamera();
		camHUD5.bgColor.alpha = 0;
		noteCam = new FlxCamera();
		noteCam.bgColor.alpha = 0;
		//noteCam2 = new FlxCamera();
		//noteCam2.bgColor.alpha = 0;
		cutsceneCam = new FlxCamera();
		cutsceneCam.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(vignetteCamera);
		FlxG.cameras.add(noteCam);
		//FlxG.cameras.add(noteCam2);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camHUD3);
		//FlxG.cameras.add(camHUD2);
		FlxG.cameras.add(camHUD4);
		FlxG.cameras.add(camHUD5);
		FlxG.cameras.add(camIllusion);		
		FlxG.cameras.add(cutsceneCam);

		FlxCamera.defaultCameras = [camGame];

		//IT DOESNT END HERE FUCK
		camGame.setFilters(filters);
		//camHUD2.setFilters(filters);
		noteCam.setFilters(filters);
		//noteCam2.setFilters(filters);
		camHUD3.setFilters(filters);
		cutsceneCam.setFilters(filters);
		camHUD5.setFilters(filters);
		camGame.filtersEnabled = true;
		//camHUD2.filtersEnabled = true;
		noteCam.filtersEnabled = true;
		//noteCam2.filtersEnabled = true;
		camHUD3.filtersEnabled = true;
		cutsceneCam.filtersEnabled = true;
		camHUD5.filtersEnabled = true;
		
		for (i in 0...filterList.length)
		{
		var kys = bullshitKeys[i];
		//if (kys == "Hq2x" || kys == "Grayscale" || kys == "Scanline" || kys == "Tiltshift")
		if (Highscore.getEffects().contains(kys))
			filters.push(filterList[i]);
		else
			filters.remove(filterList[i]);
		}
		
		filters.push(chromaticAberration);
		//filters.push(shockwave);
		filters.push(brightShader);
		//WELL SHIT

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (isStoryMode)
		{
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'my-battle' | 'last-chance' | 'genocide':
				dialogue = CoolUtil.coolDialogue(Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'Dialogue'));
				//trace(dialogue);
		}
		}

		if (SONG.song.toLowerCase() == 'spookeez' || SONG.song.toLowerCase() == 'monster' || SONG.song.toLowerCase() == 'south')
		{
			curStage = "spooky";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'pico' || SONG.song.toLowerCase() == 'blammed' || SONG.song.toLowerCase() == 'philly')
		{
			curStage = 'philly';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
			add(street);
		}
		else if (SONG.song.toLowerCase() == 'milf' || SONG.song.toLowerCase() == 'satin-panties' || SONG.song.toLowerCase() == 'high')
		{
			curStage = 'limo';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = true;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
			// add(limo);
		}
		else if (SONG.song.toLowerCase() == 'cocoa' || SONG.song.toLowerCase() == 'eggnog')
		{
			curStage = 'mall';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = true;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
			bgEscalator.antialiasing = true;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
			tree.antialiasing = true;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = true;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = true;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = true;
			add(santa);
		}
		else if (SONG.song.toLowerCase() == 'winter-horrorland')
		{
			curStage = 'mallEvil';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (SONG.song.toLowerCase() == 'senpai' || SONG.song.toLowerCase() == 'roses')
		{
			curStage = 'school';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = Paths.getPackerAtlas('weeb/weebTrees');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (SONG.song.toLowerCase() == 'roses')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		}
		else if (SONG.song.toLowerCase() == 'thorns')
		{
			curStage = 'schoolEvil';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		}
		else if (['my-battle', 'last-chance'].contains(SONG.song.toLowerCase()))
		{
			defaultCamZoom = 0.8;
			curStage = 'curse';
			var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/normal_stage'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		}
		else if (SONG.song.toLowerCase() == 'genocide')
		{
			defaultCamZoom = 0.8;
			curStage = 'genocide';
			/*var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/youhavebeendestroyed'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			var fireRow:FlxTypedGroup<TabiFire> = new FlxTypedGroup<TabiFire>();
			for (i in 0...3)
			{
				fireRow.add(new TabiFire(10 + (i * 450), 200));
			}
			add(fireRow);*/
			//and a 1 and a 2 and a 3 and your pc is fucked lol
			/*var prefixShit:String = 'fuckedpc/PNG_Sequence/StageFire';
			var shitList:Array<String> = [];
			for (i in 0...84)
			{
				var ourUse:Array<String> = [Std.string(i)];
				var ourUse2:Array<String> = Std.string(i).split("");
				while (ourUse2.length < 2)
				{
					ourUse.push("0");
					ourUse2.push("0");
				}
				ourUse.reverse();
				//trace(ourUse);
				shitList.push(prefixShit + ourUse.join(""));
			}*/
			
			siniFireBehind = new FlxTypedGroup<SiniFire>();
			siniFireFront = new FlxTypedGroup<SiniFire>();
			
			//genocideBG = new SequenceBG(-600, -300, shitList, true, 2560, 1400, true);
			genocideBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('fire/wadsaaa'));
			genocideBG.antialiasing = true;
			genocideBG.scrollFactor.set(0.9, 0.9);
			add(genocideBG);
			
			//Time for sini's amazing fires lol
			//this one is behind the board
			//idk how to position this
			//i guess fuck my life lol
			for (i in 0...2)
			{
				var daFire:SiniFire = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * i)), genocideBG.y + 180, true, false, 30, i * 10, 84);
				daFire.antialiasing = true;
				daFire.scrollFactor.set(0.9, 0.9);
				daFire.scale.set(0.4, 1);
				daFire.y += 50;
				siniFireBehind.add(daFire);
			}
			
			add(siniFireBehind);
			
			//genocide board is already in genocidebg but u know shit layering for fire lol
			genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/boards'));
			genocideBoard.antialiasing = true;
			genocideBoard.scrollFactor.set(0.9, 0.9);
			add(genocideBoard);
			
			//front fire shit

			var fire1:SiniFire = new SiniFire(genocideBG.x + (-100), genocideBG.y + 889, true, false, 30);
			fire1.antialiasing = true;
			fire1.scrollFactor.set(0.9, 0.9);
			fire1.scale.set(2.5, 1.5);
			fire1.y -= fire1.height * 1.5;
			fire1.flipX = true;
			
			var fire2:SiniFire = new SiniFire((fire1.x + fire1.width) - 80, genocideBG.y + 889, true, false, 30);
			fire2.antialiasing = true;
			fire2.scrollFactor.set(0.9, 0.9);
			//fire2.scale.set(2.5, 1);
			fire2.y -= fire2.height * 1;
			
			var fire3:SiniFire = new SiniFire((fire2.x + fire2.width) - 30, genocideBG.y + 889, true, false, 30);
			fire3.antialiasing = true;
			fire3.scrollFactor.set(0.9, 0.9);
			//fire3.scale.set(2.5, 1);
			fire3.y -= fire3.height * 1;
			
			var fire4:SiniFire = new SiniFire((fire3.x + fire3.width) - 10, genocideBG.y + 889, true, false, 30);
			fire4.antialiasing = true;
			fire4.scrollFactor.set(0.9, 0.9);
			fire4.scale.set(1.5, 1.5);
			fire4.y -= fire4.height * 1.5;

			siniFireFront.add(fire1);
			siniFireFront.add(fire2);
			siniFireFront.add(fire3);
			siniFireFront.add(fire4);

			add(siniFireFront);
			
			//more layering shit
			var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/glowyfurniture'));
			fuckYouFurniture.antialiasing = true;
			fuckYouFurniture.scrollFactor.set(0.9, 0.9);
			add(fuckYouFurniture);
		}
		else
		{
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'curse':
				gfVersion = 'gf-tabi';
			case 'genocide':
				gfVersion = 'gf-tabi-crazy';
				var destBoombox:FlxSprite = new FlxSprite(400, 130).loadGraphic(Paths.image('tabi/mad/Destroyed_boombox'));
				destBoombox.y += (destBoombox.height - 648) * -1;
				destBoombox.y += 150;
				destBoombox.x -= 110;
				destBoombox.scale.set(1.2, 1.2);
				add(destBoombox);
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);

		if (curStage != 'genocide')
		{
			gf.scrollFactor.set(0.95, 0.95);
		}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tabi':
				dad.x -= 300;
			case 'tabi-crazy':
				dad.x -= 300;
				dad.y += 50;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'curse':
				boyfriend.setZoom(1.2);
				boyfriend.x += 300;
				gf.setZoom(1.2);
				gf.y -= 110;
				gf.x -= 50;
			case 'genocide':
				boyfriend.setZoom(1.2);
				boyfriend.x += 300;
				gf.setZoom(1);
				//gf.y -= 20;
				gf.x += 100;
				var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
				add(tabiTrail);
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);
		
		switch (curStage)
		{
			case 'curse':
				var sumtable:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/sumtable'));
				sumtable.antialiasing = true;
				sumtable.scrollFactor.set(0.9, 0.9);
				sumtable.active = false;
				add(sumtable);
			case 'genocide':
				var sumsticks:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/overlayingsticks'));
				sumsticks.antialiasing = true;
				sumsticks.scrollFactor.set(0.9, 0.9);
				sumsticks.active = false;
				add(sumsticks);
		}

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.classAssign = classAssign;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		dadStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		//healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (Highscore.getDownscroll())
		{
		healthBarBG = new FlxSprite(0, FlxG.height * 0.1).loadGraphic(Paths.image('healthBar'));
		} else {
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (SONG.song.toLowerCase() != 'genocide')
		{
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		} else {
			healthBar.createFilledBar(0xFF333333, 0xFF66FF33);
		}
		// healthBar
		add(healthBar);

		/*scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);*/
		
		var daPosShit:Float = healthBarBG.y + ((FlxG.height - 30) - (FlxG.height * 0.9));
		if (Highscore.getDownscroll())
		{
			daPosShit = healthBarBG.y + ((FlxG.height - 30) - (FlxG.height * 0.9));
		}
		
		scoreTxt = new FlxText(healthBarBG.x + 30, daPosShit, 0, "", 200);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		//new layering lol
		add(iconP2);
		add(iconP1);
		add(scoreTxt);

		strumLineNotes.cameras = [noteCam];
		notes.cameras = [noteCam];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD3];
		iconP2.cameras = [camHUD3];
		scoreTxt.cameras = [camHUD4];
		doof.cameras = [camHUD5];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'my-battle' | 'last-chance' | 'genocide':
					if (showCutscene)
					{
						showItBitch(doof);
					} else {
						startCountdown();
					}
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		
		#if animTest
		gf.visible = false;
		boyfriend.visible = false;
		dad.visible = true;
		playerStrums.visible = false;
		playerStrums.forEach(function(spr:FlxSprite)
		{
			spr.visible = false;
		});
		#end
		
		samShit = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		samShit.alpha = 0.05;
		samShit.color = FlxColor.BLACK;
		add(samShit);
		samShit.cameras = [camIllusion];
		samShit.visible = false;
		
		vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
		vignette.width = 1280;
		vignette.height = 720;
		vignette.x = 0;
		vignette.y = 0;
		vignette.updateHitbox();
		add(vignette);
		vignette.cameras = [vignetteCamera];
		vignette.alpha = 1;
		
		if (SONG.song.toLowerCase() == 'genocide')
		{
		var someShit:SwagSong = Song.loadFromJson("commands", "genocide");
		if (someShit.notes.length > 0)
		{
			genocideCommands = [];
			for (shitnote in someShit.notes)
			{
				for (somemoreshit in shitnote.sectionNotes)
				{
					genocideCommands.push(somemoreshit);
				}
			}
		}
		}

		super.create();
	}
	
	function showItBitch(?dialogueBox:DialogueBox):Void
	{
		if (dialogueBox != null)
		{
			inCutscene = true;
			add(dialogueBox);
		} else {
			startCountdown();
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	
	function classAssign(shit1:String, shit2:Array<String>):Void
	{
		var parsedShit3:Array<Dynamic> = [];
		var parsedShit2 = shit2;
		for (i in 0...parsedShit2.length)
		{
			if (i == 0)
			{
			parsedShit3.push(areWeThereYet);
			} else {
			parsedShit3.push(parsedShit2[i]);
			}
		}
		//trace(shit1);
		//trace(Type.resolveClass(shit1));
		var someShitClass = Type.createInstance(Type.resolveClass(shit1), parsedShit3);
		//trace(someShitClass);
		//im a hard working boss
		//sussy susy susy sussy sussy
		var sussySussy:String = "Im a hard working boss i come in and dab then i go grab SUCK MY BOOTY";
		var suckmybooty:String = "tha fuck am i doing with my life";
		var yocodingishard:String = "Coding is hard send some help if u see this in the exe lol";
		var whydididothis:String = "i got PTSD for some reason... meh its my fault";
		//doof.paused = true;
		//someShitClass.daDoof = doof;
		/*if (Reflect.hasField(someShitClass, "callBackToVaccine"))
		{
			//someShitClass.callBackToVaccine = areWeThereYet;
		}*/
		//someShitClass.finishCallback = areWeThereYet;
		add(someShitClass);
		someShitClass.cameras = [cutsceneCam];
	}
	
	function areWeThereYet():Void
	{
		var banana:String = "cuz in my discord vc and chat banana go brr";
		doof.paused = false;
		var potato:String = "cuz POTATOPOTAY POTATO POTATO POTAY POTATO";
	}

	function startCountdown():Void
	{
		showCutscene = false;
		resetChromeShit2();
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
					
				var daNoteDataMod:Int = daNoteData;
					
				/*if (Highscore.getDownscroll())
				{
					daNoteDataMod = (daNoteDataMod == 0) ? 3 : (daNoteDataMod == 3) ? 0 : (daNoteDataMod == 1) ? 2 : (daNoteDataMod == 2) ? 1 : daNoteDataMod;
				}*/

				var swagNote:Note = new Note(Highscore.getDownscroll(), daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					
					/*var daNoteDataMod:Int = daNoteData;
					
					if (Highscore.getDownscroll())
					{
						daNoteDataMod = (daNoteDataMod == 0) ? 3 : (daNoteDataMod == 3) ? 0 : (daNoteDataMod == 1) ? 2 : (daNoteDataMod == 2) ? 1 : daNoteDataMod;
					}*/

					var sustainNote:Note = new Note(Highscore.getDownscroll(), daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					//if ((sustainNote.mustPress && !Highscore.getDownscroll()) || (Highscore.getDownscroll() && !sustainNote.mustPress))
					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
						//swagNote.x += 157 / 2 + 157 / 4;
					}
					/*else if (Highscore.getDownscroll())
					{
						swagNote.x += 157 / 2 + 157 / 4;
					}*/
					
					sustainNote.isAlt = oldNote.isAlt;
					
					sustainNote.inverseX();
				}

				swagNote.mustPress = gottaHitNote;

				//if ((swagNote.mustPress && !Highscore.getDownscroll()) || (Highscore.getDownscroll() && !swagNote.mustPress))
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
				
				if (songNotes.length > 3)
				{
					swagNote.isAlt = (songNotes[3] == 0) ? false : true;
				} else {
					swagNote.isAlt = false;
				}
				
				swagNote.inverseX();
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite;
			/*if (Highscore.getDownscroll())
			{
			babyArrow = new FlxSprite(0, FlxG.height - strumLine.y);
			} else {*/
			babyArrow = new FlxSprite(0, strumLine.y);
			//}

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					//changed animated shit
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					if (Highscore.getDownscroll())
					{
					babyArrow.animation.add('green', [6], 30, true, true, true);
					babyArrow.animation.add('red', [7], 30, true, true, true);
					babyArrow.animation.add('blue', [5], 30, true, true, true);
					babyArrow.animation.add('purplel', [4], 30, true, true, true);
					} else {
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);
					}

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					if (Highscore.getDownscroll())
					{
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0], 30, true, true, true);
							babyArrow.animation.add('pressed', [4, 8], 12, false, true, true);
							babyArrow.animation.add('confirm', [12, 16], 24, false, true, true);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1], 30, true, true, true);
							babyArrow.animation.add('pressed', [5, 9], 12, false, true, true);
							babyArrow.animation.add('confirm', [13, 17], 24, false, true, true);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2], 30, true, true, true);
							babyArrow.animation.add('pressed', [6, 10], 12, false, true, true);
							babyArrow.animation.add('confirm', [14, 18], 12, false, true, true);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3], 30, true, true, true);
							babyArrow.animation.add('pressed', [7, 11], 12, false, true, true);
							babyArrow.animation.add('confirm', [15, 19], 24, false, true, true);
					}
					} else {
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					}

				default:
					if (isGenocide)
					{
						babyArrow.frames = Paths.getSparrowAtlas('tabi/mad/NOTE_assets');
					} else {
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					}
					if (Highscore.getDownscroll())
					{
					babyArrow.animation.addByPrefix('green', 'arrowUP', 30, true, true, true);
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN', 30, true, true, true);
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT', 30, true, true, true);
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT', 30, true, true, true);
					} else {
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					}

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					if (Highscore.getDownscroll())
					{
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT', 30, true, true, true);
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false, true, true);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false, true, true);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN', 30, true, true, true);
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false, true, true);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false, true, true);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP', 30, true, true, true);
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false, true, true);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false, true, true);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT', 30, true, true, true);
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false, true, true);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false, true, true);
					}
					} else {
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			
			/*if (Highscore.getDownscroll())
			{
			babyArrow.y -= babyArrow.height;
			}*/

			if (!isStoryMode)
			{
				/*if (!Highscore.getDownscroll())
				{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
				else
				{*/
				babyArrow.y += 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y - 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				//}
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			} else {
				dadStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			if (Highscore.getDownscroll())
			{
			babyArrow.x = FlxG.width - babyArrow.x - babyArrow.width;
			}

			strumLineNotes.add(babyArrow);
			strumLineX.push(babyArrow.x);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED " + SONG.song + " " + detailsText, daShitText , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
			
			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence("Tabi v" + CurrentVersion.get() + " " + detailsText + " " + SONG.song, daShitText , iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence("Tabi v" + CurrentVersion.get() + " " + detailsText + " " + SONG.song, daShitText , iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
		
		#if desktop
		DiscordClient.changePresence("Tabi v" + CurrentVersion.get() + " " + detailsText + " " + SONG.song, daShitText , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		if (0 < genocideCommands.length && Conductor.songPosition > genocideCommands[0][0])
		{
			altCommand(genocideCommands[0][1]);
			genocideCommands.shift();
		}
		
		if (Highscore.getDownscroll())
		{
			//noteCam.y = FlxG.height - strumLine.y * 4;
			noteCam.angle = 180;
		}
		
		if (crazyMode)
		{
			vignette.alpha = 1 - (health / 3);
		} else if (isGenocide)
		{
			vignette.alpha = 1 - (health / 2);
		} else {
			vignette.alpha = 0;
		}
	
		if (isGenocide && storyDifficulty > 0 && minusHealth)
		{
			if (health > 0)
			{
				health -= 0.001;
			}
		}
		
		if (isGenocide)
		{
			setBrightness(((health / 2) - 1 < 0) ? 0 : (((health / 2) - 1) * 2) / 32);
			setContrast(((health / 2) - 1 < 0) ? 1 : 1 + ((health / 2) - 1) / 8);
		} else {
			setBrightness(0.0);
			setContrast(1.0);
		}
		
		/*if (SONG.song.toLowerCase() == 'genocide' && hasShocked)
		{
			trace(getValue("radius")[0]);
			setValue("radius", [getValue("radius")[0] + 0.02]);
		} else {
			setValue("radius", [0.0]);
		}*/
	
		#if !debug
		perfectMode = false;
		#end
		
		#if animTest
		FlxG.sound.music.volume = 1;
		FlxG.sound.music.looped = true;
		vocals.volume = 0;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			#if !animTest
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
			#else
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			openSubState(new ShowOffsetsSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, dad.printOff()));
			#end
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		//scoreTxt.text = "Score:" + songScore;
		
		if (Math.round((notesHit/notesPassing) * 100) > 100)
		{
		notesHit = 1;
		notesPassing = 1;
		} else if (Math.round((notesHit/notesPassing) * 100) < 0) {
		notesHit = 0;
		notesPassing = 0;
		}
		
		var baseText:String = "Accuracy:";
		
		if (notesPassing != 0) {
			baseText = "Accuracy:" + Math.round((notesHit/notesPassing) * 100) + "%";
		} else {
			baseText = "Accuracy:100%";
		}
		
		if (notesPassing != 0) {
			baseText2 = "Accuracy: " + Math.round((notesHit/notesPassing) * 100) + "%";
		} else {
			baseText2 = "Accuracy: 100%";
		}
		
		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Health:" + Math.round(health * 50) + "% | " + baseText;
		
		if (health >= 0)
		{
		daShitText = "Score: " + songScore + " | Misses: " + misses + " | Health: " + Math.round(health * 50) + "% | " + baseText2;
		} else {
		daShitText = "Score: " + songScore + " | Misses: " + misses + " | Health: 0% | " + baseText2;
		}
		
		#if animTest
		scoreTxt.text = "Offset Debugger Version 1.0 By GWebDev";
		daShitText = "Offset Testing";
		#end

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		#if !animTest
		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}
		#else
		if (FlxG.keys.pressed.SEVEN)
		{
			dad.subOff(3);
		}
		#end
		
		#if animTest
		if (FlxG.keys.pressed.Z)
		{
			dad.subOff2(0);
		}
		
		if (FlxG.keys.pressed.X)
		{
			dad.addOff2(0);
		}
		
		if (FlxG.keys.pressed.C)
		{
			dad.subOff2(1);
		}
		
		if (FlxG.keys.pressed.V)
		{
			dad.addOff2(1);
		}
		
		if (FlxG.keys.pressed.B)
		{
			dad.subOff2(2);
		}
		
		if (FlxG.keys.pressed.N)
		{
			dad.addOff2(2);
		}
		
		if (FlxG.keys.pressed.M)
		{
			dad.subOff2(3);
		}
		
		if (FlxG.keys.pressed.COMMA)
		{
			dad.addOff2(3);
		}
		
		if (FlxG.keys.pressed.SIX)
		{
			dad.addOff(2);
		}
		
		if (FlxG.keys.pressed.FIVE)
		{
			dad.subOff(2);
		}
		
		if (FlxG.keys.pressed.FOUR)
		{
			dad.addOff(1);
		}
		
		if (FlxG.keys.pressed.THREE)
		{
			dad.subOff(1);
		}
		
		if (FlxG.keys.pressed.TWO)
		{
			dad.addOff(0);
		}
		#end

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (!(crazyMode))
		{
		if (health > 2)
			health = 2;
		} else {
		var p2ToUse:Float = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		if (iconP2.x - iconP2.width / 2 < healthBar.x && iconP2.x > p2ToUse)
		{
			healthBarBG.offset.x = iconP2.x - p2ToUse;
			healthBar.offset.x = iconP2.x - p2ToUse;
		} else {
			healthBarBG.offset.x = 0;
			healthBar.offset.x = 0;
		}
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = p2ToUse;
		if (health > 3)
			health = 3;
		}

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if ((!crazyMode && healthBar.percent > 80) || (crazyMode && (health / 2 * 100) > 100))
		{
			iconRPC = iconRPCBefore + "-dead";
			iconP2.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconRPC = iconRPCBefore;
			iconP2.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		#if !animTest
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#else
		if (FlxG.keys.pressed.EIGHT)
			dad.addOff(3);
		#end
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'tabi':
						camFollow.y = dad.getMidpoint().y;
						camFollow.x = dad.getMidpoint().x + 530;
						FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
					case 'tabi-crazy':
						camFollow.y = dad.getMidpoint().y - 100;
						camFollow.x = dad.getMidpoint().x + 260;
						FlxTween.tween(FlxG.camera, {zoom: 0.8}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				if (boyfriend.curCharacter.startsWith("bf-tabi"))
				{
				camFollow.setPosition(boyfriend.getMidpoint().x - 530, dad.getMidpoint().y);
				if (boyfriend.curCharacter.contains("-crazy"))
				{
					FlxTween.tween(FlxG.camera, {zoom: 0.65}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
				} else {
					FlxTween.tween(FlxG.camera, {zoom: 0.55}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
				}

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			//camHUD2.zoom = FlxMath.lerp(1, camHUD2.zoom, 0.95);
			camHUD3.zoom = FlxMath.lerp(1, camHUD3.zoom, 0.95);
			camHUD4.zoom = FlxMath.lerp(1, camHUD4.zoom, 0.95);
			noteCam.zoom = FlxMath.lerp(1, noteCam.zoom, 0.95);
			//noteCam2.zoom = FlxMath.lerp(1, noteCam2.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			//health = 0;
			//trace("RESET = True");
			trace("i hate this feature im disabling it lol");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			chromDanced = true;
			setChrome(0.0);
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
				#if desktop
				DiscordClient.changePresence("GITAROO! GAME OVER -- " + SONG.song + " " + detailsText, daShitText , iconRPC);
				#end
			}
			else
			{
				/*noteCam.visible = false;
				camHUD.visible = false;
				camHUD3.visible = false;
				camHUD4.visible = false;
				camHUD5.visible = false;
				vignetteCamera.visible = false;
				camIllusion.visible = false;
				boyfriend.visible = false;

				persistentUpdate = false;
				persistentDraw = true;*/
			
				openSubState(new GameOverSubstate(boyfriend));
				#if desktop
				DiscordClient.changePresence("GAME OVER -- " + SONG.song + " " + detailsText, daShitText , iconRPC);
				#end
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			daAnims = [];
			var leNotes:Int = 0;
			notes.forEachAlive(function(daNote:Note)
			{
				leNotes++;
				//if ((Highscore.getDownscroll() && daNote.y < 0 - daNote.height) || (Highscore.getDownscroll() == false && daNote.y + daNote.height > FlxG.height + daNote.height))
				if (daNote.y + daNote.height > FlxG.height + daNote.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				/*if (Highscore.getDownscroll())
				{
				daNote.y *= -1;
				daNote.y += FlxG.height - strumLine.y - daNote.height;
				}*/
				
				/*if (!daNote.wasGoodHit && daNote.mustPress && ((Highscore.getDownscroll() && (daNote.y - daNote.height * 0.5 > FlxG.height - daNote.height)) || (Highscore.getDownscroll() == false && (daNote.y + daNote.height + daNote.height * 0.5 < daNote.height))))
				{
				daNote.tooLate = true;
				}*/

				// i am so fucking sorry for this if condition
				/*if ((Highscore.getDownscroll() && (daNote.isSustainNote
					&& daNote.y + daNote.offset.y >= FlxG.height - (strumLine.y - Note.swagWidth / 2) - daNote.height
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))) || (Highscore.getDownscroll() == false && (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))))*/
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					/*if (Highscore.getDownscroll())
					{
						swagRect = new FlxRect(0, FlxG.height - (strumLine.y - Note.swagWidth / 2) - daNote.y, daNote.width * 2, daNote.height * 2);
					}*/
					swagRect.y /= daNote.scale.y;
					/*if (Highscore.getDownscroll())
					{
						swagRect.height += swagRect.y;
					} else {*/
						swagRect.height -= swagRect.y;
					//}

					daNote.clipRect = swagRect;
				}
				
				if (crazyMode)
				{
					if (daNote.mustPress)
					{
						if (doIt)
						{
							doIt = false;
							justDoItMakeYourDreamsComeTrue = true;
						}
					}
				}
				
				if (!daNote.mustPress)
				{
					minusHealth = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					/*var shitDuration:Float = (SONG.speed / 10);
					shitDuration = (shitDuration <= 0.0005) ? 0.0005 : shitDuration / 4;
					shitDuration = (shitDuration <= 0.0005) ? 0.0005 : shitDuration;
					shitDuration = 50 * shitDuration;
					shitDuration = 50 - shitDuration;
					shitDuration = shitDuration / 1000;
					shitDuration = (shitDuration <= 0.0005) ? 0.0005 : shitDuration;*/
					
					var shitDuration:Float = 0.1;

					#if !animTest
					switch (Math.abs(daNote.noteData))
					{
						case 0:
							daAnims.push('singLEFT' + altAnim);
						case 1:
							daAnims.push('singDOWN' + altAnim);
						case 2:
							daAnims.push('singUP' + altAnim);
						case 3:
							daAnims.push('singRIGHT' + altAnim);
					}

					dad.holdTimer = 0;
					if (crazyMode)
					{
						if (!Highscore.getPhoto())
						{
						camGame.shake(0.03, 0.02, null, true);
						}
						if (health > 0 && justDoItMakeYourDreamsComeTrue && Highscore.getInput())
						{
							if (daNote.isSustainNote)
							{
								health -= 0.0005;
							} else {
								//health -= 0.04;
								health -= 0.03;
							}
						}
					}
					
					chromaticDance(true);
					
					#if desktop
					if (!FlxG.fullscreen && isGenocide)
					{
						screenDance();
					}
					#end
					
					var bullshit:Int = Std.int(Math.abs(daNote.noteData));
					if (bullshit >= 0 && bullshit <= 3)
					{
					if (dadTimers[bullshit] != null)
					{
					dadTimers[bullshit].cancel();
					dadTimers[bullshit].destroy();
					}
					dadStrums.members[bullshit].animation.play('confirm');
					if (!curStage.startsWith('school'))
					{
					dadStrums.members[bullshit].centerOffsets();
					dadStrums.members[bullshit].offset.x -= 13;
					dadStrums.members[bullshit].offset.y -= 13;
					} else {
					dadStrums.members[bullshit].centerOffsets();
					}
					dadTimers[bullshit] = new FlxTimer();
					dadTimers[bullshit].start(shitDuration, function(tmr:FlxTimer)
					{
					dadStrums.members[bullshit].animation.play('static');
					dadStrums.members[bullshit].centerOffsets();
					}, 1);
					}
					#end

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				//if ((Highscore.getDownscroll() && (daNote.y > FlxG.height + daNote.height)) || (Highscore.getDownscroll() == false && (daNote.y < -daNote.height)))
				if (daNote.y < -daNote.height)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						if (!daNote.isSustainNote)
						{
							misses++;
							if (crazyMode)
							{
								health -= 0.1;
							}
						}
						health -= 0.0475;
						vocals.volume = 0;
						notesPassing += 1;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
			if (leNotes == 0)
			{
				minusHealth = false;
			}
			if (daAnims.length > 0) {
				if (tonNoteMode)
				{
					if (!daAnims.contains(prevAnim))
					{
						tonNoteMode = false;
						dad.playAnim(daAnims[0], true);
					} else {
						dad.playAnim(prevAnim, true);
					}
				} else {
					dad.playAnim(daAnims[0], true);
				}
				if (daAnims.length > 1 && !tonNoteMode)
				{
					tonNoteMode = true;
					prevAnim = daAnims[0];
				}
			}
		}

		if (!inCutscene)
			keyShit();

		#if debug
		#if !animTest
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#else
		if (FlxG.keys.pressed.ONE)
			dad.subOff(0);
		#end
		#end
	}

	function endSong():Void
	{
		#if !animTest
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					//NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				showCutscene = true;
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
		#end
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
			notesHit += 0.25;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
			notesHit += 0.25;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
			notesHit += 0.95;
		}
		if (daRating == 'sick')
			notesHit += 1;
			notesPassing -= 0.25;
		if (notesHit > notesPassing) {
			notesHit = notesPassing;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}
	
	private function chk(prop, keyN:String):Bool
	{
	if (keyN == "NONE")
	{
	return false;
	} else {
	return Reflect.getProperty(prop, keyN);
	}
	}
	
	private function toggleColor():Void
	{
		if (!Highscore.getPhoto())
		{
		samShit.visible = !samShit.visible;
		}
	}
	
	private function altCommand(?command:Int = 0):Void
	{
		if (command < 0)
		{
			command = 0;
		}
		if (command > 3)
		{
			command = 3;
		}
		switch (command)
		{
			/*case 0:
				someCrap.visible = true;
				goBf.visible = true;*/
			case 0:
				toggleColor();
			case 1:
				/*someCrap.visible = false;
				goBf.visible = false;*/
				healthBarBG.visible = true;
				healthBar.visible = true;
			case 2:
				healthBarBG.visible = false;
				healthBar.visible = false;
			case 3:
				//FlxG.camera.shake(1, 0.3);
				if (crazyMode)
				{
				justDoItMakeYourDreamsComeTrue = !justDoItMakeYourDreamsComeTrue;
				}
		}
	}

	private function keyShit():Void
	{
		// HOLDING
		/*var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;*/
		
		//NAH MATE THIS FOR CUSTOM KEYBIND TO WORK
		
		var prk = FlxG.keys.pressed;
		var prkP = FlxG.keys.justPressed;
		var prkR = FlxG.keys.justReleased;
		
		var gtk = Highscore.getKeyBind;
		
		var up = chk(prk, gtk(0)) || chk(prk, gtk(4));
		var left = chk(prk, gtk(1)) || chk(prk, gtk(5));
		var down = chk(prk, gtk(2)) || chk(prk, gtk(6));
		var right = chk(prk, gtk(3)) || chk(prk, gtk(7));

		var upP = chk(prkP, gtk(0)) || chk(prkP, gtk(4));
		var leftP = chk(prkP, gtk(1)) || chk(prkP, gtk(5));
		var downP = chk(prkP, gtk(2)) || chk(prkP, gtk(6));
		var rightP = chk(prkP, gtk(3)) || chk(prkP, gtk(7));

		var upR = chk(prkR, gtk(0)) || chk(prkR, gtk(4));
		var leftR = chk(prkR, gtk(1)) || chk(prkR, gtk(5));
		var downR = chk(prkR, gtk(2)) || chk(prkR, gtk(6));
		var rightR = chk(prkR, gtk(3)) || chk(prkR, gtk(7));

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		
		#if animTest
		notes.forEach(function(daNote:Note)
		{
			//goodNoteHit(daNote);
			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		});
		#end

		#if !animTest
		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && (!daNote.wasGoodHit || Highscore.getInput()))
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!Highscore.getInput() && !inIgnoreList)
									badNoteCheck();
								else
									missItUp();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						//SMART RAM WASTE
						/*if (!Highscore.getInput())
						{
						noteCheck(controlArray[daNote.noteData], daNote);
						} else {
						if (controlArray[daNote.noteData])
							goodNoteHit(daNote);
						else
						{
						if (leftP)
							noteMiss(0);
						if (downP)
							noteMiss(1);
						if (upP)
							noteMiss(2);
						if (rightP)
							noteMiss(3);
						}
						}*/
						
						noteCheck(controlArray[daNote.noteData], daNote);
					}	
					else
					{
						for (coolNote in possibleNotes)
						{
							//SMART RAM WASTING LOL
							/*
							if (!Highscore.getInput())
							{
							noteCheck(controlArray[coolNote.noteData], coolNote);
							} else {
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
							if (leftP)
								noteMiss(0);
							if (downP)
								noteMiss(1);
							if (upP)
								noteMiss(2);
							if (rightP)
								noteMiss(3);
							}
							}*/
							
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					//IM WASTING RAM LOL
					/*if (!Highscore.getInput())
					{
					noteCheck(controlArray[daNote.noteData], daNote);
					} else {
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
					else
					{
					if (leftP)
						noteMiss(0);
					if (downP)
						noteMiss(1);
					if (upP)
						noteMiss(2);
					if (rightP)
						noteMiss(3);
					}
					}*/
					
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
					switch (daNote.noteData)
					{
						case 2: // NOTES YOU JUST PRESSED
							if (upP || rightP || downP || leftP)
								noteCheck(upP, daNote);
						case 3:
							if (upP || rightP || downP || leftP)
								noteCheck(rightP, daNote);
						case 1:
							if (upP || rightP || downP || leftP)
								noteCheck(downP, daNote);
						case 0:
							if (upP || rightP || downP || leftP)
								noteCheck(leftP, daNote);
					}
				
				//this is already done in noteCheck / goodNoteHit
				*/
				if (Highscore.getInput() && daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!Highscore.getInput())
			{
				badNoteCheck();
			} else {
				missItUp();
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				/*if (daNote.isSustainNote)
				{
					trace("can be hit: " + daNote.canBeHit);
					trace("must press: " + daNote.mustPress);
					trace("---");
				}*/
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}
		#else
		dadStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP)
						spr.animation.play('confirm');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP)
						spr.animation.play('confirm');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP)
						spr.animation.play('confirm');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP)
						spr.animation.play('confirm');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
		if (up || down || left || right)
		{
			doIdle = false;
			if (up)
				dad.playAnim('singUP');
			if (down)
				dad.playAnim('singDOWN');
			if (right)
				dad.playAnim('singRIGHT');
			if (left)
				dad.playAnim('singLEFT');
		} else {
			doIdle = true;
			if (upR || downR || leftR || rightR)
			{
				//dad.dance();
			}
		}
		#end
		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}
		
		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			//misses++;
			minusHealth = true;
			notesPassing += 1;
			health -= 0.04;
			if (crazyMode)
			{
				health -= 0.08;
				//health -= 0.02;
			}
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*if (!Highscore.getInput())
			{
			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});
			} else {*/
				boyfriend.stunned = false;
			//}

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}
	
	function missUp(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			//health -= 0.04 * damagegobrr;
			/*if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}*/
			//combo = 0;

			//songScore -= 10;

			//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}
	
	function missItUp()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		/*var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;*/
		
		var prk = FlxG.keys.pressed;
		var prPk = FlxG.keys.justPressed;
		var prRk = FlxG.keys.justReleased;
		
		var gtk = Highscore.getKeyBind;
		
		var upP = Reflect.getProperty(prPk, gtk(0)) || Reflect.getProperty(prPk, gtk(4));
		var leftP = Reflect.getProperty(prPk, gtk(1)) || Reflect.getProperty(prPk, gtk(5));
		var downP = Reflect.getProperty(prPk, gtk(2)) || Reflect.getProperty(prPk, gtk(6));
		var rightP = Reflect.getProperty(prPk, gtk(3)) || Reflect.getProperty(prPk, gtk(7));

		if (leftP)
			missUp(0);
		if (downP)
			missUp(1);
		if (upP)
			missUp(2);
		if (rightP)
			missUp(3);
	}

	function badNoteCheck(?daNot:Int = -1)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		/*var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;*/
		
		var prk = FlxG.keys.pressed;
		var prPk = FlxG.keys.justPressed;
		var prRk = FlxG.keys.justReleased;
		
		var gtk = Highscore.getKeyBind;
		
		var upP = Reflect.getProperty(prPk, gtk(0)) || Reflect.getProperty(prPk, gtk(4));
		var leftP = Reflect.getProperty(prPk, gtk(1)) || Reflect.getProperty(prPk, gtk(5));
		var downP = Reflect.getProperty(prPk, gtk(2)) || Reflect.getProperty(prPk, gtk(6));
		var rightP = Reflect.getProperty(prPk, gtk(3)) || Reflect.getProperty(prPk, gtk(7));

		if (!Highscore.getInput())
		{
		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
		} else {
		if (plzListen)
		{
		if (leftP && daNot != 0)
			noteMiss(0);
		else if (downP && daNot != 1)
			noteMiss(1);
		else if (upP && daNot != 2)
			noteMiss(2);
		else if (rightP && daNot != 3)
			noteMiss(3);
		}
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			if (!Highscore.getInput() || note.listenBadNotes)
			{
				badNoteCheck(note.noteData);
			}
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			/*if (note.isSustainNote)
			{
				trace("good sus hit");
			}*/
			//shockwaveDance(note.getGraphicMidpoint().x, note.getGraphicMidpoint().y);
			chromaticDance(false);
			minusHealth = false;
			if (Highscore.getInput())
			{
			plzListen = false;
			if (listenTimer != null)
			{
				listenTimer.cancel();
				listenTimer.destroy();
			}
			listenTimer = new FlxTimer();
			listenTimer.start(0.1, function(tmr:FlxTimer)
			{
			plzListen = true;
			});
			}
			
			if (!note.isSustainNote)
			{
				notesPassing += 1;
				popUpScore(note.strumTime);
				combo += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;
				
			if (crazyMode)
			{
				health += 0.05;
				if (!Highscore.getPhoto())
				{
				camGame.shake(0.008, 0.02, null, true);
				}
			}
			
			if (isGenocide && storyDifficulty > 0 && !Highscore.getInput())
			{
				health += 0.05;
			}

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		/*if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}*/
		var fkUMultiplier:Float = 5;
		if ((FlxG.sound.music.time > Conductor.songPosition + fkUMultiplier || FlxG.sound.music.time < Conductor.songPosition - fkUMultiplier) || (vocals.playing && (vocals.time > Conductor.songPosition || vocals.time < Conductor.songPosition)))
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence("Tabi v" + CurrentVersion.get() + " " + detailsText + " " + SONG.song, daShitText , iconRPC,true,  songLength - Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	
	function shakeNote():Void
	{
		/*var offsetShit:Float = 10;
		if (noteShaked)
		{
			noteShaked = !noteShaked;
			for (i in 0...strumLineNotes.length)
			{
				FlxTween.tween(strumLineNotes.members[i], {x: strumLineX[i] + (offsetShit * -1)}, (60 / Conductor.bpm));
			}
		} else {
			noteShaked = !noteShaked;
			for (i in 0...strumLineNotes.length)
			{
				FlxTween.tween(strumLineNotes.members[i], {x: strumLineX[i] + (offsetShit * 1)}, (60 / Conductor.bpm));
			}
		}*/
		//im tired of rip ram shit
		if (!Highscore.getPhoto())
		{
		noteCam.shake(0.005, (60 / Conductor.bpm), null, true, FlxAxes.X);
		//noteCam2.shake(0.005, (60 / Conductor.bpm), null, true, FlxAxes.X);
		}
	}
	
	public function screenDance():Void
	{
		if (!Highscore.getPhoto())
		{
		if (!screenDanced)
		{
			Lib.application.window.x += Std.int(Lib.application.window.width / 100);
		} else {
			Lib.application.window.x -= Std.int(Lib.application.window.width / 100);
		}
		screenDanced = !screenDanced;
		}
	}
	
	public function resetChromeShit2(?tmr:FlxTimer):Void
	{
		if (!paused)
		{
			setChrome(0.0);
			chromDanced = false;
		}
	}
	
	/*public function shockwaveDance(daNoteX:Float, daNoteY:Float):Void
	{
		if (SONG.song.toLowerCase() == 'genocide')
		{
			hasShocked = true;
			//setValue("speed", [500]);
			//setValue("radius", [500]);
			//setValue("center", [0, 0]);
			//setValue("filterArea", [1, 1, 1, 1]);
			//setValue("filterClamp", [1, 1, 1, 1]);
			setValue("radius", [0.0]);
			setValue("centerX", [1 - (daNoteX / 1280)]);
			setValue("centerY", [1 - (daNoteY / 720)]);
			setValue("texOffset", [0.05]);
			setValue("scale", [0.09]);
		}
	}*/
	
	public function chromaticDance(tabiTurn:Bool):Void
	{
		if (isGenocide)
		{
		if (chromeTimer != null)
		{
			chromeTimer.cancel();
			chromeTimer.destroy();
		}
		chromeTimer = new FlxTimer().start(2, resetChromeShit2, 1);
		var maxHealth:Float = 2;
		if (crazyMode)
		{
			maxHealth = 3;
		}
		var chromeOffset:Float = (maxHealth - (health / maxHealth));
		chromeOffset /= 1000;
		if (tabiTurn)
		{
			chromeOffset *= 2;
		}
		if (!chromDanced)
		{
			setChrome(chromeOffset);
		} else {
			setChrome(0.0);
		}
		chromDanced = !chromDanced;
		}
	}

	override function beatHit()
	{
		super.beatHit();
		
		/*#if desktop
		if (!FlxG.fullscreen)
		{
			screenDance();
		}
		#end*/
		
		if (isGenocide)
		{
			shakeNote();
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
			/*var colList:Array<FlxColor> = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF, 0x00000000, 0x000000];
			samShit.color = colList[FlxG.random.int(0, colList.length - 1)];*/
			samShit.color = FlxG.random.color(FlxColor.BLACK, FlxColor.WHITE);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			#if !animTest
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
			#else
			if (doIdle && dad.animation.curAnim.finished)
				dad.dance();
			#end
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}
