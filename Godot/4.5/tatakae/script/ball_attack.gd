extends Area2D
#region variables
var ball_angle :float = 0.0
var speed :float = 1.05
var timer :float = 0.0
var limiter_off :bool = false
var enemy_pos :Vector2
@onready var enemy :CharacterBody2D = $"../enemy-1"
#endregion
#region functions
func fire(angle :float,enemy_position :Vector2):# for setting the position of the projectile and spawn it
	$AnimatedSprite2D.play("apppear")
	ball_angle = angle
	enemy_pos = enemy_position
	await $AnimatedSprite2D.animation_finished
	$CollisionShape2D.set_deferred("disabled",false)
func release(activation :bool):#to throw all projectiles at once
	limiter_off = activation
func _process(delta: float) -> void:
	timer += delta
	if $CollisionShape2D.disabled == false:
		if $AnimatedSprite2D.rotation <= 355:
			$AnimatedSprite2D.rotation += 0.18
		else:
			$AnimatedSprite2D.rotation = 0
	if timer > 0.01 and limiter_off:
		timer = 0.0
		if enemy.stage2 and enemy_pos != Vector2(0.0,0.0):
			$".".set_global_position(Vector2(enemy_pos.x+0.5+(speed*35*cos(deg_to_rad(ball_angle))),enemy_pos.y+6+(speed*45*sin(deg_to_rad(ball_angle)))))
		else:
			$".".set_global_position(Vector2(+1203.0+(speed*75*cos(deg_to_rad(ball_angle))),-102+(speed*85*sin(deg_to_rad(ball_angle)))))
		speed += 0.05
		if $".".global_position.y > -100.0 or $".".global_position.y < -390.0 or $".".global_position.x > 2340 or $".".global_position.x < 60 :
			limiter_off = false
			$AnimatedSprite2D.play("disappear")
			$CollisionShape2D.set_deferred("disabled",true)
			await $AnimatedSprite2D.animation_finished
			$".".queue_free()
func _on_area_entered(area: Area2D) -> void:#to determine if the player will be damaged or it is being parried
	if area == $"../Player_0/parry":
		limiter_off = false
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimatedSprite2D.play("disappear")
		await $AnimatedSprite2D.animation_finished
		$".".queue_free()
	if area == $"../Player_0/damage_player":
		limiter_off = false
		$CollisionShape2D.set_deferred("disabled",true)
		$"../Player_0".player_damage(1)
		$AnimatedSprite2D.play("disappear")
		await $AnimatedSprite2D.animation_finished
		$".".queue_free()
#endregion
