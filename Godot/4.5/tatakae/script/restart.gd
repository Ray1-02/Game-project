extends Node
var rerun :bool = false
func restart():
	rerun = true
	get_tree().reload_current_scene()
	get_tree().paused = false
	Engine.time_scale = 1
