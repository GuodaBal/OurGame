shader_type canvas_item;

uniform float col_count = 200.0;
uniform float drop_length = 0.15;
uniform float drop_width = 0.01;
uniform float rain_speed = 0.5;
uniform vec4 color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float slant = 0.2;
uniform float drop_density = 0.2;

void fragment() {
    // Apply slant
    float x_offset = UV.x - UV.y * slant;

    // Determine spacing and which column we're in
    float drop_spacing = 1.0 / col_count;
    float x_index = floor(x_offset / drop_spacing);

    // Pseudo-random
	float rand = fract(sin(x_index * 12.9898) * 43758.5453);

	// Use rand to decide whether a drop appears
	if (rand > drop_density) {
	    discard; // No drop in this column
	}


    // Animate fall with speed variation
    float fall = fract(UV.y - TIME * (rain_speed + rand * 0.2));

    // Check if within the vertical range of the drop
    float within_drop = step(1.0 - drop_length, fall);

    // Horizontal bounds
    float drop_center = mod(x_offset, drop_spacing);
    float within_width = step(drop_center, drop_width);

    // Compute fading streak from head to tail (bottom brighter than top)
    float streak_alpha = smoothstep(1.0 - drop_length, 1.0 , fall);

    // Final color output with streak fade
    if (within_drop * within_width > 0.0) {
        COLOR = vec4(color.rgb, color.a * streak_alpha);
    }
}
