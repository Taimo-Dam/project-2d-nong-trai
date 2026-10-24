extends NodeState

@export var chicken: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var speed: float = 20.0
@export var wander_radius: float = 50.0
@export var max_walk_duration: float = 4.0

var walk_timer: float = 0.0
var target_pos: Vector2 = Vector2.ZERO
var start_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().physics_frame

func _on_enter() -> void:
	walk_timer = 0.0
	if not chicken:
		return
	if start_pos == Vector2.ZERO:
		start_pos = chicken.global_position

	var random_offset = Vector2(randf_range(-wander_radius, wander_radius), randf_range(-wander_radius, wander_radius))
	target_pos = start_pos + random_offset

	if navigation_agent_2d:
		navigation_agent_2d.target_position = target_pos

	if animated_sprite_2d:
		animated_sprite_2d.play("walk")

func _on_physics_process(delta: float) -> void:
	if not chicken:
		return
	walk_timer += delta

	var current_pos: Vector2 = chicken.global_position
	var next_pos: Vector2 = target_pos

	if navigation_agent_2d and not navigation_agent_2d.is_navigation_finished():
		var nav_pos = navigation_agent_2d.get_next_path_position()
		if nav_pos != Vector2.ZERO and nav_pos != current_pos:
			next_pos = nav_pos

	var direction = next_pos - current_pos
	if direction.length() < 3.0:
		chicken.velocity = Vector2.ZERO
		return

	direction = direction.normalized()
	chicken.velocity = direction * speed
	chicken.move_and_slide()

	if animated_sprite_2d:
		if direction.x < -0.1:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0.1:
			animated_sprite_2d.flip_h = false

func _on_next_transitions() -> void:
	if not chicken:
		return
	var reached = false
	if navigation_agent_2d:
		reached = navigation_agent_2d.is_navigation_finished() or (chicken.global_position.distance_to(target_pos) < 6.0)
	else:
		reached = chicken.global_position.distance_to(target_pos) < 6.0

	if reached or walk_timer >= max_walk_duration:
		transition.emit("idle")

func _on_exit() -> void:
	if chicken:
		chicken.velocity = Vector2.ZERO
	if animated_sprite_2d:
		animated_sprite_2d.stop()
