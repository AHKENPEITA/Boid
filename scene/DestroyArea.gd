extends Area2D
func _on_area_entered(area):
	if area is EntityArea:
		area.hit_destroy_area()









