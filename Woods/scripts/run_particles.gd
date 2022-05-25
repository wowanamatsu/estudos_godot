extends AnimatedSprite


func play_particle() -> void:
	play()

func _on_animation_finished() -> void:
	queue_free()
