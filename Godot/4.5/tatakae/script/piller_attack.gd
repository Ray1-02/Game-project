extends Node2D
#region variables
@onready var player = $"../Player_0"
var timer :float = 0.0
var accel :float = 0.0
var pos :float = 0.0
#endregion
#region functions
func _on_damage_area_entered(area: Area2D) -> void:
	if area == $"../Player_0/damage_player":
		player.player_damage(1)
func _process(delta: float) -> void:
	timer += delta
	if $GPUParticles2D.process_material.gravity.y == -100.0 and timer >= 0.5:
		timer = 0.0
		accel += 0.6
		pos += 6.5
		$damage/CollisionShape2D.shape.size.y += accel
		$damage/CollisionShape2D.global_position.y -= pos
	if not $GPUParticles2D.emitting and $damage/CollisionShape2D.shape.size.y !=0.0:
		await get_tree().create_timer(1).timeout
		$damage/CollisionShape2D.shape.size.y = 0.0
		accel = 0.0
		pos = 0.0
#endregion
