extends Interactable

class_name Generator

@onready var charge_bar: ProgressBar = $ChargeBar
@onready var tick_timer: Timer = $TickTimer
const MAX_CHARGE: int = 100
var deplete_speed: float = 3
var is_on: bool = false
var charge: int = 100

signal generator

func interact() -> void:
	is_on = not(is_on)
	if is_on and charge <= 0 :
		is_on = false
	if is_on :
		tick_timer.start()
	else :
		tick_timer.stop()
	generator.emit(is_on)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name.contains("Fuel") and charge < MAX_CHARGE :
		charge = MAX_CHARGE
		charge_bar.value = charge
		area.get_parent().queue_free()

func _on_tick_timer_timeout() -> void:
	charge -= deplete_speed
	charge_bar.value = charge
	if charge <= 0 :
		charge = 0
		is_on = false
		generator.emit(is_on)
