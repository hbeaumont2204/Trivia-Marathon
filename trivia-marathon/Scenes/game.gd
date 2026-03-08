extends Control

var question = ""
var option_1 = ""
var option_2 = ""
var option_3 = ""
var option_4 = ""
var buttons = ""

var question_pack = ""
var correct_answer = ""
var file_path = "res://quiz.csv"

var score = 0 # Player Score

@onready var button_container = $VBoxContainer
@onready var label = $Label
@onready var answerLabel = $Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = button_container.get_children()
	question_pack = load_question_pack(file_path)
	load_question(question_pack)	


func load_question_pack(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		print("Error finding file", file_path)
		get_tree().quit() # Ends game if file not found
	return file


func load_question(file):
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
	
	for i in range(0,4):
		buttons[i].text = current_line[i + 1]


func check_answer(selected_answer,correct_answer):
	if selected_answer == correct_answer:
		answerLabel.text = "Correct Answer"
		await get_tree().create_timer(5).timeout # Delay between questions
		load_question(question_pack)
	else:
		answerLabel.text = "Wrong answer"
		await get_tree().create_timer(5).timeout
		load_question(question_pack)


func skip_question():
	answerLabel.text = "Skipped"


func _on_option_1_pressed() -> void:
	check_answer(option_1,correct_answer)


func _on_option_2_pressed() -> void:
	check_answer(option_2,correct_answer)


func _on_option_3_pressed() -> void:
	check_answer(option_3,correct_answer)


func _on_option_4_pressed() -> void:
	check_answer(option_4,correct_answer)


func _on_skip_pressed() -> void:
	skip_question()
