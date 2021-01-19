tool
extends Spatial

onready var outline_shader :ShaderMaterial = preload("res://addons/vrtools/materials/outline.tres")

export (int) var button_index = 15
var is_pressed :bool = false
var current_object :PhysicsBody
var current_outline :MeshInstance

export (String) var interactible_group = "interactible"

func _enter_tree():
	if not Engine.editor_hint:
		$DetectionArea.connect("body_entered", self, "on_object")
		$DetectionArea.connect("body_exited", self, "on_lost")

func on_object(body):
	if body.is_in_group(interactible_group):
		current_object = body
		
		for child in current_object.get_children():
			if child.has_signal("interact"):
				if child.MeshInstance_path != null:
					var m :MeshInstance = child.get_node(child.MeshInstance_path)
					current_outline = m.duplicate()
					child.get_parent().add_child(current_outline)
					current_outline.material_override = outline_shader
		
func on_lost(body):
	if body == current_object:
		current_object = null
		
		current_outline.queue_free()

func _input(event):
	if event.device + 1 != get_parent().controller_id:
		return
	
	if not Engine.editor_hint:
		if event is InputEventJoypadButton:
			if event.button_index == button_index:
				if event.pressed:
					if not is_pressed:
						if current_object != null:
							for child in current_object.get_children():
								if child.has_signal("interact"):
									child.emit_signal("interact")
							
						is_pressed = true
				else:
					is_pressed = false

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
