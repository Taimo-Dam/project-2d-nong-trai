extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/objects/trees/log.tscn")
 
func _ready() -> void:
	var mat = material.duplicate()
	material = mat
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	if not is_queued_for_deletion():
		shake_tree()

func shake_tree() -> void:
	var mat = material as ShaderMaterial
	if not mat:
		return
	mat.set_shader_parameter("shake_intensity", 0.2)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/shake_intensity", 0.0, 0.5)

func on_max_damage_reached() -> void:
	spawn_log()
	queue_free()

func spawn_log() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().call_deferred("add_child", log_instance)
