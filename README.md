# VR Tools
VR Tools is an auxiliary set of virtual reality tools for godot development, including such useful nodes as teleportation, grabbing, and the world space user interface.

This asset also includes Mux123's OpenVR addon.

To get started, simply drag and drop the vrplayer.tscn file from the scenes folder onto your scene. This asset is originally intended for use with OpenVR, however you can manually change the interface in the script to another.

The plugin provides you with many nodes, and here are the most basic ones:
ARVRTeleportArea
You can set this node as a child of the surface (StaticBody or CSG with enabled collision) that the player can teleport to.
ARVRGrabbable
You can set this node as a child of the Rigidbody that should interact with the controller. In the parameters, the node needs to specify the path to MeshInstance in order for the highlighting effect to work.
ARVRUI
This node allows you to create interfaces based on Control. It cannot be added to the scene directly from the editor. Better take the ARVRUI blank from the scenes folder. All you have to do is also add this node to the child objects of the Control node with its controls and specify the path to it in the inspector.

The plugin also contains many nodes from the controller side, but I will not consider them here, because they are already configured by default.

This addon works with the stable version of OpenVR, which does not support the action system, however, when the new version of the plugin is released in assetlib, this plugin will also be updated for it.

If you find a bug, please report it to the issues section on github.

New features, documentation and tools coming soon

Current version: 0.1
