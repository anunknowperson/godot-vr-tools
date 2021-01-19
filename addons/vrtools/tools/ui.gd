tool
extends Spatial

export (NodePath) var viewport
export (NodePath) var mesh
export (NodePath) var control

var controln : Control

func _enter_tree():
	if not Engine.editor_hint:
		controln = get_node(control)
		
		if get_node(viewport).get_child_count() > 0:
			get_node(viewport).remove_child(get_node(viewport).get_child(0))
		
		controln = controln.duplicate()
		get_node(viewport).add_child(controln)
		
		get_node(viewport).size = Vector2(controln.margin_right, controln.margin_bottom)
		
		get_node(mesh).scale = Vector3(controln.margin_right / 100, controln.margin_bottom / 100, 1)
		
		update_image()

func _process(delta):
	var find := false
	
	for child in get_children():
		if child is Control:
			find = true
	
	if !find:
		return
	
	if Engine.editor_hint:
		controln = get_node(control)
		
		if get_node(viewport).get_child_count() > 0:
			get_node(viewport).remove_child(get_node(viewport).get_child(0))
		
		controln = controln.duplicate()
		get_node(viewport).add_child(controln)
		
		get_node(viewport).size = Vector2(controln.margin_right, controln.margin_bottom)
		
		get_node(mesh).scale = Vector3(controln.margin_right / 100, 1, controln.margin_bottom / 100)
		
		update_image()

func update_image():
	var material : SpatialMaterial = get_node(mesh).material_override
	material.albedo_texture = get_node(viewport).get_texture()

func _get_configuration_warning() -> String:
	var find := false
	
	for child in get_children():
		if child is Control:
			find = true
	
	if not find:
		return "This tool must have the Control node as child"
	else:
		return ""
