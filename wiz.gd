extends KinematicBody2D

var max_health = 100
var health = max_health

onready var base_scale_x = self.scale.x
#onready var anim_player = $AnimationTree["parameters/playback"]

var NJUMPS = 1
# 1 means 2 because jumps starting from the ground don't actually consume one. Lol

var shooting
enum HSTATE {STILL, MOVE, DASH, HURT}
var hstate
enum HDIR {LEFT, RIGHT}
var hdir

var shootdir: Vector2

var immune = false
var immune_time = 0.4

#var reload_time = 0.417
var reloading = false

var move_speed = 250
var move_accel = 10000

var dash_speed = 700
var dash_accel = 30000
var dash_duration = 0.25

var gravity = 1800
var jump_power = 550
var downwards_jump_corr = 0
var glide_speed = 100
var glide_push = 39
var on_ground = false
var on_ground_lastframe = false

var jumps_available = NJUMPS

const FIREBALL = preload("res://scenes/projectile/fireball/fireball.tscn")

const FLOOR = Vector2(0, -1)
const FRICTION = 12
var first_half_of_jump = false
var first_half_of_jump_lastframe = false

var is_dead = false

var move_vec = Vector2()
export var hurt_knockback_force: Vector2
var knockback_dir = 1

signal set_health(new_hp)
signal damaged(new_hp)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("set_health", self.health)
	pass # Replace with function body.


func die():
	self.is_dead = true
#	$AnimatedSprite.play("dead")


func _physics_process(delta):
	if self.is_dead == false:
		# read input
		if hstate == HSTATE.HURT:
			pass
		elif hstate == HSTATE.DASH:
			pass
		else:				
			if Input.is_action_pressed("move_left"):
				hdir = HDIR.LEFT
			elif Input.is_action_pressed("move_right"):
				hdir = HDIR.RIGHT
			###############

			#
			if Input.is_action_pressed("shoot_left"):
				shootdir = Vector2(-1,0)
				shooting = true
			elif Input.is_action_pressed("shoot_right"):
				shootdir = Vector2(1,0)
				shooting = true
			elif Input.is_action_pressed("shoot_up"):
				shootdir = Vector2(0,-1)
				shooting = true
			elif Input.is_action_pressed("shoot_down"):
				shootdir = Vector2(0,1)
				shooting = true
			else:
				shooting = false

			if Input.is_action_pressed("shoot_left") && Input.is_action_pressed("shoot_down"):
				shootdir = Vector2(-1,1).normalized()
				shooting = true
			elif Input.is_action_pressed("shoot_left") && Input.is_action_pressed("shoot_up"):
				shootdir = Vector2(-1,-1).normalized()
				shooting = true
			elif Input.is_action_pressed("shoot_right") && Input.is_action_pressed("shoot_down"):
				shootdir = Vector2(1,1).normalized()
				shooting = true
			elif Input.is_action_pressed("shoot_right") && Input.is_action_pressed("shoot_up"):
				shootdir = Vector2(1,-1).normalized()
				shooting = true


			if Input.is_action_just_pressed("dash"):
				hstate = HSTATE.DASH
				start_dash()
			elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				hstate = HSTATE.MOVE
			else:
				hstate = HSTATE.STILL
		
		# read state and apply
		
		if hstate == HSTATE.MOVE:
			$AnimationPlayer.play("run")
		if hstate == HSTATE.STILL:
			$AnimationPlayer.play("idle")
		if hstate == HSTATE.HURT:
			$AnimationPlayer.play("hurt")
		
		var dirmod = 1
		if hdir == HDIR.LEFT: 
			dirmod = -1
		if hdir == HDIR.RIGHT: 
			dirmod = 1
		
		$AnimatedSprite.scale.x = base_scale_x * dirmod
		
		if hstate == HSTATE.MOVE:
			move_vec.x += move_accel*delta * dirmod
			if abs(move_vec.x) > move_speed:
				move_vec.x = move_speed * dirmod

		if hstate == HSTATE.DASH:
			move_vec.x += dash_accel*delta * dirmod
			if abs(move_vec.x) > dash_speed:
				move_vec.x = dash_speed * dirmod
			
		if hstate == HSTATE.HURT:
			hurt_knockback_force.x = hurt_knockback_force.x * (-knockback_dir)
			move_vec += delta* hurt_knockback_force
		
		if hstate == HSTATE.STILL:
			move_vec.x = 0
		
		# jump
		#if Input.is_action_pressed("move_up") and on_ground == true:
		if hstate != HSTATE.HURT:
			if Input.is_action_just_pressed("jump") and jumps_available > 0:
				move_vec.y = -jump_power
				first_half_of_jump = true
				first_half_of_jump_lastframe = true
				#on_ground = false
				jumps_available = jumps_available - 1
			# jump correction
			if on_ground == false:
				first_half_of_jump_lastframe = first_half_of_jump;
				if move_vec.y > 0:
					first_half_of_jump = false
				if first_half_of_jump_lastframe == true && first_half_of_jump == false:
					move_vec.y += downwards_jump_corr
		
		if hstate == HSTATE.DASH:
			move_vec.y = 0

		if hstate != HSTATE.DASH && hstate != HSTATE.HURT:
			if (shooting == true) && reloading == false:
				reloading = true
				$ShootTimer.start($AnimationPlayer.get_animation("cast").length)
				$AnimationPlayer.play("cast")

		if first_half_of_jump == false && Input.is_action_pressed("glide"):
			move_vec.y = glide_speed
			#move_vec.y -= glide_push
	
	if hstate != HSTATE.DASH:
		move_vec.y += gravity*delta

	if immune == true:
		$"hurt?box/CollisionShape2D".disabled = true
	else:
		$"hurt?box/CollisionShape2D".disabled = false
		
	
	if is_on_floor():
		on_ground = true
		jumps_available = NJUMPS
	else:
		on_ground = false
	
	#friction
	if is_dead and is_on_floor():
		move_vec -= FRICTION * move_vec.normalized()
	

	move_vec = self.move_and_slide(move_vec, FLOOR, true)
	

func shoot_fireball(dir: Vector2):
	var fireball = FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.z_index = +3
	
	fireball.init($fireball_pos_1.global_position, shootdir)

func start_dash():
	self.get_node("DashTimer").start(dash_duration)

func _on_DashTimer_timeout():
	hstate = HSTATE.STILL

func _on_ShootTimer_timeout():
	reloading = false
	
func stop_being_hurt():
	play("idle")
	hstate = HSTATE.STILL

func _on_hurtbox_body_entered(body):
	if body.active:
		self.knockback_dir = -sign(body.linear_velocity.x)
#		print(body.linear_velocity)
		get_hit(body)

func _on_hurtbox_area_entered(area):
	get_hit(area)

func get_hit(body_or_area):
	if self.immune == false:
		self.move_vec.x = 0
		self.move_vec.y = 0
		self.hstate = HSTATE.HURT
		
		if body_or_area.damage != null:
			self.health -= body_or_area.damage
			emit_signal("damaged", self.health)
		
		self.immune = true
		$ImmunityTimer.start(immune_time)
	

func _on_ImmunityTimer_timeout():
	self.immune = false

func play(new_anim: String):
	$AnimationPlayer.play(new_anim)
