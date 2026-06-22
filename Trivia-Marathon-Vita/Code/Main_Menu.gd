extends Control

onready var high_score_label = $ScoreContainer/HighScore
onready var previous_score_label = $ScoreContainer/PreviousScore
onready var options = $OptionsContainer
onready var game_mode_button = $OptionsContainer/GameModeButton

var high_score_path = "user://high_score.dat"
var previous_score_path = "user://previous_score.dat"

var high_score
var previous_score

var game_mode_tf = false

# Called when the node enters the scene tree for the first time.
func _ready():
	options.visible = false
	high_score = read_score(high_score_path)
	previous_score = read_score(previous_score_path)
	
	high_score_label.text = "High Score: %s" % high_score
	previous_score_label.text = "Previous Score: %s" % previous_score 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_score(var file_path):
	var file = File.new()
	var dir = Directory.new()
	var score = 0
	
	if dir.file_exists(file_path):
		if file.open_encrypted_with_pass(file_path,File.READ,"12345") == OK:
			score = file.get_var()
			file.close()
		#print(score)
	else:
		init_score(file_path)
	return score
		
	
func init_score(var file_path):
	var file = File.new()
	if file.open_encrypted_with_pass(file_path,File.WRITE,"12345") == OK:
		file.store_var(0)
		file.close()

# Button functions

func _on_PlayButton_pressed():
	if game_mode_tf:
		get_tree().change_scene("res://Scenes/TrueOrFalse.tscn")
	else:
		get_tree().change_scene("res://Scenes/Game.tscn")


func _on_OptionButton_pressed():
	options.visible = !options.visible


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_GameModeButton_pressed():
	if game_mode_tf:
		game_mode_tf = false
		game_mode_button.text = "True or False"
	else:
		game_mode_tf = true
		game_mode_button.text = "Multiple choice"
