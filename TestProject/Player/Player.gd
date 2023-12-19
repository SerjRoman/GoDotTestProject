extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var bullet_path = preload("res://Player/Bullet.tscn")
var animation_active = false
var direction
var HP = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var HPBox = get_node('/root/World/GUI/HBoxContainer')
@onready var HPBar = HPBox.get_node('HPBarBackground/HPBar')
@onready var HPNumber = HPBox.get_node('HPCountBackground/HBoxContainer/Number')
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play('Jump')
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node('AnimatedSprite2D').flip_h = true
	else:
		get_node('AnimatedSprite2D').flip_h = false
	if animation_active == false:
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play('Run')
		else:
			if velocity.y == 0:
				anim.play('Idle')
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if Input.is_action_just_pressed('D'):
			animation_active = true
			
			anim.play('Shoot')
			await anim.animation_finished
			shoot()
			animation_active = false
	move_and_slide()
	for i in get_slide_collision_count():
		var collision_body = get_slide_collision(i).get_collider()
		if collision_body.is_in_group('Enemies'):
			animation_active = true
			hurt(collision_body)
			await anim.animation_finished
			animation_active = false
			break
				

func shoot():
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	if direction == -1:
		bullet.position = $MarkerLeft.global_position
	else:
		bullet.position = $MarkerRight.global_position
	bullet.direction = direction
func hurt(collision_body):
	if direction == 0:
		velocity.x = SPEED * collision_body.direction
	else:
		velocity.x = SPEED * direction * -1
	velocity.y = -200
	anim.play('Hurt')
	HP -= 10
	HPBar.value = HP
	HPNumber.text = str(HP)
	if HP <= 0:
		die()
func die():
	get_tree().change_scene_to_file('res://End/GameOver.tscn')
	
