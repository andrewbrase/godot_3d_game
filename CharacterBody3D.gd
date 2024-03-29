extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Node3D_neck
@onready var camera := $Node3D_neck/Camera3D
@onready var esc_pressed = false


func _unhandled_input(event: InputEvent):
	if not esc_pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				neck.rotate_y(-event.relative.x * 0.001)
				camera.rotate_x(-event.relative.y * 0.001)
				camera.rotation.x = clamp(camera.rotation.x,  deg_to_rad(-30),  deg_to_rad(60))


func _physics_process(delta):
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("esc"):
		if not esc_pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			esc_pressed = true
			print(esc_pressed)
		else:
			esc_pressed = false
			print(esc_pressed)
	
	if not esc_pressed:	
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
