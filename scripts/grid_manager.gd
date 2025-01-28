extends Node

class_name GridManager

var grids: Array[Lever]
var active_count: int = 0
var max_power: int = 100
@onready var game_manager: GameManager = $"../GameManager"
const GRID_LEVER = preload("res://scenes/grid_lever.tscn")

func _ready() -> void:
	start_game()

func start_game() -> void:
	var children = get_children()
	grids.append_array(children)
	print(grids)
	for g in grids :
		g.interacted.connect(distribute_power)
		g.game_over.connect(game_manager.game_over)

func distribute_power(is_on : bool) -> void:
	if is_on :
		active_count += 1
	else :
		active_count -= 1
	var per_grid_power = 0
	if active_count > 0 :
		per_grid_power = max_power / active_count
	for g in grids :
		if g.is_on :
			g.curr_power = per_grid_power
		else : 
			g.curr_power = 0
		g.check_power()
