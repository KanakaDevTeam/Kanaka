extends Node

# code for the config files
const SCORES_PATH = "res://etc/scores.cfg"
var score_file = ConfigFile.new()

# scoreboard variables
var top5scores = []

onready var goldtimelabel = get_node("Board/Gold/TimeScore")
onready var goldkanalabel = get_node("Board/Gold/KanaScore")
onready var silvertimelabel = get_node("Board/Silver/TimeScore")
onready var silverkanalabel = get_node("Board/Silver/KanaScore")
onready var bronzetimelabel = get_node("Board/Bronze/TimeScore")
onready var bronzekanalabel = get_node("Board/Bronze/KanaScore")

var goldtime
var goldkana
var silvertime
var silverkana
var bronzetime
var bronzekana

# load_scores is called at bootup
func _ready():
    pass
    loadscores()
    displayscores()

func loadscores():
    if score_file.load(SCORES_PATH) != OK:
        print("Score file does not exist")
        initscore()
    else:
        top5scores = score_file.get_value("Scores", "Top5scores")

func displayscores():
    goldtime = top5scores[4][0]
    goldkana = top5scores[4][1]
    silvertime = top5scores[3][0]
    silverkana = top5scores[3][1]
    bronzetime = top5scores[2][0]
    bronzekana = top5scores[2][1]
    goldtimelabel.text = str((int(goldtime)-(int(goldtime)%60))/60)+":"+str(int(fmod(goldtime,60)))
    goldkanalabel.text = str(goldkana)
    silvertimelabel.text = str((int(silvertime)-(int(silvertime)%60))/60)+":"+str(int(fmod(silvertime,60)))
    silverkanalabel.text = str(silverkana)
    bronzetimelabel.text = str((int(bronzetime)-(int(bronzetime)%60))/60)+":"+str(int(fmod(bronzetime,60)))
    bronzekanalabel.text = str(bronzekana)


func initscore():
    top5scores = [[5, 0], [10, 1], [20, 2], [30, 3], [40, 4]]
    score_file.set_value("Scores", "Top5scores", top5scores)
