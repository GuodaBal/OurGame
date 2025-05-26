shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Color to outline
uniform vec4 outline_color : source_color = vec4(1.0); // Outline color
uniform float threshold : hint_range(0.0, 1.0) = 0.1; // How close color must match
uniform float radius : hint_range(0.0, 10.0) = 2.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec3 center_col = texture(SCREEN_TEXTURE, uv).rgb;

    float diff = length(center_col - target_color.rgb);

    float edge = 0.0;
    if (diff > threshold) {
        // Check surrounding pixels to see if any are target color
        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                if (x == 0 && y == 0) continue;
                vec2 offset = vec2(float(x), float(y)) * SCREEN_PIXEL_SIZE * radius;
                vec3 neighbor_col = texture(SCREEN_TEXTURE, uv + offset).rgb;
                float neighbor_diff = length(neighbor_col - target_color.rgb);
                if (neighbor_diff < threshold) {
                    edge = 1.0;
                }
            }
        }
    }

    if (edge > 0.0) {
        COLOR = outline_color;
    } else {
        COLOR = vec4(center_col, 1.0);
    }
}
