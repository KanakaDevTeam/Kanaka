extends Node2D

# code for the config files
const CONFIG_PATH = "res://etc/config.cfg"
var config_file = ConfigFile.new()

# settings variables
var kanaLanes
var kanaFreq
var tutorialMode
var assistMode
var voiceRepeatControl

onready var basket = get_node("TileMap/Basket")
onready var pausebutton = get_node("PauseButton")
onready var leftblock = get_node("TileMap/LeftBlock")
onready var rightblock = get_node("TileMap/RightBlock")

var rand = RandomNumberGenerator.new()
var kanascene = load("res://scenes/Kana.tscn")
# program loads settings at bootup
func _ready():
    load_config()
    basket.update_lims(kanaLanes)
    leftblock.position.x = 40 + (80 * basket.leftlim)
    rightblock.position.x = 200 + (80 * basket.rightlim)
    print("Game is ready!")


func load_config():
    if config_file.load(CONFIG_PATH) != OK:
        print("Config file does not exist")
        init_settings()
        return
    else:
        load_settings()

func init_settings():
    kanaLanes = 3
    kanaFreq = 50
    tutorialMode = false
    assistMode = false
    voiceRepeatControl = false
    config_file.set_value("Game","kanaLanes", kanaLanes)
    config_file.set_value("Game", "kanaFreq", kanaFreq)
    config_file.set_value("Game", "tutorialMode", tutorialMode)
    config_file.set_value("Game", "assistMode", assistMode)
    config_file.set_value("Game", "voiceRepeatControl", voiceRepeatControl)
    if config_file.save(CONFIG_PATH) != OK:
        print("Error: Unable to save configuration file.")

func load_settings():
    kanaLanes = config_file.get_value("Game","kanaLanes")
    kanaFreq = config_file.get_value("Game", "kanaFreq")
    tutorialMode = config_file.get_value("Game", "tutorialMode")
    assistMode = config_file.get_value("Game", "assistMode")
    voiceRepeatControl = config_file.get_value("Game", "voiceRepeatControl")

func _unhandled_input(event):
    if event.is_action_pressed("spawn_key"):
        var newkana = kanascene.instance()
        newkana.position.y = 160
        rand.randomize()
        var kanacol = rand.randi_range(basket.leftlim ,basket.rightlim)
        newkana.position.x = 120 + (80 * kanacol)
        add_child(newkana)
    if event.is_action_pressed("pause_key"):
        pausebutton.pausegame()
    if event.is_action_pressed("quit_key"):
        if get_tree().change_scene("res://scenes/MainMenuScreen.tscn") != OK:
            print("Error: Unable to change the scene.")
    if event.is_action_pressed("left_key"):
        basket.moveleft()
    if event.is_action_pressed("right_key"):
        basket.moveright()
    get_tree().set_input_as_handled()


func _on_BackButton_pressed():
    get_tree().paused = false
    if get_tree().change_scene("res://scenes/GameOverSreen.tscn") != OK:
        print("Error: Unable to change the scene.")
