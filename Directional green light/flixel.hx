package;

import flixel.system.FlxAssets.FlxShader;

class DirectionalGreenLight extends FlxShader
{
	@:glFragmentSource('
	#pragma header

	const float GeneralIntensity = 3.;
	const float GreenIntensity = 1.;
	
	const bool blending = true;
	const int blendingQuality = 7; //this will be done twice, advised to not put it too high because that would make performance take a hit + diminishing returns
	
	uniform float x;
	uniform float y;
	
	void main()
	{
		vec2 uv = openfl_TextureCoordv;
		vec4 col = flixel_texture2D(bitmap, uv);
		
		vec2 coordOffsets = vec2(x, y)/100.;
		
		//get the highlight
		float hglh = flixel_texture2D(bitmap, vec2(uv.x+coordOffsets.x, uv.y+coordOffsets.y)).a;
	
		//mask the highlight so that its only the border
		if (blending) {
		for (float i = float(-1*blendingQuality); i < float(blendingQuality); i+= 0.25) {
			float cur = (float(i) + float(blendingQuality))/float(blendingQuality);
			hglh -= (flixel_texture2D(bitmap, vec2(uv.x-mix(coordOffsets.x/2., coordOffsets.x*2., cur),uv.y-mix(coordOffsets.y/2., coordOffsets.y*2., cur))).a)*cur;
		}
		} else {
			hglh -= (flixel_texture2D(bitmap, vec2(uv.x-coordOffsets.x, uv.y-coordOffsets.y))).a;
		}
		//apply the highlight with mask

		//fix or whatever :rolling eyes:
		hglh *= col.a;

		hglh /= GeneralIntensity;
		col.b = max(col.b, col.b + hglh);
		hglh /= GreenIntensity;
		col.g = max(col.g, col.g + hglh);
		
		gl_FragColor = col;
	}')

	public function new(x:Float = 0.01, y:Float = 0.01)
	{
		super();
		this.x.value = [x];
		this.y.value = [y];
	}
}
