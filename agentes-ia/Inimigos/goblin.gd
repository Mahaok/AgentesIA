extends CharacterBody2D
class_name Goblin

var direction: Vector2 = Vector2.ZERO
var distance: float
var wait_time: float

var is_dead: bool = false
var player_ref = null

var can_attack:bool = true

@export_category("Variables")
@export var move_speed: float = 120.0
@export var chase_speed: float = 180.0

@export_category("Objects")
@export var sprite: Sprite2D
@export var morto: Sprite2D
@export var anima: AnimationPlayer
@export var area_ataque: Area2D
@export var area_deteccao: Area2D
@export var walk_timer: Timer

func _ready() -> void:
	morto.visible = false
	wait_time = randf_range(2.0, 5.0)
	direction = get_direction()
	walk_timer.start(wait_time)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") or body.is_in_group("aliado"):
		player_ref = body
		walk_timer.stop() # Para o timer aleatório para focar em seguir o player

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("character") or body.is_in_group("aliado"):
		player_ref = null
		velocity = Vector2.ZERO
		wait_time = randf_range(2.0, 5.0)
		direction = get_direction()
		walk_timer.start(wait_time) # Reinicia o comportamento aleatório

func _physics_process(delta: float) -> void:	
	if is_dead:
		sprite.visible = false
		morto.visible = true
		return
	
	if player_ref != null:
		# Se o player foi detectado, persegue ele
		direction = global_position.direction_to(player_ref.global_position)
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
	attack()
	
func animate() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		area_ataque.position.x = 64
		
	if velocity.x < 0:
		sprite.flip_h = true
		area_ataque.position.x = -64
		
	if velocity:
		anima.play("walk")
		return
	
	anima.play("idle")

func attack() -> void:
	# Se estiver morto, nem tenta atacar
	if is_dead:
		return
	if distance <= 64 and distance != 0 and player_ref != null:
		can_attack = false
		anima.play("attack")
		set_physics_process(false)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") or body.is_in_group("enemy") or body.is_in_group("aliado"):
		body.update_health()

func update_health() -> void:
	if is_dead:
		return # Evita rodar a morte mais de uma vez se tomar múltiplos hits
	is_dead = true
	velocity = Vector2.ZERO
	# Garante que a física será reativada para o queue_free() funcionar perfeitamente no final da animação
	set_physics_process(true)
	# Toca a animação de morte imediatamente, interrompendo qualquer outra (como o ataque)
	anima.play("death")

func _on_animacao_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
	elif anim_name == "attack":
		# Só libera o ataque se ele NÃO estiver morto
		if not is_dead:
			can_attack = true
			set_physics_process(true)

func get_direction() -> Vector2:
		return [
			Vector2(-1, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(1, -1),
			Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2.ZERO
		].pick_random().normalized()

func _on_walk_timer_timeout() -> void:
	# Só altera o movimento aleatório se o player NÃO estiver sendo seguido
	if player_ref == null:
		if direction == Vector2.ZERO:
			direction = get_direction()
		else:
			direction = Vector2.ZERO
			
		wait_time = randf_range(2.0, 5.0)
		walk_timer.start(wait_time)
