extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var pivot: Node3D = $Pivot  
@onready var animation_player: AnimationPlayer = $Pivot/Body/AnimationPlayer  


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	
	# use look at instead
	if velocity.length() > 0.2 :
		pivot.look_at(Vector3(camera.global_position.x, 0, camera.global_position.z))
	#	var look_direction = Vector2(velocity.z, velocity.x)
	#	pivot.rotation.y = lerp_angle(pivot.rotation.y, look_direction.angle(), delta*SPEED*5)
		
	if Input.is_action_pressed("ui_up") :
		animation_player.play("run_forward")
	elif Input.is_action_pressed("ui_down") :
		animation_player.play("run_backward")
	else:	
		if Input.is_action_pressed("ui_left") :
			animation_player.play("strafe_left")
		elif Input.is_action_pressed("ui_right") :
			animation_player.play("strafe_right")
		else:	
			animation_player.play("idle")
