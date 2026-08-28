extends Area2D
class_name Tomate

var pode_colher: bool = false
var perto_tomate: bool = false

@export_category("Objects")
@export var textura: Sprite2D
@export var animacao: AnimationPlayer

func _ready() -> void:
	textura.frame = 29
	await get_tree().create_timer(10.0).timeout
	textura.frame = 28
	await get_tree().create_timer(10.0).timeout
	textura.frame = 27
	await get_tree().create_timer(10.0).timeout
	textura.frame = 26
	await get_tree().create_timer(10.0).timeout
	textura.frame = 25
	await get_tree().create_timer(10.0).timeout
	pode_colher = true
	textura.frame = 24
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("colher") and pode_colher == true and perto_tomate == true:
		Dados.semente_tomate += 2
		Dados.tomates += 1
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		Dados.por_cima_da_planta = true
		pode_colher = true
		perto_tomate = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		Dados.por_cima_da_planta = false
		pode_colher = false
		perto_tomate = false
