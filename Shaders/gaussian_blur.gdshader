shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int blur_radius : hint_range(1, 32) = 8;
uniform float blur_strength : hint_range(0.1, 20.0) = 1.0;

float gaussian_weight(float i, float sigma) {
    return exp(-0.5 * (i * i) / (sigma * sigma));
}

void calculate_kernel(out float kernel[32], int radius, float sigma) {
    float sum = 0.0;
    for (int i = 0; i <= radius; i++) {
        kernel[i] = gaussian_weight(float(i), sigma);
        sum += i == 0 ? kernel[i] : 2.0 * kernel[i];
    }
    for (int i = 0; i <= radius; i++) {
        kernel[i] /= sum;
    }
}

void fragment() {
    vec2 resolution = SCREEN_PIXEL_SIZE;


    float kernel[32];
    calculate_kernel(kernel, blur_radius, blur_strength);

    vec4 final_color = vec4(0.0);
    float total_weight = 0.0;

    for (int x = -blur_radius; x <= blur_radius; x++) {
        for (int y = -blur_radius; y <= blur_radius; y++) {
            float weight = kernel[abs(x)] * kernel[abs(y)];
            vec2 offset = vec2(float(x), float(y)) * resolution;
            vec4 sample = texture(SCREEN_TEXTURE, SCREEN_UV + offset);

            final_color.rgb += sample.rgb * sample.a * weight; // Blend color with alpha
            final_color.a += sample.a * weight; // Accumulate alpha
            total_weight += weight;
        }
    }

    // Normalize the final color and alpha
    if (final_color.a > 0.0) {
        final_color.rgb /= final_color.a; // Pre-multiplied alpha correction
    }

    final_color.a = clamp(final_color.a, 0.0, 1.0); // Ensure alpha stays within bounds

    COLOR *= final_color;
}
