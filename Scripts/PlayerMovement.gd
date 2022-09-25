extends CharacterBody3D

@onready var _camera_raycast : Node3D = $CameraRaycast
@onready var _mesh : Node3D = $Mesh
var _last_mesh_rotation : Vector3

@onready var _animation_tree : AnimationTree = $Mesh/AnimationTree

@export var _max_speed := 7.0

@export var _jump_length := 5.0

@export var _jump_input_remember := 0.3
var _jump_input_timer := 0.0

@export var _mouse_sensitivity_y := 0.1
@export var _mouse_sensitivity_x := 0.3
@export var _max_pitch := 75
@export var _min_pitch := -55

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * deg_to_rad(_mouse_sensitivity_x)
		_camera_raycast.rotation.x += event.relative.y * deg_to_rad(_mouse_sensitivity_y)
		_camera_raycast.rotation.x = \
			clamp(_camera_raycast.rotation.x, deg_to_rad(_min_pitch), deg_to_rad(_max_pitch))
	elif event.is_action_pressed("jump"):
		_jump_input_timer = _jump_input_remember

func _process(delta: float) -> void:
	if _jump_input_timer > 0: _jump_input_timer -= delta

	
	var animation_blend := Vector2((abs(velocity.x)+abs(velocity.z)) / 2.0, 0)
	if !is_on_floor():
		animation_blend = Vector2(0, -1)
	
	_animation_tree["parameters/movement/blend_position"] = animation_blend

func _physics_process(delta : float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if _jump_input_timer > 0 and is_on_floor():
		velocity.y = sqrt(2 * _jump_length * gravity)

	var input_dir := Input.get_vector("move_right", "move_left", "move_back", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_velocity = direction * _max_speed + Vector3(0, velocity.y, 0)
	
	if(target_velocity.distance_to(velocity) > 0.1):
		velocity = lerp(velocity, target_velocity, 5*delta)
	else:
		velocity = target_velocity
		
	if velocity * Vector3(1, 0, 1):
		_mesh.global_rotation = Vector3(0, atan2(velocity.x, velocity.z), 0)
		_last_mesh_rotation = _mesh.global_rotation
	else:
		_mesh.global_rotation = _last_mesh_rotation
		
	move_and_slide()
