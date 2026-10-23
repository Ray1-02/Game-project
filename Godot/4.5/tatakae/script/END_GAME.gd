extends RichTextLabel
#for the end game credit and message
var timer : float = 0
var timer_colorrect :float = 0
var fade : bool = false
func _process(delta: float) -> void:
	timer += delta
	timer_colorrect += delta
	if $"../../../ColorRect".color.a < 1.0 and not fade and timer_colorrect >= 0.03:
		$"../../../ColorRect".color.a += 0.01
	elif $"../../../ColorRect".color.a >= 1.0:
		fade = true
		$"..".show()
	if timer >= 0.03 and visible_ratio <=1.0 and fade:
		timer = 0
		visible_ratio += 0.008
	elif visible_ratio >= 1.0:
		await get_tree().create_timer(10).timeout
		get_tree().quit()
func _ready() -> void:
	$"../../../ColorRect".global_position = $"../../../Player_0/Camera2D".get_target_position() + Vector2(-325,-175)
