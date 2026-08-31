extends StaticBody2D

@export_category("Variables")
@export var escala: Vector2

@export_category("Objects")
@export var textura: StaticBody2D

func _ready() -> void:
	var x = randf_range(2, 7)
	escala = Vector2(x,x)
	textura.global_scale = escala
