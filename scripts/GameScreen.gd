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


# program loads settings at bootup
func _ready():
    load_config()
    var basket = get_node("TileMap/Basket")
    basket.update_lims(kanaLanes)
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

