extends NodeState

@export var chicken: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var min_idle_time: float = 1.5
@export var max_idle_time: float = 3.5

var idle_timer: float = 0.0
var idle_duration: float = 2.0

func _on_enter() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")
	if chicken:
		chicken.velocity = Vector2.ZERO
	idle_timer = 0.0
	idle_duration = randf_range(min_idle_time, max_idle_time)

func _on_process(delta: float) -> void:
	idle_timer += delta

func _on_next_transitions() -> void:
	if idle_timer >= idle_duration:
		transition.emit("walk")

func _on_exit() -> void:
	pass
