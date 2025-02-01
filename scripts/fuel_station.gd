extends Interactable

const FUEL = preload("res://scenes/fuel.tscn")
var curr_player : Player

func interact() -> void:
	if not(curr_player.holdingFuel) :
		var new_fuel = FUEL.instantiate()
		curr_player.add_child(new_fuel)
		curr_player.holdingFuel = true
		var fuel_tween = new_fuel.create_tween()
		fuel_tween.tween_property(new_fuel, "position", Vector2(0, -50), 0.2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		body.currInteractable = self
		interact_label.visible = true
		curr_player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player :
		if body.currInteractable == self :
			body.currInteractable = null
		interact_label.visible = false
		curr_player = null
