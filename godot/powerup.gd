extends Node2D
class_name Powerup


signal collected


func _on_area_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit()
