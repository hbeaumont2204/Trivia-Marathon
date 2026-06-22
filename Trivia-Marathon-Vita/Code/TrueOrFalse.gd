extends Control

var question = ""
var buttons = ""

var question_pack = ""
var is_true = ""
var file_path = "res://Assets/quiz_history_tf.csv"
var correct_answer = ""
var question_active = true

var score = 10
var timer = 30.0

onready var button_container = $CenterContainer/VBoxContainer
onready var question_label = $Question
onready var answer_label = $CenterContainer/VBoxContainer/Result
onready var points_label = $Points
onready var timer_label = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():	
	buttons = button_container.get_children()
	question_pack = load_question_pack(file_path)
	load_question(question_pack)
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		end_game()
	if Input.is_action_pressed("option1"):
		check_answer(true, correct_answer)
	if Input.is_action_just_pressed("option2"):
		check_answer(true, correct_answer)
	if Input.is_action_just_pressed("skip"):
		skip_question()
	if question_active:
		timer -= delta
		timer_label.text = "Time: " + str(int(timer))
		if timer <= 0:
			skip_question()

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
		end_game()
		return
	
	var current_line = file.get_csv_line()
	
	print(current_line.size())
	print(current_line[0])
	if current_line.size() < 2 or current_line[0] == "":
		end_game()
		return
	
	timer = 30.0
	answer_label.text = ""
	
	question_label.text = current_line[0]
	
	question = current_line[0]
	correct_answer = current_line[1]
	
	question_active = true


func check_answer(selected_answer, correct_answer):
	print(str(selected_answer))
	if question_active:
		question_active = false
		if str(selected_answer) == correct_answer:
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
	var high_score = 0 # Default val if first game
	if d.file_exists(file_path):
		if f.open_encrypted_with_pass("user://high_score.dat",File.READ,"12345") == OK:
			high_score = f.get_var()
			print(high_score)
			f.close()
	return high_score


# Button functions

func _on_True_pressed():
	check_answer(true,correct_answer)


func _on_False_pressed():
	check_answer(false,correct_answer)


func _on_Skip_pressed():
	skip_question()


