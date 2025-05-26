shader_type canvas_item;

uniform sampler2D cracks;
uniform sampler2D noise;

void fragment(){
	COLOR = min(texture(cracks, UV), texture(noise, UV));
}