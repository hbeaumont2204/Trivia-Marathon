extends Control

onready var high_score_label = $ScoreContainer/HighScore
onready var previous_score_label = $ScoreContainer/PreviousScore
onready var options = $OptionsContainer
onready var credits = $CreditsContainer
onready var game_mode_button = $OptionsContainer/GameModeButton
onready var MT_Options = $OptionsContainer/MTContainer

var high_score_path = "user://high_score.dat"
var previous_score_path = "user://previous_score.dat"

var manifest_path_mt = "res://Assets/manifest_mt.txt"
var manifest_path_tf = "res://Assets/manifest_tf.txt"
var files_mt = ["res://Assets/quiz_pack_2.csv", "res://Assets/quiz_pack_1.csv"]
var files_tf = ["res://Assets/quiz_history_tf.csv", "res://Assets/tf_pack_1.csv"]

var high_score
var previous_score

var game_mode_tf = false

# Called when the node enters the scene tree for the first time.
func _ready():
	options.visible = false
	credits.visible = false
	high_score = read_score(high_score_path)
	previous_score = read_score(previous_score_path)
	
	high_score_label.text = "High Score: %s" % high_score
	previous_score_label.text = "Previous Score: %s" % previous_score 
	
	# Test
	#write_to_manifest(["res://Assets/quiz_pack_2.csv", "res://Assets/quiz_pack_1.csv"], manifest_path_mt)
	#write_to_manifest(["res://Assets/quiz_history_tf.csv", "res://Assets/tf_pack_1.csv"], manifest_path_tf)
	
	files_mt = read_manifest(manifest_path_mt)
	files_tf = read_manifest(manifest_path_tf)
	
	print(files_mt)
	print(files_tf)
	
	if !files_mt.has("res://Assets/Quiz Packs/lit_mt.csv"):
		set_button_red($OptionsContainer/MTContainer/LiteratureMT)
	if !files_mt.has("res://Assets/Quiz Packs/religion_mult_choice.csv"):
		set_button_red($OptionsContainer/MTContainer/ReligionMT)
	if !files_mt.has("res://Assets/Quiz Packs/video_game_mt.csv"):
		set_button_red($OptionsContainer/MTContainer/VideoGamesMT)
	
	

func read_manifest(var manifest_path):
	var file = File.new()
	var files = []
	
	if file.open(manifest_path,File.READ) == OK:
		while not file.eof_reached():
			var line = file.get_line()
			files.append(line)
		file.close()
	else:
		print("Failed to open file: ", manifest_path)
	
	return files
		
func write_to_manifest(var files, var manifest_path):
	var file = File.new()
	
	if file.open(manifest_path, File.WRITE) == OK:
		for pack in files:
			file.store_line(pack)
		file.close()
	else:
		print("Write error: ", manifest_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


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
	credits.visible = false
	options.visible = !options.visible


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_GameModeButton_pressed():
	if game_mode_tf:
		game_mode_tf = false
		game_mode_button.text = "True or False"
		MT_Options.visible = true
	else:
		game_mode_tf = true
		game_mode_button.text = "Multiple choice"
		MT_Options.visible = false


func _on_CreditsButton_pressed():
	options.visible = false
	credits.visible = !credits.visible

func topic_button_press(var button, var pack):
	if button.modulate == Color(0, 1, 0):
		button.modulate = Color(1, 0, 0)
		if !game_mode_tf:
			files_mt.erase(pack)
			write_to_manifest(files_mt,manifest_path_mt)
		else:
			files_tf.erase(pack)
			write_to_manifest(files_tf,manifest_path_tf)
	else:
		button.modulate = Color(0, 1, 0)
		if !game_mode_tf:
			files_mt.append(pack)
			write_to_manifest(files_mt,manifest_path_mt)
		else:
			files_tf.append(pack)
			write_to_manifest(files_tf,manifest_path_tf)
			
func set_button_red(var button):
	button.modulate = Color(1, 0, 0)

func _on_VideoGamesMT_pressed():
	topic_button_press($OptionsContainer/MTContainer/VideoGamesMT,"res://Assets/Quiz Packs/video_game_mt.csv")

func _on_ReligionMT_pressed():
	topic_button_press($OptionsContainer/MTContainer/ReligionMT,"res://Assets/Quiz Packs/religion_mult_choice.csv")

func _on_LiteratureMT_pressed():
	topic_button_press($OptionsContainer/MTContainer/LiteratureMT,"res://Assets/Quiz Packs/lit_mt.csv")
