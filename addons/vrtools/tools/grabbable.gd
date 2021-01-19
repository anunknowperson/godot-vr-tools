extends Spatial

export (NodePath) var MeshInstance_path = null
export (String) var grabbable_group = "grabbable"

func _enter_tree():
	if not Engine.editor_hint:
		get_parent().add_to_group(grabbable_group)

