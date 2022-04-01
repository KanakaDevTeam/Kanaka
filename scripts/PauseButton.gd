extends Button

export(String,FILE) var scene_path:=""
export(String) var node_path:=""
var paused = true
onready var pausescreen = get_node("PauseScreen")
func _ready():
    pause_mode = Node.PAUSE_MODE_PROCESS

#use this to pause the game
func _on_PauseButton_pressed():
    pausegame()

func pausegame():
    paused = !paused
    get_tree().paused = paused
    pausescreen.visible = paused
