extends Button


func _on_SwitchToKatakana_pressed():
	get_tree().change_scene("res://scenes/KCompendium.tscn")


func _on_SwitchtoHiragana_pressed():
	get_tree().change_scene("res://scenes/HCompendium.tscn")
