extends StaticBody2D

var ouro_cena = preload("res://Resources/Gold/ouro.tscn")

var player_ref = null
var x = 20.0

@export_category("Variables")
@export var health: float = 5.0

@export_category("Objects")
@export var minerio_ouro: StaticBody2D
@export var textura: AnimatedSprite2D
@export var colisao: CollisionPolygon2D

func _ready() -> void:
	textura.animation = "meteoro"
	health = health * x
	minerio_ouro.scale = Vector2(x,x)

func _on_area_encontro_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		textura.play()

func _on_area_mineracao_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref.can_mine = true

func update_health() -> void:
	health -= 1.0
	if health <= 0:
		spawn_gold()
		textura.visible = false
		colisao.set_deferred("disabled", true)
		
		await get_tree().create_timer(20.0*x).timeout
		health = 5.0 * x
		textura.visible = true
		colisao.set_deferred("disabled", false)
		
func spawn_gold() -> void:
	var gold_amount: int = randi_range((1*100), (3*100))
	for i in gold_amount:
		var gold = ouro_cena.instantiate()
		gold.global_position = global_position + Vector2(randi_range(-256, 256), randi_range(-256, 256))
		get_tree().root.call_deferred("add_child", gold)
