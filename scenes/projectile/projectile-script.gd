extends Resource

static func clear(proj):
	var anchor_pos = - proj.get_viewport().get_canvas_transform().get_origin()
	var offset = proj.global_position - anchor_pos
	if offset.length() > proj.QFREE_DIST:
		proj.queue_free()
