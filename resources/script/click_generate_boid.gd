extends Node

@export var boid_path:String
var boid_scene
func _ready():
	boid_scene = load(boid_path)
	
	for i in 50:
		var boid = boid_scene.instantiate()
		add_child(boid)
		boid.position = Vector2(randi_range(0,1152),randi_range(0,640))


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var boid = boid_scene.instantiate()
			add_child(boid)
			boid.position = event.position-get_viewport().get_visible_rect().size/2
	
	


