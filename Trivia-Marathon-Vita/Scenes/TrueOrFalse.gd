extends Control

var question = ""
var buttons = ""

var question_pack = ""
var is_true = ""
var file_path = ""
var correct_answer = ""
var question_active = true

var score = 0
var timer = 30.0

onready var button_container = $CenterContainer/VBoxContainer
onready var question_label = $Question
onready var answer_label = $CenterContainer/VBoxContainer/Result
onready var points_label = $Points
onready var timer_label = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	file_path = "res://Assets/--.csv"
	
	buttons = button_container.get_children()
	#question_pack = load_question_pack(file_path)
	#load_question(question_pack)
	#update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("option1"):
		pass
	if Input.is_action_just_pressed("option2"):
		pass
	if Input.is_action_just_pressed("skip"):
		pass
	if question_active:
		timer -= delta
		timer_label.text = "Time: " + str(int(timer))
		if timer <= 0:
			pass

func update_score():
	points_label.text = "Points: " + str(score)

func load_question_pack(file_path: String):
	#var file = FileAccess.open(file_path, FileAccess.READ)
	
	var file = File.new()
	file.open(file_path, File.READ)
	
	if not file:
		print("Error finding file", file_path)
		question_label.text = "Quiz pack not found"
		#get_tree().quit() # Ends game if file not found
		return
	return file
	
func load_question(file):
	if file.eof_reached() || score < 0:
		#end_game()
		return
	
	var current_line = file.get_csv_line()
	
	if current_line.size() < 6 or current_line[0] == "":
		#end_game()
		return
	
	timer = 30.0
	answer_label.text = ""
	
	question_label.text = current_line[0]
	
	question = current_line[0]
	correct_answer = current_line[1]
	
	question_active = true

func check_answer(selected_answer, correct_answer):
	if question_active:
		question_active = false
		if selected_answer == correct_answer:
			answer_label.text = "Correct Answer +10 points"
			score += 10
			update_score()
			yield(get_tree().create_timer(5.0), "timeout") # Delay
			load_question(question_pack)
		else:
			answer_label.text = "Incorrect answer -5 points"
			score -= 5
			update_score()
			yield(get_tree().create_timer(5.0), "timeout")
			load_question(question_pack)
			
func skip_question():
	if question_active:
		question_active = false
		answer_label.text = "Question skipped"
		yield(get_tree().create_timer(5.0), "timeout")
		load_question(question_pack)
		
func end_game():
	if question_pack:
		question_pack.close()
		print("Question pack closed")
		
	#var high_score = 0 # Default if on first game
	var dir = Directory.new()
	var file = File.new()
	
	#if file.open_encrypted_with_pass
	save_score(file,"user://previous_score_tf.dat",score)
	var high_score = read_score(dir,file,"user://high_score_tf.dat")
	if score > high_score:
		save_score(file,"user://high_score_tf.dat",score)
		
	get_tree().change_scene("res://Scenes/Main_Menu.tscn")


func save_score(f,file_path,score):
	if f.open_encrypted_with_pass(file_path,File.WRITE,"12345") == OK:
		f.store_var(score)
		f.close()
	
func read_score(d,f,file_path):
	var high_score = 0 # Defaullt val if first game
	if d.file_exists(file_path):
		if f.open_encrypted_with_pass("user://high_score.dat",File.READ,"12345") == OK:
			high_score = f.get_var()
			print(high_score)
			f.close()
	return high_score
	
# Button functions
