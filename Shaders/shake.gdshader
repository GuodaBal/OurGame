shader_type canvas_item;

uniform float start_time = -1.0;
uniform float current_time = 0.0;
uniform float duration = 0.3;

void vertex() {
	float t = current_time - start_time;

	if (t >= 0.0 && t <= duration) {
		float decay = exp(-10.0 * t);
		float shake = sin(50.0 * t);
		VERTEX.x += 50.0 * decay * shake;
		// VERTEX.y += 20.0 * decay * cos(40.0 * t); // optional Y-axis shake
	}
}
