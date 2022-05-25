extends KinematicBody2D

var player_ref = null
var velocity: Vector2

export (int) var speed = 60

func _physics_process(_delta: float) -> void:
	if player_ref != null:
		var distance: Vector2 =  player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		
		velocity = direction * speed
		velocity = move_and_slide(velocity)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body


func _on_body_exited(body):
	if body.is_in_group("plaier"):
		player_ref = null
