extends CharacterBody2D

var health = 10
var fall_limit = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var sprite
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("Camera2D/AnimationPlayer")
var game_over_triggered = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if position.y > fall_limit:
		get_tree().change_scene_to_file("res://over.tscn")
	var direction = Input.get_axis("ui_left", "ui_right")
	print(direction)
	if direction == -1:
		get_node("CollisionShape2D/AnimatedSprite2D").flip_h =true
	else:
		get_node("CollisionShape2D/AnimatedSprite2D").flip_h =false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y ==0:
			anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")
	move_and_slide()
	if health <=0:
		queue_free()
		get_tree().change_scene_to_file("res://over.tscn")
