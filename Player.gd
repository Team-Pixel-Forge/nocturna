extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var pivot: Node3D = $Pivot  
@onready var animation_tree: AnimationTree = $Pivot/Body/AnimationTree 


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# we can probably remove this now
	direction = direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)	

	move_and_slide()
	
	if velocity.length() > 0.2 :
		pivot.look_at(Vector3(camera.global_position.x, 0, camera.global_position.z))
		
	animation_tree.set("parameters/movement/blend_position", Vector2(input_dir.x, input_dir.y))
