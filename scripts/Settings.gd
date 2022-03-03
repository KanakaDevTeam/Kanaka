extends Node

# code for the config files
const CONFIG_PATH = "res://etc/config.cfg"
var config_file = ConfigFile.new()

# settings variables
var kanaLanes = 3
var kanaFreq = 50
var tutorialMode = false
var assistMode = false
var voiceRepeatControl = false

# program loads settings at bootup
func _ready():
	load_settings()

func load_settings():
	var file_exists = config_file.load(CONFIG_PATH)
	if file_exists != OK:
		print("Config file does not exist")
		save_settings()
		return
	
	kanaLanes = config_file.get_value("Game","kanaLanes")
	kanaFreq = config_file.get_value("Game", "kanaFreq")
	tutorialMode = config_file.get_value("Game", "tutorialMode")
	assistMode = config_file.get_value("Game", "assistMode")
	voiceRepeatControl = config_file.get_value("Game", "voiceRepeatControl")

func save_settings():
	kanaLanes = config_file.set_value("Game","kanaLanes", kanaLanes)
	kanaFreq = config_file.set_value("Game", "kanaFreq", kanaFreq)
	tutorialMode = config_file.set_value("Game", "tutorialMode", tutorialMode)
	assistMode = config_file.set_value("Game", "assistMode", assistMode)
	voiceRepeatControl = config_file.set_value("Game", "voiceRepeatControl", voiceRepeatControl)
	
	config_file.save(CONFIG_PATH)
