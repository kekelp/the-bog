extends Area2D

# child setup:
# in scene:
# Sprite resource
# CollisionShape2D resource
# "default" animation
#
# in script:
# init function
# movement code
# collision code in on_body_entered connected to the signals

const QFREE_DIST = 2000
#const SPEED = 450

#const GROUND_VFX = preload("res://scenes/bullets/bullet-lin-stretch/vfx-ground.tscn")

var anchor_pos: Vector2
onready var viewport = self.get_viewport();


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	anchor_pos = - viewport.get_canvas_transform().get_origin()
	var offset = self.global_position - anchor_pos
	if offset.length() > QFREE_DIST:
		self.queue_free()
	
#	translate(self.dir * SPEED * delta)

#func _on_Bullet_area_entered(area):
#	if area.has_method("get_shot_by_enemy"):
#		area.get_shot_by_enemy()
#	if area.get_name() == "Ground":
#		var vfx1 = GROUND_VFX.instance()
#		vfx1.position = self.position
#		get_parent().add_child(vfx1)
#		self.queue_free()

#
#func _on_Bullet_body_entered(body):
#	if body.get_name() == "Ground":
#		var vfx1 = GROUND_VFX.instance()
#		vfx1.position = self.position
#		get_parent().add_child(vfx1)
#		self.queue_free()
