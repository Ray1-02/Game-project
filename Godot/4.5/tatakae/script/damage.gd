extends Area2D
#for damaging the enemy
@onready var enemy_1 = $".."
func _on_area_entered(_area: Area2D) -> void:
	enemy_1.health -= 1
	enemy_1.stage1_animation()
