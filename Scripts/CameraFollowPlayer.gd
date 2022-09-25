extends Camera3D

@onready var _player : Node3D = get_tree().get_nodes_in_group("Player")[0]
@onready var _target : Node3D = _player.get_node("CameraTarget")
@onready var _eyes : Node3D = _player.get_node("CameraRaycast")

func _process(delta: float) -> void: 
	position = _target.global_position
	look_at(_eyes.global_position)

