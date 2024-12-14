extends AnimatedSprite2D

@onready var attackTimer := $AttackTimer as Timer
@onready var stageTimer := $StageTimer as Timer

var stage = 1
var state = "wait"

var attackLength = 10
var waitLength = 3

var lastWasDark = false #If last attack was darkness, don't cast it again (gets repetitive)


func _on_attack_timer_timeout() -> void:
	#Finished waiting, switching to attacking
	if state == "wait":
		var whichAttack = randi()%3
		match whichAttack:
			0:
				play("calling_spikes")
				get_parent().start_spike_attack()
				attackTimer.start(15)
				lastWasDark = false
			1:
				play("calling_bunnies")
				get_parent().start_rabbit_attack()
				lastWasDark = false
				attackTimer.start(15)
			2:
				attackTimer.start(0.1)
				if !lastWasDark:
					get_parent().block_sun()
					lastWasDark = true
					attackTimer.start(0.1)
		state = "attack"
	#Finished attacking, switching to waiting
	elif state == "attack":
		attackTimer.start(3)
		if lastWasDark:
			attackTimer.start(1.5)
		if !stageTimer.is_stopped():
			state = "wait"
		else:
			state = "changeStage"
		get_parent().stop_attacks()
	elif state == "changeStage":
		changeStage()
		attackTimer.start(5)
		state = "wait"

func changeStage():
	if stage == 3: #Fight ends
		GlobalVariables.MedeinaDone = true
		get_parent().end_level()
		play("death")
		await animation_finished
		queue_free()
	else:
		stage+=1
		lastWasDark = true
		get_parent().block_sun()
		#Attack speed changes
		get_parent().coef *= 1.4
		stageTimer.start()
		#Environment changes
		await get_tree().process_frame
		get_parent().change_environment(stage)
