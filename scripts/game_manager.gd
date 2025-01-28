extends Node

class_name GameManager

@onready var game_timer: Timer = $GameTimer
@onready var grid_manager: GridManager = $"../GridManager"

func start_game() -> void:
	grid_manager.start_game()

func game_over() -> void:
	print("Game Over")

func win() -> void:
	pass
