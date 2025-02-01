extends Interactable

class_name Generator

@onready var charge_bar: ProgressBar = $ChargeBar
@onready var tick_timer: Timer = $TickTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var upgrade_screen: Control = $"../UpgradeScreen"
@onready var fuel_upgrade: Button = $"../UpgradeScreen/FuelUpgrade"
@onready var generator_upgrade: Button = $"../UpgradeScreen/GeneratorUpgrade"
var max_charge: float = 100
var deplete_speed: float = 3
var is_on: bool = false
var charge: float = 100
var fuel_refill_charge: float = 20
var fuel_level: int = 1
var generator_level: int = 1

signal generator
signal upgrade

func interact() -> void:
	is_on = not(is_on)
	if is_on and charge <= 0 :
		is_on = false
	if is_on :
		tick_timer.start()
	else :
		tick_timer.stop()
	if is_on :
		animated_sprite_2d.play("on")
	else :
		animated_sprite_2d.play("off")
	generator.emit(is_on)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name.contains("Fuel") and charge < max_charge :
		charge += fuel_refill_charge
		charge = min(charge, max_charge)
		charge_bar.value = charge
		area.get_parent().get_parent().holdingFuel = false
		area.get_parent().queue_free()

func _on_tick_timer_timeout() -> void:
	charge -= deplete_speed
	charge_bar.value = charge
	if charge <= 0 :
		charge = 0
		is_on = false
		generator.emit(is_on)
		tick_timer.stop()

func reset() -> void:
	charge = max_charge
	charge_bar.value = charge

func show_upgrades() -> void:
	fuel_upgrade.text = "+" + str(5 + 5 * (fuel_level - 1)) + " on fuel refill"
	generator_upgrade.text = "+" + str(20 + 10 * (generator_level - 1)) + " generator charge"
	upgrade_screen.visible = true

func _on_fuel_upgrade_pressed() -> void:
	fuel_refill_charge += 5 + 5 * (fuel_level - 1)
	upgrade_screen.visible = false
	fuel_level += 1
	upgrade.emit()

func _on_generator_upgrade_pressed() -> void:
	max_charge += 20 + 10 * (generator_level - 1)
	charge_bar.max_value += 20
	upgrade_screen.visible = false
	generator_level += 1
	upgrade.emit()
