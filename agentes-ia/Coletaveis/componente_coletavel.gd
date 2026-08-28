extends Area2D
class_name ComponenteColetavel


func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		#body.add_item({
			#"item_name": "madeira", 
			#"item_amount": [1, 5], 
			#"item_texture": "res://Resources/Resources/W_Idle.png"
		#})
			
		queue_free()
