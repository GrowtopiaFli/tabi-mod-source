package;

import yaml.Yaml;
import yaml.Parser;
import yaml.Renderer;
import yaml.util.ObjectMap;

import lime.utils.Assets;
import lime.utils.Bytes;
import lime.utils.CompressionAlgorithm;
import haxe.io.Bytes as HaxeBytes;

import haxe.ValueException;
import haxe.crypto.Base64;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class MLanguageDialogueParser
{
	public static var dataObj:Dynamic = {};
	public static var doSys:Bool = false;
	public static var errored:Bool = false;
	
	public static function update():Void
	{
		if (doSys)
		{
			#if sys
			try {
			if (FileSystem.exists("languageData.yaml") && !FileSystem.isDirectory("languageData.yaml") && (!FileSystem.exists("languageData.gz") || (FileSystem.exists("languageData.gz") && !FileSystem.isDirectory("languageData.gz"))))
			{
				var daBytes:HaxeBytes = File.getBytes("languageData.yaml");
				var newDaBytes:Bytes = Bytes.fromBytes(daBytes);
				newDaBytes = newDaBytes.compress(CompressionAlgorithm.GZIP);
				File.saveBytes("languageData.gz", HaxeBytes.ofHex(newDaBytes.toHex()));
			}
			}
			catch(e:Dynamic)
			{
				if (!errored)
				{
					errored = true;
					trace("Something Went Wrong With This FileSystem Shit!");
				}
			}
			#end
		}
	}

	public static function init():Void
	{
		var daText:String = Assets.getText(Paths.yaml('languageData'));
		dataObj = Yaml.parse(daText);
		if (!(dataObj.exists("id") && dataObj.get("id") == "GWebDev idk screw it it's for verifying shit for idiots who don't follow instructions" && dataObj.exists("mod") && dataObj.get("mod") == "Tabi"))
		{
			throw new ValueException("This Is What You Get Motherfucker For Not Following Verification");
		}
		else
		{
			var daBytes:Bytes = Bytes.ofString(daText);
			daBytes = daBytes.compress(CompressionAlgorithm.GZIP);
			/*trace("---------------");
			trace("GZIP ENCRYPTED:");
			trace("---------------");
			trace(daText);
			trace("---------------");
			trace(Base64.encode(HaxeBytes.ofHex(daBytes.toHex())));
			trace("---------------");*/
			doSys = true;
		}
	}
	
	public static function get(fname:String, id:String):String
	{
		var toRet:String = "";
		var shittyFormat:Bool = false;
		var dataObj2:Dynamic = {};
		trace("----");
		trace(fname);
		trace(id);
		trace("----");
		var bool1:Bool = dataObj.exists("dialogues") && dataObj.get("dialogues").exists(fname);
		var bool2:Bool = false;
		if (bool1)
		{
			//trace(dataObj.get("dialogues"));
			dataObj2 = dataObj.get("dialogues").get(fname);
			//trace(dataObj2);
		}
		else
		{
			//trace(dataObj);
			//trace(dataObj.exists("dialogues"));
			shittyFormat = true;
		}
		if (!shittyFormat)
		{
			bool2 = dataObj2.exists("languages") && dataObj.exists("languageNames");
		}
		if (bool2 && getList().length > 0)
		{
			var defaultLanguage:Dynamic = dataObj2.get("languages").get(dataObj.get("languageNames")[0]);
			var selectedLanguage:Dynamic = {};
			if (!(Highscore.getLang() < 0 || Highscore.getLang() > getList().length - 1))
			{
				selectedLanguage = dataObj2.get("languages").get(dataObj.get("languageNames")[Highscore.getLang()]);
			} else {
				Highscore.setLang(0);
				selectedLanguage = dataObj2.get("languages").get(dataObj.get("languageNames")[0]);
			}
			//trace(defaultLanguage);
			//trace(selectedLanguage);
			if (selectedLanguage.exists(id))
			{
				toRet = selectedLanguage.get(id);
			} 
			else if (defaultLanguage.exists(id))
			{
				toRet = defaultLanguage.get(id);
			}
			else
			{
				toRet = "NULL NULL NULL WHY DO YOU NOT FILL THIS VARIABLE NULL";
			}
		}
		else
		{
			shittyFormat = true;
		}
		if (shittyFormat)
		{
			toRet = "NULL NULL NULL YOU DON'T FOLLOW SHITTY FORMATS NULL";
		}
		return toRet;
	}
	
	public static function getList():Array<String>
	{
		var toRet = [];
		var bool1:Bool = dataObj.exists("languageNames");
		if (bool1)
		{
			toRet = dataObj.get("languageNames");
		}
		return toRet;
	}
	
	public static function settings():Dynamic
	{
		var toRet:Dynamic = { font: "vcr.ttf", size: 16 };
		var daList:Array<String> = getList();
		if (daList.length > 0)
		{
			var defaultLanguage:Dynamic = dataObj.get("settings").get(daList[0]);
			var selectedLanguage:Dynamic = {};
			if (dataObj.exists("settings"))
			{
			if (!(Highscore.getLang() < 0 || Highscore.getLang() > daList.length - 1))
			{
				selectedLanguage = dataObj.get("settings").get(daList[Highscore.getLang()]);
			}
			else
			{
				Highscore.setLang(0);
				selectedLanguage = dataObj.get("settings").get(daList[0]);
			}
			
			if (selectedLanguage.exists("font"))
			{
				toRet.font = selectedLanguage.get("font");
			}
			else if (defaultLanguage.exists("font"))
			{
				toRet.font = defaultLanguage.get("font");
			}
			
			if (selectedLanguage.exists("size"))
			{
				toRet.size = selectedLanguage.get("size");
			}
			else if (defaultLanguage.exists("size"))
			{
				toRet.size = defaultLanguage.get("size");
			}
			
			}
		}
		toRet = { font: "15111.ttf", size: 32 };
		if (Highscore.getRus())
		{
			toRet.size = 25;
		}
		return toRet;
	}
}