extends StaticBody2D

var minerio_ouro = preload("res://Resources/Gold/minerio_ouro.tscn")

var player_ref = null

@export_category("Objects")
@export var textura: AnimatedSprite2D
@export var colisao: CollisionShape2D

func _on_area_encontro_body_entered(body: Node2D) -> void:
	textura.play("shine")
	if body.is_in_group("character"):
		player_ref = body

func _on_area_mineracao_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref.can_mine = true

func update_health() -> void:
	textura.visible = false
	colisao.set_deferred("disabled", true)
	await get_tree().create_timer(20.0).timeout
	textura.visible = true
	colisao.set_deferred("disabled", false)
