extends Node2D
class_name World


@export var list_ports_parent: VBoxContainer
@export var panel: Panel
@export var no_gamepad_btn: Button


func _ready() -> void:
	for powerup: Powerup in find_children("", "Powerup"):
		powerup.collected.connect(_on_powerup_collected.bind(powerup))


func _on_powerup_collected(powerup: Powerup) -> void:
	powerup.get_parent().remove_child.call_deferred(powerup)
	powerup.queue_free()
	print("Powerup Collected!")
