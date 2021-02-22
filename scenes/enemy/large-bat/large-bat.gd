extends Node2D

# instance as a child of a bat-swarm :)

onready var base_scale_x = self.scale.x

var view_range = 4500
var attack_range = 90
var reload_wait = 1

var angle = 0
var on_top_of_targ = Vector2(0,-90)

var spread_degrees = 55.0
var spread_radians = spread_degrees* (PI/180)

var health = 10
var move_speed = 150
var alive = true

var direction = Vector2(0,0)
var spot = Vector2(0,0)

#var gravity = 0
#var gravity = 1.8

enum STATE {IDLE, FLYING, ATTACKING}
var state

var target
var reload_timer = 999
var move_vec = Vector2(0,0)
var speed_vec = Vector2(0,0)
export var flight_offset = 0
var last_flight_offset = 0

const to_dust_script = preload("res://shaders/dust/to_dust.gd")
const PROJ = preload("res://scenes/projectile/rock/rock.tscn")
onready var traj_position = $interm/body.global_position


onready var flap_period = $interm/body/AnimationPlayer.get_animation("fly").get_length()

# Called when the node enters the scene tree for the first time.
func _ready():
#	Engine.time_scale = 0.25
	$interm/body/AnimationPlayer.play("fly")
#	call_deferred("spawn_inactive_image()")
	to_dust_script.load_shaders($interm/body/AnimatedSprite)
	var t = get_parent().get_parent().get_parent().get_parent().get_node("wiz")
	if t != null:
		target = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# acquire info
	var distance = 999
	if target != null:
		spot = target.global_position + on_top_of_targ.rotated(angle)
		distance = (spot - $interm/body.global_position).length()
	
	# determine state
	if target == null:
		state = STATE.IDLE
		var t = get_parent().get_parent().get_node("wiz")
		if t != null:
			target = t
	else:
		if state == STATE.ATTACKING:
			pass
		elif target.global_position.distance_to($interm/body.global_position) < attack_range:
			if reload_timer >= reload_wait:
				state = STATE.ATTACKING
			else:
				state = STATE.FLYING
		elif target.global_position.distance_to($interm/body.global_position) < view_range:
			state = STATE.FLYING
		else:
			state = STATE.IDLE
	
	# act

	reload_timer += delta
	
	if self.alive == true:
		var x_dist_targ = $interm/body.global_position.x - target.global_position.x
		$interm/body/AnimatedSprite.scale.x = base_scale_x * sign(x_dist_targ)
		
	if self.alive == true:
		if state == STATE.IDLE:
			play("fly")
		if state == STATE.FLYING:
			play("fly")
			move_vec = direction * move_speed *delta
			if distance < (40):
				move_vec.y = move_vec.y *0.7
				move_vec.x = move_vec.x *0.9
			else:
				pass
			$interm/body.move_and_collide(move_vec)
		if state == STATE.ATTACKING:
				play("attack")
	if self.alive == false:
		pass
#		self.move_vec += gravity*delta*Vector2(0,1);
#		$interm/body.move_and_collide(move_vec)





#func play_and_shake(new_anim: String):
#	if $AnimationPlayer.current_animation != new_anim:
#		$AnimationPlayer.play(new_anim)
#		# shake goes AFTER for some reason
#		$AnimationPlayer2.play("shake")

func play(new_anim: String):
	$interm/body/AnimationPlayer.play(new_anim)
	
func shake():
	$interm/body/AnimationPlayer2.play("shake")

func after_attacking():
	reload_timer = 0
	self.state = STATE.FLYING

func reset_rotation():
	tween_rotate(0,3)
	
func aim_attack(frames: float):
	var new_ang = ($interm/body.global_position - target.global_position).angle() + PI/2
	tween_rotate(new_ang,frames)

func tween_rotate(angle2: float, frames: float):
	var corrected_angle = angle2
	if abs($interm/body.rotation - angle2) > PI:
		corrected_angle = angle2 - 2*PI
	$Tween.interpolate_property($interm/body, "rotation", $interm/body.rotation, corrected_angle, frames/60.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()   

func on_health_change():
	if self.health <= 0:
		self.alive = false
		self.die()

func redirect():
	direction = (self.spot - $interm/body.global_position).normalized()
	if direction == Vector2(0,0):
		print("WEW")
		direction = Vector2(0,-1)
	direction = direction.rotated( rand_range(-spread_radians, spread_radians) )

func die():
#	self.move_vec = Vector2(0,0)
	play("die")
	
func turn_to_dust():
	to_dust_script.turn_to_dust($interm/body/AnimatedSprite, 1.0, 0.3)

func _on_hitbox_area_entered(area):
	if area.damage != null:
		self.health -= area.damage
		on_health_change()

const hit_player_script = preload("res://scenes/enemy/hit_player.gd")

func _on_biteprojectile_body_entered(body):
	hit_player_script.hit_player(body,$"interm/body/walkbox-shape/bite-projectile")
