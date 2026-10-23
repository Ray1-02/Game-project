extends CharacterBody2D
#region variables
var jump_force :float = 388.0
var jump_acceleretion :float = 290.0
var speed :int = 200
var gravity :float = 500.0
var flag :int = 1
var flag2 :int = 1
var landing :int = 1
var start :int = 0
var stop :int = 0
var timer :float = 0.0
var timer_attack :float = 0.0
var fight :int = 2
var length :int = 0
var posistion_doge :float = 0.0
var doge_val :int = 0
var timer_jump :float = 0.0
var start_timer_jump :int = 0
var look :bool = true
var side_change :bool = false
var side_change_forward :bool = false
var recoil_pos :float = 0.0
var collide :bool = true
var health :int = 15
var after_damage_forward :bool = false
var after_damage_backward :bool = false
var collistion_diactivation  :bool = true
var collistion_activation :bool = true
var parry :bool = false
var direction :float = 0.0
var run :bool = false
var back :bool = false
var go :bool = false
#endregion
#region onready variables
@onready var enemy_1 :CharacterBody2D = get_node("../enemy-1")
@onready var anim_play :AnimationPlayer = $AnimationPlayer
@onready var health_bar :AnimatedSprite2D = $"../health_bar"
#endregion
#functions
#region user defined
func position():#					for the movement before the game starts
	if (go or start == 1) and timer >= 0.015:
		timer = 0.0
		go = false
		$".".global_position.x = move_toward($".".global_position.x,1052.082,0.85)
		var pre :AnimatedSprite2D = $"pre-game_movement"
		if start == 0:
			start = 1
			pre.play("start")
			await pre.animation_finished
			pre.play("walk")
		if $".".global_position.x >= 1052.082 and stop == 0:
			stop = 1
			start = 2
			pre.play("stop")
			await pre.animation_finished
			pre.play("hat_fly")
			await pre.animation_finished
			$"../Floor".play("default")
			await $"../Floor".animation_finished
			enemy_1.summon()
			pre.play("ready")
			await pre.animation_finished
			$Camera2D.drag_left_margin = 0.5
			$Camera2D.drag_right_margin = 0.5
			pre.hide()
			$game.show()
func animation():#					for player animation
	if anim_play.current_animation == "attack_3" or anim_play.current_animation == "parry" or doge_val == 1:
		return
	speed = 200
	$attack_player/CollisionShape2D.disabled = true
	if look:
		if not anim_play.is_playing():
			anim_play.play("idle")
		elif Input.is_action_just_pressed("Attack") and timer_attack >= 0.38:
			timer_attack = 0.0
			anim_play.play("attack_3",-1,2.8)
			if direction == 1.0:
				run = true
				await anim_play.animation_finished
				anim_play.play("runing")
				await anim_play.animation_finished
			elif direction == -1.0:
				back = true
				await anim_play.animation_finished
				anim_play.play("back")
				await anim_play.animation_finished
				if direction == -1.0:
					anim_play.play("back_con")
		elif Input.is_action_just_pressed("Parry"):
			anim_play.play("parry")
			if direction == 1.0:
				run = true
				await anim_play.animation_finished
				anim_play.play("run",-1,0.5)
				await anim_play.animation_finished
				if direction == 1.0:
					anim_play.play("runing")
			elif direction == -1.0:
				back = true
				await anim_play.animation_finished
				anim_play.play("back")
				await anim_play.animation_finished
				if direction == -1.0:
					anim_play.play("back_con")
		elif Input.is_action_just_pressed("Doge") and timer >= 0.26 and is_on_floor():
			doge_len()
			doge(1)
			anim_play.play("doge")
			if direction == 1.0:
				run = true
				await anim_play.animation_finished
				anim_play.play("run",-1,0.5)
				await anim_play.animation_finished
				if direction == 1.0:
					anim_play.play("runing")
			elif direction == -1.0:
				back = true
				await anim_play.animation_finished
				anim_play.play("back")
				await anim_play.animation_finished
				if direction == -1.0:
					anim_play.play("back_con")
		elif Input.is_action_just_pressed("ui_accept") and doge_val == 0 and direction == 0.0:
			anim_play.play("jump")
		elif (direction == 1.0 or (after_damage_forward) or (side_change_forward)) and not run:
			side_change_forward = false
			after_damage_forward = false
			back = false
			anim_play.play("run",-1,0.5)
			run = true
			await anim_play.animation_finished
			if direction == 1.0:
				anim_play.play("runing")
		elif direction == 0.0 and run:
			anim_play.play("stop")
			run = false
		elif (direction == -1.0 or (after_damage_backward) or (side_change)) and not back:
			side_change = false
			after_damage_backward = false
			run = false
			anim_play.play("back")
			back = true
			await anim_play.animation_finished
			if direction == -1.0:
				anim_play.play("back_con")
		elif direction == 0.0 and back:
			anim_play.play("back_stop")
			back = false
		return
	if not anim_play.is_playing():
		anim_play.play("idle")
	elif Input.is_action_just_pressed("Attack") and timer_attack >= 0.38:
		timer_attack = 0.0
		anim_play.play("attack_3",-1,2.8)
		if direction == -1.0:
			run = true
			await anim_play.animation_finished
			anim_play.play("runing")
			await anim_play.animation_finished
		elif direction == 1.0:
			back = true
			await anim_play.animation_finished
			anim_play.play("back")
			await anim_play.animation_finished
			if direction == 1.0:
				anim_play.play("back_con")
	elif Input.is_action_just_pressed("Parry"):
		anim_play.play("parry")
		if direction == -1.0:
			run = true
			await anim_play.animation_finished
			anim_play.play("run",-1,0.5)
			await anim_play.animation_finished
			if direction == 1.0:
				anim_play.play("runing")
		elif direction == 1.0:
			back = true
			await anim_play.animation_finished
			anim_play.play("back")
			await anim_play.animation_finished
			if direction == 1.0:
				anim_play.play("back_con")
	elif Input.is_action_just_pressed("Doge") and timer >= 0.26 and is_on_floor():
		doge_len()
		doge(1)
		anim_play.play("doge")
		if direction == -1.0:
			run = true
			await anim_play.animation_finished
			anim_play.play("run",-1,0.5)
			await anim_play.animation_finished
			if direction == -1.0:
				anim_play.play("runing")
		elif direction == 1.0:
			back = true
			await anim_play.animation_finished
			anim_play.play("back")
			await anim_play.animation_finished
			if direction == 1.0:
				anim_play.play("back_con")
	elif Input.is_action_just_pressed("ui_accept") and doge_val == 0 and direction == 0.0:
		anim_play.play("jump")
	elif (direction == -1.0 or (after_damage_forward) or (side_change_forward)) and not run:
		side_change_forward = false
		after_damage_forward = false
		back = false
		anim_play.play("run",-1,0.5)
		run = true
		await anim_play.animation_finished
		if direction == -1.0:
			anim_play.play("runing")
	elif direction == 0.0 and run:
		anim_play.play("stop")
		run = false
	elif (direction == 1.0 or (after_damage_backward) or (side_change)) and not back:
		side_change = false
		after_damage_backward = false
		run = false
		anim_play.play("back")
		back = true
		await anim_play.animation_finished
		if direction == 1.0:
			anim_play.play("back_con")
	elif direction == 0.0 and back:
		anim_play.play("back_stop")
		back = false
func moving_jump():#					for jump while moving in x-axis
	if Input.is_action_just_pressed("ui_accept") and doge_val == 0:
		start_timer_jump  = 1
	if timer_jump>0.0 and timer_jump <= 0.2007 and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		jump()
		start_timer_jump = 0
		timer_jump = 0.0
	elif timer_jump >= 0.2008:
		start_timer_jump = 0
		timer_jump = 0.0
func jump():#					for jump in y-axis
	if is_on_floor():
		velocity.y -= lerp(jump_force,jump_acceleretion,0.1)
		flag = 1
		landing = 0 
func fall():#					for the gravity that will pull the palyer down to the floor
	if not is_on_floor():
		if flag == 1 and not Input.is_action_pressed("ui_accept"):
			velocity.y = lerp(velocity.y,gravity,0.2)
			velocity.y *= 0.5
			flag = 0
	elif landing==0 and is_on_floor():
		if anim_play.current_animation == "jump":
			anim_play.play("landing")
		landing = 1
	else:
		return
func doge_len():#					for the length of the doge that is to be performed
	if doge_val == 0:
		posistion_doge = $".".global_position.x
func doge(a):#						for the doge that will avoided the attack from the enemy
	if (a==1 or length == 1) and timer >= 0.015 and $".".global_position.x >= 60.0 and $".".global_position.x <= 2345.0 and is_on_floor():
		length = 1 
		timer = 0.0
		doge_val = 1
		if look:
			$".".global_position.x = lerp($".".global_position.x,posistion_doge-70.0,0.25)
			if $".".global_position.x <= posistion_doge-68.0 or $".".global_position.x <= 60.0:
				length = 0
				doge_val = 0
		else:
			$".".global_position.x = lerp($".".global_position.x,posistion_doge+70.0,0.25)
			if $".".global_position.x >= posistion_doge+68.0 or $".".global_position.x >= 2345.0:
				length = 0
				doge_val = 0
func left_right():#					for the player to move in the x-axis
	var parry_speed :int = 50
	var attack_spped :int = 140
	direction = Input.get_axis("ui_left","ui_right")
	if anim_play.current_animation == "parry":
		velocity.x = parry_speed * direction
	elif anim_play.current_animation == "attack_3":
		velocity.x = attack_spped * direction
	elif doge_val == 0:
		velocity.x = speed * direction
	else:
		velocity.x = 0.0
func flip():#					for filping the player to face the enemy
	if (enemy_1.global_position.x > $".".global_position.x and is_on_floor()) or (enemy_1.global_position.x > $".".global_position.x and collide == false):
		scale.x = scale.y * 1
		look = true
		if scale.x == -1.0:
			if Input.is_action_pressed("ui_left"):
				side_change = true
			if Input.is_action_pressed("ui_right"):
				side_change_forward = true
	elif (enemy_1.global_position.x < $".".global_position.x and is_on_floor()) or (enemy_1.global_position.x < $".".global_position.x and collide == false):
		scale.x = scale.y * -1
		look = false
		if scale.x == -1.0:
			if Input.is_action_pressed("ui_right"):
				side_change = true
			if Input.is_action_pressed("ui_left"):
				side_change_forward = true
func player_damage_recoil():#	for the position from where the player showed be recoiling
	if collide:
		recoil_pos = $".".global_position.x
func player_collison():#		for deactivating the collision ditection to let the plyer room to breath
	collistion_diactivation = false
func player_damage(a=0):#		for diecting hit and applying damage and doing the actual recoil calculation
	if ($".".get_last_slide_collision() and $".".get_last_slide_collision().get_collider().name == "enemy-1") or a == 1:
		$damage_player/CollisionShape2D.set_deferred("disabled",true)
		fight = 2
		call_deferred("player_collison")
		run = false
		back = false
		health -= 1
		var camera_tween = get_tree().create_tween()
		camera_tween.tween_method($Camera2D.camera_shake,8.0,1.0,0.2)
		match health:
			15:
				health_bar.play("damage_0")
			14:
				health_bar.play("damage_01")
			13:
				health_bar.play("damage_02")
			12:
				health_bar.play("damage_03")
			11:
				health_bar.play("damage_04")
			10:
				health_bar.play("damage_05")
			9:
				health_bar.play("damage_06")
			8:
				health_bar.play("damage_07")
			7:
				health_bar.play("damage_08")
			6:
				health_bar.play("damage_09")
			5:
				health_bar.play("damage_10")
			4:
				health_bar.play("damage_11")
			3:
				health_bar.play("damage_12")
			2:
				health_bar.play("damage_13")
			1:
				health_bar.play("damage_14")
			0:
				health_bar.play("damage_15")
				get_tree().paused = true
				$"../UI".show()
				$"../UI".restart_menu()
	if collistion_diactivation == false or collide == false and timer >= 0.015 and $".".global_position.x >= 60.0 and $".".global_position.x <= 2345.0:
		timer = 0.0
		player_damage_recoil()
		collistion_diactivation = true
		collide = false
		flip()
		if look:
			$".".global_position.x = lerp($".".global_position.x,recoil_pos-80.0,0.15)
			Engine.time_scale = 0.5
			anim_play.play("back_con")
			velocity.x = 0.0
			if $".".global_position.x <= recoil_pos-75.0 or $".".global_position.x <= 60.0:
				collide = true
				if Input.is_action_pressed("ui_left"):
					after_damage_backward = true
				if Input.is_action_pressed("ui_right"):
					after_damage_forward = true
				Engine.time_scale = 1
				anim_play.play("back_stop")
				await anim_play.animation_finished
				if enemy_1.stage_in_between != true:
					fight = 1
		else:
			$".".global_position.x = lerp($".".global_position.x,recoil_pos+80.0,0.15)
			Engine.time_scale = 0.5
			anim_play.play("back_con")
			velocity.x = 0.0
			if $".".global_position.x >= recoil_pos+75.0 or $".".global_position.x >= 2345.0:
				collide = true
				if Input.is_action_pressed("ui_left"):
					after_damage_forward = true
				if Input.is_action_pressed("ui_right"):
					after_damage_backward = true
				Engine.time_scale = 1
				anim_play.play("back_stop")
				await anim_play.animation_finished
				if enemy_1.stage_in_between != true:
					fight = 1
	if enemy_1.stage_in_between != true and $damage_player/CollisionShape2D.disabled == true and collistion_activation:
		collistion_activation = false
		await get_tree().create_timer(2).timeout
		$damage_player/CollisionShape2D.set_deferred("disabled",false)
		collistion_activation = true
func parry_call():#				for parrying the projectile type attacks
	if !parry:
		parry = true
		$parry/CollisionShape2D.set_deferred("disabled",false)
#endregion
#region inbuilt
func _physics_process(delta: float) -> void:
	if Restart.rerun:
		$".".global_position.x = 1052.0820
		$"../Floor".set_frame_and_progress(105,0.0)
		$"pre-game_movement".hide()
		$Camera2D.drag_left_margin = 0.5
		$Camera2D.drag_right_margin = 0.5
		$game.show()
	if Input.is_action_just_pressed("ui_cancel") and start != 0:
		get_tree().paused = true
		$"../UI".show()
		$"../UI".pause_menu()
	velocity.y += gravity * delta
	timer += delta
	timer_attack += delta
	move_and_slide()
	player_damage()
	if start_timer_jump == 1:
		timer_jump += delta
	if anim_play.current_animation != "parry" and parry:
		$parry/CollisionShape2D.set_deferred("disabled",true)
		parry = false
	match fight:
		1:
			flip()
			animation()
			left_right()
			moving_jump()
			fall()
			if timer >= 0.86 or doge_val == 1:
				doge(0)
		0:
			position()
func _ready() -> void:
	$attack_player/CollisionShape2D.disabled = true
	$parry/CollisionShape2D.set_deferred("disabled",true)
	fight = 0
#endregion
