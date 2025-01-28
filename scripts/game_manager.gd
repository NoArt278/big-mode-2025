extends Node

class_name GameManager

@onready var game_timer: Timer = $GameTimer
@onready var grid_manager: GridManager = $"../GridManager"
@onready var timer_text: Label = $"../HUD/TimerText"
@onready var end_screen: Control = $"../EndScreen"
@onready var end_text: Label = $"../EndScreen/EndText"
@onready var hud: Control = $"../HUD"
@onready var main_menu: Control = $"../MainMenu"

func start_game() -> void:
	end_screen.visible = false
	hud.visible = true
	grid_manager.start_game()
	game_timer.start()

func game_over() -> void:
	end_text.text = "YOU LOSE"
	end_screen.visible = true
	get_tree().paused = true

func win() -> void:
	end_text.text = "YOU WIN"
	end_screen.visible = true
	get_tree().paused = true

func _on_game_timer_timeout() -> void:
	win()

func _process(delta: float) -> void:
	timer_text.text = str(ceil(game_timer.time_left))

func _on_start_btn_pressed() -> void:
	main_menu.visible = false
	start_game()

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	start_game()
