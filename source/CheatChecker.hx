package;

import flixel.FlxG;

class CheatChecker
{	
	public static function check():Bool
	{
		var isCheat:Bool = false;
		var P1Array:Array<String> = [];
		var P2Array:Array<String> = [];
		for (i in 0...4)
		{
		P1Array.push(Highscore.getKeyBind(i));
		}
		for (i in 4...8)
		{
		P2Array.push(Highscore.getKeyBind(i));
		}
		
		var P1Shit:Int = checkList(P1Array);
		var P2Shit:Int = checkList(P2Array);
		
		var TotalArray:Array<String> = [];
		
		for (i in P1Array)
		{
		TotalArray.push(i);
		}
		for (i in P2Array)
		{
		TotalArray.push(i);
		}
		
		var TotalShit:Int = checkList(TotalArray);
		
		if (P1Shit >= 2 || P2Shit >= 2 || TotalShit >= 2)
		{
		isCheat = true;
		}
		
		return isCheat;
	}
	
	public static function checkList(List:Array<String>):Int
	{
		var Ints:Int = 0;
		var IntsList:Array<Int> = [];
		for (i in 0...List.length)
		{
		Ints = 0;
		for (k in 0...List.length)
		{
		if (List[i] == List[k] && List[i] != "NONE" && List[k] != "NONE")
		{
		Ints++;
		}
		}
		IntsList.push(Ints);
		}
		IntsList.sort(Reflect.compare);
		IntsList.reverse();
		if (IntsList.length > 0)
		{
		Ints = IntsList[0];
		} else {
		Ints = 0;
		}
		
		return Ints;
	}
	
	public static function isProb():Bool
	{
		var isProbably:Bool = false;
		var P1Array:Array<String> = [];
		var P2Array:Array<String> = [];
		for (i in 0...4)
		{
		P1Array.push(Highscore.getKeyBind(i));
		}
		for (i in 4...8)
		{
		P2Array.push(Highscore.getKeyBind(i));
		}
		
		var P1Shit:Int = checkList(P1Array);
		var P2Shit:Int = checkList(P2Array);
		
		var TotalArray:Array<String> = [];
		
		for (i in P1Array)
		{
		TotalArray.push(i);
		}
		for (i in P2Array)
		{
		TotalArray.push(i);
		}
		
		var TotalShit:Int = checkList(TotalArray);
		
		if (P1Shit == 2 || P2Shit == 2)
		{
		isProbably = true;
		}
		
		if (TotalShit > 3 && isProbably)
		{
		isProbably = false;
		}
		
		return isProbably;
	}
}
