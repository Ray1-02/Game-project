extends Node2D
#its litrally the name of the functions
@onready var player = $"../Player_0"
func _on_start_pressed() -> void:
	if Restart.rerun:
		Restart.rerun = false
		player.fight = 1
		$".".hide()
		return
	player.go = true
	$".".hide()
func _on_conntrol_pressed() -> void:
	$PanelContainer/control.show()
	$PanelContainer/main_menu.hide()
	$PanelContainer/restart_menu.hide()
	$PanelContainer/pause_menu.hide()
func _on_resume_pressed() -> void:
	get_tree().paused = false
	$".".hide()
func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_restart_pressed() -> void:
	Restart.restart()
func _on_back_pressed() -> void:
	if get_tree().paused == true:
		if player.health == 0:
			$PanelContainer/control.hide()
			$PanelContainer/restart_menu.show()
			$PanelContainer/restart_menu/restart.grab_focus()
			return
		$PanelContainer/control.hide()
		$PanelContainer/pause_menu.show()
		$PanelContainer/pause_menu/resume.grab_focus()
		return
	$PanelContainer/control.hide()
	$PanelContainer/main_menu.show()
func main_men():
	$PanelContainer/main_menu.show()
	$PanelContainer/pause_menu.hide()
	$PanelContainer/restart_menu.hide()
	$PanelContainer/control.hide()
func pause_menu():
	$PanelContainer/main_menu.hide()
	$PanelContainer/control.hide()
	$PanelContainer/restart_menu.hide()
	$PanelContainer/pause_menu.show()
	$PanelContainer/pause_menu/resume.grab_focus()
func restart_menu():
	$PanelContainer/main_menu.hide()
	$PanelContainer/control.hide()
	$PanelContainer/pause_menu.hide()
	$PanelContainer/restart_menu.show()
	$PanelContainer/restart_menu/restart.grab_focus()
func _process(_delta: float) -> void:
	if get_viewport().gui_get_focus_owner() == null and $PanelContainer/main_menu.is_visible_in_tree():
		if Input.is_action_just_pressed("ui_up"):
			$PanelContainer/main_menu/exit.grab_focus()
		if Input.is_action_just_pressed("ui_down"):
			$PanelContainer/main_menu/start.grab_focus()
