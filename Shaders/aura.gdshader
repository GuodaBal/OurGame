shader_type canvas_item;

uniform sampler2D noise_tex : repeat_enable;
uniform float direction = 1.0;

void fragment(){
	vec4 tex = texture(TEXTURE, UV);
	vec4 noise = texture(noise_tex, UV + TIME * direction / 8.0);
	
	COLOR.a *= clamp(tex.r * noise.r * 8.0, 0.0, 1.0);
	COLOR.b *= 1.9;
	COLOR.g *= 1.5;
	//COLOR = noise;
}