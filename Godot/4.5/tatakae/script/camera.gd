extends Camera2D
#for the camera effects and movement, there isnt too much in this file so i didnt bother explaing
var flag:int = 1
@onready var camerashakenoise : FastNoiseLite = FastNoiseLite.new()
func _process(_delta: float) -> void:
	$"../../health_bar".global_position = $".".get_target_position() - Vector2(180.0,-130.0)
	$"../../UI".global_position = $".".get_target_position() - Vector2(0,-116.0)
	if Input.is_action_pressed("cam_up") or Input.is_action_pressed("cam_down"):
		var direction = Input.get_axis("cam_down","cam_up")
		if direction == 1.0:
			$".".offset.y = lerp($".".offset.y,-70.0,0.1)
			flag = 0
		if direction == -1.0:
			$".".offset.y = lerp($".".offset.y,55.0,0.1)
			flag = 0
	if not (Input.is_action_pressed("cam_down") or Input.is_action_pressed("cam_up")) and flag ==0:
		$".".offset.y = lerp($".".offset.y,0.0,0.1)
		if $".".offset.y >= -0.02 and $".".offset.y <= 0.02:
			flag = 1
func camera_shake(intensity:float):
	var cameraoff = camerashakenoise.get_noise_1d(Time.get_ticks_msec())*intensity
	$".".offset.x = cameraoff
	$".".offset.y = cameraoff
