shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float max_line_thickness : hint_range(0.0, 20.0) = 7.0;
uniform float min_blur_strength : hint_range(0.0, 1.0) = 0.5;

uniform float start_time = -1.0; // Time when shake was triggered
uniform float current_time = 0.0;
uniform float duration = 0.5;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

	float t = current_time - start_time;
	float line_thickness = 0.0;
	float blur_strength = 1.0;

	 if (t >= 0.0 && t <= duration) {
        float half_duration = duration * 0.5;
        if (t <= half_duration) {
            // Growing phase
            line_thickness = mix(0.0, max_line_thickness, t / half_duration);
			blur_strength = mix(min_blur_strength, 1.0, t / half_duration);
        } else {
            // Shrinking phase
            line_thickness = mix(max_line_thickness, 0.0, (t - half_duration) / half_duration);
			blur_strength = mix(1.0, min_blur_strength, (t - half_duration) / half_duration);
        }
    } else if (t > duration) {
        line_thickness = max_line_thickness;
    }
    // Accumulate alpha with a radial falloff kernel (5×5)
    float alpha_accum = 0.0;
    float weight_accum = 0.0;
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * line_thickness;
            // radial falloff: center stronger, edges weaker
            float w = 1.0 - length(vec2(float(x), float(y))) / 3.0;
            alpha_accum  += texture(TEXTURE, UV + offset).a * w;
            weight_accum += w;
        }
    }
    float blurred_alpha = alpha_accum / weight_accum;

    // Outline only where blurred_alpha exceeds original alpha
    float outline_alpha = clamp((blurred_alpha - tex.a) * (1.0 / blur_strength), 0.0, 1.0);

    // Mix between original and outline color
    COLOR = mix(tex, line_color, outline_alpha);
}
