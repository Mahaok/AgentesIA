extends Area2D

var player_ref = null
var barco_in_ilha = null

func _physics_process(delta: float) -> void:
	embarque()

func embarque() -> void:
	if player_ref != null and Input.is_action_just_pressed("interagir") and barco_in_ilha != null:
		player_ref.global_position = barco_in_ilha.global_position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = null

func _on_area_barcos_inimigos_body_entered(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ilha = body

func _on_area_barcos_inimigos_body_exited(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ilha = null


func _on_entrada_ponte_inimigos_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		#await get_tree().create_timer(0.1).timeout
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)


func _on_entrada_ponte_inimigos_body_exited(body: Node2D) -> void:
	#if body.is_in_group("character"):
		#body.set_collision_layer_value(1, true)
		#body.set_collision_layer_value(2, false)
		#body.set_collision_mask_value(1, true)
		#body.set_collision_mask_value(2, false)
	pass
