extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	var mat = material.duplicate()
	material = mat
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	if not is_queued_for_deletion():
		shake_rock()

func shake_rock() -> void:
	var mat = material as ShaderMaterial
	if not mat:
		return
	mat.set_shader_parameter("shake_intensity", 0.3)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/shake_intensity", 0.0, 0.4)

func on_max_damage_reached() -> void:
	spawn_stone()
	queue_free()

func spawn_stone() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().call_deferred("add_child", stone_instance)
