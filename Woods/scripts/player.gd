extends KinematicBody2D

const PARTICLES: PackedScene = preload("res://scenes/player/run_particles.tscn")

onready var collision = get_node("AreaAttack/Collision")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var velocity: Vector2
export (int) var Speed = 60

var can_die: bool = false
var can_attack: bool = false

func _physics_process(_delta: float) -> void:
	move()
	attack()
	verify_direction()
	animate()
	

func move() -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("top")
	).normalized()

	velocity = direction * Speed
	velocity = move_and_slide( velocity )


func attack() -> void:
	if Input.is_action_pressed("ui_select") and not can_attack:
		can_attack = true


func animate() -> void:
	if can_die:
		animation.play("dead")
		set_physics_process(false)
	elif can_attack:
		animation.play("attack")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("Idle")


func verify_direction() -> void:
	if velocity.x > 0:
		collision.position = Vector2(20, 8)
		sprite.flip_h = false
	elif velocity.x < 0:
		collision.position = Vector2(-20, 8)
		sprite.flip_h = true


func instance_particles() -> void:
	var particle = PARTICLES.instance()
	get_tree().root.call_deferred("add_child", particle)
	particle.global_position = global_position + Vector2(0, 16)
	particle.play_particle()


func kill() -> void:
	can_die = true


func _on_animation_finished(anim_name):
	if anim_name == "dead":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "attack":
		set_physics_process(true)
		can_attack = false




