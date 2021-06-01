tool
extends Spatial

var viewport
var mesh
var control

var prev_pos = null
var last_click_pos = null
var last_pos2d = null

func _enter_tree():
	for child in get_children():
		if child is Control:
			control = child
			
	if !control:
		return
	
	viewport = $Viewport
	mesh = $MeshInstance

	if viewport.get_child_count() > 0:
		viewport.remove_child(viewport.get_child(0))
		
	control = control.duplicate()
	viewport.add_child(control)
		
	viewport.size = control.rect_size
		
	mesh.scale = Vector3(control.rect_size.x / 100, 1, control.rect_size.y / 100)
	
	var material : SpatialMaterial = mesh.material_override
	material.albedo_texture = viewport.get_texture()

func ui_raycast_hit_event(position, click, release):
	var local_position = to_local(position);
	var pos2d = Vector2(local_position.x + mesh.scale.x / 2, mesh.scale.z-local_position.y - mesh.scale.z / 2) * 100

	if (click || release):
		var e = InputEventMouseButton.new()
		e.pressed = click
		e.button_index = BUTTON_LEFT
		e.position = pos2d
		e.global_position = pos2d

		viewport.input(e)
		
	elif (last_pos2d != null && last_pos2d != pos2d):
		var e = InputEventMouseMotion.new()
		e.relative = pos2d - last_pos2d
		e.speed = (pos2d - last_pos2d) / 16.0
		e.global_position = pos2d
		e.position = pos2d
		
		viewport.input(e)
	last_pos2d = pos2d

func _get_configuration_warning() -> String:
	var find := false
	
	for child in get_children():
		if child is Control:
			find = true
	
	if not find:
		return "This tool must have the Control node as child"
	else:
		return ""
