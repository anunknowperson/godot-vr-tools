extends Spatial

export (String) var teleport_area_group = "teleport_area"

func _enter_tree():
	if not Engine.editor_hint:
		get_parent().add_to_group(teleport_area_group)

