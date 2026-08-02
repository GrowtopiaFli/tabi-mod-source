package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;

using StringTools;

class Cutscene2 extends FlxSpriteGroup
{
	var finishCallback:Void->Void;
	var startUpdate:Bool = false;
	var updateShit:Bool = false;
	var updateShitYes:Bool = false;
	var updateShit2:Bool = false;
	var updateShit2Yes:Bool = false;
	
	//OBJECTS
	var curSound:FlxSound;
	var curSound2:FlxSound;
	var curSound3:FlxSound;
	
	var bg:FlxSprite;
	var genocideBG:FlxSprite;
	var genocideBoard:FlxSprite;

	var bgFire1:SiniFire;
	var bgFire2:SiniFire;

	var fire1:SiniFire;
	var fire2:SiniFire;
	var fire3:SiniFire;
	var fire4:SiniFire;
	
	var gf1:Character;
	var gf2:Character;
	var tabi:Character;
	var tabiLaugh:FlxSprite;
	var bf1:Character;
	var bf2:Character;
	
	var sumtable:FlxSprite;
	var sumsticks:FlxSprite;
	var fuckYouFurniture:FlxSprite;
	var destBoombox:FlxSprite;
	
	public function new(?callBack:Void->Void)
	{
		super();
		
		finishCallback = callBack;
		
		tabi = new Character(100, 100, 'tabi-crazy');
		
		gf1 = new Character(400, 130, 'gf-tabi');
		gf1.scrollFactor.set(0.95, 0.95);
		gf2 = new Character(400, 130, 'gf-tabi-crazy');
		
		tabi.x -= 300;
		tabi.y += 50;
		
		bf1 = new Character(770, 450, 'bf-tabi', true);
		bf2 = new Character(770, 450, 'bf-tabi-crazy', true);
		
		bf1.setZoom(1.2);
		bf1.x += 300;
		gf1.setZoom(1.2);
		gf1.y -= 110;
		gf1.x -= 50;
		
		bf2.setZoom(1.2);
		bf2.x += 300;
		gf2.setZoom(1);
		gf2.x += 100;

		/*FlxG.camera.zoom = 0.8;
		
		FlxG.camera.setPosition(tabi.getMidpoint().x + 260, tabi.getMidpoint().y - 100);*/
		
		tabiLaugh = new FlxSprite(100, 100);
		tabiLaugh.x -= 450;
		tabiLaugh.y -= 50;
		tabiLaugh.frames = Paths.getSparrowAtlas('anims/Tabi_Cutscene');
		tabiLaugh.animation.addByPrefix('animationshit', 'Tabi_Cutscene', 0, false);
		tabiLaugh.animation.play('animationshit', true);
		
		//START GENOCIDE FUCK COPYPASTE			
			//genocideBG = new SequenceBG(-600, -300, shitList, true, 2560, 1400, true);
			genocideBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('fire/wadsaaa'));
			genocideBG.antialiasing = true;
			genocideBG.scrollFactor.set(0.9, 0.9);
			add(genocideBG);
			
			//Time for sini's amazing fires lol
			//this one is behind the board
			//idk how to position this
			//i guess fuck my life lol
			bgFire1 = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * 0)), genocideBG.y + 180, true, false, 30, 0 * 10, 84);
			bgFire1.antialiasing = true;
			bgFire1.scrollFactor.set(0.9, 0.9);
			bgFire1.scale.set(0.4, 1);
			bgFire1.y += 50;
			
			bgFire2 = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * 1)), genocideBG.y + 180, true, false, 30, 1 * 10, 84);
			bgFire2.antialiasing = true;
			bgFire2.scrollFactor.set(0.9, 0.9);
			bgFire2.scale.set(0.4, 1);
			bgFire2.y += 50;
			
			add(bgFire1);
			add(bgFire2);
			
			//genocide board is already in genocidebg but u know shit layering for fire lol
			genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/boards'));
			genocideBoard.antialiasing = true;
			genocideBoard.scrollFactor.set(0.9, 0.9);
			add(genocideBoard);
			
			//front fire shit

			fire1 = new SiniFire(genocideBG.x + (-100), genocideBG.y + 889, true, false, 30);
			fire1.antialiasing = true;
			fire1.scrollFactor.set(0.9, 0.9);
			fire1.scale.set(2.5, 1.5);
			fire1.y -= fire1.height * 1.5;
			fire1.flipX = true;
			
			fire2 = new SiniFire((fire1.x + fire1.width) - 80, genocideBG.y + 889, true, false, 30);
			fire2.antialiasing = true;
			fire2.scrollFactor.set(0.9, 0.9);
			//fire2.scale.set(2.5, 1);
			fire2.y -= fire2.height * 1;
			
			fire3 = new SiniFire((fire2.x + fire2.width) - 30, genocideBG.y + 889, true, false, 30);
			fire3.antialiasing = true;
			fire3.scrollFactor.set(0.9, 0.9);
			//fire3.scale.set(2.5, 1);
			fire3.y -= fire3.height * 1;
			
			fire4 = new SiniFire((fire3.x + fire3.width) - 10, genocideBG.y + 889, true, false, 30);
			fire4.antialiasing = true;
			fire4.scrollFactor.set(0.9, 0.9);
			fire4.scale.set(1.5, 1.5);
			fire4.y -= fire4.height * 1.5;

			add(fire1);
			add(fire2);
			add(fire3);
			add(fire4);
			
			//more layering shit
			fuckYouFurniture = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/glowyfurniture'));
			fuckYouFurniture.antialiasing = true;
			fuckYouFurniture.scrollFactor.set(0.9, 0.9);
			add(fuckYouFurniture);

			destBoombox = new FlxSprite(400, 130).loadGraphic(Paths.image('tabi/mad/Destroyed_boombox'));
			destBoombox.y += (destBoombox.height - 648) * -1;
			destBoombox.y += 150;
			destBoombox.x -= 110;
			destBoombox.scale.set(1.2, 1.2);
			add(destBoombox);
		//END GENOCIDE COPYPASTE
		
		add(gf2);
		add(tabi);
		add(bf2);
		
		sumsticks = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/overlayingsticks'));
		sumsticks.antialiasing = true;
		sumsticks.scrollFactor.set(0.9, 0.9);
		sumsticks.active = false;
		add(sumsticks);
		
		bg = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/normal_stage'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);
		
		add(gf1);
		add(tabiLaugh);
		add(bf1);
		
		sumtable = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/sumtable'));
		sumtable.antialiasing = true;
		sumtable.scrollFactor.set(0.9, 0.9);
		sumtable.active = false;
		add(sumtable);
		
		//make all invisible
		bgFire1.visible = false;
		bgFire2.visible = false;
		fire1.visible = false;
		fire2.visible = false;
		fire3.visible = false;
		fire4.visible = false;
		genocideBG.visible = false;
		genocideBoard.visible = false;
		gf2.visible = false;
		tabi.visible = false;
		bf2.visible = false;
		sumsticks.visible = false;
		bg.visible = false;
		gf1.visible = false;
		tabiLaugh.visible = false;
		bf1.visible = false;
		sumtable.visible = false;
		destBoombox.visible = false;
		fuckYouFurniture.visible = false;
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			gf1.dance();
			gf2.dance();
			bf1.playAnim('idle', true);
			bf2.playAnim('idle', true);
			tabi.playAnim('idle', true);
		}, 0);
	}
	
	public function init():Void
	{
		startUpdate = true;
		
		bgFire1.visible = true;
		bgFire2.visible = true;
		fire1.visible = true;
		fire2.visible = true;
		fire3.visible = true;
		fire4.visible = true;
		genocideBG.visible = true;
		genocideBoard.visible = true;
		gf2.visible = true;
		tabi.visible = true;
		bf2.visible = true;
		sumsticks.visible = true;
		bg.visible = true;
		gf1.visible = true;
		tabiLaugh.visible = true;
		bf1.visible = true;
		sumtable.visible = true;
		destBoombox.visible = true;
		fuckYouFurniture.visible = true;

		updateShit = true;
		curSound = FlxG.sound.play(Paths.sound('voices/tabi3/tabilaugh'));
		//curSound.play();
		
		camera.zoom = 0.6;
	}
	
	function finishedCurSound():Void
	{
		updateShitYes = false;
		updateShit = false;
		bg.visible = false;
		gf1.visible = false;
		tabiLaugh.visible = false;
		bf1.visible = false;
		sumtable.visible = false;
		curSound2 = FlxG.sound.play(Paths.sound('explode'));
		if (!Highscore.getPhoto())
		{
			camera.fade(FlxColor.WHITE, 5, true);
		}
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			curSound3 = FlxG.sound.play(Paths.sound('afterexplode'));
			updateShit2 = true;
		}, 1);
		ChromaHandler.setChrome(10 / 1000);
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				ChromaHandler.setChrome(6 / 1000);
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					ChromaHandler.setChrome(5 / 1000);
					new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						ChromaHandler.setChrome(3 / 1000);
					}, 1);
				}, 1);
			}, 1);
		//curSound2.play();
	}
	
	function finishedCurSound2():Void
	{
		trace("yes done");
		updateShit2Yes = false;
		updateShit2 = false;
		visible = false;
		startUpdate = false;
		camera.zoom = 1;
		ChromaHandler.setChrome(0.0);
		finishCallback();
		kill();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ClassConductor.get() == Type.getClassName(Type.getClass(this)))
		{
			init();
		}

		if (startUpdate && updateShit && curSound != null)
		{
			tabiLaugh.animation.curAnim.curFrame = Std.int((tabiLaugh.animation.curAnim.numFrames - 1) * (curSound.time / curSound.length));
			
			//if ((tabiLaugh.animation.curAnim.curFrame / (tabiLaugh.animation.curAnim.numFrames - 1)) < 1)
			/*if (tabiLaugh.animation.curAnim.curFrame <= 30)
			{
				curSound.time = (tabiLaugh.animation.curAnim.curFrame / tabiLaugh.animation.curAnim.numFrames) * curSound.length;
			}*/

			//trace((curSound.time / curSound.length));
			
			if ((curSound.time / curSound.length) != 0)
			{
				updateShitYes = true;
			}

			if ((curSound.time / curSound.length) <= 0 && updateShitYes)
				finishedCurSound();
			
			//finishCallback();
		}
		/*if (startUpdate && updateShit2 && curSound2 != null)
		{
			if ((curSound2.time / curSound2.length) != 0)
			{
				updateShit2Yes = true;
			}

			if ((curSound2.time / curSound2.length) <= 0 && updateShit2Yes)
				finishedCurSound2();
		}*/
		if (startUpdate && updateShit2 && curSound3 != null)
		{
			if ((curSound3.time / curSound3.length) != 0)
			{
				updateShit2Yes = true;
			}

			if ((curSound3.time / curSound3.length) <= 0 && updateShit2Yes)
				finishedCurSound2();
		}
	}
}