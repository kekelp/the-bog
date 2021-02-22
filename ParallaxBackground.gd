extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startingy = -250

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var player_pos = get_parent().get_node("Player").global_position
	#var newpos = Vector2( -player_pos.x, -player_pos.y )
	#self.scroll_offset = newpos
	
	# x is viewport-based, y isn't?
	# var newx = self.get_viewport().get_canvas_transform().get_origin().x
	# var newy = 0
	# var newpos = Vector2(newx, newy)
	# self.scroll_offset = newpos
	
	self.scroll_offset.x = self.get_viewport().get_canvas_transform().get_origin().x
