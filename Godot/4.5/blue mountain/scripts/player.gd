extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = 980.0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_released("ui_accept"):
			velocity.y = lerp(velocity.y,gravity,0.2)
	if Input.is_action_just_pressed("ui_accept"):
		if Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("jump")
		elif Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("jump2")
		else:
			$AnimatedSprite2D.play("jump")
	elif Input.is_action_pressed("ui_right") and is_on_floor():
			$AnimatedSprite2D.play("run")
	elif Input.is_action_pressed("ui_left") and is_on_floor():
		$AnimatedSprite2D.play("run2")
	elif not Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
