shader_type canvas_item;

uniform float reveal_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a < 0.01) {
        discard;
    }

    // Pritaikome atskleidimo stiprumą prie alfa
    float final_alpha = tex_color.a * reveal_amount * 0.8;

    // Ryškiai geltona spalva
    vec3 fire_color = vec3(2.0, 2.0, 0.0);

    COLOR = vec4(fire_color, final_alpha);
}
