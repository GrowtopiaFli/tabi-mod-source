package;

import openfl.filters.ShaderFilter;

class BrightHandler
{
	public static var brightShader:ShaderFilter = new ShaderFilter(new Bright());

	public static function setBrightness(brightness:Float):Void
	{
		if (Highscore.getPhoto())
		{
			brightness = 0.0;
		}
		brightShader.shader.data.brightness.value = [brightness];
	}
	
	public static function setContrast(contrast:Float):Void
	{
		if (Highscore.getPhoto())
		{
			contrast = 0.0;
		}
		brightShader.shader.data.contrast.value = [contrast];
	}
}