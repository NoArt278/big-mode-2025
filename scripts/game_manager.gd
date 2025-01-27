extends Node

class_name GameManager

@onready var game_timer: Timer = $GameTimer

func game_over() -> void:
	print("Game Over")

func win() -> void:
	pass
