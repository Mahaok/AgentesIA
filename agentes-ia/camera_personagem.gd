extends Camera2D

@export_category("Variables")
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5   # Máximo de afastamento
@export var max_zoom: float = 3.0   # Máximo de aproximação


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		set_zoom_level(-zoom_speed)

func set_zoom_level(delta: float) -> void:
	# Calcula o novo valor somando o delta nos eixos X e Y
	var new_zoom: Vector2 = zoom + Vector2(delta, delta)
	
	# Limita o zoom para não afastar ou aproximar infinitamente
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	zoom = new_zoom
