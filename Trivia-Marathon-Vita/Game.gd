extends Control


var question = ""
var option_1 = ""
var option_2 = ""
var option_3 = ""
var option_4 = ""
var buttons = ""

var question_pack = ""
var correct_answer = ""
var file_path = "res://Assets/quiz_pack_2.csv"
var questionActive = true

var score = 0 # Player Score
var timer = 30.0

onready var button_container = $CenterContainer/VBoxContainer
onready var label = $Question
onready var answerLabel = $CenterContainer/VBoxContainer/Result
onready var pointsLabel = $Points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = button_container.get_children()
	question_pack = load_question_pack(file_path)
	load_question(question_pack)
	update_score()

func _process(delta):
	if Input.is_action_just_pressed("option1"):
		#questionActive = false
		check_answer(option_1,correct_answer)
	if Input.is_action_just_pressed("option2"):
		#questionActive = false
		check_answer(option_2,correct_answer)
	if Input.is_action_just_pressed("option3"):
		#questionActive = false
		check_answer(option_3,correct_answer)
	if Input.is_action_just_pressed("option4"):
		#questionActive = false
		check_answer(option_4,correct_answer)
	if Input.is_action_just_pressed("skip"):
		skip_question()
	#pointsLabel.text = "Points: " + str(score)
	timer -= delta
	
func update_score():
	pointsLabel.text = "Points: " + str(score)


func load_question_pack(file_path: String):
	#var file = FileAccess.open(file_path, FileAccess.READ)
	
	var file = File.new()
	file.open(file_path, File.READ)
	
	if not file:
		print("Error finding file", file_path)
		label.text = "Quiz pack not found"
		#get_tree().quit() # Ends game if file not found
		return
	return file


func load_question(file):
	if file.eof_reached():
		end_game()
	var current_line = file.get_csv_line()
	answerLabel.text = "" # Reset/Initialise answer label
	#print(current_line)
	label.text = current_line[0] # Display question
	
	question = current_line[0]
	# Set buttons to options
	option_1 = current_line[1]
	option_2 = current_line[2]
	option_3 = current_line[3]
	option_4 = current_line[4]
	correct_answer = current_line[5] # Define correct answer
	questionActive = true
	for i in range(0,4):
		buttons[i].text = current_line[i + 1]


func check_answer(selected_answer,correct_answer):
	if questionActive:
		questionActive = false
		if selected_answer == correct_answer:
			answerLabel.text = "Correct Answer"
			yield(get_tree().create_timer(5.0), "timeout") # Delay between questions
			score += 10
			update_score()
			load_question(question_pack)
		else:
			answerLabel.text = "Wrong answer"
			yield(get_tree().create_timer(5.0), "timeout") # Delay between questions
			score -= 5
			update_score()
			load_question(question_pack)


func skip_question():
	if questionActive:
		questionActive = false
		answerLabel.text = "Skipped"
		yield(get_tree().create_timer(5.0), "timeout") # Delay between questions
		load_question(question_pack)
	
func no_answer():
	questionActive = false
	answerLabel.text = "No answer given"
	yield(get_tree().create_timer(5.0), "timeout") # Delay
	load_question(question_pack)
	
func end_game():
	question_pack.close()
	get_tree().change_scene("res://End_Menu.tscn")


func _on_Option1_pressed():
	check_answer(option_1,correct_answer)


func _on_Option2_pressed():
	check_answer(option_2,correct_answer)


func _on_Option3_pressed():
	check_answer(option_3,correct_answer)


func _on_Option4_pressed():
	check_answer(option_4,correct_answer)


func _on_Skip_pressed():
	skip_question()
