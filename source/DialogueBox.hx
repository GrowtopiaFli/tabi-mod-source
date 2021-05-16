package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var controls(get, never):Controls;
	
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	var curSound:FlxSound;

	//var fadeScreen:FlxSprite;
	var blackScreen:FlxSprite;

	var whitelisted:Array<String> = [];

	var box:FlxSprite;
	var daBg:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var extraPortraits:Array<FlxSprite> = [];
	
	var fadeColor:FlxColor = FlxColor.BLACK;
	
	public var paused:Bool = false;
	public var isFade:Bool = false;
	public var isFadeIn:Bool = false;
	public var isFadeOut:Bool = false;
	public var toFade:Float = 0;
	public var queueFade:Bool = false;
	public var fadeTimer:FlxTimer;
	/*public var curTime:Int = 0;
	public var startingTime:Int = 0;*/

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;
	public var classAssign:(String, Array<String>)->Void;
	public var classInit:(String)->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	
	var blackListed:Array<String> = ['my-battle', 'last-chance', 'genocide'];

	var extraCharnames:Array<String> = [
	'bf-left',
	'bf-exp',
	'bf-right',
	'gf',
	'gf-talking',
	'gf-hmm',
	'gf-letsgo',
	'tabi',
	'tabi-mad',
	'tabi-worried'
	];

	var extraRights:Array<Bool> = [];

	var enableTypeSound:Bool = false;
	var defaultSound:String = 'pixelText';

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		
		whitelisted = ['chromeoffset', 'soundoverwritestop', 'musicstop', 'music', 'musicloop', 'soundoverwrite', 'sound', 'class', 'class-use', 'bg', 'bghide', 'makeGraphic', 'enableTypeSound', 'disableTypeSound', 'switchSound', 'fadeIn', 'fadeOut'];

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		if (blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
		box = new FlxSprite(-20, FlxG.height - 45);
		} else {
		box = new FlxSprite(-20, 45);
		}
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'my-battle' | 'last-chance' | 'genocide':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
			
		daBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		daBg.antialiasing = true;
		add(daBg);
		daBg.visible = false;
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		if (!blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		} else {
		box.x = FlxG.width / 2 - box.width / 2;
		}
		box.updateHitbox();
		
		if (!blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
			box.screenCenter(X);
		}
		
		if (blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
		box.y -= box.height;
		box.y += 20;
		box.x += 40;
		}
		
		for (i in 0...10)
		{
			var isRight:Bool = false;
			var rightInts:Array<Int> = [1, 2, 3, 4, 5, 6];
			if (rightInts.contains(i))
			{
				isRight = true;
			}
			var prefix:String = "tabi/dialogue/Dialog icons/";
			//var shitList:Array<String> = [];
			var newSprite:FlxSprite = new FlxSprite(box.x, box.y + 100).loadGraphic(Paths.image(prefix + extraCharnames[i]));
			newSprite.y -= newSprite.height;
			if (isRight)
			{
				newSprite.x += box.width;
				newSprite.x -= newSprite.width;
				newSprite.x -= 100;
			} else {
				newSprite.x += 100;
			}
			if (extraCharnames[i].startsWith('bf'))
			{
				newSprite.y += 30;
			}
			newSprite.updateHitbox();
			newSprite.scrollFactor.set();
			newSprite.visible = false;
			extraPortraits.push(newSprite);
			add(extraPortraits[i]);
			extraRights.push(isRight);
		}
		
		add(box);
		
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		if (!blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		} else {
			/*swagDialogue.size = 16;
			swagDialogue.font = '';
			swagDialogue.color = FlxColor.BLACK;*/
			var daFontSize:Int = 32;
			if (Highscore.getRus())
			{
				daFontSize = 25;
			}
			swagDialogue.setFormat(Paths.font("15111.ttf"), daFontSize, 0xFF3F2021, LEFT);
		}
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
		/*fadeScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		fadeScreen.antialiasing = true;
		add(fadeScreen);
		fadeScreen.alpha = 0;*/
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.antialiasing = true;
		add(blackScreen);
		
		if (fadeTimer != null)
		{
			fadeTimer.cancel();
			fadeTimer.destroy();
		}
		
		/*fadeTimer = new FlxTimer().start(1 / 100, function(tmr:FlxTimer)
		{
			curTime++;
		}, 0);*/
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
			dropText.visible = false;
			dropText.alpha = 0;
		}
	
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		
		//gwebdev = shit lol
		
		/*if (Math.isNaN(toFade))
		{
			toFade = 0;
		}*/

		/*if (queueFade)
		{
			queueFade = false;
			//startingTime = curTime;
		}*/
		
		//trace(curCharacter);
		
		//i suk
		//trace("start: " + startingTime);
		//trace("cur time: " + curTime);

		/*if (isFade)
		{
			box.visible = false;
			swagDialogue.visible = false;
			if (isFadeIn)
			{
				var newToFade:Int = startingTime + Std.int(toFade * 100);
				var someShit:Float = curTime / newToFade;
				if (someShit > 1)
				{
					someShit = 1;
				}
				if (someShit < 0)
				{
					someShit = 0;
				}
				//trace("some shit: " + someShit);
				fadeScreen.alpha = someShit;
				if (fadeScreen.alpha >= 1)
				{
					isFadeIn = false;
					isFadeOut = false;
					isFade = false;
				}
			}
			if (isFadeOut)
			{
				var newToFade:Int = startingTime + Std.int(toFade * 100);
				var someShit:Float = curTime / newToFade;
				if (someShit > 1)
				{
					someShit = 1;
				}
				if (someShit < 0)
				{
					someShit = 0;
				}
				//trace("some shit: " + someShit);
				var finalShit:Float = 1 - someShit;
				if (finalShit > 1)
				{
					finalShit = 1;
				}
				if (finalShit < 0)
				{
					finalShit = 0;
				}
				fadeScreen.alpha = finalShit;
				if (fadeScreen.alpha <= 0)
				{
					isFadeOut = false;
					isFadeIn = false;
					isFade = false;
				}
			}
		} else if (!paused)	{
			box.alpha = 1;
		}*/
		
		/*if (!isFade && !paused)
		{
			box.visible = true;
			swagDialogue.visible = true;
		}*/
		
		if (!paused && !isFade && !whitelisted.contains(curCharacter)) {
				box.alpha = 1;
				swagDialogue.alpha = 1;
		} else {
				box.alpha = 0;
				swagDialogue.alpha = 0;
		}

		whitelisted = ['chromeoffset', 'soundoverwritestop', 'musicstop', 'music', 'musicloop', 'soundoverwrite', 'sound', 'class', 'class-use', 'bg', 'bghide', 'makeGraphic', 'enableTypeSound', 'disableTypeSound', 'switchSound', 'fadeIn', 'fadeOut'];

		//if ((FlxG.keys.justPressed.ANY) || (dialogueList.length > 0 && whitelisted.contains(curCharacter)) && dialogueStarted == true && !paused && !isFade)
		if ((controls.ACCEPT) || (dialogueList.length > 0 && whitelisted.contains(curCharacter)) && dialogueStarted == true && !paused && !isFade)
		{
			var queuePause:Bool = false;
			queueFade = false;
			if (!paused && !isFade)
			{
			switch (curCharacter)
			{
				case 'chromeoffset':
					var chromeOffset:Float = Std.parseFloat(dialogueList[0]);
					chromeOffset /= 1000;
					ChromaHandler.setChrome(chromeOffset);
				case 'musicloop':
					if (Paths.exists(Paths.music(dialogueList[0])))
					{
						FlxG.sound.playMusic(Paths.music(dialogueList[0]), 1, true);
					}
				case 'music':
					if (Paths.exists(Paths.music(dialogueList[0])))
					{
						FlxG.sound.playMusic(Paths.music(dialogueList[0]), 1, false);
					}
				case 'musicstop':
					if (FlxG.sound.music.playing)
					{
						FlxG.sound.music.stop();
					}
				case 'soundoverwrite':
					if (Paths.exists(Paths.sound(dialogueList[0])))
					{
						if (curSound != null && curSound.playing)
						{
							curSound.stop();
						}
						curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
						//curSound.volume = FlxG.sound.volume;
						curSound.play();
					}
				case 'soundoverwritestop':
					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
				case 'sound':
					/*var isParseable:Bool = false;

					try {
						haxe.crypto.Base64.decode(dialogueList[0]);
						isParseable = true;
					} catch(e:Dynamic) {
						isParseable = false;
					}*/
					
					if (Paths.exists(Paths.sound(dialogueList[0])))
					{
						FlxG.sound.play(Paths.sound(dialogueList[0]));
					}

					/*if (isParseable)
					{
						if (Paths.exists(Paths.sound(haxe.crypto.Base64.decode(dialogueList[0]))))
						{
							FlxG.sound.play(Paths.sound(haxe.crypto.Base64.decode(dialogueList[0])), 0.8);
						}
					}*/
				case 'bghide':
					daBg.visible = false;
				case 'bg':
					if (Paths.exists(Paths.image(dialogueList[0])))
					{
						daBg.loadGraphic(Paths.image(dialogueList[0]));
					}
					daBg.visible = true;
				case 'class':
					var ourArr:Array<String> = [];
					var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					for (shit in tempShit)
					{
						ourArr.push(shit);
					}
					if (ourArr.length == 2)
					{
						/*var isParseable:Bool = false;
						try {
							haxe.Json.parse(ourArr[1]);
							isParseable = true;
						} catch (e:Dynamic) {
							isParseable = false;
						}
						if (isParseable)
						{*/
							//queuePause = true;
							//anim(ourArr[0], ourArr);
							classAssign(ourArr[0], ourArr);
						//}
					}
				case 'class-use':
					var ourArr:Array<String> = [];
					var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					for (shit in tempShit)
					{
						ourArr.push(shit);
					}
					if (ourArr.length == 1)
					{
						//copy pasting shit
						queuePause = true;
						ClassConductor.set(ourArr[0]);
					}
				case 'enableTypeSound':
					enableTypeSound = true;
				case 'disableTypeSound':
					enableTypeSound = false;
				case 'switchSound':
					if (Paths.exists(Paths.sound(dialogueList[0])))
					{
						defaultSound = dialogueList[0];
					}
				case 'makeGraphic':
					var ourArr:Array<Int> = [];
					var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					for (shit in tempShit)
					{
						ourArr.push(Std.parseInt(shit));
					}
					if (ourArr.length == 4)
					{
						var canUse:Bool = true;
						for (fuck in 0...ourArr.length)
						{
							if (!(ourArr[fuck] <= 255 && ourArr[fuck] >= 0))
							{
								canUse = false;
							}
						}
						if (canUse)
						{
							var PACKED_COLOR = (ourArr[0] & 0xFF) << 24 | (ourArr[1] & 0xFF) << 16 | (ourArr[2] & 0xFF) << 8 | (ourArr[3] & 0xFF);
							daBg.makeGraphic(FlxG.width, FlxG.height, PACKED_COLOR);
							daBg.visible = true;
						}
					}
				case 'fadeColor':
					var ourArr:Array<Int> = [];
					var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					for (shit in tempShit)
					{
						ourArr.push(Std.parseInt(shit));
					}
					if (ourArr.length == 4)
					{
						var canUse:Bool = true;
						for (fuck in 0...ourArr.length)
						{
							if (!(ourArr[fuck] <= 255 && ourArr[fuck] >= 0))
							{
								canUse = false;
							}
						}
						if (canUse)
						{
							fadeColor = (ourArr[0] & 0xFF) << 24 | (ourArr[1] & 0xFF) << 16 | (ourArr[2] & 0xFF) << 8 | (ourArr[3] & 0xFF);
						}
					}
				case 'fadeIn':
					/*var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					if (tempShit.length == 2)
					{*/
						/*toFade = Std.parseFloat(dialogueList[0]);
						isFadeOut = false;
						isFadeIn = true;*/
						/*var calc1:Float = Std.parseFloat(tempShit[0]);
						var calc2:Int = Std.parseInt(tempShit[1]);
						if (Math.isNaN(calc1))
						{
							calc1 = 0;
						}*/
						
						//fadeScreen.alpha = 0;
						/*new FlxTimer().start(calc1, function(tmr:FlxTimer)
						{
							fadeScreen.alpha = 1 * (tmr.elapsedLoops / tmr.loops);
							if (tmr.loopsLeft == 0)
							{
								isFade = false;
							}
						}, calc2);*/

						queueFade = true;
						
						camera.fade(fadeColor, Std.parseFloat(dialogueList[0]), false, function()
						{
							isFade = false;
							queueFade = false;
						}, true);
						box.alpha = 0;
						swagDialogue.alpha = 0;
					//}
					//trace("fade in");
				case 'fadeOut':
					/*var tempShit:Array<String> = new EReg(",", "g").split(dialogueList[0]);
					if (tempShit.length == 2)
					{*/
						/*toFade = Std.parseFloat(dialogueList[0]);
						isFadeIn = false;
						isFadeOut = true;*/
						/*var calc1:Float = Std.parseFloat(tempShit[0]);
						var calc2:Int = Std.parseInt(tempShit[1]);
						if (Math.isNaN(calc1))
						{
							calc1 = 0;
						}*/
						
						//fadeScreen.alpha = 1;
						/*new FlxTimer().start(calc1, function(tmr:FlxTimer)
						{
							fadeScreen.alpha = 1 - (1 * (tmr.elapsedLoops / tmr.loops));
							if (tmr.loopsLeft == 0)
							{
								isFade = false;
							}
						}, calc2);*/

						queueFade = true;
						
						camera.fade(fadeColor, Std.parseFloat(dialogueList[0]), true, function()
						{
							isFade = false;
							queueFade = false;
						}, true);
						box.alpha = 0;
						swagDialogue.alpha = 0;
						//trace("fadeout");
					//}
			}

			if (whitelisted.contains(curCharacter))
			{
				box.alpha = 0;
				swagDialogue.alpha = 0;
			}
			
			remove(dialogue);
			
			if (!blackListed.contains(PlayState.SONG.song.toLowerCase()))
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			} else {
				bgFade.alpha = 0;
			}
			}
			
			//trace(isFade);
			//trace(dialogueList[0]);

			if ((dialogueList[1] == null && dialogueList[0] != null))
			//trace(dialogueList);
			//if (dialogueList.length == 0)
			{
				//trace("dis called");
				if (!isEnding && !paused && !isFade)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					if (!blackListed.contains(PlayState.SONG.song.toLowerCase()))
					{
					//trace("yes2");
					blackScreen.visible = false;
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						hidePortraits();
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						camera.fill(FlxColor.TRANSPARENT);
						finishThing();
						kill();
					});
					} else {
					//trace("yes");
					blackScreen.visible = false;
					box.alpha = 0;
					bgFade.alpha = 0;
					hidePortraits();
					swagDialogue.alpha = 0;
					dropText.alpha = 0;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						camera.fill(FlxColor.TRANSPARENT);
						finishThing();
						kill();
					});
					}
				}
			}
			else if (!paused && !isFade)
			{
				dropText.visible = true;
				box.visible = true;
				swagDialogue.visible = true;
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
			else if (paused || isFade)
			{
				dropText.visible = false;
				box.visible = false;
				swagDialogue.visible = false;
				hidePortraits();
			}

			if (queuePause)
			{
				queuePause = false;
				paused = true;
			}
			
			if (queueFade)
			{
				queueFade = false;
				isFade = true;
			}
		}
		
		super.update(elapsed);
	}
	
	function hidePortraits():Void
	{
		portraitLeft.visible = false;
		portraitRight.visible = false;
		for (shit in extraPortraits)
		{
			shit.visible = false;
		}
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		if (!isFade && !paused)
		{
			box.visible = true;
			swagDialogue.visible = true;
		}
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		if (blackListed.contains(PlayState.SONG.song.toLowerCase()))
		{
			if (swagDialogue.sounds != [FlxG.sound.load(Paths.sound(defaultSound), 0.6)])
			{
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound(defaultSound), 0.6)];
			}
			if (!enableTypeSound || whitelisted.contains(curCharacter))
			{
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound(defaultSound), 0)];
			}
		}
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				hidePortraits();
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'bf':
				hidePortraits();
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'noone':
				hidePortraits();
		}
		
		if (extraCharnames.contains(curCharacter))
		{
			hidePortraits();
			extraPortraits[extraCharnames.indexOf(curCharacter)].visible = true;
			if (!extraRights[extraCharnames.indexOf(curCharacter)])
			{
				box.flipX = true;
			} else {
				box.flipX = false;
			}
		}
		
		if (!whitelisted.contains(curCharacter))
		{
			blackScreen.visible = false;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
