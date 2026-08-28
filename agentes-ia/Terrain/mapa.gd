extends Node2D

func _on_area_camada_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.set_collision_layer_value(1, true)
		body.set_collision_layer_value(2, false)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, false)
