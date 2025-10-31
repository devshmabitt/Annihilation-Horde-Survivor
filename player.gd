extends CharacterBody3D
class_name Player


@onready var animated_sprite_2d = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray_cast_3d = $RayCast3D
@onready var shoot_sound = $ShootSound
@onready var punch_ray_cast_3d = $"Punch Raycast"


var enemyspawn = preload("res://enemy.tscn")
var boomerspawn = preload("res://Boomerenemy.tscn")
var sprinterspawn = preload("res://Sprinterenemy.tscn")
var impspawn = preload("res://impenemy.tscn")
var witchspawn = preload("res://witchenemy.tscn")
var healspawn = preload("res://healspirit.tscn")

const SPEED = 6.25
const MOUSE_SENS = 0.35
const JUMP_VELOCITY = 3.5

var can_shoot = true
var dead = false
var health = 100
var can_punch = true




func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)
	


func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		rotation_degrees.x -= event.relative.y * MOUSE_SENS

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	
	if dead:
		return
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_pressed("Heal"):
		heal_damage(5)
	if Input.is_action_pressed("punch"):
		punch()
		can_punch = false
		$"Punch Cooldown".start()
		$CanvasLayer/Punch/HandAnims.play("Punch")
		$PunchCooldownBar.value = 0
		$CanvasLayer/Punch.visible = false
		


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 9 * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if dead:
		return
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if dead == true:
		kill()
	if Input.is_anything_pressed():
		$AnimationPlayer.play("Gun Sway")
	move_and_slide()

	

func restart():
	get_tree().reload_current_scene()

func shoot():
	if !can_shoot:
		return
	can_shoot = false
	animated_sprite_2d.play("Holy Shotgun Shoot")
	shoot_sound.play()
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()

func punch():
	if !can_punch:
		return
	if punch_ray_cast_3d.is_colliding() and punch_ray_cast_3d.get_collider().has_method("kill"):
		punch_ray_cast_3d.get_collider().kill()
		heal_damage(7)

func shoot_anim_done():
	can_shoot = true

func kill():
	if $"CanvasLayer/GunBase/HealthBar 3D".value == 0:
		dead = true
		$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE





func _on_enemytimeout_timeout() -> void:
	var instance = enemyspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = -4


func _on_boomertimeout_timeout() -> void:
	var instance = boomerspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 10



func _on_sprinterspawn_timeout() -> void:
	var instance = sprinterspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 5
	
	

func take_damage(damage):
	var healthbar = $"CanvasLayer/GunBase/HealthBar 3D"
	healthbar.value -= damage
	if healthbar.value <= 0:
		kill()

func heal_damage(heal):
	var healthbar = $"CanvasLayer/GunBase/HealthBar 3D"
	healthbar.value += heal 


func _on_punch_cooldown_timeout() -> void:
	can_punch = true
	$PunchCooldownBar.value = 100
	$CanvasLayer/Punch/HandAnims.active = true


func _on_hand_anims_animation_finished(punch: StringName) -> void:
	if !can_punch:
		$CanvasLayer/Punch/HandAnims.active = false
	else:
		$CanvasLayer/Punch/HandAnims.active = true


func _on_horde_2_timer_timeout() -> void:
	var instance = impspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = -2
	$"../Impspawn".start()




func _on_horde_1_timer_timeout() -> void:
	var instance = boomerspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 10
	$"../boomertimeout".start()



func _on_horde_1_5_timer_timeout() -> void:
	var instance = sprinterspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 5
	$"../sprinterspawn".start()


func _on_horde_3_timer_timeout() -> void:
	var instance = witchspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 2
	$"../witchspawntimer".start()


func _on_witchspawntimer_timeout() -> void:
	var instance = witchspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 9


func _on_healspirittimer_timeout() -> void:
	var instance = healspawn.instantiate()
	$"..".add_child(instance)
	instance.position.z = 2
