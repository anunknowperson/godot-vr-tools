extends Spatial

signal interact

export (NodePath) var MeshInstance_path = null
export (String) var interactible_group = "interactible"

func _enter_tree():
	if not Engine.editor_hint:
		get_parent().add_to_group(interactible_group)

