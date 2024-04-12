extends Node2D

@export_range(0,180) var vision_field:float
@export var self_entity_area:EntityArea
@export var vision_edge_left:RayCast2D
@export var vision_edge_right:RayCast2D

var boid_set = []
var barrier_set = []
func _ready():
	
	vision_edge_left.rotation = deg_to_rad(-vision_field) 
	vision_edge_right.rotation = deg_to_rad(vision_field) 
	
	
func _process(delta):
	#for boid in boid_set:
		#
		#if abs(calculate_relative_angle(boid))>vision_field:
			#sign_off_boid(boid)
		
	pass	

func is_in_vision(arg_boid):
	return abs(calculate_relative_angle(arg_boid))<=vision_field

func sign_on_boid(arg_boid):
	if not boid_set.has(arg_boid):
		boid_set.append(arg_boid)
		#if get_parent().look_at:
			#print("sign_on_boid  "+str(boid_set.size()))
			
func sign_on_barrier(arg_barrier):
	if not barrier_set.has(arg_barrier):
		barrier_set.append(arg_barrier)

func sign_off_boid(arg_boid):
	if boid_set.has(arg_boid):
		boid_set.erase(arg_boid)
		#if get_parent().look_at:
			#print("sign_off_boid  "+str(boid_set.size()))
			
func sign_off_barrier(arg_barrier):
	if barrier_set.has(arg_barrier):
		barrier_set.erase(arg_barrier)

func _on_area_entered(area):
	if area!=self_entity_area:
		if area is EntityArea:
			sign_on_boid(area.get_parent())
		elif area is Barrier:
			sign_on_barrier(area)
		#print(rad_to_deg(Vector2.from_angle(get_parent().rotation).angle_to(area.global_position-self.global_position)) )

func _on_area_exited(area):
	if area!=self_entity_area:
		if area is EntityArea:
			sign_off_boid(area.get_parent())
		elif area is Barrier:
			sign_off_barrier(area)

func calculate_relative_angle(arg_object):
	return rad_to_deg(Vector2.from_angle(get_parent().rotation).angle_to(arg_object.global_position-self.global_position))
