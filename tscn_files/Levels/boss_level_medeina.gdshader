shader_type canvas_item;

// Spyglių centro koordinatės TileMap lokalioje erdvėje (pikseliais)
uniform vec2 spike_origin_local = vec2(-1000.0, -1000.0);
// Laikmatis nuo 0 iki spike_duration; kai < 0, deformacija neveikia
uniform float spike_time = -1.0;
uniform float spike_duration = 0.6;   // bangavimo trukmė sekundėmis

// Maksimalus pakėlimas (ekrano pikseliais)
uniform float max_strength = 8.0;
// Paveiktas spindulys (ekrano pikseliais)
uniform float max_radius = 64.0;

void vertex() {
    float t = spike_time / spike_duration;
    vec2 local_pos = VERTEX.xy;
    float dist = distance(local_pos, spike_origin_local);
    float wave = 0.0;

    if (spike_time >= 0.0 && t <= 1.0 && dist <= max_radius) {
        float local_strength = 1.0 - dist / max_radius;
        wave = sin(3.14159 * local_strength * (1.0 - t))
               * local_strength * (1.0 - t);
    }

    VERTEX.y += wave * max_strength;
}