extends Node


var grid_width: int = 4
var grid_height: int = 4

# Usado luego de seleccionar dos cartas
var selection_enabled: bool = true

enum GridSize {SMALL, MID, BIG}

func set_grid_size(size: GridSize) -> void:
	match size:
		GridSize.SMALL: # 16
			grid_width = 4
			grid_height = 4
		GridSize.MID: # 32
			grid_width = 8
			grid_height = 4
		GridSize.BIG: # 48
			grid_width = 8
			grid_height = 6
