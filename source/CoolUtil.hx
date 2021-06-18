package;

import lime.utils.Assets;

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
	
	public static function coolDialogue(path:String):Array<String>
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
		
		/*var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}*/
		
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
