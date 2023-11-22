extends CharacterBody3D


const SPEED = 2
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var pivot: Node3D = $Pivot  
@onready var animation_tree: AnimationTree = $Pivot/Body/AnimationTree 
@onready var player: CharacterBody3D = get_parent().get_node("Player")


func _physics_process(delta):
		if global_position.distance_to(player.global_position) < 0.5:
			var playback = animation_tree.get("parameters/playback")
			playback.travel("attack")
		else:
			move_to_player(delta)


	
	

func move_to_player(delta) :
	var direction = global_position.direction_to(player.global_position)
	look_at(global_position - direction, Vector3.UP)

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var playback = animation_tree.get("parameters/playback")
	if playback.get_current_node() != "movement":
		direction = Vector2.ZERO	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)	

	move_and_slide()
	

		
	animation_tree.set("parameters/movement/blend_position", Vector2(0, 1))
