class_name BarrierVision extends Node2D

func get_barrier_main_direction():
	var barrier_main_direction = Vector2.ZERO
	var collide_count = 0
	for ray in get_children():
		if ray.is_colliding():
			collide_count+=1
			barrier_main_direction += ray.get_collision_point()-self.global_position
	if collide_count>0:
		barrier_main_direction = barrier_main_direction/collide_count
	return barrier_main_direction

func is_colliding():
	for ray in get_children():
		if ray.is_colliding():
			return true
	return false
