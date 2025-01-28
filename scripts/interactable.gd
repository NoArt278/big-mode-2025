extends StaticBody2D

class_name Interactable

@onready var interact_label: Label = $InteractLabel
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)

func interact() -> void :
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		body.currInteractable = self
		interact_label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player :
		if body.currInteractable == self :
			body.currInteractable = null
		interact_label.visible = false
