extends Node

# code for the config files
const CONFIG_PATH = "res://etc/config.cfg"
var config_file = ConfigFile.new()

# settings variables
var kanaLanes
var kanaFreq
var tutorialMode
var assistMode
var voiceRepeatControl

# temporary settings variables in case change fails
var t_kanaLanes
var t_kanaFreq
var t_tutorialMode
var t_assistMode
var t_voiceRepeatControl

# program loads settings at bootup
func _ready():
    var frequencyslider = get_node("KanaFreq/KFreq")
    var lanesslider = get_node("KanaLanes/KLanes")
    var assistbutton = get_node("AssistButton")
    var tutorialbutton = get_node("TutorialButton")
    var voicerepeatbutton = get_node("VoiceRepeatButton")
    load_config()

    t_kanaLanes = kanaLanes
    t_kanaFreq = kanaFreq
    t_tutorialMode = tutorialMode
    t_assistMode = assistMode
    t_voiceRepeatControl = voiceRepeatControl

    frequencyslider.value = kanaFreq
    lanesslider.value = kanaLanes

    if tutorialMode:
        tutorialbutton.pressed = true
    if assistMode:
        assistbutton.pressed = true
    if voiceRepeatControl:
        voicerepeatbutton.pressed = true
    print("Load complete!")


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



func _on_SaveSettings_pressed():
    config_file.set_value("Game","kanaLanes", kanaLanes)
    config_file.set_value("Game", "kanaFreq", kanaFreq)
    config_file.set_value("Game", "tutorialMode", tutorialMode)
    config_file.set_value("Game", "assistMode", assistMode)
    config_file.set_value("Game", "voiceRepeatControl", voiceRepeatControl)
    if config_file.save(CONFIG_PATH) != OK:
        print("Error: Unable to save configuration file.")
        #revert changes
        kanaLanes = t_kanaLanes
        kanaFreq = t_kanaFreq
        tutorialMode = t_tutorialMode
        assistMode = t_assistMode
        voiceRepeatControl = t_voiceRepeatControl
    else:
        print("Success!")
    if get_tree().change_scene("res://scenes/MainMenuScreen.tscn") != OK:
        print("Error: Unable to change the scene.")


func _on_KFreq_value_changed(value):
    kanaFreq = value
    print("Kana Frequency = "+str(kanaFreq))


func _on_KLanes_value_changed(value):
    kanaLanes = value
    print("Kana Lanes = "+str(kanaLanes))

func _on_TutorialButton_pressed():
    tutorialMode = !tutorialMode
    print("Tutorial Mode = "+str(tutorialMode))

func _on_AssistButton_pressed():
    assistMode = !assistMode



    print("Assist Mode = "+str(assistMode))

func _on_VoiceRepeatButton_pressed():
    voiceRepeatControl = !voiceRepeatControl
    print("Voice Repeat Mode = "+str(voiceRepeatControl))
