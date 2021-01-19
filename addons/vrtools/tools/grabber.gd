tool
extends Spatial

export (int) var button_index = 2
export (String) var grabbable_group = "grabbable"

var offset_node :Spatial
var current_object :RigidBody = null
var is_pressed :bool = false
var current_outline :MeshInstance

onready var outline_shader :ShaderMaterial = preload("res://addons/vrtools/materials/outline.tres")


func _enter_tree():
	if not Engine.editor_hint:
		$DetectionArea.connect("body_entered", self, "on_object")
		$DetectionArea.connect("body_exited", self, "on_lost")

func on_object(body):
	if body.is_in_group(grabbable_group):
		current_object = body
		
		for child in current_object.get_children():
			if child.get("MeshInstance_path") != null:
				var m :MeshInstance = child.get_node(child.MeshInstance_path)
				current_outline = m.duplicate()
				child.get_parent().add_child(current_outline)
				current_outline.material_override = outline_shader
		
func on_lost(body):
	if body == current_object:
		current_object = null
		
		current_outline.queue_free()

func _physics_process(delta):
	if current_object != null and is_pressed == true:
		current_object.linear_velocity = (offset_node.global_transform.origin - current_object.global_transform.origin) * 15
		
		var odelta : Basis = offset_node.global_transform.basis * current_object.global_transform.basis.inverse()
	
		var q = odelta.get_rotation_quat()
		current_object.set_angular_velocity(Vector3(q.x, q.y, q.z).normalized() * (15.0 * acos(q.w)))


func smallestSignedAngleBetween(x, y):
	var a = y - x
	
	if a > PI:
		a -= TAU 
	if a < -PI:
		a += TAU

	return a

func _input(event):
	if event.device + 1 != get_parent().controller_id:
		return
	
	if not Engine.editor_hint:
		if event is InputEventJoypadButton:
			if event.button_index == button_index:
				if event.pressed:
					if current_object != null:
						offset_node = Spatial.new()
						
						add_child(offset_node)
						
						offset_node.global_transform = current_object.global_transform
					
					is_pressed = true
				else:
					if current_object != null:
						offset_node.queue_free()
					
					is_pressed = false
				

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
