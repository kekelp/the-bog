extends "res://scenes/projectile/projectile.gd"

var speed = 400
var damage = 20

var time = 0.0
var lifetime = 0.7
var slowdown_time = 0.5
var final_speed = 100.0
onready var slowdown_rate = (speed - final_speed)/(slowdown_time)

var dir: Vector2
var move_vec: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("default")

func init(origin: Vector2, direction: Vector2):
	self.global_position = origin
	self.dir = direction
	self.rotation = direction.angle()
	move_vec = dir * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > (lifetime - slowdown_time):
		move_vec -= move_vec.normalized() *slowdown_rate * delta
	self.translate(move_vec * delta)
	if time > lifetime:
		self.queue_free()
