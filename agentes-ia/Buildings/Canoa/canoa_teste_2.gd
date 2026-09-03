extends CharacterBody2D

var barco_in_ilha = null
var barco_in_ponte = null

var player_ref = null
var diferenca_posicao: Vector2

@export_category("Objects")
@export var canoa: CharacterBody2D
@export var textura: Sprite2D

@onready var pin_porto_inimigos = $"../PinPortoInimigos"
@onready var pin_porto_aliados = $"../PinPortoAliados"

func _physics_process(delta: float) -> void:
	diferenca_posicao = get_global_mouse_position() - canoa.global_position
	print(diferenca_posicao)
	navegar()
	desembarque()
	
func navegar() -> void:
	if player_ref and Input.is_action_pressed("navegar"):
		canoa.global_position = canoa.global_position.move_toward(get_global_mouse_position(), 7)
		player_ref.global_position = canoa.global_position
		move_and_slide()
		if player_ref and diferenca_posicao.x < -20:
			textura.flip_h = true
		if player_ref and diferenca_posicao.x > 20:
			textura.flip_h = false
			
func desembarque() -> void:
	if player_ref and barco_in_ilha and Input.is_action_just_pressed("interagir"):
		player_ref.global_position = pin_porto_inimigos.position
	if player_ref and barco_in_ponte and Input.is_action_just_pressed("interagir"):
		player_ref.global_position = pin_porto_aliados.position

func _on_area_barco_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)

func _on_area_barco_body_exited(body: Node2D) -> void:
		player_ref = null

func _on_area_barcos_body_entered(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ponte = body

func _on_area_barcos_body_exited(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ponte = null

func _on_area_barcos_inimigos_body_entered(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ilha = body


func _on_area_barcos_inimigos_body_exited(body: Node2D) -> void:
	if body.is_in_group("barco"):
		barco_in_ilha = null
