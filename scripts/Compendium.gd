extends Node

export(ButtonGroup) var group

var on_state = preload("res://assets/Buttons_Sliders/Pause.png")

func _on_EnableALL_pressed():
	for i in group.get_buttons():
		i.texture_normal = on_state
