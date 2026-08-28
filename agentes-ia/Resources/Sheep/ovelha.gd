extends CharacterBody2D
class_name Ovelha

var wait_time: float
var direction: Vector2

@export_category("Variables")
@export var move_speed:float = 128.0

@export_category("Objects")
@export var sprite: Sprite2D
@export var animacao: AnimationPlayer
@export var walk_timer: Timer

func _ready() -> void:
	wait_time = randf_range(5.0, 15.0)
	direction = get_direction()
	walk_timer.start(wait_time)

func _physics_process(delta: float) -> void:
	velocity = direction * move_speed
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		direction = velocity.bounce(
			get_slide_collision(0).get_normal()
		).normalized()
	
	animate()
	
func animate() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity:
		animacao.play("andando")
		return
	
	animacao.play("parada")
	
	
func get_direction() -> Vector2:
	return [
		Vector2(-1, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2.ZERO
	].pick_random().normalized()


func _on_walktimer_timeout() -> void:
	walk_timer.start(wait_time)
	if direction == Vector2.ZERO:
		direction = get_direction()
		return
		
	direction = Vector2.ZERO
	
func update_health() -> void:
	move_speed = 500.0
	await get_tree().create_timer(0.5).timeout
	move_speed = 128.0
