shader_type canvas_item;

uniform sampler2D main_tex : source_color;
uniform sampler2D poison_noise_tex;

uniform float time;
uniform float poison_speed = 0.5;
uniform vec4 color_1 : source_color = vec4(0.5, 1.0, 0.5, 1.0);
uniform vec4 color_2 : source_color = vec4(1.0, 0.0, 1.0, 1.0);

void fragment() {
    vec4 base = texture(main_tex, UV);

    vec2 p_uv = UV + vec2(0.0, time * poison_speed);
    float poison_mask = texture(poison_noise_tex, p_uv).r;

    vec4 poison_color = mix(color_1, color_2, poison_mask);
    vec4 final_color = mix(base, poison_color, poison_mask);

    // Glow efektas be EMISSION — naudodami HDR reikšmes
    COLOR = final_color * 1.8;
}
