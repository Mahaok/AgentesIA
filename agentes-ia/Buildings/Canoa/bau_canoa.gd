extends CharacterBody2D

var diferenca_posicao: Vector2
var ouro: int

@export_category("Objects")
@export var textura: Sprite2D
@export var bau: CharacterBody2D
@export var colisao: CollisionShape2D

@onready var canoa_teste_2: CharacterBody2D = $".."

func _ready() -> void:
	global_position = canoa_teste_2.global_position + Vector2(90,-19)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("navegar"):
		diferenca_posicao = get_global_mouse_position() - bau.global_position
		if diferenca_posicao.x <= 0:
			textura.flip_h = true
			global_position = canoa_teste_2.global_position + Vector2(90,-19)
			colisao.global_position = canoa_teste_2.global_position + Vector2(90,-19)
		if diferenca_posicao.x > 0:
			textura.flip_h = false
			global_position = canoa_teste_2.global_position + Vector2(-90,-19)
			colisao.global_position = canoa_teste_2.global_position + Vector2(-80,-19)
	

func _on_area_bau_body_entered(body: Node2D) -> void:
	ouro += Dados.ouro
	Dados.ouro = 0
	print(ouro)
	
