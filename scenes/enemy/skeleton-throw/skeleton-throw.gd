extends KinematicBody2D

var view_range = 2500
var reload_wait = 2.5

onready var base_scale_x = self.scale.x
const to_dust_script = preload("res://shaders/dust/to_dust.gd")
const CORPSE = preload("res://scenes/enemy/skeleton-throw/corpse/skeleton-corpse.tscn")

var health = 60
var alive = true

var gravity = 1800

enum STATE {IDLE, ATTACKING}
var state

var target
var reload_timer = 999
onready var anim_player = $AnimationPlayer
var move_vec = Vector2(0,0)
var inactive_proj

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	
	reload_timer = randf() * reload_wait
	
	to_dust_script.load_shaders($AnimatedSprite)
	
	var t = get_parent().get_parent().get_parent().get_parent().get_node("wiz")
	if t != null:
		target = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inactive_proj == null:
		spawn_inactive_image()
	# determine state
	if target == null:
		state = STATE.IDLE
		var t = get_parent().get_parent().get_node("wiz")
		if t != null:
			target = t
	else:
		if target.global_position.distance_to(self.global_position) < view_range:
			state = STATE.ATTACKING
		else:
			state = STATE.IDLE
	
	# act
	if alive == true:
		if state == STATE.IDLE:
			hide_inactive_image()
			play_and_shake("idle")
		if state == STATE.ATTACKING:
			reload_timer += delta
			if reload_timer >= reload_wait:
				reload_timer = 0
				play_and_shake("throw")
		var x_dist_targ = self.global_position.x - target.global_position.x
		$"..".scale.x = base_scale_x * sign(x_dist_targ)
	move_vec.y += gravity*delta
	move_vec =  self.move_and_slide(move_vec)
	
	if alive == false:
		var corpse = CORPSE.instance()
		self.owner.get_parent().add_child(corpse)
		corpse.global_position = self.global_position
	#	self.owner.call_deferred("add_child", "corpse")
		self.queue_free()

const PROJ = preload("res://scenes/projectile/rock/rock.tscn")
func spawn_inactive_image():
	var proj = PROJ.instance()
	self.add_child(proj)
#	proj.z_index = +99
	proj.init_inactive(get_node("../skeleton/hold_pos").position)
	self.inactive_proj = proj
	proj.position = get_node("../skeleton/hold_pos").position
	hide_inactive_image()


func hide_inactive_image():
	if inactive_proj != null:
		inactive_proj.visible = false
	
func show_inactive_image():
	if inactive_proj != null:
		inactive_proj.visible = true

func shoot():
	var proj = PROJ.instance()
	owner.get_parent().add_child(proj)
	proj.z_index = +3
	proj.init(get_node("../skeleton/hold_pos").global_position, get_node("../skeleton/throw_pos").global_position, get_node("../skeleton/aim_pos").global_position)
	hide_inactive_image()

func play_and_shake(new_anim: String):
	if $AnimationPlayer.current_animation != new_anim:
		$AnimationPlayer.play(new_anim)
		# shake goes AFTER for some reason
		$AnimationPlayer2.play("shake")

func play(new_anim: String):
	$AnimationPlayer.play(new_anim)
	
func shake():
	$AnimationPlayer2.play("shake")

func on_health_change():
	if self.health <= 0:
		if self.alive == true:
			self.alive = false
			self.die()

#func die():
#	alive = false
#	play("die")
#	hide_inactive_image()

func die():
	alive = false

func turn_to_dust():
	to_dust_script.turn_to_dust($AnimatedSprite, 1.0, 0.4)

func _on_hitbox_area_entered(area):
	if area.damage != null:
		self.health -= area.damage
		on_health_change()
