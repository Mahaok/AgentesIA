extends StaticBody2D

var diferenca_posicao: Vector2

@export_category("Objects")
@export var vela: StaticBody2D
@export var textura: Sprite2D

@onready var canoa_teste_2: CharacterBody2D = $"../../Porto/Porto/CanoaTeste2"

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("navegar"):
		global_position = canoa_teste_2.global_position
		diferenca_posicao = get_global_mouse_position() - vela.global_position
		if diferenca_posicao.x < -20:
			textura.flip_h = true
		if diferenca_posicao.x > 20:
			textura.flip_h = false
			global_position = canoa_teste_2.global_position + Vector2(30,0)
