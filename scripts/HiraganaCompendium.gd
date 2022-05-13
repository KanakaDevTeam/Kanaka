extends Node

const CONFIG_PATH = "res://etc/hiraganacompen.cfg"
var config_file = ConfigFile.new()

var path
var splitpath
var nodepath
var current_button
var setToTrue = false
var KanaConfig = {\
    "Kana/あ": 0, "Kana/い": 0, "Kana/う": 0, "Kana/え": 0, "Kana/お": 0, \
    "Kana/か": 0, "Kana/き": 0, "Kana/く": 0, "Kana/け": 0, "Kana/こ": 0, \
    "Kana/さ": 0, "Kana/し": 0, "Kana/す": 0, "Kana/せ": 0, "Kana/そ": 0, \
    "Kana/た": 0, "Kana/ち": 0, "Kana/つ": 0, "Kana/て": 0, "Kana/と": 0, \
    "Kana/な": 0, "Kana/に": 0, "Kana/ぬ": 0, "Kana/ね": 0, "Kana/の": 0, \
    "Kana/は": 0, "Kana/ひ": 0, "Kana/ふ": 0, "Kana/へ": 0, "Kana/ほ": 0, \
    "Kana/ま": 0, "Kana/み": 0, "Kana/む": 0, "Kana/め": 0, "Kana/も": 0, \
    "Kana/ら": 0, "Kana/り": 0, "Kana/る": 0, "Kana/れ": 0, "Kana/ろ": 0, \
    "Kana/や": 0, "Kana/ゆ": 0, "Kana/よ": 0, "Kana/わ": 0, "Kana/を": 0, \
    "Kana/が": 0, "Kana/ぎ": 0, "Kana/ぐ": 0, "Kana/げ": 0, "Kana/ご": 0, \
    "Kana/ざ": 0, "Kana/じ": 0, "Kana/ず": 0, "Kana/ぜ": 0, "Kana/ぞ": 0, \
    "Kana/だ": 0, "Kana/ぢ": 0, "Kana/づ": 0, "Kana/で": 0, "Kana/ど": 0, \
    "Kana/ば": 0, "Kana/び": 0, "Kana/ぶ": 0, "Kana/べ": 0, "Kana/ぼ": 0, \
    "Kana/ぱ": 0, "Kana/ぴ": 0, "Kana/ぷ": 0, "Kana/ぺ": 0, "Kana/ぽ": 0, \
    "Kana/ん": 0}

func _on_EnableALL_pressed():
    var parent = get_node("Kana").get_children()
    for i in parent:
        if i is TextureButton:
            i.pressed = setToTrue
            path = str(i.get_path())
            splitpath = path.split("/")
            nodepath = splitpath[3] + "/" + splitpath[4]
            KanaConfig[nodepath] = setToTrue
    setToTrue = !setToTrue
    saveCompen()

func _ready():
    if config_file.load(CONFIG_PATH) != OK:
        print("Compendium Config file does not exists")
        saveCompen()
        return
    loadConfig()

func loadConfig():
    KanaConfig = config_file.get_value("Hiragana", "KanaConfig")
    for i in KanaConfig.keys():
        if get_node_or_null(i) != null:
            current_button = get_node(i)
            if KanaConfig[i]:
                current_button.pressed = true

func saveCompen():
    config_file.set_value("Hiragana", "KanaConfig", KanaConfig)
    if config_file.save(CONFIG_PATH) != OK:
        print("Error: Unable to save configuration file.")

func _on_kana_pressed(button_path):
    print(button_path)
    KanaConfig[button_path] = !KanaConfig[button_path]
    saveCompen()
