extends Node

export(ButtonGroup) var group

var on_state = preload("res://assets/Buttons_Sliders/Pause.png")
var setToTrue = 0
func _on_EnableALL_pressed():
    var parent = get_node("Kana").get_children()
    for i in parent:
        if i is TextureButton:
            i.pressed = setToTrue
    setToTrue = !setToTrue
    print(parent)
