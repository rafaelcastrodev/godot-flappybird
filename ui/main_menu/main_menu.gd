extends Control;

signal game_started;

@onready var play: Button = $MarginContainer/VBoxContainer/Play;
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit;

func _ready() -> void:
	play.pressed.connect(_on_play_pressed);
	quit.pressed.connect(_on_quit_pressed);
#}


func _on_play_pressed() -> void:
	game_started.emit();
#}


func _on_quit_pressed() -> void:
	get_tree().quit();
#}
