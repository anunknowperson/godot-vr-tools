tool
extends EditorPlugin

func _enter_tree():
	# Register plugin types
	add_custom_type("ARVRTeleporter", "Spatial", preload("res://addons/vrtools/tools/teleporter.gd"), preload("res://addons/vrtools/icons/teleporter.png"))
	add_custom_type("ARVRGrabber", "Spatial", preload("res://addons/vrtools/tools/grabber.gd"), preload("res://addons/vrtools/icons/grabber.png"))
	add_custom_type("ARVRPointer", "Spatial", preload("res://addons/vrtools/tools/pointer.gd"), preload("res://addons/vrtools/icons/pointer.png"))
	add_custom_type("ARVRInteractor", "Spatial", preload("res://addons/vrtools/tools/interactor.gd"), preload("res://addons/vrtools/icons/interactor.png"))
	add_custom_type("ARVRUI", "Spatial", preload("res://addons/vrtools/tools/ui.gd"), preload("res://addons/vrtools/icons/ui.png"))
	add_custom_type("ARVRInteractible", "Spatial", preload("res://addons/vrtools/tools/interactible.gd"), preload("res://addons/vrtools/icons/pointer.png"))
	add_custom_type("ARVRTeleportArea", "Spatial", preload("res://addons/vrtools/tools/teleportarea.gd"), preload("res://addons/vrtools/icons/area.png"))
	add_custom_type("ARVRGrabbable", "Spatial", preload("res://addons/vrtools/tools/grabbable.gd"), preload("res://addons/vrtools/icons/grabber.png"))
	add_custom_type("ARVRControllerModel", "MeshInstance", preload("res://addons/vrtools/tools/controllermodel.gd"), preload("res://addons/vrtools/icons/model.png"))
func _exit_tree():
	# Remove plugin types from tree
	remove_custom_type("ARVRTeleporter")
	remove_custom_type("ARVRGrabber")
	remove_custom_type("ARVRPointer")
	remove_custom_type("ARVRInteractor")
	remove_custom_type("ARVRUI")
	remove_custom_type("ARVRInteractible")
	remove_custom_type("ARVRGrabbable")
	remove_custom_type("ARVRTeleportArea")
	remove_custom_type("ARVRControllerModel")
