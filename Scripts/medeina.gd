extends AnimatedSprite2D

@onready var attackTimer := $AttackTimer as Timer
@onready var stageTimer := $StageTimer as Timer

var stage = 1
var state = "wait"

var attackLength = 10
var waitLength = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_attack_timer_timeout() -> void:
	#Finished waiting, switching to attacking
	if state == "wait":
		var whichAttack = randi()%3
		match whichAttack:
			0:
				get_parent().start_spike_attack()
				attackTimer.start(10)
			1:
				get_parent().block_sun()
				attackTimer.start(2)
		state = "attack"
	#Finished attacking, switching to waiting
	elif state == "attack":
		attackTimer.start(3)
		if !stageTimer.is_stopped():
			state = "wait"
		else:
			state = "changeStage"
		get_parent().stop_attacks()
	elif state == "changeStage":
		changeStage()
		attackTimer.start(3)
		state = "wait"

func changeStage():
	stage+=1
	print_debug("aaaaaaaa")
	#Environment changes
	#Attack speed changes
	get_parent().coef = stage
	stageTimer.start()
