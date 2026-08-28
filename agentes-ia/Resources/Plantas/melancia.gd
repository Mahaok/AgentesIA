extends Area2D
class_name Melancia

var itens: = ["tomate", "melancia"]
var index: = 0
var item_atual: = ""

var pode_colher: bool = false
var perto_tomate: bool = false

@export_category("Objects")
@export var textura: Sprite2D
@export var animacao: AnimationPlayer

func _ready() -> void:
	textura.frame = 35
	await get_tree().create_timer(10.0).timeout
	textura.frame = 34
	await get_tree().create_timer(10.0).timeout
	textura.frame = 33
	await get_tree().create_timer(10.0).timeout
	textura.frame = 32
	await get_tree().create_timer(10.0).timeout
	textura.frame = 31
	await get_tree().create_timer(10.0).timeout
	pode_colher = true
	textura.frame = 30
	
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
