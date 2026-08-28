extends CharacterBody2D
class_name TNT

var tnt = preload("res://Inimigos/TNT/dinamite.tscn")

var direction: Vector2 = Vector2.ZERO
var distance: float
var wait_time: float

var is_dead: bool = false
var player_ref = null

var can_attack:bool = true

@export_category("Variables")
@export var move_speed: float = 32.0
@export var chase_speed: float = 64.0

@export_category("Objects")
@export var goblin_tnt: Sprite2D
@export var morto: Sprite2D
@export var anima: AnimationPlayer
@export var walk_timer: Timer
@export var bomba_timer: Timer

func _ready() -> void:
	morto.visible = false
	wait_time = randf_range(2.0, 5.0)
	direction = get_direction()
	walk_timer.start(wait_time)

func _on_area_deteccao_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = body
		walk_timer.stop() # Para o timer aleatório para focar em seguir o player
		bomba_timer.start()
		attack()

func _on_area_deteccao_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		player_ref = null
		velocity = Vector2.ZERO
		wait_time = randf_range(2.0, 5.0)
		direction = get_direction()
		walk_timer.start(wait_time) # Reinicia o comportamento aleatório
		bomba_timer.stop()

func _physics_process(delta: float) -> void:
	if is_dead:
		goblin_tnt.visible = false
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

func attack() -> void:
	if is_dead:
		return
	if can_attack:
		can_attack = false
		anima.play("jogando")
		var bomba = tnt.instantiate()
		add_child(bomba)
		set_physics_process(false)

func animate() -> void:
	if velocity.x > 0:
		goblin_tnt.flip_h = false

	if velocity.x < 0:
		goblin_tnt.flip_h = true

	if velocity:
		anima.play("walk")
		return

	anima.play("idle")

func update_health() -> void:
	if is_dead:
		return # Evita rodar a morte mais de uma vez se tomar múltiplos hits
	is_dead = true
	velocity = Vector2.ZERO
	# Garante que a física será reativada para o queue_free() funcionar perfeitamente no final da animação
	set_physics_process(true)
	# Toca a animação de morte imediatamente, interrompendo qualquer outra (como o ataque)
	anima.play("morreu")

func get_direction() -> Vector2:
		return [
			Vector2(-1, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(1, -1),
			Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2.ZERO
		].pick_random().normalized()

func _on_animacao_animation_finished(anim_name: StringName) -> void:
	if anim_name == "morreu":
		queue_free()
	if anim_name == "jogando":
		can_attack = true
		anima.play("idle")
		await get_tree().create_timer(1.2).timeout
		set_physics_process(true)

func _on_timer_timeout() -> void:
	# Só altera o movimento aleatório se o player NÃO estiver sendo seguido
	if player_ref == null:
		if direction == Vector2.ZERO:
			direction = get_direction()
		else:
			direction = Vector2.ZERO
			
		wait_time = randf_range(2.0, 5.0)
		walk_timer.start(wait_time)

func _on_tempo_bomba_timeout() -> void:
	attack()
	bomba_timer.start()
