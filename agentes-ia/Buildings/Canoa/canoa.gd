extends StaticBody2D
class_name Barco

var player_ref = null

@export_category("Objects")
@export var canoa: StaticBody2D
@onready var pin_ilha = $"../../IlhaInimigos/PinIlha"
@onready var pin_desembarque = $"../../IlhaInimigos/PinDesembarque"

func _process(delta: float) -> void:
	navegar()
	desembarque()
	
func navegar() -> void: 
	if player_ref:# and Input.is_action_just_pressed("navegar"):
		canoa.global_position = canoa.global_position.move_toward(pin_ilha.position,10)
		pass
		
func desembarque() -> void:
	if player_ref and Input.is_action_just_pressed("interagir") and canoa.global_position == pin_ilha.position:
		player_ref.global_position = pin_desembarque.position

func _on_area_barco_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)

func _on_area_barco_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.set_collision_layer_value(1, true)
		body.set_collision_layer_value(2, false)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, false)
		player_ref = null
