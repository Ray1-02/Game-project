extends Node2D
#region declaretions
var run :bool = true
const curve2 = preload("res://curve/drop_attack_dv_curv_x_2.tres")
const curve1 = preload("res://curve/drop_attack_dv_curv_x.tres")
@onready var player = $"..".player
#endregion
#region functions
func _process(_delta: float) -> void:
	if global_position.y >= -102.0 and $GPUParticles2D.emitting and run:
		run = false
		$GPUParticles2D.process_material.gravity.y = -30.0
		$GPUParticles2D.process_material.directional_velocity_curve.curve_x = curve2
		await get_tree().create_timer(0.5).timeout
		$damage/CollisionShape2D.global_position.y += 24
		$damage/CollisionShape2D.shape.size = Vector2(386,14)
		await get_tree().create_timer(1).timeout
		$GPUParticles2D.emitting = false
		await get_tree().create_timer(1).timeout
		$damage/CollisionShape2D.global_position.y -= 24
		queue_free()
		$"../damage/stage02".set_deferred("disabled",false)
		$"../stage02".set_deferred("disabled",false)
		$"..".attack_4_positioning = false
		$"..".waite = true
func activate():# for activaing the paticales in the drop attack
	$GPUParticles2D.process_material.gravity.y = -100.0
	$GPUParticles2D.process_material.directional_velocity_curve.curve_x = curve1
	$damage/CollisionShape2D.shape.size = Vector2(47,42)
func _on_damage_area_entered(area: Area2D) -> void:#to inflect damage onplayer
	if area == player.get_node("damage_player"):
		player.player_damage(1)
#endregion
