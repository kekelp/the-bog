extends Node2D

var target
var spread_degrees = 80
var spread_radians = spread_degrees* (PI/180)
var spread_correct_degrees = 2.5
var spread_correct_radians = spread_correct_degrees* (PI/180)
 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_spots();

func set_spots():
	var t = get_parent().get_parent().get_parent().get_node("wiz")
	if t != null:
		target = t
		
	var bats = self.get_children()
	var n_bats = bats.size()
	if n_bats == 1:
		bats[0].angle = 0
	else:
		if n_bats > 5:
			spread_radians += max( n_bats - 5, 10)*spread_correct_radians
		
		var slice = spread_radians /( n_bats - 1)
		for i in range(bats.size()):
			bats[i].angle = - (spread_radians/2) + slice * i

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
