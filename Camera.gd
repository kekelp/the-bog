extends Node2D




onready var Viewport = self.get_viewport();

onready var startingy = -50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_number = 3
	#var smoothing_time_seconds = 0.05
	var smoothing_time_seconds = 0.06
	var almost_three
	if delta != 0:
		almost_three = smoothing_time_seconds/(delta)
	else:
		almost_three = time_number
		
	var previous_frame_view_x = Viewport.get_canvas_transform().get_origin().x
	var previous_frame_view_y = Viewport.get_canvas_transform().get_origin().y

	var safety_bubble_r = 0 #doesn't work
	
	var mouse_offset_x = (get_viewport().get_mouse_position() - get_viewport().size / 2).x
	var mouse_corr_x = 0
	var mouse_corr_y = 0
#	if abs(mouse_offset_x) > safety_bubble_r:
#		mouse_corr_x = sign(mouse_offset_x) * min(0.29* pow(abs(mouse_offset_x),1 ) - safety_bubble_r , get_viewport().size.x * 0.5 *0.4)
#	var mouse_offset_y = (get_viewport().get_mouse_position() - get_viewport().size / 2).y
#	if abs(mouse_offset_y) > safety_bubble_r:
#		mouse_corr_y = sign(mouse_offset_y) * min(0.1* pow(abs(mouse_offset_y),1 ) - safety_bubble_r , get_viewport().size.x * 0.5 *0.4)
#
	
	
	var target_x = -self.global_transform.get_origin().x  + get_viewport().size.x/2 - mouse_corr_x
	var target_y = startingy   - mouse_corr_y
	
	var new_view_x = previous_frame_view_x + ( target_x - previous_frame_view_x  )/almost_three
	var new_view_y = previous_frame_view_y + ( target_y - previous_frame_view_y  )/almost_three
	
	var target_point = Vector2( new_view_x, new_view_y )
	var frame_step = Transform2D(self.rotation, target_point)
	
#	Engine.time_scale = 0.25
	Viewport.set_canvas_transform(frame_step)



