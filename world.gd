extends Node3D

var enemyspawn = preload("res://enemy.tscn")
var boomerspawn = preload("res://Boomerenemy.tscn")
var sprinterspawn = preload("res://Sprinterenemy.tscn")
var impspawn = preload("res://impenemy.tscn")

@onready var pause_menu = $"Pause Menu"
var paused = false 
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		pausemenu()
	

func pausemenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func _on_horde_2_timer_timeout() -> void:
	$Impspawn.autostart
	$Impspawn.start()
	





func _on_impspawn_timeout() -> void:
	var instanceimp = impspawn.instantiate()
	$"..".add_child(instanceimp)
	instanceimp.position.z = -6.666



var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	print(rng.randi_range(0, 100))
	var random_number = randi() % 100
	if random_number < 60:
		$AudioStreamPlayer3D.play()
	if random_number > 60:
		$"Enter Annihilation".play()
	
	if Input.is_action_just_pressed("ui_cancel"):
		pausemenu()



func _on_audio_stream_player_3d_finished() -> void:
	rng.randomize()
	print(rng.randi_range(0, 100))
	var random_number = randi() % 100
	if random_number < 60:
		$Neverless.play()
	if random_number > 60:
		$"This Dread".play()
	


func _on_neverless_finished() -> void:
	_ready()


func _on_this_dread_finished() -> void:
	_ready()
