class_name EntityArea extends Area2D
signal self_destroy
func hit_destroy_area():
	emit_signal("self_destroy")
	
func _input(event):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				hit_destroy_area()
