shader_type canvas_item;

uniform float strength = 5.0;

void vertex() {
	VERTEX = vec2((sin(VERTEX.x+TIME)*(1.0 - UV.y) * strength)+VERTEX.x,VERTEX.y);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
