extends StaticBody2D

var random_speed: float = randf_range(0.5,0.8)

@export_category("Objects")
@export var textura: AnimatedSprite2D

func _ready() -> void:
	textura.play("",random_speed)
