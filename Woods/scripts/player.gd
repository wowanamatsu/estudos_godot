extends KinematicBody2D

var velocity: Vector2
export (int) var Speed = 60

onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")

func _physics_process(_delta: float) -> void:
	move()
	verify_direction()
	animate()
	

func move() -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("top")
	).normalized()

	velocity = direction * Speed
	velocity = move_and_slide( velocity )


func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("Idle")


func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
