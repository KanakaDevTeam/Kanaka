extends Button

export(String,FILE) var scene_path:=""
export(String) var node_path:=""
#use this to change scenes
func _on_SceneButton_pressed():
    if get_tree().change_scene(scene_path) != OK:
        print("Error: Unable to change the scene.")

#use this to exit the game
func _on_ExitButton_pressed():
    get_tree().quit()


#use this to pause the game
func _on_PauseButton_pressed():
    if get_tree().change_scene(scene_path) != OK:
        print("Error: Unable to change the scene.")

func _get_configuration_warning():
    if scene_path == "":
        return "Error: no scene set"
    elif node_path == "":
        return "Error: no tab set"
    else:
        return ""

