extends TileMapLayer
class_name Ponte

var player_ref = null
var barco_ref = null

func _process(delta: float) -> void:
	if player_ref != null and barco_ref != null and Input.is_action_just_pressed("interagir"):
		player_ref.global_position = barco_ref.global_position

func _on_area_embarque_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body

func _on_area_embarque_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = null

func _on_entrada_ponte_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		await get_tree().create_timer(0.2).timeout
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)


func _on_entrada_ponte_body_exited(body: Node2D) -> void:
	#if body.is_in_group("character"):
		#await get_tree().create_timer(0.2).timeout
		#body.set_collision_layer_value(1, true)
		#body.set_collision_layer_value(2, false)
		#body.set_collision_mask_value(1, true)
		#body.set_collision_mask_value(2, false)
	pass

func _on_area_barcos_body_entered(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_ref = body

func _on_area_barcos_body_exited(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_ref = null
