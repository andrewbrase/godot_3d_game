extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@onready var neck := $Node3D_neck
@onready var camera := $Node3D_neck/Camera3D
@onready var flash_light := $Node3D_neck/Camera3D/flashlight/SpotLight3D
@onready var menu_main := $Menu
@onready var esc_pressed = false
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var flashlight_on = true


func _unhandled_input(event: InputEvent):
	
	if not esc_pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				neck.rotate_y(-event.relative.x * 0.001)
				camera.rotate_x(-event.relative.y * 0.001)
				camera.rotation.x = clamp(camera.rotation.x,  deg_to_rad(-30),  deg_to_rad(60))


func _physics_process(delta):
	
	if Input.is_action_just_pressed("esc"):
		var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
		if not esc_pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			esc_pressed = true
			menu_main.size = screen_size
			menu_main.visible = true
		else:
			esc_pressed = false
			menu_main.visible = false
	
	if not esc_pressed:	
		if not is_on_floor():
			velocity.y -= gravity * delta
	
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("toggle_flashlight"):
			if flashlight_on:
				flash_light.visible = false
				flashlight_on = false
			else:
				flash_light.visible = true
				flashlight_on = true
				
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		move_and_slide()


# Signals
func _on_continue_button_pressed():
	esc_pressed = false
	menu_main.visible = false

func _on_exit_button_pressed():
	get_node("/root").free()

