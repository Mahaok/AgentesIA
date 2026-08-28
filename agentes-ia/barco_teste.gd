extends AnimatableBody2D

var barco_ref = null
var player_ref = null
var ativa_navegacao: bool = true
var ativa_retorno: bool = true
var diferenca_posicao: Vector2

@export_category("Objects")
@export var canoa: AnimatableBody2D
@export var textura: Sprite2D

@onready var pin_ilha = $"../../IlhaInimigos/PinIlha"
@onready var pin_desembarque = $"../../IlhaInimigos/PinDesembarque"
@onready var pin_ponte = $"../Ponte/PinPonte"

func _physics_process(delta: float) -> void:
	diferenca_posicao = get_global_mouse_position() - canoa.global_position
	
	navegar()
	desembarque()
	
func navegar() -> void:
	if player_ref and Input.is_action_pressed("navegar"):
		canoa.global_position = canoa.global_position.move_toward(get_global_mouse_position(), 7)#pin_ilha.position,10)
		move_and_collide(canoa.global_position) #teste
		if player_ref and diferenca_posicao.x < 0:
			textura.flip_h = true
		if player_ref and diferenca_posicao.x > 0:
			textura.flip_h = false

func desembarque() -> void:
	if player_ref and barco_ref and Input.is_action_just_pressed("interagir"):
		player_ref.global_position = pin_desembarque.position

func _on_area_barco_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		await get_tree().create_timer(0.2).timeout
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

func _on_embarque_inimigos_body_entered(body: Node2D) -> void:
	barco_ref = body

func _on_area_barcos_body_entered(body: Node2D) -> void:
	barco_ref = null
