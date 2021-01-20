tool
extends Spatial

export (int) var max_raycast_distance = 100
export (String) var ui_group = "ui_collider"
export (int) var button_index = 15

var is_pressed :bool = false
var space_state :PhysicsDirectSpaceState
var point :Vector3
var body :StaticBody

func _enter_tree():
	if not Engine.editor_hint:
		space_state = get_parent().get_world().direct_space_state

func _physics_process(delta):
	if not Engine.editor_hint:
		var result = space_state.intersect_ray(global_transform.origin, global_transform.origin + global_transform.basis.z * -1 * max_raycast_distance)

		if not result.empty() and result.collider.is_in_group(ui_group):
			$LineRenderer.points = [global_transform.origin, result.position]
			$LineRenderer.show()
			
			body = result.collider
			point = result.position
			
			if is_pressed:
				body.get_parent().get_parent().ui_raycast_hit_event(point, false, false)
		else:
			$LineRenderer.hide()
			
			body = null

func _input(event):
	if event.device + 1 != get_parent().controller_id:
		return
	
	if not Engine.editor_hint:
		if event is InputEventJoypadButton:
			if event.button_index == button_index:
				if event.pressed:
					if not is_pressed:
						if body != null:
							body.get_parent().get_parent().ui_raycast_hit_event(point, true, false)
							
						is_pressed = true
				else:
					if is_pressed:
						if body != null:
								body.get_parent().get_parent().ui_raycast_hit_event(point, false, true)
						
						is_pressed = false

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
