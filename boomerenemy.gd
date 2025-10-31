extends CharacterBody3D


@onready var animated_sprite_3d = $AnimatedSprite3D

@export var move_speed = 2.5
@export var attack_range = 1.8

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead = false
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	if not is_on_floor():
		velocity.y -= 9 * delta
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	move_and_slide()
	attempt_to_kill_player()

func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		player.take_damage(8)

func kill():
	$CollisionShape3D.disabled = true
	dead = true
	$DeathSound.play()
	animated_sprite_3d.play("death")
	#$CollisionShape3D.disabled = true
	$".".add_child(instance)
	$Timer.start()
	
#Code to spawn health pickup
var healthspawn = preload("res://Medipak.tscn")
var instance = healthspawn.instantiate()

func _on_timer_timeout() -> void:
	queue_free()

#Attempt at trying to randomize health spawns below:
#func _ready():
	#rng.randomize()
	#print(rng.randi_range(0, 100))
	#var random_number = randi() % 100
	#if random_number > 90:
		#$".".add_child(instance)


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_animated_sprite_3d_animation_finished(death) -> void:
	$AnimatedSprite3D.visible = false
