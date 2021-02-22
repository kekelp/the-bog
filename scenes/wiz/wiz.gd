extends KinematicBody2D

var health = 3

onready var base_scale_x = self.scale.x

var NJUMPS = 1
# 1 means 2 because jumps starting from the ground don't actually consume one. Lol

var shooting
var autoshooting
enum HSTATE {STILL, MOVE, DASH}
var hstate
enum HDIR {LEFT, RIGHT}
var hdir

var reload_time = 0.1
var reloading = false

var move_speed = 250
var move_accel = 10000

var dash_speed = 1500
var dash_accel = 30000
var dash_duration = 0.25

var gravity = 30
var jump_power = 550
var downwards_jump_corr = 0
var glide_speed = 100
var glide_push = 39
var on_ground = false
var on_ground_lastframe = false

var jumps_available = NJUMPS

const FIREBALL = preload("res://scenes/fireball.tscn")

const FLOOR = Vector2(0, -1)
const FRICTION = 12
var first_half_of_jump = false
var first_half_of_jump_lastframe = false

var is_dead = false

var move_vec = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func die():
	self.is_dead = true
	$AnimatedSprite.play("dead")


func _physics_process(delta):
	if self.is_dead == false:
		# determine state?
		if hstate == HSTATE.DASH:
			pass
		else:
			if Input.is_action_just_pressed("autoshoot"):
				autoshooting = !autoshooting
			
			if Input.is_action_pressed("shoot"):
				shooting = true
			else:
				shooting = false
				
			if Input.is_action_pressed("move_left"):
				hdir = HDIR.LEFT
			elif Input.is_action_pressed("move_right"):
				hdir = HDIR.RIGHT

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
			
		var dirmod = 1
		if hdir == HDIR.LEFT: 
			dirmod = -1
		if hdir == HDIR.RIGHT: 
			dirmod = 1
		
		$Sprite.scale.x = base_scale_x * dirmod
		
		if hstate == HSTATE.MOVE:
			move_vec.x = move_accel*delta * dirmod
			if abs(move_vec.x) > move_speed:
				move_vec.x = move_speed * dirmod

		if hstate == HSTATE.DASH:
			move_vec.x = dash_accel*delta * dirmod
			if abs(move_vec.x) > dash_speed:
				move_vec.x = dash_speed * dirmod
			
		if hstate == HSTATE.STILL:
			move_vec.x = 0
		
		# jump
		#if Input.is_action_pressed("move_up") and on_ground == true:
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

#		if hstate != HSTATE.DASH:
#			if (shooting == true || autoshooting == true) && reloading == false:
#				reloading = true
#				$ShootTimer.start(reload_time)
#				shoot_shuriken( get_global_mouse_position() )

		if first_half_of_jump == false && Input.is_action_pressed("glide"):
			move_vec.y = glide_speed
			#move_vec.y -= glide_push
	
	if hstate != HSTATE.DASH:
		move_vec.y += gravity

	
	if is_on_floor():
		on_ground = true
		jumps_available = NJUMPS
	else:
		on_ground = false
		
		
	#friction
	if is_dead and is_on_floor():
		move_vec -= FRICTION * move_vec.normalized()
	

	move_vec = move_and_slide(move_vec, FLOOR, true)
	

func shoot_shuriken(target_pos):
	var fireball = FIREBALL.instance()
	fireball.init(self.position, target_pos)
	fireball.z_index = +3
	get_parent().add_child(fireball)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass	

func start_dash():
	$DashTimer.start(dash_duration)

func _on_DashTimer_timeout():
	hstate = HSTATE.STILL

func _on_ShootTimer_timeout():
	reloading = false
