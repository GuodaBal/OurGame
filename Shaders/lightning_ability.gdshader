shader_type canvas_item;

uniform vec2 size;
uniform int samples = 2; // Number of samples outwards in each direction

void fragment() {
	vec4 color = vec4(0.0);
	int count = 0;

	for (int x = -samples; x <= samples; x++) {
		for (int y = -samples; y <= samples; y++) {
			vec2 offset = vec2(float(x), float(y)) * size;
			color += texture(TEXTURE, UV + offset);
			count++;
		}
	}
	COLOR = clamp(COLOR + (color / float(count)) * 1.0, 0.0, 1.0);
}
