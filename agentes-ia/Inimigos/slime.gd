extends CharacterBody2D
class_name Slime

var is_dead: bool = false
var player_ref = null

@export_category("Objects")
@export var texture: Sprite2D
@export var animation: AnimationPlayer
@export var colisao: CollisionShape2D

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = null
		velocity = Vector2.ZERO
		
func _physics_process(delta: float) -> void:
	if is_dead:
		colisao.disabled = true
		return
	
	animate()
	if player_ref != null:

		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)

		velocity = direction * 120
		move_and_slide()
		
	move_and_slide()
	
func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
	if velocity.x < 0:
		texture.flip_h = true
	if velocity:
		animation.play("walk")
		return
	
	animation.play("idle")
		

func update_health() -> void:
	is_dead = true
	animation.play("death")

func _on_animacao_animation_finished(anim_name: StringName) -> void:
	queue_free()
