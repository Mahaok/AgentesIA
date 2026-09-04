extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Dados.ouro += 1
	print(Dados.ouro)
	queue_free()
