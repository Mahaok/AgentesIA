extends CanvasLayer

@export_category("Display")
@export var display_sementes: Label
@export var display_tomates: Label

func _process(delta: float) -> void:
	display_sementes.text = str("Sementes de Tomates: ", Dados.semente_tomate)
	display_tomates.text = str("Tomates: ", Dados.tomates)
