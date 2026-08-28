extends Area2D
class_name Semente

var perto_do_item: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		perto_do_item = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		perto_do_item = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interagir") and perto_do_item == true:
		Dados.semente_tomate += 1
		queue_free()
