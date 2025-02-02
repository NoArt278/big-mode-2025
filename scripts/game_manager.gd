extends Node

class_name GameManager

@onready var game_timer: Timer = $GameTimer
@onready var grid_manager: GridManager = $"../GridManager"
@onready var timer_text: Label = $"../HUD/TimerText"
@onready var day_text: Label = $"../HUD/DayText"
@onready var end_screen: Control = $"../EndScreen"
@onready var end_text: Label = $"../EndScreen/EndText"
@onready var hud: Control = $"../HUD"
@onready var retry_button: Button = $"../EndScreen/RetryButton"
@onready var main_menu: Control = $"../MainMenu"
@onready var generator: Generator = $"../Generator"
@onready var tutorial: Control = $"../Tutorial"
var just_won : bool = false

func _ready() -> void:
	get_tree().paused = true
	generator.upgrade.connect(start_game)

func start_game() -> void:
	just_won = false
	end_screen.visible = false
	day_text.text = "Day " + str(Globals.curr_day)
	hud.visible = true
	if Globals.curr_day > 1 and (Globals.curr_day-1) % 5 == 0 : # Add 30 secs every 5 days
		game_timer.wait_time += 30
	get_tree().paused = false
	grid_manager.start_game()
	game_timer.start()

func game_over() -> void:
	end_text.text = "YOU LOSE"
	retry_button.text = "BACK TO MAIN"
	Globals.curr_day = 1
	end_screen.visible = true
	get_tree().paused = true

func win() -> void:
	end_text.text = "DAY " + str(Globals.curr_day) + " FINISHED"
	retry_button.text = "NEXT DAY"
	Globals.curr_day += 1
	end_screen.visible = true
	just_won = true
	get_tree().paused = true

func _on_game_timer_timeout() -> void:
	win()

func _process(delta: float) -> void:
	timer_text.text = str(ceil(game_timer.time_left))

func _on_start_btn_pressed() -> void:
	main_menu.visible = false
	start_game()

func _on_retry_button_pressed() -> void:
	if just_won :
		end_screen.visible = false
		generator.show_upgrades()
	else :
		get_tree().paused = false
		get_tree().reload_current_scene()

func _on_tutorial_btn_pressed() -> void:
	main_menu.visible = false
	tutorial.visible = true

func _on_back_to_main_pressed() -> void:
	main_menu.visible = true
	tutorial.visible = false
