extends Node2D
class_name World


@export var list_ports_parent: VBoxContainer
@export var panel: Panel
@export var no_gamepad_btn: Button

@export var time_text: RichTextLabel
@export var powerups_text: RichTextLabel

@export var powerup_sfx: Array[AudioStream] = []
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var collected_powerups: int = 0
var max_powerups: int = 0
var time: float = 0


func _ready() -> void:
	for powerup: Powerup in find_children("", "Powerup"):
		powerup.collected.connect(_on_powerup_collected.bind(powerup))
		max_powerups += 1
	powerups_text.text = str(collected_powerups) + " / " + str(max_powerups)

func _process(delta: float) -> void:
	time += delta
	time_text.text = str(time)


func _on_powerup_collected(powerup: Powerup) -> void:
	powerup.get_parent().remove_child.call_deferred(powerup)
	powerup.queue_free()
	audio_stream_player.stream = powerup_sfx.pick_random()
	audio_stream_player.play()
	print("Powerup Collected!")
	collected_powerups += 1
	powerups_text.text = str(collected_powerups) + " / " + str(max_powerups)
