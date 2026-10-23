extends Node
#region variable
var timer1: float = 0.0
var timer2: float = 0.0
var shootfall_1_a : Array
var shootfall_2_a : Array
var shootfall_3_a : Array
var starblink_0_a : Array
var starblink_1_a : Array
var starblink_2_a : Array
var starblink_3_a : Array
@onready var cam = $Player_0/Camera2D
#endregion
#region constant
#time = no.frame/(fps*speed)
const shootfall1 = preload("res://scenes/shooting_start_1.tscn")
#time1 = 3.2sec
const shootfall2 = preload("res://scenes/shooting_star_2.tscn")
#time2 = 6.64sec
const shootfall3 = preload("res://scenes/shooting_star_3.tscn")
#time3 = 2.16sec
const starblink = preload("res://scenes/0star.tscn")
#time4 = 0.32sec
const starblink1 = preload("res://scenes/star_0.tscn")
#time5 = 0.48sec
const starblink2 = preload("res://scenes/star0.tscn")
#time6 = 0.64sec
const starblink3 = preload("res://scenes/star.tscn")
#time7 = 0.8sec
#endregion
#region functions
#coordinate to spawn
func star_co ():
	var x_cam = cam.get_global_position().x - 297 -150
	var x = randi_range(x_cam,x_cam+594+300)
	var y = randi_range(-110,-388)
	# moon coordinate x 820 930 y -205 -315
	var pos = Vector2(x,y)
	return pos
func shoot_co ():
	var x_cam = cam.get_global_position().x - 297 -150
	var x = randi_range(x_cam,x_cam+594+300)
	var y = randi_range(-110,-388)
	# moon coordinate x 820 930 y -205 -315
	var pos = Vector2(x,y)
	return pos
#to spawn star
func spawn_star():
	if len(starblink_0_a)<=10:
		var starblink_0 = starblink.instantiate()
		starblink_0_a.append(starblink_0)
		$Parallax2D3.add_child(starblink_0)
		starblink_0.set_global_position(star_co())
		starblink_0.animation_finished.connect(star_del0)
	elif len(starblink_1_a)<=10:
		var starblink_1 = starblink1.instantiate()
		starblink_1_a.append(starblink_1)
		$Parallax2D3.add_child(starblink_1)
		starblink_1.set_global_position(star_co())
		starblink_1.animation_finished.connect(star_del1)
	elif len(starblink_2_a)<=5:
		var starblink_2 = starblink2.instantiate()
		starblink_2_a.append(starblink_2)
		$Parallax2D3.add_child(starblink_2)
		starblink_2.set_global_position(star_co())
		starblink_2.animation_finished.connect(star_del2)
	else:
		var star_var
		star_var = [starblink,starblink1,starblink2,starblink3].pick_random()
		match star_var:
			starblink:
				var starblink_0 = starblink.instantiate()
				starblink_0_a.append(starblink_0)
				$Parallax2D3.add_child(starblink_0)
				starblink_0.set_global_position(star_co())
				starblink_0.animation_finished.connect(star_del0)
			starblink1:
				var starblink_1 = starblink1.instantiate()
				starblink_1_a.append(starblink_1)
				$Parallax2D3.add_child(starblink_1)
				starblink_1.set_global_position(star_co())
				starblink_1.animation_finished.connect(star_del1)
			starblink2:
				var starblink_2 = starblink2.instantiate()
				starblink_2_a.append(starblink_2)
				$Parallax2D3.add_child(starblink_2)
				starblink_2.set_global_position(star_co())
				starblink_2.animation_finished.connect(star_del2)
			starblink3:
				var starblink_3 = starblink3.instantiate()
				starblink_3_a.append(starblink_3)
				$Parallax2D3.add_child(starblink_3)
				starblink_3.set_global_position(star_co())
				starblink_3.animation_finished.connect(star_del3)
#to spawn shooting star
func spawn_shoot():
	if len(shootfall_3_a)<=40:
		var shootfall_3 = shootfall3.instantiate()
		shootfall_3_a.append(shootfall_3)
		$Parallax2D3.add_child(shootfall_3)
		shootfall_3.set_global_position(shoot_co())
		shootfall_3.animation_finished.connect(shoot_del3)
	else:
		var shoot_var
		shoot_var = [shootfall1,shootfall2,shootfall3].pick_random()
		match shoot_var:
			shootfall1:
				var shootfall_1 = shootfall1.instantiate()
				shootfall_1_a.append(shootfall_1)
				$Parallax2D3.add_child(shootfall_1)
				shootfall_1.set_global_position(shoot_co())
				shootfall_1.animation_finished.connect(shoot_del1)
			shootfall2:
				var shootfall_2 = shootfall2.instantiate()
				shootfall_2_a.append(shootfall_2)
				$Parallax2D3.add_child(shootfall_2)
				shootfall_2.set_global_position(shoot_co())
				shootfall_2.animation_finished.connect(shoot_del2)
			shootfall3:
				var shootfall_3 = shootfall3.instantiate()
				shootfall_3_a.append(shootfall_3)
				$Parallax2D3.add_child(shootfall_3)
				shootfall_3.set_global_position(shoot_co())
				shootfall_3.animation_finished.connect(shoot_del3)
#to delete node which is done animating
func shoot_del1():
	shootfall_1_a[0].queue_free()
	shootfall_1_a.erase(shootfall_1_a[0])
func shoot_del2():
	shootfall_2_a[0].queue_free()
	shootfall_2_a.erase(shootfall_2_a[0])
func shoot_del3():
	shootfall_3_a[0].queue_free()
	shootfall_3_a.erase(shootfall_3_a[0])
func star_del0():
	starblink_0_a[0].queue_free()
	starblink_0_a.erase(starblink_0_a[0])
func star_del1():
	starblink_1_a[0].queue_free()
	starblink_1_a.erase(starblink_1_a[0])
func star_del2():
	starblink_2_a[0].queue_free()
	starblink_2_a.erase(starblink_2_a[0])
func star_del3():
	starblink_3_a[0].queue_free()
	starblink_3_a.erase(starblink_3_a[0])
func _process(delta: float) -> void:
	timer1 += delta
	if timer1>=0.04: #0.04 is the optimum
		spawn_shoot()
		timer1=0.0
	timer2 +=delta
	if timer2 >=0.015: #0.015 is the optimum
		spawn_star()
#endregion
