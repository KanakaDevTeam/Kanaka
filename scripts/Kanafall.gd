extends KinematicBody2D


var v
var x
var y
var kana
onready var kanalabel = get_node("Kanalabel")
# Called when the node enters the scene tree for the first time.
func _ready():
	v = Vector2(0,1)

func _physics_process(_delta):
	var collide = move_and_collide(v)
	if test_move(transform,v):
		print("Collision detected.")
		print(collide)
	pass

func update_label(kanaval):
	kanalabel.text = kanaval
	print(kanaval)
