extends Area2D

var column = 5
var leftlim = 1
var rightlim = 9
var colsize = 80
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    position = position.snapped((Vector2.ONE * colsize) - (Vector2.ONE * colsize / 2))
    pass # Replace with function body.

func _unhandled_input(event):
    if event.is_action_pressed("left_key") and column > leftlim:
        position += Vector2.LEFT * colsize
        column -= 1
    if event.is_action_pressed("right_key") and column < rightlim:
        position += Vector2.RIGHT * colsize
        column += 1
    get_tree().set_input_as_handled()

func update_lims(numcol):
    print("NUMBER OF COLS = "+str(numcol))
    if int(numcol) % 2 == 1:
        leftlim = 5 - ((numcol - 1) / 2)
    else:
        leftlim = 5 - (numcol / 2)
    rightlim = leftlim + numcol - 1

    print("LEFT LIMIT = "+str(leftlim))
    print("RIGHT LIMIT = "+str(rightlim))
