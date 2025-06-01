shader_type canvas_item;

uniform float amplitude = 0.02;      // maksimalus poslinkis
uniform float speed = 2.0;           // judėjimo greitis
uniform float frequency = 10.0;      // bangų tankis
uniform float frame_offset = 0.0;    // gaunamas iš GDScript - kinta kas frame
uniform float growth_progress = 1.0; // nuo 0 (neužaugę) iki 1 (pilnai užaugę)
render_mode unshaded;
void fragment() {
    vec2 uv = UV;

    // Poslinkis su frame offsetu ir laiku
    float wave_x = sin(uv.y * frequency + frame_offset + TIME * speed);
    float wave_y = cos(uv.x * frequency + frame_offset + TIME * speed);

    // Judėjimo stiprumas priklauso nuo growth_progress:
    // kai dar neaugę, juda daugiau (amplitude),
    // kai užaugę, juda mažiau (0.2x amplitude)
    float current_amplitude = mix(amplitude, amplitude * 0.2, growth_progress);

    //uv.x += wave_x * current_amplitude;
    uv.y += wave_y * current_amplitude;

    vec4 tex_color = texture(TEXTURE, uv);

    if (tex_color.a < 0.1) {
        discard;
    }

    COLOR = tex_color;
	
}

/*void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.a < 0.1) {
        discard; // nesimato, praleidžiam pikselį
    }
    // Spalvą pakeičiam – čia pavyzdyje į tamsiai žalią:
    COLOR = vec4(tex_color.rgb * vec3(0.0, 0.5, 0.0), tex_color.a);
}*/
