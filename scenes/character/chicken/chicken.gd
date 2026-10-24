class_name Chicken
extends CharacterBody2D

@export var speed: float = 20.0
@export var egg_scene: PackedScene = preload("res://scenes/objects/egg.tscn")
@export var egg_drop_min_interval: float = 20.0
@export var egg_drop_max_interval: float = 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var egg_timer: float = 0.0
var next_egg_time: float = 0.0

func _ready() -> void:
	reset_egg_timer()

func _process(delta: float) -> void:
	egg_timer += delta
	if egg_timer >= next_egg_time:
		drop_egg()
		reset_egg_timer()

func reset_egg_timer() -> void:
	egg_timer = 0.0
	next_egg_time = randf_range(egg_drop_min_interval, egg_drop_max_interval)

func drop_egg() -> void:
	if not egg_scene or not get_parent():
		return
	var egg_instance = egg_scene.instantiate() as Node2D
	egg_instance.global_position = global_position
	get_parent().call_deferred("add_child", egg_instance)
