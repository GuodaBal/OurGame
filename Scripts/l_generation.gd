extends Node2D

var lines: Array = []
var scale_factor = 1.2
var starting_point

var done = false

@onready var light := $PointLight2D as PointLight2D
@onready var canvas_group := $CanvasGroup as CanvasGroup

#func _ready():
	#starting_point = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y)
#
	#lines = generate(starting_point + Vector2(0, -900), 8, 1.0, Color.WHITE, 10.0, Lightning.new())
	#
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		for child in get_children():
			if child is Line2D:
				remove_child(child)
				child.queue_free()
		starting_point = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y)
		lines = generate(starting_point + Vector2(0, -900), 8, 1.0, Color.WHITE, 10.0, Lightning.new())
	if Input.is_action_just_pressed("fire_ability"):
		light_up()
		
		#await get_tree().process_frame  # Let it render at least once
		#get_viewport().transparent_bg = true
		#
		#var image = get_viewport().get_texture().get_image()
		#image.convert(Image.FORMAT_RGBA8) # Ensure transparency
		#var used_rect = image.get_used_rect()
		#var cropped_image := Image.create(used_rect.size.x, used_rect.size.y, false, Image.FORMAT_RGBA8)
		#cropped_image.blit_rect(image, used_rect, Vector2.ZERO)
		#var date = Time.get_date_string_from_system()
		#var time = Time.get_time_string_from_system().replace(":", "_")
		#var dir = DirAccess.open("user://")
		#if not dir.dir_exists("tree_exports"):
			#dir.make_dir("tree_exports")
		#var file_path = "user://tree_exports/tree_"+str(date)+str(time)+".png"
		#cropped_image.save_png(file_path)
func _process(delta):
	var lines_per_frame = 2
	if done:
		for index in lines_per_frame:
			for child in get_children():
				if child is Line2D:
					child.queue_free()
					break
			if canvas_group:
				for child in canvas_group.get_children():
					if child is Line2D:
						child.queue_free()
						break
		if canvas_group and canvas_group.get_child_count() == 0:
			done = false
	if lines.is_empty():
		await get_tree().create_timer(0.1).timeout
		done = true
		return
		
	for index in lines_per_frame:
		var line = lines.pop_front()
		add_child(line)
		if canvas_group:
			canvas_group.add_child(line.duplicate())
		if lines.is_empty():
			break
			

func generate(start_position, iterations, length_reduction, color, width, rule):
	var lines = [] as Array
	var length = -200
	var value = rule.axiom
	var arrangement
	if value is Array:
		var r = randf()
		var cumulative = 0.0
		for item in value:
			cumulative += item["prob"]
			if r <= cumulative:
				arrangement = item["axiom"]
				break
		if arrangement == null:
			arrangement = value[-1]["axiom"]
	else:
		arrangement = value
	for i in iterations:
		length *= length_reduction
		var new_arrangement = ""
		for character in arrangement:
			new_arrangement += rule.get_character(character)
		arrangement = new_arrangement
	print_debug(arrangement)
	
	
	var from = start_position
	var rot = 0
	var cache_queue = []
	for index in arrangement:
		match rule.get_action(index):
			"draw_forward":
				var to = from + Vector2(0, length).rotated(deg_to_rad(rot))
				var line = Line2D.new()
				line.default_color = color
				line.width = width
				line.antialiased = true
				line.begin_cap_mode = Line2D.LINE_CAP_ROUND
				line.end_cap_mode = Line2D.LINE_CAP_ROUND
				
				#var mid = from.linear_interpolate(to, 0.5)
				#mid += Vector2(0, -10).rotated(deg_to_rad(rot))  # curve upward slightly
				line.add_point(from)
				#line.add_point(mid)
				line.add_point(to)
				lines.push_back(line)
				from = to
			"rotate_right":
				rot += rule.angle
				#color = Color.RED
			"rotate_left":
				rot -= rule.angle
				#color = Color.BLUE
			"store":
				cache_queue.push_back([from, rot])
			"load":
				var cached_data = cache_queue.pop_back()
				from = cached_data[0]
				rot = cached_data[1]
			"multiply":
				length *= scale_factor
				width *= scale_factor
			"divide":
				length /= scale_factor
				width /= scale_factor
	return lines

func generate_lightning(position):
	lines = generate(position, 8, 1.0, Color.WHITE, 10.0, Lightning.new())

func light_up():
	get_viewport().transparent_bg = true
	var image = get_viewport().get_texture().get_image() as Image
	image.convert(Image.FORMAT_RGBA8) # Ensure transparency

	var tex := ImageTexture.create_from_image(image)

	light.texture = tex
	light.force_update_transform()

class Rule:
	var axiom
	var rules = {}
	var actions = {}
	var angle
	
	func get_character(character):
		if rules.has(character):
			var value = rules[character]
			if value is Array:
				var r = randf()
				var cumulative = 0.0
				for item in value:
					cumulative += item["prob"]
					if r <= cumulative:
						return item["rule"]
				# Fallback in case of rounding errors
				return value[-1]["rule"]
			else:
				return value
		return character
	
	func get_action(character):
		return actions.get(character)
	


class Org_Tree extends Rule:
	func _init():
		self.axiom = "FX"
		self.angle = 24
		self.rules = {
			"X" : [{"rule": "[-<FY>][+<FX>]", "prob": 0.3},
			{"rule": "[<FY>][+<FX>]", "prob": 0.2},
			{"rule": "[-<FY>][<FX>]", "prob": 0.2},
			{"rule": "[+<FX>]", "prob": 0.2},
			{"rule": "[-<FY>]", "prob": 0.1}],
			"Y" : [{"rule": "-<FX>+<FY>", "prob": 0.4},
			{"rule": "<FX>+<FY>", "prob": 0.2},
			{"rule": "-<FX><FY>", "prob": 0.2},
			{"rule": "+<FY>", "prob": 0.1},
			{"rule": "+<FY>", "prob": 0.1}]
		}
		self.actions = {
			"F" : "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}
class Org_Tree2 extends Rule:
	func _init():
		self.axiom = "F"
		self.angle = 22
		self.rules = {
			"F": [
				{"rule": "F[+F]F[-F][F]", "prob": 0.1},
				{"rule": "F[+F]F[-F]",    "prob": 0.9}]
		}
		self.actions = {
			"F" : "draw_forward",
			"A": "draw_forward",
			"B": "draw_forward",
			"C": "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}


class Generated_tree extends Rule:
	func _init():
		self.axiom = "a"
		self.angle = 45
		self.rules = {
			"F" : ">F<",
			"a" : "F[+x]Fb",
			"b" : "F[-y]Fa",
			"x" : "a",
			"y" : "b"
		}
		self.actions = {
			"F" : "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}
class Bush extends Rule:
	func _init():
		self.axiom = "F"
		self.angle = 16
		self.rules = {
			"F" : "FF-[5-<F+F+F>]+[5+<F-F-F>]",
			"a" : "F[+x]Fb",
			"b" : "F[-y]Fa",
			"y" : "b"
		}
		self.actions = {
			"F" : "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}

class Lightning extends Rule:
	func _init():
#		self.axiom = "----FX"
		self.axiom = [{"axiom": "----FX", "prob": 0.4},
		{"axiom": "---FX", "prob": 0.3},
		{"axiom": "-----FX", "prob": 0.3}]
		self.angle = 45
		self.rules = {
			"X" : [{"rule": "[-<FX>]+<FX>", "prob": 0.1},
			{"rule": "[-<FX>]", "prob": 0.3},
			{"rule": "[+<FX>]", "prob": 0.3},
			{"rule": "[<FX>]+<FX>", "prob": 0.15},
			{"rule": "[-<FX>]<FX>", "prob": 0.15}]
		}
		self.actions = {
			"F" : "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}
class Barsley extends Rule:
	func _init():
		self.axiom = "-X"
		self.angle = 25
		self.rules = {
			"X" : "<F>+[[X]-X]-<F>[-<FX>]+X",
			"F" : "FF"
		}
		self.actions = {
			"F" : "draw_forward",
			"+" : "rotate_left",
			"-" : "rotate_right",
			"[" : "store",
			"]" : "load",
			">" : "multiply",
			"<" : "divide"
		}
		
		#
		 #L(g)->
  #fwd("randbetween(100/(g+1)-10, 100/(g+1)+10)", "5/(g+1)")
  #rot(defer("(3/(g+1))*Math.cos(ctx.f/60.0)"))
  #[rot("randbetween(-20-5, -20+5)")L("g+1")]
  #rot(defer("(3/(g+1))*Math.cos(ctx.f/70.0)"))
  #[rot("randbetween(20-5, 20+5)")L("g+1")]
  #rot(defer("(3/(g+1))*Math.sin(ctx.f/100.0)"));
