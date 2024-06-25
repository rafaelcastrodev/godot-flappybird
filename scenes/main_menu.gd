extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	play.pressed.connect(_on_play_pressed);
	quit.pressed.connect(_on_quit_pressed);
#}

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn");
#}

func _on_quit_pressed() -> void:
	get_tree().quit();
#}
