extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var level_end: StaticBody2D = $"../Level End"


const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var can_double_jump = true

func _ready() -> void:
	animated_sprite_2d.play("idle")
	
func _physics_process(delta: float) -> void:
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump:
		can_double_jump = false
		velocity.y = JUMP_VELOCITY * 0.75
		
	# Reset double jump
	if is_on_floor():
		can_double_jump = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
