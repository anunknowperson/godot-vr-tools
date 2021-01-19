tool
extends MeshInstance

signal controller_activated(controller)

export var show_controller_mesh = true setget set_show_controller_mesh, get_show_controller_mesh

func set_show_controller_mesh(p_show):
	show_controller_mesh = p_show
	visible = p_show

func get_show_controller_mesh():
	return show_controller_mesh

var ovr_render_model
var components = Array()
var ws = 0

func _ready():
	if not Engine.editor_hint:
		# instance our render model object
		ovr_render_model = preload("res://addons/vrtools/thirdparty/godot-openvr/OpenVRRenderModel.gdns").new()
	
		# set our starting vaule
		visible = false

func apply_world_scale():
	var new_ws = ARVRServer.world_scale
	if (ws != new_ws):
		ws = new_ws
		scale = Vector3(ws, ws, ws)

func load_controller_mesh(controller_name):
	if ovr_render_model.load_model(controller_name.substr(0, controller_name.length()-2)):
		return ovr_render_model
	
	if ovr_render_model.load_model("generic_controller"):
		return ovr_render_model
	
	return Mesh.new()

func _process(delta):
	if not Engine.editor_hint:
		if !get_parent().get_is_active():
			visible = false
			return
		
		# always set our world scale, user may end up changing this
		apply_world_scale()
		
		if visible:
			return
		
		# became active? lets handle it...
		var controller_name = get_parent().get_controller_name()
		print("Controller " + controller_name + " became active")
		
		# attempt to load a mesh for this
		mesh = load_controller_mesh(controller_name)
		
		# make it visible
		visible = true
		emit_signal("controller_activated", self)

func _get_configuration_warning() -> String:
	if not get_parent().get_class() == "ARVRController":
		return "This tool must have ARVRController as its parent"
	else:
		return ""
