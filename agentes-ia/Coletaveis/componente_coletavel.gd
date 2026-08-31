extends Area2D
class_name ComponenteColetavel


func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		queue_free()
