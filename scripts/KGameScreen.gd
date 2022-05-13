extends Node2D

export var gamemode = 0 #0 for hiragana, 1 for katakana
# code for the config files
const CONFIG_PATH = "res://etc/config.cfg"
var config_file = ConfigFile.new()
const COMPEN_PATH = "res://etc/katakanacompen.cfg"
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
var genthresh = 1
var score = 0
var kanapool = ["ア","イ","ウ","エ","オ","カ","キ","ク","ケ","コ", \
                "サ","シ","ス","セ","ソ","タ","チ","ツ","テ","ト", \
                "ナ","ニ","ヌ","ネ","ノ","ハ","ヒ","フ","ヘ","ホ", \
                "マ","ミ","ム","メ","モ","ラ","リ","ル","レ","ロ", \
                "ヤ","ユ","ヨ","ワ","ヲ","ガ","ギ","グ","ゲ","ゴ", \
                "ザ","ジ","ズ","ゼ","ゾ","ダ","ヂ","ヅ","デ","ド", \
                "バ","ビ","ブ","ベ","ボ","パ","ピ","プ","ペ","ポ","ン"]
var tempool
var validkana
var choicepool = []
onready var basket = get_node("TileMap/Basket")
onready var pausebutton = get_node("PauseButton")
onready var leftblock = get_node("TileMap/LeftBlock")
onready var rightblock = get_node("TileMap/RightBlock")
onready var timerscreen = get_node("Timer")
onready var kanalabel = get_node("KanaNext/Kanalabel")
onready var lifesprite = [get_node("Life0"),get_node("Life1"),get_node("Life2")]

var kanaConfig = {\
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

var kanaDirectory = {\
    "ア" : preload("res://assets/Audio/Vowels/あーア.wav"), \
    "イ" : preload("res://assets/Audio/Vowels/いーイ.wav"), \
    "ウ" : preload("res://assets/Audio/Vowels/うーウ.wav"), \
    "エ" : preload("res://assets/Audio/Vowels/えーエ.wav"), \
    "オ" : preload("res://assets/Audio/Vowels/おーオ.wav"), \
    "カ" : preload("res://assets/Audio/K/かーカ.wav"), \
    "キ" : preload("res://assets/Audio/K/きーキ.wav"), \
    "ク" : preload("res://assets/Audio/K/くーク.wav"), \
    "ケ" : preload("res://assets/Audio/K/けーケ.wav"), \
    "コ" : preload("res://assets/Audio/K/こーコ.wav"), \
    "サ" : preload("res://assets/Audio/S/さーサ.wav"), \
    "シ" : preload("res://assets/Audio/S/しーシ.wav"), \
    "ス" : preload("res://assets/Audio/S/すース.wav"), \
    "セ" : preload("res://assets/Audio/S/せーセ.wav"), \
    "ソ" : preload("res://assets/Audio/S/そーソ.wav"), \
    "タ" : preload("res://assets/Audio/T/たータ.wav"), \
    "チ" : preload("res://assets/Audio/T/ちーチ.wav"), \
    "ツ" : preload("res://assets/Audio/T/つーツ.wav"), \
    "テ" : preload("res://assets/Audio/T/てーテ.wav"), \
    "ト" : preload("res://assets/Audio/T/とート.wav"), \
    "ナ" : preload("res://assets/Audio/N/なーナ.wav"), \
    "ニ" : preload("res://assets/Audio/N/にーニ.wav"), \
    "ヌ" : preload("res://assets/Audio/N/ぬーヌ.wav"), \
    "ネ" : preload("res://assets/Audio/N/ねーネ.wav"), \
    "ノ" : preload("res://assets/Audio/N/のーノ.wav"), \
    "ハ" : preload("res://assets/Audio/H/はーハ.wav"), \
    "ヒ" : preload("res://assets/Audio/H/ひーヒ.wav"), \
    "フ" : preload("res://assets/Audio/H/ふーフ.wav"), \
    "ヘ" : preload("res://assets/Audio/H/へーヘ.wav"), \
    "ホ" : preload("res://assets/Audio/H/ほーホ.wav"), \
    "マ" : preload("res://assets/Audio/M/まーマ.wav"), \
    "ミ" : preload("res://assets/Audio/M/みーミ.wav"), \
    "ム" : preload("res://assets/Audio/M/むーム.wav"), \
    "メ" : preload("res://assets/Audio/M/めーメ.wav"), \
    "モ" : preload("res://assets/Audio/M/もーモ.wav"), \
    "ラ" : preload("res://assets/Audio/R/らーラ.wav"), \
    "リ" : preload("res://assets/Audio/R/りーリ.wav"), \
    "ル" : preload("res://assets/Audio/R/るール.wav"), \
    "レ" : preload("res://assets/Audio/R/れーレ.wav"), \
    "ロ" : preload("res://assets/Audio/R/ろーロ.wav"), \
    "ヤ" : preload("res://assets/Audio/Y/やーヤ.wav"), \
    "ユ" : preload("res://assets/Audio/Y/ゆーユ.wav"), \
    "ヨ" : preload("res://assets/Audio/Y/よーヨ.wav"), \
    "ワ" : preload("res://assets/Audio/W/わーワ.wav"), \
    "ヲ" : preload("res://assets/Audio/W/をーヲ.wav"), \
    "ガ" : preload("res://assets/Audio/K/がーガ.wav"), \
    "ギ" : preload("res://assets/Audio/K/ぎーギ.wav"), \
    "グ" : preload("res://assets/Audio/K/ぐーグ.wav"), \
    "ゲ" : preload("res://assets/Audio/K/げーゲ.wav"), \
    "ゴ" : preload("res://assets/Audio/K/ごーゴ.wav"), \
    "ザ" : preload("res://assets/Audio/S/ざーザ.wav"), \
    "ジ" : preload("res://assets/Audio/S/じージ.wav"), \
    "ズ" : preload("res://assets/Audio/S/ずーズ.wav"), \
    "ゼ" : preload("res://assets/Audio/S/ぜーゼ.wav"), \
    "ゾ" : preload("res://assets/Audio/S/ぞーゾ.wav"), \
    "ダ" : preload("res://assets/Audio/T/だーダ.wav"), \
    "ヂ" : preload("res://assets/Audio/T/ぢーヂ.wav"), \
    "ヅ" : preload("res://assets/Audio/T/づーヅ.wav"), \
    "デ" : preload("res://assets/Audio/T/でーデ.wav"), \
    "ド" : preload("res://assets/Audio/T/どード.wav"), \
    "バ" : preload("res://assets/Audio/H/ばーバ.wav"), \
    "ビ" : preload("res://assets/Audio/H/びービ.wav"), \
    "ブ" : preload("res://assets/Audio/H/ぶーブ.wav"), \
    "ベ" : preload("res://assets/Audio/H/べーベ.wav"), \
    "ボ" : preload("res://assets/Audio/H/ぼーボ.wav"), \
    "パ" : preload("res://assets/Audio/H/ぱーパ.wav"), \
    "ピ" : preload("res://assets/Audio/H/ぴーピ.wav"), \
    "プ" : preload("res://assets/Audio/H/ぷープ.wav"), \
    "ペ" : preload("res://assets/Audio/H/ぺーペ.wav"), \
    "ポ" : preload("res://assets/Audio/H/ぽーポ.wav"), \
    "ン" : preload("res://assets/Audio/んーン.wav"), \
    }

var lives = 3
var rand = RandomNumberGenerator.new()
var kanascene = load("res://scenes/Kana.tscn")
# program loads settings at bootup
func _ready():
    score = 0
    lives = 3
    load_config()
    genthresh = 10*exp(-0.04*kanaFreq)+1
    load_compendium()
    load_score()
    basket.update_lims(kanaLanes)
    leftblock.position.x = 40 + (80 * basket.leftlim)
    rightblock.position.x = 200 + (80 * basket.rightlim)

    if (assistMode):
        $KanaNext.visible = true
    else:
        $KanaNext.visible = false

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
        compen_file.set_value("Katakana", "KanaConfig", kanaConfig)
        if compen_file.save(COMPEN_PATH) != OK:
            print("Error: Unable to save katakana configuration file.")
    else:
        kanaConfig = compen_file.get_value("Katakana", "KanaConfig")
    for i in kanaConfig.keys():
        if kanaConfig[i] and (i[5] in kanapool):
            validkana.append(i[5])
    if len(validkana) == 0:
        validkana.append("°Д°")
    generate_kanapool()

func load_score():
    if score_file.load(SCORE_PATH) != OK:
        print("Score file does not exist")
        initscore()
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

    var KanaSound = AudioStreamPlayer.new()
    add_child(KanaSound)
    KanaSound.stream = kanaDirectory[choicepool[0]]
    KanaSound.play()

    yield(KanaSound, "finished")
    remove_child(KanaSound)


func _on_BackButton_pressed():
    get_tree().paused = false
    if get_tree().change_scene("res://scenes/MainMenuSreen.tscn") != OK:
        print("Error: Unable to change the scene.")

func _process(delta):
    timer += delta
    timerscreen.text = str((int(timer)-(int(timer)%60))/60)+":"+str(int(fmod(timer,60)))
    gentimer += delta
    if gentimer > genthresh:
        generate_kana(choicepool[rng(0,len(choicepool)-1)])
        gentimer = 0

func rng(a,b):
        rand.randomize()
        return rand.randi_range(a,b)


func _on_Basket_body_entered(body):
    print("Kana "+body.kana+" caught!")
    if(body.kana == choicepool[0]):
        score += 1
        if (rng(0,100) > 50): #50 percent chance of change kana
            generate_kanapool()

        if (voiceRepeatControl):
            var KanaSound1 = AudioStreamPlayer.new()
            add_child(KanaSound1)
            KanaSound1.stream = kanaDirectory[choicepool[0]]
            KanaSound1.play()
            yield(KanaSound1, "finished")
            remove_child(KanaSound1)
    else:
        gameover()
    body.queue_free()

func _on_LoseBlock_body_entered(body):
    if(body.kana == choicepool[0]):
        lives -= 1
        lifesprite[lives].visible = false
    if lives < 0:
        gameover()
    body.queue_free()

func gameover():
    #insert score code here
    var rightkana = choicepool[0]
    var numkanacaught = score
    var timescore = timer

    load_score()

    score_file.set_value("Most Recent Score", "rightkana", rightkana)
    score_file.set_value("Most Recent Score", "numkanacaught", numkanacaught)
    score_file.set_value("Most Recent Score", "timescore", timescore)

    if score_file.save(SCORE_PATH) != OK:
        print("Error: Unable to save recent score.")

    if get_tree().change_scene(next_scene_path) != OK:
        print("Error: missing next_scene_path")

func initscore():
    var top5scores = [[5, 0], [10, 1], [20, 2], [30, 3], [40, 4]]
    score_file.set_value("Scores", "Top5scores", top5scores)
