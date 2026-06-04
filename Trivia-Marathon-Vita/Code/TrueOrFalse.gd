extends Control

var question = ""
var buttons = ""

var question_pack = ""
var is_true = False
var file_path = ""

var score = 0
var timer = 30.0

onready var button_container = $CenterContainer/VBoxContainer
onready var question_label  $Question
onready var answer_label = $CenterContainer/VBoxContainer/Result
onready var points_label = $Points
onready var timer_label = $Timer

func _ready() -> void:
	# Test values


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
