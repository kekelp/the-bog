extends TextureProgress


func _on_wiz_damaged(new_hp):
	self.value = new_hp


func _on_wiz_set_health(new_hp):
		self.value = new_hp
