extends KinematicBody2D

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

var player_ref = null
var velocity: Vector2

var can_die: bool = false

export (int) var speed = 60

func _physics_process(_delta: float) -> void:
	move()
	animate()
	verify_direction()
	
	
func move() -> void:
	if player_ref != null:
		var distance: Vector2 =  player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var distance_length: float = distance.length()
		
		if distance_length <= 5:
			player_ref.kill()
			velocity = Vector2.ZERO
		else:
			velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(velocity)


func animate() -> void:
	if can_die:
		animation.play("dead")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("walk")
	else:
		animation.play("idle")


func verify_direction() -> void:
	if velocity.x >= 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null


func kill(area) -> void:
	if area.is_in_group("player_attack"):
		can_die = true


func _on_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()
