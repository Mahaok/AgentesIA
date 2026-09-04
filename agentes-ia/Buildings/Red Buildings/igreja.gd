extends StaticBody2D

var player_ref = null

@export_category("Objects")
@export var camera: Camera2D

@onready var pin_entrada_igreja: Marker2D = $"../../../Interior/Igreja/PinEntradaIgreja"
@onready var pin_saida_igreja: Marker2D = $"../../../Interior/Igreja/PinSaidaIgreja"
@onready var camera_personagem: Camera2D = $"../../PeaoTeste/CameraPersonagem"


func _on_entrada_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		player_ref.global_position = pin_entrada_igreja.global_position
		camera.make_current()

func _on_saida_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		player_ref.global_position = pin_saida_igreja.global_position
		camera_personagem.make_current()
