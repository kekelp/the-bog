extends Resource

const sprite_material = preload("res://shaders/dust/to_dust_sprite_material.tres")
const sprite_shader = preload("res://shaders/dust/to_dust_sprite.shader")

const particle_material = preload("res://shaders/dust/to_dust_particle_material.tres")
const particle_shader = preload("res://shaders/dust/to_dust_particle.shader")
const emitter_scene = preload("res://shaders/dust/dust_emitter.tscn")

static func load_shaders(sprite: AnimatedSprite):
	sprite.material = sprite_material.duplicate()
	sprite.material.shader = sprite_shader.duplicate()
	var particle_emitter = sprite.get_node("DustEmitter")
	var texture = sprite.frames.get_frame("frames" , sprite.frame)
	particle_emitter.amount = texture.get_width() * texture.get_height()
	particle_emitter.process_material.set_shader_param("sprite", texture)

static func load_shaders_2(sprite: Sprite):
	sprite.material = sprite_material.duplicate()
	sprite.material.shader = sprite_shader.duplicate()
	var particle_emitter = sprite.get_node("DustEmitter")
	var texture = sprite.texture
	particle_emitter.amount = texture.get_width() * texture.get_height()
	particle_emitter.process_material.set_shader_param("sprite", texture)



static func turn_to_dust(sprite: AnimatedSprite, duration: float, ahead: float):
	# sprite dissolve
#	sprite.material = sprite_material.duplicate()
#	sprite.material.shader = sprite_shader.duplicate()
	var global_t  = OS.get_ticks_msec()/1000.0 - ahead
#	var global_t  = (OS.get_ticks_msec() - floor(OS.get_ticks_msec()/3600.0)*3600.0)/1000.0
	sprite.material.set_shader_param("tzero", global_t)
	sprite.material.set_shader_param("duration", duration)
	sprite.material.set_shader_param("active", true)


	# particles
	var particle_emitter = sprite.get_node("DustEmitter")
	particle_emitter.emitting = true
#	sprite.add_child(particle_emitter)
#	particle_emitter.process_material = particle_material.duplicate()
#	particle_emitter.process_material.shader = particle_shader.duplicate()
#	var texture = sprite.frames.get_frame("frames" , sprite.frame)
#	particle_emitter.amount = texture.get_width() * texture.get_height()
#	particle_emitter.process_material.set_shader_param("sprite", texture)
	particle_emitter.process_material.set_shader_param("duration", duration)
	particle_emitter.process_material.set_shader_param("tzero", global_t)



static func turn_to_dust_2(sprite: Sprite, duration: float, ahead: float):
	# sprite dissolve
	var global_t  = OS.get_ticks_msec()/1000.0 - ahead
	sprite.material.set_shader_param("tzero", global_t)
	sprite.material.set_shader_param("duration", duration)
	sprite.material.set_shader_param("active", true)

	# particles
	var particle_emitter = sprite.get_node("DustEmitter")
	particle_emitter.emitting = true
	particle_emitter.process_material.set_shader_param("duration", duration)
	particle_emitter.process_material.set_shader_param("tzero", global_t)
