extends StaticBody2D
class_name PhysicsTree

var random_speed: float = randf_range(0.5,0.8)

var arvore = preload("res://Resources/Trees/arvore_unica.tscn")

const WOOD_COLETAVEL: PackedScene = preload ("res://Coletaveis/wood.tscn")

var is_dead: bool = false

@export_category("Variables")
@export var health:int
@export var min_health: int = 10
@export var max_health: int = 30
@export var min_wood: int = 1
@export var max_wood: int = 5


@export_category("Objects")
@export var anima: AnimationPlayer
@export var respawn_timer: Timer

func _ready() -> void:
	health = randi_range(min_health, max_health)
	anima.play("",-1.0,random_speed)
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("reseta"):
		#destroy()
		#respawn()
		
func destroy() -> void:
	for child in get_children():
		child.queue_free()
	#if self.get_child_count() > 0:
		#self.get_child(0).queue_free()

func respawn() -> void:
	await get_tree().create_timer(5.0).timeout
	var nova_arvore = arvore.instantiate()
	add_child(nova_arvore)
	#var arvore_instance = arvore.instantiate()
	#self.add_child(arvore_instance)

func update_health(damage_range: Array) -> void: #[1, 5]
	#if is_dead:
		#return
		
	health -= randi_range(
		damage_range[0],
		damage_range[1]
	)
	
	if health <= 0:
		spawn_wood()
		is_dead = true
		anima.play("kill")
		destroy()
		respawn()
		return
		
	anima.play("hit")
		
func spawn_wood() -> void:
	var wood_amount: int = randi_range(min_wood, max_wood)
	for i in wood_amount:
		var wood: ComponenteColetavel = WOOD_COLETAVEL.instantiate()
		wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", wood)
		
func _on_animacao_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		anima.play("idle")
