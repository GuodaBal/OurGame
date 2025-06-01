shader_type canvas_item;
render_mode unshaded;


void fragment() {
	vec2 uv = UV;
	vec4 tex_color = texture(TEXTURE, uv);

	if (tex_color.a < 0.1) {
		discard;
	}

	// Atsitiktinis atspalvis pagal UV ir TIME
	float variation = fract(sin(dot(uv * TIME, vec2(12.9898, 78.233))) * 43758.5453);

	// Ruda bazinė spalva: (0.4, 0.25, 0.1)
	// Pridedame šiek tiek atsitiktinio variavimo:
	vec3 brown = vec3(0.4, 0.25, 0.1) + variation * vec3(0.05, 0.05, 0.03);

	COLOR = vec4(brown, tex_color.a);
}
