extends Node

class_name GridManager

var grids: Array[Lever]
var pos_list: Array[Node2D]
var grid_count: int = 5
var active_count: int = 0
var max_power: int = 100
var pow_increase: int = 50
@onready var game_manager: GameManager = $"../GameManager"
@onready var generator: Generator = $"../Generator"
const GRID_LEVER = preload("res://scenes/grid_lever.tscn")

func _ready() -> void:
	pos_list.append_array(get_children())
	generator.generator.connect(change_max_pow)

func start_game() -> void:
	if grids.size() > 0 :
		for g in grids :
			g.queue_free()
		grids.clear()
	generator.reset()
	active_count = 0
	for i in grid_count :
		var g = GRID_LEVER.instantiate()
		pos_list[i].add_child(g)
		g.position = Vector2.ZERO
		g.interacted.connect(switch_lever)
		g.game_over.connect(game_manager.game_over)
		grids.append(g)

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
