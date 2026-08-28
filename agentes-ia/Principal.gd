extends Node2D

#Para mudar o item de plantar
var itens: = ["tomate", "melancia", "nada_selecionado"]
var index: = 0
var item_atual: = ""

var pode_colher: bool = false

@export_category("Objects")
@export var fazendeiro: CharacterBody2D
@export var area_plantio: Area2D

var tomate = preload("res://Resources/Plantas/tomate.tscn")
var grid_size:int = 64
var pode_plantar: bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("plantar") and Dados.semente_tomate >= 1 and pode_plantar == true and Dados.por_cima_da_planta == false:
		Dados.semente_tomate -= 1
		var instance_tomate = tomate.instantiate()
		$ordem_de_colisoes.add_child(instance_tomate)
		instance_tomate.position = fazendeiro.position.snapped(Vector2(grid_size, grid_size))
#muda o valor da cena
	if Input.is_action_just_pressed("mudar_item"):
		index = (index +1) % itens.size()
		item_atual = itens[index]
		if item_atual == "tomate":
			tomate = preload("res://Resources/Plantas/tomate.tscn")
		if item_atual == "melancia":
			tomate = preload("res://Resources/Plantas/melancia.tscn")
		if item_atual == "nada_selecionado":
			return
		
func _on_area_plantio_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		pode_plantar = true


func _on_area_plantio_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		pode_plantar = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reseta"):
		get_tree().reload_current_scene()
