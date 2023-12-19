extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0
const STATIC_DISTANCE = 1500
var distance = 0
const ENEMY = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
var direction: int = 1
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if distance >= 2000:
		direction = -1
		get_node('AnimatedSprite2D').flip_h = true
	if distance <= -2000:
		direction = 1
		get_node('AnimatedSprite2D').flip_h = false
	anim.play('Walk')
	velocity.x = SPEED * direction
	distance += velocity.x
	move_and_slide()
