package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class UpdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var daVer:String = "I DONT KNOW";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hello This Is GWeb And I Am The Tabi Police :)\n" +
			"Answer This Question Right Now!\n" +
			"How Did You Get A Hold Of This Version?\n" +
			"The Version On Github Is " + daVer + "\n" +
			"While This One Is " + CurrentVersion.get() + "!\n" +
			"H O W ?\n" +
			"IDK It's Either You Stole It From Us/Your One Of The Devs/You Manipulated The Version Code\n" +
			"I Don't Really Care...\n" +
			"Just Don't Steal\n" +
			"What Are You Waiting For...\n\n" +
			"PRESS ENTER If You Want To Go To The Gamebanana Page!\n" +
			"Or Back To Go To The Menu",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.openURL("https://gamebanana.com/mods/286388");
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
