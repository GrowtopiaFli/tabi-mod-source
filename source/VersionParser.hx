package;

using StringTools;

class VersionParser
{
	public static var alphabet:Array<String> = "abcdefghijklmnopqrstuvwxyz".split("");
	public static var numeric:Array<String> = "0123456789".split("");

	public static function parse(strRaw:String):Int
	{
		var strSplit:Array<String> = strRaw.toLowerCase().split("");
		for (shit in 0...strSplit.length)
		{
			if (!alphabet.contains(strSplit[shit - 1]) && !numeric.contains(strSplit[shit - 1]) && strSplit[shit - 1] != ".")
			{
				strSplit[shit - 1] = "";
			}
		}
		strSplit = strSplit.join("").split(".");
		strSplit.reverse();
		var strSplit2:Array<Int> = [];
		var isNotZero:Bool = false;
		for (str in 0...strSplit.length)
		{
			if (!isNotZero)
			{
				if (strSplit[str] != "0")
				{
					isNotZero = true;
				}
				else
				{
					strSplit[str] = "";
				}
			}
		}
		strSplit = strSplit.join(".").split(".");
		for (str in 0...strSplit.length)
		{
			var daLetter:String = "";
			var daStr:String = strSplit[str];
			for (letter in 0...alphabet.length)
			{
				if (daStr.contains(alphabet[letter]))
				{
					daLetter = alphabet[letter];
				}
				daStr = new EReg(alphabet[letter], "g").replace(daStr, "");
			}
			var daInt:Int = Std.parseInt(daStr);
			if (daLetter != "" && alphabet.contains(daLetter))
			{
				daInt += (alphabet.indexOf(daLetter) + 1);
			}
			var multiplier:Int = 1;
			for (multiplierAdd in 0...str)
			{
				multiplier *= 10;
			}
			daInt *= multiplier;
			if (daInt > 0)
			{
				strSplit2.push(daInt);
			}
		}
		var sum:Int = 0;
		for (integer in strSplit2)
		{
			sum += integer;
		}
		return sum;
	}
}