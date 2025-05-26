shader_type canvas_item;

uniform vec2 size; //How far apart blur samples are
uniform int samples = 2; // Number of samples for blur

uniform float rotation_strength = 1.0;
uniform float rotation_radius = 0.65; //Distance from center for bendring to stop
uniform float random_offset = 0.0; //Time start offset

vec2 rotateUV(vec2 uv, vec2 pivot, float time) {

	//Distance from pivot so rotation gets more intense
	vec2 dist = uv-pivot;

	//Rotation limits
	float min_angle = radians(-30.0);
	float max_angle = radians(30.0);

	float radius_gradient = length(dist);  // Distance from the center
	float strength = smoothstep(0.0, rotation_radius, radius_gradient); // Stronger effect at edges

	//Rotation back and forth using sine wave
	float rotation = mix(min_angle, max_angle, 0.5 + 0.6 * sin(time * 2.0 + random_offset) * strength) * rotation_strength;

	// Perform rotation
	float vsin = sin(rotation);
	float vcos = cos(rotation);

	uv -= pivot;

	float x = (uv.x * vcos - uv.y * vsin);
	float y = (uv.x * vsin + uv.y * vcos);

	uv = vec2(x, y) + pivot;
	return uv;
}

void vertex(){
	VERTEX = (VERTEX - 0.5) * 2.0 + 0.5;
}

void fragment() {
	//Rotation
	vec2 expanded_region_uv = (UV - 0.5) * 2.0 + 0.5;
	vec2 pivot = vec2(0.5, 1.0);
	vec2 rotated_region_uv = rotateUV(expanded_region_uv, pivot, TIME);

	//Blur + 'glow'
	vec4 texColor = texture(TEXTURE, rotated_region_uv);
	vec4 color = vec4(0.0);
	int count = 0;

	//Adding samples
	for (int x = -samples; x <= samples; x++) {
		for (int y = -samples; y <= samples; y++) {
			vec2 offset = vec2(float(x), float(y)) * size;
			color += texture(TEXTURE, rotated_region_uv + offset);
			count++;
		}
	}

	COLOR = texColor;
	COLOR = clamp(texColor + (color / float(count)) * 1.0, 0.0, 1.0);
}