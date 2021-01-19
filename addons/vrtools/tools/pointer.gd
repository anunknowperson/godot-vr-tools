tool
extends Spatial


func _enter_tree():
	pass

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
