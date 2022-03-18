extends Node

# code for the config files
const SCORES_PATH = "res://etc/scores.cfg"
var score_file = ConfigFile.new()

# scoreboard variables
var scores = []

# load_scores is called at bootup
func _ready():
    load_scores()

func load_scores():
    var file_exists = score_file.load(SCORES_PATH)
    if file_exists != OK:
        print("Score file does not exist")
        save_scores()
        return

    scores = score_file.get_value("Scores","Top20scores")

func save_scores():
    if scores.empty():
        for i in range(0,200,10):
            scores.append(i)

    scores = score_file.set_value("Scores","Top20scores", scores)
    score_file.save(SCORES_PATH)
