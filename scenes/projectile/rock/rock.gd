#extends "res://scenes/projectile/projectile.gd"
extends RigidBody2D

const hit_player_script = preload("res://scenes/enemy/hit_player.gd")
const proj_script = preload("res://scenes/projectile/projectile-script.gd")
const QFREE_DIST = 5000

var damage = 20

var thrown_already: bool = false

var base_speed = 550
var meme_gravity = 1800

var hold: Vector2
var throw: Vector2
var aim: Vector2

var active: bool = false

var speed: Vector2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$AnimationPlayer.play("default")
	pass

func init(hhold: Vector2, tthrow: Vector2, aaim: Vector2):
	self.hold = hhold
	self.throw = tthrow
	self.aim = aaim
	self.global_position = throw
	var lspeed = (aim - throw).normalized() * base_speed
	self.apply_central_impulse(lspeed)
	self.active = true

func init_inactive(hhold: Vector2):
	self.mode =RigidBody2D.MODE_KINEMATIC
	self.position = hhold
	$CollisionShape2D.disabled = true
	self.active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	proj_script.clear(self)
	
	if active:
		$Sprite.rotation += -0.1
#		self.apply_central_impulse(delta*meme_gravity*Vector2(0,1))
#	self.translate(speed * delta)


func _on_RigidBody2D_body_entered(body):
	hit_player_script.hit_player(body, self)
