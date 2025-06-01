shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Tiesiog sampleris be hint’ų – Godot 4 leidžia priskirti bet kokią 2D tekstūrą
uniform sampler2D noise_texture;
uniform float time_speed = 1.0;
uniform float distortion_strength = 5.0;
uniform vec2 noise_scale = vec2(20.0, 20.0);

void fragment() {
    // 1. Paimame ekrano UV koordinates
    vec2 uv = SCREEN_UV;

    // 2. Sukuriame noise UV, judančią pagal laiką
    vec2 noise_uv = UV * noise_scale + vec2(TIME * time_speed, 0.0);

    // 3. Iš tekstūros paimame šviesumo kanalą (r), kuris bus tarp 0 ir 1
    float noise = texture(noise_texture, noise_uv).r;

    // 4. Apskaičiuojame ekrano iškraipymo poslinkį pagal noise reikšmę
    vec2 offset = vec2(noise * 0.01, noise * 0.01) * distortion_strength;

    // 5. Nuskaitome SCREEN_TEXTURE su apskaičiuotu poslinkiu
    COLOR = texture(screen_texture, uv + offset);
}