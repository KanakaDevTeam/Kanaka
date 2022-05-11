extends Node

const CONFIG_PATH = "res://etc/katakanacompen.cfg"
var config_file = ConfigFile.new()

var path
var splitpath
var nodepath
var current_button
var setToTrue = false
var KanaConfig = {\
	"Kana/ア": 0, "Kana/イ": 0, "Kana/ウ": 0, "Kana/エ": 0, "Kana/オ": 0, \
	"Kana/カ": 0, "Kana/キ": 0, "Kana/ク": 0, "Kana/ケ": 0, "Kana/コ": 0, \
	"Kana/サ": 0, "Kana/シ": 0, "Kana/ス": 0, "Kana/セ": 0, "Kana/ソ": 0, \
	"Kana/タ": 0, "Kana/チ": 0, "Kana/ツ": 0, "Kana/テ": 0, "Kana/ト": 0, \
	"Kana/ナ": 0, "Kana/ニ": 0, "Kana/ヌ": 0, "Kana/ネ": 0, "Kana/ノ": 0, \
	"Kana/ハ": 0, "Kana/ヒ": 0, "Kana/フ": 0, "Kana/ヘ": 0, "Kana/ホ": 0, \
	"Kana/マ": 0, "Kana/ミ": 0, "Kana/ム": 0, "Kana/メ": 0, "Kana/モ": 0, \
	"Kana/ラ": 0, "Kana/リ": 0, "Kana/ル": 0, "Kana/レ": 0, "Kana/ロ": 0, \
	"Kana/ヤ": 0, "Kana/ユ": 0, "Kana/ヨ": 0, "Kana/ワ": 0, "Kana/ヲ": 0, \
	"Kana/ガ": 0, "Kana/ギ": 0, "Kana/グ": 0, "Kana/ゲ": 0, "Kana/ゴ": 0, \
	"Kana/ザ": 0, "Kana/ジ": 0, "Kana/ズ": 0, "Kana/ゼ": 0, "Kana/ゾ": 0, \
	"Kana/ダ": 0, "Kana/ヂ": 0, "Kana/ヅ": 0, "Kana/デ": 0, "Kana/ド": 0, \
	"Kana/バ": 0, "Kana/ビ": 0, "Kana/ブ": 0, "Kana/ベ": 0, "Kana/ボ": 0, \
	"Kana/パ": 0, "Kana/ピ": 0, "Kana/プ": 0, "Kana/ペ": 0, "Kana/ポ": 0, \
	"Kana/ン": 0}

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
	KanaConfig = config_file.get_value("Katakana", "KanaConfig")
	for i in KanaConfig.keys():
		if get_node_or_null(i) != null:
			current_button = get_node(i)
			if KanaConfig[i]:
				current_button.pressed = true

func saveCompen():
	config_file.set_value("Katakana", "KanaConfig", KanaConfig)
	if config_file.save(CONFIG_PATH) != OK:
		print("Error: Unable to save configuration file.")

func _on_kana_pressed(button_path):
	print(button_path)
	KanaConfig[button_path] = !KanaConfig[button_path]
	saveCompen()
