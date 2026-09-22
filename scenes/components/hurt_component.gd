class_name HurtComponent
extends Area2D

@export var tool : DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	print("Có va chạm từ Area: ", area.name)
	var hit_component = area as HitComponent
	
	if tool == hit_component.current_tool:
		print("Tương tác THÀNH CÔNG!")
		hurt.emit(hit_component.hit_damage)
