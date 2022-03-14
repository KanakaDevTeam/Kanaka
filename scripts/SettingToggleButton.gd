extends TextureButton

var on_state = preload("res://assets/Buttons_Sliders/Right.png")
var off_state = preload("res://assets/Buttons_Sliders/Left.png")

export (bool) var togglestate

func _ready():
    togglestate = 0

func update_icon():
    if togglestate:
        texture_normal = on_state
    else:
        texture_normal = off_state

func _on_ToggleButton_pressed():
    #change sprite
    togglestate = !togglestate
    update_icon()
