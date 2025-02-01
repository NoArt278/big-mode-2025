extends Interactable

class_name Lever

var power_req : float = 0
var curr_power : float = 0
var is_on : bool
var req_time: float = 5
var tol_time: float = 20
@onready var power_req_timer: Timer = $PowerReqTimer
@onready var tolerance_timer: Timer = $ToleranceTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var power_req_label: Label = $PowerReqLabel
@onready var curr_pow_label: Label = $CurrPowLabel
@onready var tolerance_bar: ProgressBar = $ToleranceBar
@onready var power_req_bar: ProgressBar = $PowerReqLabel/PowerReqBar
@onready var curr_pow_bar: ProgressBar = $CurrPowLabel/CurrPowBar
@onready var sprite_2d: Sprite2D = $Sprite2D
const LEVER_OFF = preload("res://assets/lever_off.png")
const LEVER_ON = preload("res://assets/lever_on.png")

signal game_over
signal interacted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	wait_next()

func interact() -> void:
	is_on = not(is_on)
	if is_on :
		sprite_2d.texture = LEVER_ON
	else :
		sprite_2d.texture = LEVER_OFF
	interacted.emit(is_on)

func check_power() -> void:
	curr_pow_label.text = str(curr_power)
	curr_pow_bar.value = curr_power
	if wait_timer.is_stopped() :
		if curr_power >= power_req :
			if power_req_timer.is_stopped() :
				power_req_timer.start()
			power_req_timer.paused = false
			tolerance_timer.stop()
			tolerance_bar.visible = false
		else :
			power_req_timer.paused = true
			tolerance_bar.visible = true
			if tolerance_timer.is_stopped() :
				tolerance_timer.start()

func next_pow_req() -> void:
	power_req = randi_range(5, 40) + randi_range(0, 2) * (Globals.curr_day - 1)
	req_time += randf_range(-2,2) * (Globals.curr_day - 1)
	req_time = max(req_time, 3)
	if tol_time > 2 :
		tol_time -= randf_range(0.01, 0.5)  * ((Globals.curr_day - 1) / 2)
		tol_time = max(tol_time, 2)
	power_req_label.text = str(power_req)
	power_req_timer.wait_time = req_time
	tolerance_timer.wait_time = tol_time
	check_power()

func wait_next() -> void:
	wait_timer.wait_time = randf_range(2, 10)
	wait_timer.start()

func _on_power_req_timer_timeout() -> void:
	power_req = 0
	power_req_label.text = str(power_req)
	wait_next()

func _on_tolerance_timer_timeout() -> void:
	game_over.emit()

func _on_wait_timer_timeout() -> void:
	next_pow_req()

func _process(_delta: float) -> void:
	power_req_bar.value = (req_time - power_req_timer.time_left) / req_time
	if not(tolerance_timer.is_stopped()) :
		tolerance_bar.value = tolerance_timer.time_left / tol_time
