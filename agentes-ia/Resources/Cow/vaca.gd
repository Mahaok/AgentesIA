extends CharacterBody2D
class_name Vaca

var player_ref = null

var wait_time: float
var direction: Vector2
var distance: float

@export_category("Variables")
@export var move_speed:float = 96.0
@export var chase_speed: float = 140.0

@export_category("Objects")
@export var animated_sprite:AnimatedSprite2D
@export var walk_timer: Timer
@export var area_deteccao: Area2D

func _on_area_deteccao_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") or body.is_in_group("enemy"):
		player_ref = body
		walk_timer.stop() # Para o timer aleatório para focar em seguir o player

func _on_area_deteccao_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = null
		velocity = Vector2.ZERO
		wait_time = randf_range(5.0, 10.0)
		direction = get_direction()
		walk_timer.start(wait_time) # Reinicia o comportamento aleatório

func _ready() -> void:
	wait_time = randf_range(5.0, 10.0)
	direction = get_direction()
	walk_timer.start(wait_time)

func _physics_process(delta: float) -> void:
	if player_ref != null:
		# Se o player foi detectado, persegue ele
		direction = -global_position.direction_to(player_ref.global_position)
		distance = global_position.distance_to(player_ref.global_position)
		velocity = direction * chase_speed
	else:
		# Movimento aleatório normal
		velocity = direction * move_speed
		
		# Verifica colisão apenas no modo aleatório
		if get_slide_collision_count() > 0:
			var collision = get_slide_collision(0)
			# Faz o bounce diretamente na velocidade
			velocity = velocity.bounce(collision.get_normal())
			# Atualiza a direção com base no novo vetor de velocidade para manter a coerência
			direction = velocity.normalized()
	
	move_and_slide()
	animate()
	
func animate() -> void:
	if velocity.x > 0:
		animated_sprite.flip_h = false
	if velocity.x < 0:
		animated_sprite.flip_h = true
	if velocity:
		animated_sprite.play("walk")
		return
	
	animated_sprite.play("idle")

func get_direction() -> Vector2:
	return [
		Vector2(-1, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2.ZERO
	].pick_random().normalized()

func _on_walk_time_timeout() -> void:
	walk_timer.start(wait_time)
	if direction == Vector2.ZERO:
		direction = get_direction()
		return
		
	direction = Vector2.ZERO
