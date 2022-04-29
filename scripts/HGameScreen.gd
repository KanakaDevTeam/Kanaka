extends Node2D

export var gamemode = 0 #0 for hiragana, 1 for katakana
# code for the config files
const CONFIG_PATH = "res://etc/config.cfg"
var config_file = ConfigFile.new()
const COMPEN_PATH = "res://etc/hiraganacompen.cfg"
#const COMPEN_PATH = "res://etc/katakanacompen.cfg"
var compen_file = ConfigFile.new()
const SCORE_PATH = "res://etc/scores.cfg"
var score_file = ConfigFile.new()



export(String, FILE) var next_scene_path = ""

func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "Error: missing next_scene_path"
	else:
		return ""

# settings variables
var kanaLanes = 3
var kanaFreq = 50
var tutorialMode = false
var assistMode = false
var voiceRepeatControl = false

var timer = 0
var gentimer = 0
var score = 0
var kanapool = ["あ","い","う","え","お","か","き","く","け","こ", \
				"さ","し","す","せ","そ","た","ち","つ","て","と", \
				"な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ", \
				"ま","み","む","め","も","ら","り","る","れ","ろ", \
				"や","ゆ","よ","わ","を","が","ぎ","ぐ","げ","ご", \
				"ざ","じ","ず","ぜ","ぞ","だ","ぢ","づ","で","ど", \
				"ば","び","ぶ","べ","ぼ","ぱ","ぴ","ぷ","ぺ","ぽ","ん"]

var tempool
var validkana
var choicepool = []
onready var basket = get_node("TileMap/Basket")
onready var pausebutton = get_node("PauseButton")
onready var leftblock = get_node("TileMap/LeftBlock")
onready var rightblock = get_node("TileMap/RightBlock")
onready var timerscreen = get_node("Timer")
onready var kanalabel = get_node("KanaNext/Kanalabel")

var kanaConfig = {\
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

var rand = RandomNumberGenerator.new()
var kanascene = load("res://scenes/Kana.tscn")
# program loads settings at bootup
func _ready():
	score = 0
	load_config()
	load_compendium()
	load_score()
	basket.update_lims(kanaLanes)
	leftblock.position.x = 40 + (80 * basket.leftlim)
	rightblock.position.x = 200 + (80 * basket.rightlim)
	print("Game is ready!")
	#print(generate_correcthiragana())
	#print(generate_correctkatakana())

func load_config():
	if config_file.load(CONFIG_PATH) != OK:
		print("Config file does not exist")
		init_settings()
	else:
		load_settings()

func load_compendium():
	validkana = []
	if compen_file.load(COMPEN_PATH) != OK:
		print("Hiragana Compendium file does not exist")
		compen_file.set_value("Hiragana", "KanaConfig", kanaConfig)
		if compen_file.save(COMPEN_PATH) != OK:
			print("Error: Unable to save hiragana configuration file.")
	else:
		kanaConfig = compen_file.get_value("Hiragana", "KanaConfig")
	for i in kanaConfig.keys():
		if kanaConfig[i] and (i[5] in kanapool):
			validkana.append(i[5])
	if len(validkana) == 0:
		validkana.append("°Д°")
	generate_kanapool()

func load_score():
	if score_file.load(CONFIG_PATH) != OK:
		print("Score file does not exist")
		#init_score()
	else:
		pass


func init_settings():
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
		generate_kana(choicepool[rng(0,len(choicepool)-1)])
	if event.is_action_pressed("reroll_key"):
		generate_kanapool()
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


func generate_kana(kana):
	print("Generating a "+kana+" kana.")
	var newkana = kanascene.instance()
	newkana.position.y = 120
	rand.randomize()
	var kanacol = rng(basket.leftlim, basket.rightlim)
	newkana.position.x = 120 + (80 * kanacol)
	newkana.kana = kana
	add_child(newkana)
	newkana.update_label(kana)

func generate_kanapool():
	choicepool = []
	#duplicate kana list
	tempool = kanapool.duplicate()
	#generates initial kana
	choicepool.append(validkana[rng(0, len(validkana)-1)])
	print(choicepool[0])
	tempool.erase(choicepool[0])
	#generate 3 different kana
	for _i in range(3):
		choicepool.append(tempool.pop_at(rng(0,len(tempool)-1)))
	kanalabel.text = choicepool[0]
	print("Requested kana is "+choicepool[0])



func _on_BackButton_pressed():
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/GameOverSreen.tscn") != OK:
		print("Error: Unable to change the scene.")

func _process(delta):
	timer += delta
	timerscreen.text = str((int(timer)-(int(timer)%60))/60)+":"+str(int(fmod(timer,60)))
	gentimer += delta
	if gentimer > 1:
		generate_kana(choicepool[rng(0,len(choicepool)-1)])
		gentimer = 0

func rng(a,b):
		rand.randomize()
		return rand.randi_range(a,b)


func _on_Basket_body_entered(body):
	print("Kana "+body.kana+" caught!")
	if(body.kana == choicepool[0]):
		score += 1
		generate_kanapool()
	else:
		gameover()
	body.queue_free()

func _on_LoseBlock_body_entered(body):
	if(body.kana == choicepool[0]):
		gameover()
	body.queue_free()

func gameover():
	#insert score code here
	if get_tree().change_scene(next_scene_path) != OK:
		print("Error: missing next_scene_path")
