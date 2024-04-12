class_name Boid extends Node
@export var look_at:bool
@export var screen_size:Vector2
@export var edge_distance:int
@export var sprite:Sprite2D
@export var vision:Area2D
@export var barrier_vision:BarrierVision
@export var seperate_radius:float

@export var speed:float
@export var max_speed:float
@export var max_force:float
@export var seperation_force_rate:float
@export var alignment_force_rate:float
@export var coheasion_force_rate:float

@export var max_acceleration_rate:float
var acceleraction:Vector2
var velocity:Vector2

#@export_range(0,1) var escape_distance_rate:float

var vision_shape
func _ready():
	vision_shape = vision.find_child("VisionShape")
	if look_at:
		vision.visible = true
		sprite.modulate.h = 0
		sprite.modulate.s = 1
		sprite.modulate.v = 1
	else:
		sprite.modulate.h = 50.0/359.0
		sprite.modulate.s = randf_range(0.80,0.100)
		sprite.modulate.v = randf_range(0.80,1.00)
	velocity = speed*Vector2.from_angle(deg_to_rad(randi_range(0,360)))*randf_range(0.5,1.5)
	
func _process(delta):
	
	move(delta)
	
func seperation():
	var seperate_force = Vector2.ZERO
	var seperate_count = 0
	for boid in vision.boid_set:
		if vision.is_in_vision(boid):
			seperate_count+=1
			var ratio = pow(seperate_radius/(boid.global_position-self.global_position).length(),1)
			seperate_force -= ratio*(boid.global_position-self.global_position).normalized()
	if seperate_count>0:
		seperate_force = seperate_force/seperate_count
	
	if barrier_vision.is_colliding():
		var barrier_ratio = seperate_radius/barrier_vision.get_barrier_main_direction().length()
		var barrier_direction = (velocity.normalized()-1.2*barrier_vision.get_barrier_main_direction().normalized()).normalized()
		seperate_force += 1.2*barrier_ratio*barrier_direction
	
	return seperation_force_rate* seperate_force

func alignment():
	var alignment_force = velocity
	var alignment_count = 1
	for boid in vision.boid_set:
		if vision.is_in_vision(boid):
			alignment_count+=1
			alignment_force += boid.velocity
	alignment_force = alignment_force/alignment_count
		
	return alignment_force_rate*(alignment_force-velocity)
	
func coheasion():
	var coheasion_center = Vector2.ZERO
	var coheasion_count = 0
	for boid in vision.boid_set:
		if vision.is_in_vision(boid):
			coheasion_count+=1
			coheasion_center += boid.global_position-self.global_position
	if coheasion_count>0:
		coheasion_center = coheasion_center/coheasion_count
	
	return coheasion_force_rate* coheasion_center


func clamp_velocity():
	if velocity.length()>=max_speed:
		velocity = velocity.normalized()*max_speed

func move(delta):
	acceleraction+=seperation()
	acceleraction+=alignment()
	acceleraction+=coheasion()
	if acceleraction.length()>max_acceleration_rate:
		acceleraction = acceleraction.normalized()*max_acceleration_rate
	#加速
	velocity = velocity+acceleraction
	#速度上限
	clamp_velocity()
	#移动
	self.global_position+=velocity*delta
	#角度对齐
	self.rotation = atan2(velocity.y,velocity.x)
	#位置重置
	self.position.x = fmod(self.position.x+3*(screen_size.x/2+edge_distance), screen_size.x+2*edge_distance) -screen_size.x/2-edge_distance
	self.position.y = fmod(self.position.y+3*(screen_size.y/2+edge_distance), screen_size.y+2*edge_distance) -screen_size.y/2-edge_distance
	
	pass

func destroy():
	queue_free()
