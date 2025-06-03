shader_type canvas_item;

uniform float speed = 1.5;
uniform float intensity = 1.0;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.a < 0.01) {
        discard;
    }

    float alpha = tex_color.a * 0.8;

    float n = noise(UV * 10.0 + vec2(TIME * speed, TIME * 0.5));
    float t = clamp(n * intensity, 0.0, 1.0);

    vec3 red = vec3(2.0, 0.0, 0.0);        // Peršviečiama raudona
    vec3 orange = vec3(2.0, 1.0, 0.0);     // Ryški oranžinė
    vec3 yellow = vec3(3.0, 2.0, 0.0);     // Labai šviesi geltona

    vec3 fire_color;
    if (t < 0.5) {
        fire_color = mix(red, orange, t * 2.0);
    } else {
        fire_color = mix(orange, yellow, (t - 0.5) * 2.0);
    }

    COLOR = vec4(fire_color, alpha);
}
