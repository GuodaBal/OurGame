shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float glow_intensity = 1.5;
uniform float glow_mix = 0.5;

void fragment() {
    vec2 uv = UV;

    float noise = texture(noise_tex, uv + vec2(sin(TIME * 0.11), cos(TIME * 0.11))).r;

    // Spalvų perėjimas, kuris pabrėžia ryškesnę raudoną spalvą su dinamiška tekstūra
    vec3 fire_color = mix(vec3(1.0, 0.0, 0.0), vec3(1.0, 0.7, 0.0), noise); // Raudona su geltonais akcentais
    vec4 tex_color = texture(TEXTURE, UV);

    // Sukuriame tankesnį spalvų perėjimą su didesniu intensyvumu
    vec3 final_color = mix(tex_color.rgb, fire_color, glow_mix);

    // Panaudojame švytėjimo intensyvumą, kad sustiprintume efektą
    COLOR = vec4(final_color * glow_intensity, tex_color.a);
}
