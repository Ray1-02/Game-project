extends CharacterBody2D
#region onready variables
@onready var animation = $animation
@onready var player = $"../Player_0"
@onready var game = $"../health_bar"
@onready var anim_play = $AnimationPlayer
#endregion
#region constant
const spawnvfx = preload("res://scenes/spawn_vfx.tscn")
const piller_attack = preload("res://scenes/piller_attack.tscn")
const ball_attack = preload("res://scenes/ball_attack.tscn")
const drop_attack = preload("res://scenes/drop_attack.tscn")
const END_GAME = preload("res://scenes/end_game.tscn")
#endregion
#region variables
var spin : bool = false
var earthquack : bool = false
var spawn_var: int = 0
var spawn : Node2D
var look : bool = false
var side_change : bool = false
var health : int = 46
var timer_attack : float = 0.0
var timer : float = 0.0
var stage2 : bool = false
var lock :bool = false
var piller :Array = []
var piller_ins :Node2D
var attack_3 :bool = true
var stage_in_between :bool = false
var attack_4_positioning :bool = false
var can_drop :bool = false
var waite :bool = true
var attack_player_position :Vector2 = Vector2(0.0,0.0)
var strike :bool = false
var hex :bool = true
var false_fire :int = 0
#endregion
#region functions
func flip_enemy():#				to flip the enemy and face the player
	if player.global_position.x < $".".global_position.x and animation.animation != "transform" and not lock:
		scale.x = scale.y * 1
		look = true
		if scale.x == -1.0:
			side_change = true
	elif player.global_position.x > $".".global_position.x and animation.animation != "transform" and not lock:
		scale.x = scale.y * -1
		look = false
		if scale.x == -1.0:
			side_change = true
func stage1_animation():#		to animate the enemy at stage one and do the transition between the stages
	if stage2 == false:
		match health:
			45:
				animation.play("damage00")
			44:
				animation.play("damage01")
			43:
				animation.play("damage02")
			42:
				animation.play("damage03")
			41:
				animation.play("damage04")
			40:
				animation.play("damage05")
			39:
				animation.play("damage06")
			38:
				animation.play("damage07")
			37:
				animation.play("damage08")
			36:
				animation.play("damage09")
			35:
				animation.play("damage10")
			34:
				animation.play("damage11")
			33:
				animation.play("damage12")
			32:
				animation.play("damage13")
			31:
				animation.play("damage14")
			30:
				animation.play("damage15")
			29:
				animation.play("damage16")
			28:
				animation.play("damage17")
			27:
				animation.play("damage18")
			26:
				animation.play("damage19")
			25:
				animation.play("damage20")
			24:
				animation.play("damage21")
			23:
				animation.play("damage22")
			22:
				animation.play("damage23")
			21:
				animation.play("damage24")
			20:
				animation.play("damage25")
			19:
				animation.play("damage26")
			18:
				animation.play("damage27")
			17:
				animation.play("damage28")
			16:
				animation.play("damage29")
			15:
				animation.play("damage30")
			14:
				animation.play("damage31")
			13:
				animation.play("damage32")
			12:
				animation.play("damage33")
			11:
				animation.play("damage34")
			10:
				animation.play("damage35")
			9:
				animation.play("damage36")
			8:
				animation.play("damage38")
			7:
				animation.play("damage39")
			6:
				animation.play("damage40")
			5:
				animation.play("damage41")
			4:
				animation.play("damage42")
			3:
				animation.play("damage43")
			2:
				animation.play("damage44")
			1:
				animation.play("damage45")
			0:
				player.get_node("damage_player/CollisionShape2D").set_deferred("disabled",true)
				stage_in_between = true
				player.fight = 2
				stage2 = true
				animation.play("transform")
				$stage01.set_deferred("disabled",true)
				$stage02.set_deferred("disabled",false)
				$damage/stage01.set_deferred("disabled",true)
				$damage/stage02.set_deferred("disabled",false)
				health = 40
				await animation.animation_finished
				player.get_node("damage_player/CollisionShape2D").set_deferred("disabled",false)
				stage_in_between = false
				player.fight = 1
				animation.play("idle")
func stage2_animation():#		to animate the enemy at stage two
	if stage2:
		animation.play("idle")
func heal():#					to add the regerative ablity to the enemy
	timer = 0.0
	if health < 45 and animation.animation != "transform":
		health += 1
		stage1_animation()
func attack_pattern():#			to determine which attack will happen when will happen and how will happen, includes both stage 1 an 2, also calculates the enemy damage
	if (timer_attack >= 1.5 and not stage2) or (stage2 and timer_attack >= 2.0):
		timer_attack = 0.0
		var attack_sequence :int
		if stage2 and health > 0:
			if false_fire == 1:
				attack_sequence = 4
				false_fire = 0
			else:
				attack_sequence = randi_range(2,5)
		elif stage2 and health <=0:
			get_tree().paused = true
			var end_game = END_GAME.instantiate()
			$"..".add_child(end_game)
			end_game.set_global_position($"../Player_0/Camera2D".get_target_position())
		elif health > 40:
			attack_sequence = 1
		elif health <= 40 and health > 35:
			attack_sequence = 2
		elif health <= 35 and health >20:
			attack_sequence = 3
		elif health <= 20 and health >15:
			attack_sequence = randi_range(1,2)
		elif health <= 15 and health > 0:
			attack_sequence = randi_range(1,3)
		else:
			attack_sequence = 0
		match attack_sequence:
			1:
				if not anim_play.is_playing():
					anim_play.play("laser")
			2:
				if len(piller) == 0:
					var starting_point :float
					if stage2:
						starting_point = $".".global_position.x - randf_range(25.0,50.0)
					else:
						starting_point = $".".global_position.x - randf_range(50.0,80.0)
					while starting_point > 50.0:
						piller_ins = piller_attack.instantiate()
						piller.append(piller_ins)
						piller_ins.get_node("damage/CollisionShape2D").set_deferred('disabled',true)
						$"..".add_child(piller_ins)
						piller_ins.set_global_position(Vector2(starting_point,-102))
						piller_ins.get_node("GPUParticles2D").process_material.gravity.y = -2
						piller_ins.get_node("GPUParticles2D").emitting = true
						if stage2:
							starting_point -= 70.0
						else:
							starting_point -= 100.0
					if stage2:
						starting_point = $".".global_position.x + randf_range(25.0,50.0)
					else:
						starting_point = $".".global_position.x + randf_range(50.0,80.0)
					while starting_point < 2350.0:
						piller_ins = piller_attack.instantiate()
						piller.append(piller_ins)
						piller_ins.get_node("damage/CollisionShape2D").set_deferred('disabled',true)
						$"..".add_child(piller_ins)
						piller_ins.set_global_position(Vector2(starting_point,-102))
						piller_ins.get_node("GPUParticles2D").process_material.gravity.y = -2
						piller_ins.get_node("GPUParticles2D").emitting = true
						if stage2:
							starting_point += 70.0
						else:
							starting_point += 100.0
					get_tree().create_timer(1.5).timeout.connect(piller_activate)
					await get_tree().create_timer(6).timeout
					for i in range(0,len(piller)):
						piller[i].get_node("GPUParticles2D").emitting = false
					await get_tree().create_timer(0.6).timeout
					for i in range(0,len(piller)):
						piller[i].get_node("damage/CollisionShape2D").set_deferred('disabled',true)
					await get_tree().create_timer(1.4).timeout
					while len(piller) != 0:
						piller[0].queue_free()
						piller.erase(piller[0])
				elif health <= 15 and not stage2:
					anim_play.play("laser")
				elif stage2:
					if attack_3:
						attack_3 = false
						var last_pos :float
						last_pos = 90.0
						var projectile_ins :Array = []
						var enemy_position :Vector2 = $".".global_position
						if stage2:
							while last_pos < 431:
								var projetile  = ball_attack.instantiate()
								$"..".add_child(projetile)
								projectile_ins.append(projetile)
								projetile.set_global_position(Vector2(enemy_position.x+0.5+(35*cos(deg_to_rad(last_pos))),enemy_position.y+6+(45*sin(deg_to_rad(last_pos)))))
								projetile.fire(last_pos,enemy_position)
								last_pos += 20
								await get_tree().create_timer(0.2).timeout
							await projectile_ins[-1].get_node("AnimatedSprite2D").animation_finished
							for i in range(0,len(projectile_ins)):
								if projectile_ins[i] != null:
									projectile_ins[i].release(true)
							attack_3 = true
				else:
					pass
			3:
				if attack_3:
					attack_3 = false
					var last_pos :float
					if stage2:
						last_pos = 90.0
					else:
						last_pos = 180.0
					var projectile_ins :Array = []
					var enemy_position :Vector2 = $".".global_position
					if stage2:
						while last_pos < 431:
							var projetile  = ball_attack.instantiate()
							$"..".add_child(projetile)
							projectile_ins.append(projetile)
							projetile.set_global_position(Vector2(enemy_position.x+0.5+(35*cos(deg_to_rad(last_pos))),enemy_position.y+6+(45*sin(deg_to_rad(last_pos)))))
							projetile.fire(last_pos,enemy_position)
							last_pos += 20
							await get_tree().create_timer(0.2).timeout
						await projectile_ins[-1].get_node("AnimatedSprite2D").animation_finished
						for i in range(0,len(projectile_ins)):
							if projectile_ins[i] != null:
								projectile_ins[i].release(true)
						attack_3 = true
					else:
						while last_pos < 361:
							var projetile  = ball_attack.instantiate()
							$"..".add_child(projetile)
							projectile_ins.append(projetile)
							projetile.set_global_position(Vector2(+1203.0+(75*cos(deg_to_rad(last_pos))),-102+(85*sin(deg_to_rad(last_pos)))))
							projetile.fire(last_pos,Vector2(0.0,0.0))
							last_pos += 10
							await get_tree().create_timer(0.2).timeout
						await projectile_ins[-1].get_node("AnimatedSprite2D").animation_finished
						for i in range(0,len(projectile_ins)):
							if projectile_ins[i] != null:
								projectile_ins[i].release(true)
						attack_3 = true
				else:
					false_fire += 1
			4:
				if player.is_on_floor() and not attack_4_positioning and len(piller) == 0:
					animation.play("roll_up")
					attack_player_position = player.global_position
					$damage/stage02.set_deferred("disabled",true)
					$stage02.set_deferred("disabled",true)
					attack_4_positioning = true
				else:
					false_fire += 1
			5:
				if not strike and not attack_4_positioning:
					attack_player_position = player.global_position
					$damage/stage02.set_deferred("disabled",true)
					$stage02.set_deferred("disabled",true)
					$attack/strike.set_deferred("disabled",false)
					animation.play("roll_up")
					await animation.animation_finished
					spin = true
					await get_tree().create_timer(0.5).timeout
					strike = true
				else:
					false_fire += 1
func piller_activate():#		to activate the piller attack 
	var count :int = len(piller)
	while count != 0:
		piller[count-1].get_node("GPUParticles2D").process_material.gravity.y = -100.0
		piller[count-1].get_node("damage/CollisionShape2D").set_deferred('disabled',false)
		count -= 1
func attack_look_lock():#		to lock player while the enemy transitions between the stages
	lock = true
	await anim_play.animation_finished
	lock = false
func lazer_area(con):#			to change the size of the collition box of the lazer over time
	var laser :CollisionShape2D = $attack/laser
	match con:
		0:
			if look:
				laser.shape.size = Vector2(46.0,24.0)
				laser.global_position = Vector2(1146.0,-140.0)
			else:
				laser.shape.size = Vector2(46.0,24.0)
				laser.global_position = Vector2(1260.0,-140.0)
		1:
			if look:
				laser.shape.size = Vector2(160.0,24.0)
				laser.global_position = Vector2(1089.0,-140.0)
			else:
				laser.shape.size = Vector2(160.0,24.0)
				laser.global_position = Vector2(1317,-140.0)
		2:
			if look:
				laser.shape.size = Vector2(325.0,24.0)
				laser.global_position = Vector2(1006.0,-140.0)
			else:
				laser.shape.size = Vector2(325.0,24.0)
				laser.global_position = Vector2(1400.0,-140.0)
		3:
			if look:
				laser.shape.size = Vector2(1120.0,24.0)
				laser.global_position = Vector2(609.0,-140.0)
			else:
				laser.shape.size = Vector2(1120.0,24.0)
				laser.global_position = Vector2(1797.0,-140.0)
		4:
			if look:
				laser.shape.size = Vector2(325.0,24.0)
				laser.global_position = Vector2(210.0,-140.0)
			else:
				laser.shape.size = Vector2(325.0,24.0)
				laser.global_position = Vector2(2196.0,-140.0)
		5:
			if look:
				laser.shape.size = Vector2(160.0,24.0)
				laser.global_position = Vector2(129.0,-140.0)
			else:
				laser.shape.size = Vector2(160.0,24.0)
				laser.global_position = Vector2(2277.0,-140.0)
		6:
			if look:
				laser.shape.size = Vector2(46.0,24.0)
				laser.global_position = Vector2(72.0,-140.0)
			else:
				laser.shape.size = Vector2(46.0,24.0)
				laser.global_position = Vector2(2334.0,-140.0)
		7:
			laser.shape.size = Vector2(24.0,24.0)
			laser.global_position = Vector2(1203.0,-40.0)
func summon():#					to controll the particles during the spawn of the enemy
	spawn = spawnvfx.instantiate()
	$"..".add_child(spawn)
	spawn.set_global_position(Vector2(1201.0,-102.0))
	spawn.get_node("GPUParticles2D").process_material.directional_velocity_curve.curve_x.clear_points()
	spawn.get_node("GPUParticles2D").process_material.directional_velocity_curve.curve_x.add_point(Vector2(0.0,1.0))
	spawn.get_node("GPUParticles2D").process_material.directional_velocity_curve.curve_x.add_point(Vector2(0.22,0.0))
	spawn.get_node("GPUParticles2D").process_material.directional_velocity_curve.curve_x.add_point(Vector2(1.0,0.0))
	spawn.get_node("GPUParticles2D").emitting = true
	animation.play("appear")
	earthquack = true
	await get_tree().create_timer(2.1).timeout
	spawn_var = 1
	await get_tree().create_timer(4.7).timeout
	spawn.get_node("GPUParticles2D").emitting = false
	earthquack = false
	await animation.animation_finished
	game.visible = true
	game.play("appear_health")
	animation.play("damage00")
	await game.animation_finished
	player.fight = 1
func _on_attack_area_entered(area: Area2D) -> void:# to fire the calculation for player damage and to disable collition for parry to take effect
	if area == $"../Player_0/parry" and strike:
		$attack/strike.set_deferred("disabled",true)
	if area == $"../Player_0/damage_player":
		player.player_damage(1)
		$attack/laser.set_deferred("disabled",true)
func _physics_process(delta: float) -> void:# i can't explain there is too much, just read the whole thing, i should have done the commenting while i was writting the code T_T
	if Restart.rerun:
		game.visible = true
		game.play("damage_0")
		animation.play("damage00")
	timer += delta
	timer_attack += delta
	if earthquack:
		var camera_tween = get_tree().create_tween()
		camera_tween.tween_method($"../Player_0/Camera2D".camera_shake,1.0,0.0,0.1)
	if spin:
		if animation.rotation >= -355:
			animation.rotation -= 0.5
		else:
			animation.rotation = 0
	if timer >= 3.0 and not stage2:
		heal()
	if attack_4_positioning and waite:
		if can_drop:
			if $".".global_position.y <= -137.0 :
				$".".global_position.y = lerp($".".global_position.y,-105.0,0.1)
				return
			else:
				var camera_tween = get_tree().create_tween()
				camera_tween.tween_method($"../Player_0/Camera2D".camera_shake,8.0,0.0,0.8)
				animation.play("idle")
				waite = false
				can_drop = false
				return
		if $".".global_position.y >= attack_player_position.y - 98:
			$".".global_position = lerp($".".global_position,attack_player_position + Vector2(+3,-100),0.5)
			return
		var drop = drop_attack.instantiate()
		$".".add_child(drop)
		drop.set_global_position(Vector2($".".global_position.x,$".".global_position.y+36))
		drop.activate()
		drop.get_node("GPUParticles2D").emitting = true
		waite = false
		await get_tree().create_timer(1).timeout
		can_drop = true
		waite = true
	if spawn_var == 1:
		spawn.global_position.y = move_toward(spawn.global_position.y,-170.0,0.28)
		if spawn.global_position.y <= -146 and spawn.get_node("GPUParticles2D").lifetime >= 0.01:
			var curve = spawn.get_node("GPUParticles2D").process_material.directional_velocity_curve.curve_x
			curve.add_point(Vector2(curve.get_point_position(1).x - 0.001,0.0))
			spawn.get_node("GPUParticles2D").lifetime -= 0.01
			spawn.get_node("GPUParticles2D").amount_ratio -= 0.01
		elif spawn.get_node("GPUParticles2D").lifetime <= 0.01:
			spawn_var = 0
			spawn.queue_free()
	if player.fight == 1:
		attack_pattern()
	flip_enemy()
	if strike:
		lock = true
		if look:
			if player.is_on_floor():
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x - 100 ,attack_player_position.y-14),0.1)
				if $".".global_position.x <= attack_player_position.x-95 or $".".global_position.x > 2150 or $".".global_position.x < 200:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
				return
			if attack_player_position.y - 49 < $".".global_position.y and hex:
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x - 100 ,attack_player_position.y - 50),0.2)
				if $".".global_position.x <= attack_player_position.x-95 or $".".global_position.x > 2150 or $".".global_position.x < 200 or $".".global_position.y >= -137.0 or $".".global_position.y < attack_player_position.y - 49:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
			else:
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x - 100 ,attack_player_position.y + 50),0.2)
				hex = false
				if $".".global_position.x <= attack_player_position.x-95  or $".".global_position.x > 2150 or $".".global_position.x < 200 or $".".global_position.y >= -137.0:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					hex = true
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
		else:
			if player.is_on_floor():
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x + 100 ,attack_player_position.y - 14),0.1)
				if $".".global_position.x >= attack_player_position.x+95 or $".".global_position.x > 2150 or $".".global_position.x < 200:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
				return
			if attack_player_position.y - 49 < $".".global_position.y and hex:
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x + 100 ,attack_player_position.y - 50),0.2)
				if $".".global_position.x >= attack_player_position.x+95 or $".".global_position.x > 2150 or $".".global_position.x < 200 or $".".global_position.y >= -137.0 or $".".global_position.y < attack_player_position.y - 49:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
			else:
				$".".global_position = lerp($".".global_position,Vector2(attack_player_position.x + 100 ,attack_player_position.y + 50),0.2)
				hex = false
				if $".".global_position.x >= attack_player_position.x+95 or $".".global_position.x > 2150 or $".".global_position.x < 200 or $".".global_position.y >= -137.0:
					lock = false
					strike = false
					spin = false
					animation.rotation = 0
					hex = true
					$stage02.set_deferred("disabled",false)
					$damage/stage02.set_deferred("disabled",false)
					$attack/strike.set_deferred("disabled",true)
					animation.play("idle")
func _ready() -> void:
	$stage01.set_deferred("disabled",false)
	$stage02.set_deferred("disabled",true)
	$damage/stage01.set_deferred("disabled",false)
	$damage/stage02.set_deferred("disabled",true)
	$attack/laser.set_deferred("disabled",true)
	$attack/strike.set_deferred("disabled",true)
#endregion
