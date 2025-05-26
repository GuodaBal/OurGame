shader_type canvas_item;
render_mode world_vertex_coords;

uniform float y = 0.0;

void fragment() {
    if (VERTEX.y > y) {
        discard;
    }
}
