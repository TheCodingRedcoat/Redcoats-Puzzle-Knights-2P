extends Node2D

@onready var output_class = Output_Puzzle.new()
##How many players have exited
var players_exited : int = 0
const FILE_BEGIN = "res://Scenes/Levels/level_"
signal sound(is_activated : bool)

func _ready():
	sound.connect($Door_Open._connect)

func _on_area_door_body_entered(body):
#	print("entered door ", door_activated, " ", body)
	if output_class.activated and body is player:
		body.entered_door()
		players_exited += 1
		if players_exited == 2:
			var current_scene_file = get_parent().scene_file_path
			var next_level_number = current_scene_file.to_int() + 1
			var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
			global.change_scene(next_level_path)
			

func _on_recieve_input(is_activated : bool) -> void:
	output_class.activated = is_activated
	var door_open = output_class.Check_Activation()
#	print(activated)
	if door_open:
		var door = $Door
		sound.emit(is_activated)
		
		if is_activated:
			door.visible = false
		else:
	#		print("door deactivated")
			door.visible = true
			
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_level") and get_tree().current_scene.name != "Menu":
		var current_scene_file = get_parent().scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		global.change_scene(next_level_path)
