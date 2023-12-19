extends RigidBody2D


var speed = 300
var velocity = Vector2(0, 0)
var direction
@onready var anim = get_node("AnimatedSprite2D")
func _ready():
	gravity_scale = 0
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	if direction == -1:
		anim.flip_h = true
	else:
		anim.flip_h = false
	if direction == 0:
		velocity.x += speed
	else:
		velocity.x += speed * direction
	if collision_info:
		var collision_body = collision_info.get_collider()
		if collision_body.is_in_group('Enemies'):
			collision_body.queue_free()
			queue_free()
		else:
			queue_free()
	
