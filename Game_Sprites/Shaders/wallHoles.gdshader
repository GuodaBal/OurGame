shader_type canvas_item;

uniform sampler2D noise_tex;

uniform float threshold = 0.3;       // Triukšmo slenkstis plyšiams
uniform float glow_intensity = 2.0;  // Švytėjimo stiprumas
uniform float glow_size = 0.05;      // Švytėjimo sklaidos dydis
uniform vec3 glow_color = vec3(1.0, 1.0, 0.8); // Spalva švytėjimo (geltonai balta)

void fragment() {
    // 1. Tekstūra kaip kaukė: balta = leidžiama, juoda = draudžiama
    float mask = texture(TEXTURE, UV).r;

    // 2. Jei kaukė yra juoda, nieko nerodome (plyšiai ten negalimi)
    if (mask < 0.1) {
        discard;
    }

    // 3. Plyšių generavimas iš noise tekstūros
    float noise_val = texture(noise_tex, UV).r;
    float cracks_mask = step(noise_val, threshold);

    // 4. Švytėjimo zona aplink plyšio kraštą
    float glow_zone = smoothstep(threshold + glow_size, threshold, noise_val);

    // 5. Galutinė spalva – švytėjimas tik plyšio vietose
    vec3 final_rgb = glow_color * glow_zone * glow_intensity * cracks_mask;

    COLOR = vec4(final_rgb, cracks_mask); // Alpha = plyšio buvimas
}