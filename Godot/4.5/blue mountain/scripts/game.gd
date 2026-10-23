extends Node2D
var ob1 = preload("res://scenes/obstical1.tscn")
var ob2 = preload("res://scenes/obstical2.tscn")
var ob3 = preload("res://scenes/obssstical3.tscn")
var ob4 = preload("res://scenes/obstical4.tscn")
var ob5 = preload("res://scenes/obstical5.tscn")
var ob6 = preload("res://scenes/obstical6.tscn")
var ob := [ob1,ob2,ob3,ob4,ob5,ob6]
var obs : Array
var count : int = 0
var last
var size : Vector2i
var floor_h : int
var score : int
var start : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	$CanvasLayer.hide()
	$Score.get_node("Highscore").text = "Highscore: "+str(global.highscr)
	$Score.get_node("start").show()
	$Score.get_node("control").show()
	score = 0
	size = get_window().size
	floor_h = $floor.get_node("Sprite2D").texture.get_height()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start:
		genarate()
		if score < 300 :
			$killzone.position.x += 1
		elif 300 < score and score < 600:
			$killzone.position.x += 3
		elif 600 < score and score < 1200:
			$killzone.position.x += 4
		elif 1200 < score and score < 2000:
			$killzone.position.x += 4.2
		else:
			$killzone.position.x += 4.5
		score = ($player.position.x - 337.0)/4
		score1()
		if $player.position.x - $floor.position.x > size.x * 1.22:
			$floor.position.x += size.x
	else:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
			start = true
			$Score.get_node("start").hide()
			$Score.get_node("control").hide()
func genarate():
	if obs.is_empty() or last < $player.position.x:
		var type = ob[randi()% ob.size()]
		var obs1
		obs1 = type.instantiate()
		var height = obs1.get_node("Sprite2D").texture.get_height()
		var scal = obs1.get_node("Sprite2D").scale
		var obs1_x : int = $player.position.x + randi_range(300,450)
		var obs1_y : int = floor_h - (height * scal.y) +32
		last = obs1_x
		if len(obs)>3:
			obs[0].queue_free()
			obs.erase(obs[0])
		generate1(obs1,obs1_x,obs1_y)
func generate1(obs1,obs1_x,obs1_y):
	obs1.position = Vector2i(obs1_x,obs1_y)
	add_child(obs1)
	obs.append(obs1)
func score1():
	$Score.get_node("score").text = "Score: "+str(score)
	if global.highscr<score:
		global.highscr=score
		$Score.get_node("Highscore").text = "Highscore: "+str(global.highscr)

func _on_killzone_body_entered(body: Node2D) -> void:
	$CanvasLayer.show()
	get_tree().paused = true
	$CanvasLayer/Button.pressed.connect(restart)
		#restart()
func restart():
	get_tree().reload_current_scene()
