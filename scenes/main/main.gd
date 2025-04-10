extends Control


func start_game(size: Global.GridSize) -> void:
	Global.set_grid_size(size)
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_small_size_button_pressed() -> void:
	start_game(Global.GridSize.SMALL)


func _on_mid_size_button_pressed() -> void:
	start_game(Global.GridSize.MID)


func _on_big_size_button_pressed() -> void:
	start_game(Global.GridSize.BIG)
