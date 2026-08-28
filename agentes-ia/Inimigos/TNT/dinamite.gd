extends Area2D

var direction: Vector2
var distance: float
var player_ref = null
var tnt_ref = null

@export_category("Variables")
@export var bomba_speed: float = 200.0
@export var stop_distance: float = 200

@export_category("Objects")
@export var dinamite: Sprite2D
@export var explosao: Sprite2D
@export var anima: AnimationPlayer
@export var tempo: Timer
@export var area_detonacao: Area2D

func _ready() -> void:
	dinamite.visible = false
	explosao.visible = false
	await get_tree().create_timer(0.1).timeout
	dinamite.visible = true

func _physics_process(delta: float) -> void:
	if player_ref != null:
		distance = global_position.distance_to(player_ref.global_position)
		position += direction * 5.0
	animate()

func animate() -> void:
	anima.play("dinamite")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		direction = global_position.direction_to(player_ref.global_position).normalized()
		await get_tree().create_timer(1.0).timeout
		dinamite.visible = false
		explosao.visible = true
		set_physics_process(false)
		anima.play("explodindo")

func _on_area_detonacao_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") or body.is_in_group("animais"):
		dinamite.visible = false
		explosao.visible = true
		set_physics_process(false)
		anima.play("explodindo")
		body.update_health()

func _on_animacao_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explodindo":
		queue_free() 
