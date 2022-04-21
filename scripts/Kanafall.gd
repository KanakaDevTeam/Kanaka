extends KinematicBody2D


var v
var x
var y

# Called when the node enters the scene tree for the first time.
func _ready():
	v = Vector2(0,2)
	pass # Replace with function body.


func _physics_process(_delta):
	var collide = move_and_collide(v)
	if collide:
		print("Collision detected.")
		print(collide)
	pass
