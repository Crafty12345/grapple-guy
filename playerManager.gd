extends CharacterBody2D


const JUMP_VELOCITY = -1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation_player = $AnimatedSprite2D
@onready var collision_polygon = $collision_polygon
@onready var crouching_collision_polygon = $crouching_collision_polygon


func _physics_process(delta):
	
	var SPEED = 800.0
	var gravity = default_gravity
	
	if Input.is_action_pressed("down"):
		SPEED = SPEED / 2
		if not is_on_floor():
			gravity *= 2
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if(velocity.x != 0 and is_on_floor()):
		if(Input.is_action_pressed("down")):
			animation_player.play("crouching_moving")
		else:
			animation_player.play("running")
			if(velocity.x >= 0):
				animation_player.flip_h = false
			else:
				animation_player.flip_h = true
	else:
		if(Input.is_action_pressed("down")):
			animation_player.play("crouching_idle")
		else:
			animation_player.play("idle")


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
