shader_type canvas_item;

uniform float strength;
uniform vec4 modulate;

void fragment(){
	COLOR.rgb += vec3(0.1, 0.1, 0.1) * strength * -1.0;
	COLOR.a *= modulate.a;
}