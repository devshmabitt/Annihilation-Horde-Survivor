extends Panel
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")


var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta) -> void:
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d :" % minutes
	$Seconds.text = "%02d." % seconds
	if $"../CanvasLayer/DeathScreen".visible == true:
		_stop()



func _stop() -> void:
	set_process(false)


func get_time_formatted() -> String:
	return "%02d : %02d." % [minutes, seconds]
