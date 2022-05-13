extends Control

const SCORE_PATH = "res://etc/scores.cfg"
var score_file = ConfigFile.new()

var top5scores = []
var rightkana
var numkanacaught
var timescore

onready var gameoverlabel = get_node("GameOverLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
    loadscore()
    savescore()
    displayscore()

func loadscore():
    if score_file.load(SCORE_PATH) != OK:
        print("Score file does not exist")
        initscore()
    rightkana = score_file.get_value("Most Recent Score", "rightkana", rightkana)
    numkanacaught = score_file.get_value("Most Recent Score", "numkanacaught", numkanacaught)
    timescore = score_file.get_value("Most Recent Score", "timescore", timescore)

func savescore():
    top5scores = score_file.get_value("Scores", "Top5scores")
    for i in range(5):
        if top5scores[i][1] >= numkanacaught:
            if timescore > top5scores[i][0]:
                if i != 4:
                    continue
            top5scores.insert(i, [timescore, numkanacaught])
            break
        if i == 4:
            top5scores.insert(5, [timescore, numkanacaught])
    top5scores = top5scores.slice(1,5)
    print("scoreboard: "+str(top5scores))
    score_file.set_value("Scores", "Top5scores", top5scores)
    if score_file.save(SCORE_PATH) != OK:
        print("Error: Unable to save configuration file.")

func displayscore():
    gameoverlabel.text = "Game Over\nKana Caught: "+str(numkanacaught)+"\nTime Elapsed: "+str((int(timescore)-(int(timescore)%60))/60)+":"+str(int(fmod(timescore,60)))

func initscore():
    top5scores = [[5, 0], [10, 1], [20, 2], [30, 3], [40, 4]]
    score_file.set_value("Scores", "Top5scores", top5scores)
    if score_file.save(SCORE_PATH) != OK:
        print("Error: Unable to save configuration file.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
