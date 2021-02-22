extends RigidBody2D

const to_dust_script = preload("res://shaders/dust/to_dust.gd")
const magnitude = 400.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const evaporate_time = 1.5
const evaporate_duration = 1.0
var timer = 0
var turned_to_dust = false

# Called when the node enters the scene tree for the first time.
func _ready():
	to_dust_script.load_shaders_2($Sprite)
	self.linear_velocity = $Position2D.position.normalized() * magnitude


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= evaporate_time && turned_to_dust == false:
		self.mode = RigidBody2D.MODE_STATIC
		to_dust_script.turn_to_dust_2($Sprite, evaporate_duration, 0.0)
		turned_to_dust = true
	if timer >= ( evaporate_time + evaporate_duration + 3.0):
		get_parent().queue_free()
