extends CharacterBody2D
class_name BaseCharacter

var is_dead: bool = false
var can_attack:bool = true
var attack_animation_name: String = ""

@export_category("Variables")
@export var move_speed:float = 128.0
@export var left_attack_name:String = ""
@export var right_attack_name:String = ""
@export var min_attack: int = 1
@export var max_attack: int = 5
@export var health: float

@export_category("Objects")
@export var textura: Sprite2D
@export var animacao: AnimationPlayer
@export var attack_area_collision: CollisionObject2D
@export var display_tomate: Sprite2D
@export var display_melancia: Sprite2D

func _ready() -> void:
	display_melancia.visible = false
	display_tomate.visible = false
	
func _physics_process(delta: float) -> void:
	if Principal.item_atual == "tomate":
		display_tomate.visible = true
		display_melancia.visible = false
	if Principal.item_atual == "melancia":
		display_tomate.visible = false
		display_melancia.visible = true
	if Principal.item_atual == "nada_selecionado":
		display_tomate.visible = false
		display_melancia.visible = false
		
	if is_dead:
		animacao.stop()
		return
	
	print(health)
	move()
	attack()
	animate()
	
func move() -> void:
	var direction:Vector2 = Input.get_vector("left","right","up","down").normalized()
	velocity = direction * move_speed
	move_and_slide()

func animate() -> void:
	if velocity.x > 0:
		textura.flip_h = false
		attack_area_collision.position.x = 64
		
	if velocity.x < 0:
		textura.flip_h = true
		attack_area_collision.position.x = -64
		
	if can_attack == false:
		animacao.play(attack_animation_name)
		return
		
	if velocity:
		animacao.play("andando")
		return
		
	animacao.play("parado")

func attack() -> void:
	if Input.is_action_just_pressed("left_attack") and can_attack:
		can_attack = false
		attack_animation_name = left_attack_name
		set_physics_process(false)

	if Input.is_action_just_pressed("right_attack") and can_attack:
		can_attack = false
		attack_animation_name = right_attack_name
		set_physics_process(false)

func _on_animacao_finished(anim_name: StringName) -> void:
	if anim_name == "attack_axe" or anim_name == "attack_hammer":
		can_attack = true
		set_physics_process(true)
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is PhysicsTree:
		body.update_health([min_attack, max_attack])
	
	if body.is_in_group("enemy"):
		body.update_health()
	
func update_health() -> void:
	health -= 0.1
	if health <= 0:
		is_dead = true
	pass
	
	
