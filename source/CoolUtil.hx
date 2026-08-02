package;

import lime.utils.Assets;
import haxe.io.Path;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	//my retarded method will eventually die lol idk
	/*public static function coolDialogue(path:String):Array<String>
	{
		var daList1:Array<String> = new EReg("\r", "g").replace(Assets.getText(path), "").trim().split('---SECTION START---\n');

		var daList:Array<Array<String>> = [];
		
		for (fuckyoumate in daList1)
		{
			//if (fuckyoumate != "")
			if (fuckyoumate.contains("\n---SECTION END---"))
			{
				var someshit:Array<String> = new EReg("\r", "g").replace(fuckyoumate, "").trim().split('\n---SECTION END---');
				//trace("fuck you mate: " + fuckyoumate);
				//trace("some shit: " + someshit);
				if (someshit.length > 0)
				{
					daList.push(someshit[0].trim().split('\n'));
				}
			}
		}
		
		//trace(daList);
		
		//var daList:Array<String> = Assets.getText(path).trim().split('\n');

		//for (i in 0...daList.length)
		//{
			//daList[i] = daList[i].trim();
		//}
		
		var listToUse:Array<String> = [];
		
		if (Highscore.getRus() && Highscore.getVoice() && daList.length > 3)
		{
			listToUse = daList[3];
		}
		else if (Highscore.getRus() && daList.length > 2)
		{
			listToUse = daList[2];
		}
		else if (Highscore.getVoice() && daList.length > 1)
		{
			listToUse = daList[1];
		}
		else if (daList.length > 0)
		{
			listToUse = daList[0];
		}

		return listToUse;
	}*/
	
	public static function coolDialogue(path:String):Array<String>
	{	
		var daList1:Array<String> = new EReg("\r", "g").replace(Assets.getText(path), "").trim().split('---SECTION START---\n');

		var daList:Array<Array<String>> = [];
		
		for (fuckyoumate in daList1)
		{
			if (fuckyoumate.contains("\n---SECTION END---"))
			{
				var someshit:Array<String> = new EReg("\r", "g").replace(fuckyoumate, "").trim().split('\n---SECTION END---');
				if (someshit.length > 0)
				{
					daList.push(someshit[0].trim().split('\n'));
				}
			}
		}
		
		var listToUse:Array<String> = [];

		if (Highscore.getVoice() && daList.length > 1)
		{
			listToUse = daList[1];
		}
		else if (daList.length > 0)
		{
			listToUse = daList[0];
		}
		
		var listToUseFinal:Array<String> = [];
		
		for (str in listToUse)
		{
			var finalString:String = str;
			var toRep:String = "";
			var daStr:Array<String> = str.split("%");
			var daStr2:Array<String> = [];
			for (strs in daStr)
			{
				daStr2.push(strs);
			}
			if (daStr2.length == 3)
			{
				daStr2.shift();
				if (daStr2.length > 1)
				{
					daStr2.pop();
					if (daStr2.length > 0)
					{
						toRep = daStr2[0];
					}
				}
			}
			if (toRep != "")
			{
				finalString = new EReg("%" + toRep + "%", "").replace(finalString, MLanguageDialogueParser.get(new Path(path).file, toRep)).trim();
			}
			listToUseFinal.push(finalString);
		}
		
		//trace(listToUseFinal);

		return listToUseFinal;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
