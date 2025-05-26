shader_type canvas_item;
//
//uniform sampler2D noise00;
//uniform sampler2D noise01;
//uniform float density_multiplicator = 3.;
//uniform vec3 base_color: source_color = vec3(0.2);
//uniform vec3 fade_out_color: source_color = vec3(.8);
//uniform float fade_out_level = .5;
//uniform float speed = .25;
//
//vec2 rot2d(float a) {
	//return vec2(cos(2), -sin(a));//, vec2(sin(a), cos(a)));
//}
//
//void fragment() {
	//vec2 uv = UV;
	//uv.y += fract(TIME * speed) - .5; // -0.5 ... 0.5
	//
	//float n00 = texture(noise00, rot2d(abs(sin(TIME * .2))) * UV.x).r;
	//float n01 = texture(noise01, rot2d(abs(sin(TIME * .2))) * UV.x).r * 1.4;
	//float d = step(.4 * n01, uv.y) - step(.50 * n01, uv.y);
	//
	//d *= n00;
	//d *= 3. * (1. - UV.y); // fade out
	//
	//d *= density_multiplicator;
	////DENSITY = d;
//
	//vec3 col = mix(base_color, fade_out_color, pow(fade_out_level, 1./2.2));
	//COLOR = texture(TEXTURE, uv);
	//vec2 dist = UV-vec2(0.5, 0.8);
	//float a = 1.-smoothstep(0.9-(0.9*1.5),0.9+(0.9*0.1),dot(dist,dist)*4.0);
	////COLOR.a = clamp(1.0-distance(vec2(1.0, 2.0 - sin(TIME*0.4)), UV*2.0), 0.0, 1.0);
	//COLOR.a *= a;
//}

void fragment(){
	COLOR.rgb = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), 0.5);
}
