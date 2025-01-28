extends Node

class_name GridManager

var grids: Array[Lever]
var active_count: int = 0
var max_power: int = 100
var pow_increase: int = 50
@onready var game_manager: GameManager = $"../GameManager"
@onready var generator: Generator = $"../Generator"
const GRID_LEVER = preload("res://scenes/grid_lever.tscn")

func _ready() -> void:
	start_game()

func start_game() -> void:
	var children = get_children()
	grids.append_array(children)
	for g in grids :
		g.interacted.connect(switch_lever)
		g.game_over.connect(game_manager.game_over)
	generator.generator.connect(change_max_pow)

func change_max_pow(is_on: bool) -> void:
	if is_on :
		max_power += pow_increase
	else :
		max_power = 100
	distribute_power()

func switch_lever(is_on: bool) -> void:
	if is_on :
		active_count += 1
	else :
		active_count -= 1
	distribute_power()

func distribute_power() -> void:
	var per_grid_power = 0
	if active_count > 0 :
		per_grid_power = max_power / active_count
	for g in grids :
		if g.is_on :
			g.curr_power = per_grid_power
		else : 
			g.curr_power = 0
		g.check_power()
