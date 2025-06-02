shader_type canvas_item;

// Pagrindinė (sienos) tekstūra gaunama iš TEXTURE (TileMap).
// Papildomai deklaruojame antrą tekstūrą – lava.
uniform sampler2D lava_tex: repeat_enable; //Pridedama repeat_enable, kad lavos tekstura kartotusi
uniform sampler2D noise_tex; // Naudosim generuoti "plyšiams"

// Tuning parametrai:
uniform float threshold = 0.5;   // Triukšmo reikšmė, nuo kurios atsiveria plyšys
uniform float lava_speed = 0.1;    // Kaip greitai lava juda (offset UV, kad simuliuotų tekėjimą)

// Ribų nustatymo parametrai
uniform float edge_start = 0.1;    // Jei UV atstumas nuo kraštų (border) mažesnis už edge_start, efektas bus išjungtas
uniform float edge_fade_start = 0.05; // Pradeda blukėti efektas

void fragment() {
	//Kaukė, rodanti lygio area
	float tex_mask = texture(TEXTURE, UV).r;
    // 1. Paimame pagrindinę sienos spalvą
    vec4 wall_col = texture(TEXTURE, UV);
    // 2. Naudojame triukšmo tekstūrą (be TIME) – plyšių raštas bus statinis
    float n = texture(noise_tex, UV).r;

    // 3. Sugeneruojame plyšių kaukę – step() grąžina 1.0, jei n < threshold, kitaip 0.0.
    float cracks_mask = step(n, threshold); 

    // 4. Apskaičiuojame atstumą nuo UV erdvės kraštų. UV koordinatės pagal nutylėjimą yra [0, 1].
    float border = min(min(UV.x, UV.y), min(1.0 - UV.x, 1.0 - UV.y));

    // Kombinuojame – efektas bus aktyvus tik vidinėje dalyje.
    float final_mask = cracks_mask * tex_mask;

    // 6. Lava tekstūros UV offsetas – lava juda vertikaliai.
	vec2 lava_uv = UV;
	lava_uv.y += TIME * lava_speed;                // Lava tekėjimas
	lava_uv.x += sin(UV.y * 10.0 + TIME) * 0.01;   // Bangavimas (horizontalus iškraipymas)
    vec4 lava_col = texture(lava_tex, lava_uv);

    // 7. Sumaišome sienos ir lavos spalvas, naudojant mūsų final_mask.
    vec3 final_rgb = mix(wall_col.rgb, lava_col.rgb, final_mask);
	
    COLOR = vec4(final_rgb, 1.0);
	COLOR.a = final_mask;
}
