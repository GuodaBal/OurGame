extends Node2D

var rules = {
	"X": "F+[[X]-X]-F[-FX]+X",
	"F": "FF"
}

var word = "X"
var len = 20  # Line length
var ang = 25  # Angle in degrees

# Function to generate the next L-System iteration
func generate():
	var next = ""
	for c in word:
		if rules.has(c):
			next += rules[c]
		else:
			next += c
	return next

# Function to interpret and draw the L-System
func _draw():
	draw_tree()

func draw_tree():
	var stack = []
	var pos = Vector2(200, 400)  # Start position
	var angle = -ang  # Initial rotation (upward)
	
	for c in word:
		match c:
			"F":
				var new_pos = pos + Vector2(0, -len).rotated(deg_to_rad(angle))
				draw_line(pos, new_pos, Color(0.5, 0.25, 0), 2)
				pos = new_pos
			"+":
				angle -= ang
			"-":
				angle += ang
			"[":
				stack.append([pos, angle])
			"]":
				var state = stack.pop_back()
				pos = state[0]
				angle = state[1]
				draw_circle(pos, 5, Color(0, 0.8, 0))  # Leaf effect

# Update tree on mouse release
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		word = generate()
		queue_redraw()  # Redraw with new generation
