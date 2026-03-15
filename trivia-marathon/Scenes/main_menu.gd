extends VBoxContainer

@onready var titleLabel = $Label
#var file_path = "res://banner.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#display_title(file_path)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()

'''
func display_title(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		print("Error finding file", file_path)
		titleLabel.text = "Title not found"
		#get_tree().quit() # Ends game if file not found
		return
	
	var content = file.get_as_text()
	titleLabel.text = content
	file.close()
'''
