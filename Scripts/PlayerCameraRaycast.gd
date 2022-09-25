extends RayCast3D

@onready var _target : Node3D = $"../CameraTarget"

@export var _ground_offset : float = 0.01
@export_range(0,1) var _transperancy_threshold : float = 0.5

func _ready() -> void:
	target_position = _target.position - position

func _process(delta: float) -> void:
	if is_colliding():
		var distance : float = _target.position.distance_to(position) /  \
			target_position.length()
		
		_target.global_position = get_collision_point()
		_target.global_position += get_collision_normal() * _ground_offset
		#_mesh.transparency = 1 - min(1, distance / (1 - _transperancy_threshold))
	else:
		#_mesh.transparency = 0
		_target.position = transform.basis * (target_position+position)
