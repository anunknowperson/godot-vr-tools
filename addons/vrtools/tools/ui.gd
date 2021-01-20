tool
extends Spatial

export (NodePath) var viewport
export (NodePath) var mesh
export (NodePath) var control

var controln : Control
var viewportn :Viewport

var prev_pos = null
var last_click_pos = null
var last_pos2d = null

func ui_raycast_hit_event(position, click, release):
	var local_position = to_local(position);
	var pos2d = Vector2(local_position.x + get_node(mesh).scale.x / 2, get_node(mesh).scale.z-local_position.y - get_node(mesh).scale.z / 2) * 100

	print(pos2d)

	if (click || release):
		var e = InputEventMouseButton.new()
		e.pressed = click
		e.button_index = BUTTON_LEFT
		e.position = pos2d
		e.global_position = pos2d

		viewportn.input(e)
		
	elif (last_pos2d != null && last_pos2d != pos2d):
		var e = InputEventMouseMotion.new()
		e.relative = pos2d - last_pos2d
		e.speed = (pos2d - last_pos2d) / 16.0
		e.global_position = pos2d
		e.position = pos2d
		
		viewportn.input(e)
	last_pos2d = pos2d

func _enter_tree():
	if not Engine.editor_hint:
		viewportn = get_node(viewport);
		
		controln = get_node(control)
		
		if get_node(viewport).get_child_count() > 0:
			get_node(viewport).remove_child(get_node(viewport).get_child(0))
		
		controln = controln.duplicate()
		get_node(viewport).add_child(controln)
		
		get_node(viewport).size = Vector2(controln.margin_right, controln.margin_bottom)
		
		get_node(mesh).scale = Vector3(controln.margin_right / 100, 1, controln.margin_bottom / 100)
		
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
