shader_type canvas_item;

uniform float speed = 1.0;
uniform float wait_time = 0.5;
uniform float circle_width = 0.1;
uniform float alpha_boost = 1.0;
uniform float tile_x = 3.0;
uniform float tile_y = 2.0;

uniform float start_time = -1.0; // When pulse should start
uniform float current_time = 0.0;
uniform float pulse_duration = 1.0; // How long the pulse lasts (adjust as needed)

void fragment() {
    // Time since pulse started
    float t = current_time - start_time;

    // Only animate if pulse is active
    if (start_time >= 0.0 && t <= pulse_duration) {
        vec2 tiled_uv = fract(UV * vec2(tile_x, tile_y));
        float dist = distance(tiled_uv, vec2(0.5)); // Center of each tile

        // Progress through pulse duration
        float mod_dist = dist - mod(t * speed, 0.75 + wait_time) + 0.5;

        vec4 circle = vec4(0.0, 0.0, 0.0, 1.0);
        circle.a *= 1.0 - step(0.5, mod_dist); // fades out after radius
        circle.a += step(0.5 - circle_width / 2.0, mod_dist) - 1.0; // cuts a hole in center
        circle.a -= 2.0 * dist; // fade out based on distance
        circle.a *= alpha_boost;

        if (circle.a < 0.0){
            circle.a = 0.0;
        } else {
            circle.b += 0.4;
            circle.g += 0.2;
        }

        COLOR += circle;
    }
}
