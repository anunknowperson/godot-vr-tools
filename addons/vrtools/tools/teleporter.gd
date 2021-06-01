tool
extends Spatial

export (int) var point_count := 30
export (float) var arcDistance :float = 10.0
export (float) var arcDuration :float = 3.0
export (float) var arcScale :float = 1.0
export (float) var pointerSize :float = 0.5

export (Color) var avaibleColor :Color = Color.white
export (Color) var notAvaibleColor :Color = Color.red

export (String) var teleport_group := "teleport_area"

var button_pressed :bool = false

var teleport_marker :Spatial
var teleport_point :Vector3
var teleport_transform :Transform

var good := false

var controller_x :float
var controller_y :float

func _enter_tree():
	if not Engine.editor_hint:
		teleport_marker = $TeleportMarker
		teleport_marker.get_parent().remove_child(teleport_marker)
		get_parent().get_parent().call_deferred("add_child", teleport_marker)
		
		$LineRenderer.startThickness *= ARVRServer.world_scale
		$LineRenderer.endThickness *= ARVRServer.world_scale

func _input(event):
	if event.device + 1 != get_parent().controller_id:
		return
	
	if not Engine.editor_hint:
		if event is InputEventJoypadMotion:
			if event.axis == 1: 
				controller_y = event.axis_value
				
				if event.axis_value > 0.9:
					if not button_pressed:
						begin_teleport()
						
						button_pressed = true
			elif event.axis == 0:
				controller_x = event.axis_value
				
			if abs(controller_x) < 0.1 and abs(controller_y) < 0.1:
				if button_pressed:
					end_teleport()
					
					button_pressed = false

func begin_teleport():
	$LineRenderer.show()

func end_teleport():
	$LineRenderer.hide()
	teleport_marker.hide()
	if good:
		get_parent().get_parent().global_transform.origin = teleport_transform.origin
		get_parent().get_parent().global_transform.basis = teleport_transform.basis.orthonormalized()

		var bady = get_parent().get_parent().get_node("ARVRCamera").rotation.y
		
		get_parent().get_parent().rotate(Vector3(0, 1, 0), -bady)
	
func process_teleport():
	$LineRenderer.points.clear()
	
	var gravity :Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector") * ProjectSettings.get_setting("physics/3d/default_gravity")
	
	var timestep := arcDuration / point_count
	
	var current_point = 0
	
	var old_pos :Vector3

	var space_state = get_parent().get_world().direct_space_state
	
	good = false
	var check = false
	
	for i in range(point_count):
		var arc_pos :Vector3 = get_parent().global_transform.origin + ((get_parent().global_transform.basis.z.normalized() * -1 * arcDistance * current_point) + (0.5 * current_point * current_point) * gravity) * arcScale
		
		if i != 0:
			var result = space_state.intersect_ray(old_pos, arc_pos)
			
			if not result.empty():
				teleport_point = result.position
				check = true
				$LineRenderer.points.append(teleport_point)
				
				if result.collider.is_in_group(teleport_group):
					good = true
				break
		
		$LineRenderer.points.append(arc_pos)
		
		current_point += timestep
		
		old_pos = arc_pos
	
	teleport_marker.show()
	
	teleport_marker.global_transform.origin = teleport_point
	var temp :Vector3 = get_parent().global_transform.origin
	temp.y = teleport_point.y
	teleport_marker.look_at(temp, Vector3(0, 1, 0))
	teleport_marker.rotate(Vector3(0, 1, 0), PI + Vector2(0, 1).angle_to(Vector2(controller_x, controller_y).normalized()))
	teleport_marker.scale = Vector3(ARVRServer.world_scale, ARVRServer.world_scale, ARVRServer.world_scale) * pointerSize
	teleport_transform = teleport_marker.global_transform
	
	
	
	if not check:
		teleport_marker.hide()

	if good:
		teleport_marker.material_override.albedo_color = avaibleColor
		$LineRenderer.material_override.albedo_color = avaibleColor
	else:
		teleport_marker.material_override.albedo_color = notAvaibleColor
		$LineRenderer.material_override.albedo_color = notAvaibleColor

func _physics_process(delta):
	if not Engine.editor_hint:
		if button_pressed:
			process_teleport()

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
