extends Resource

static func hit_player(player, projectile):
	if player.has_method("get_hit"):
		player.get_hit(projectile)
