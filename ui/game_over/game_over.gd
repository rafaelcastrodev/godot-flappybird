extends Control;

signal game_restarted;

@onready var label_score: Label = $LabelScore;
@onready var label_score_value: Label = $LabelScoreValue;
@onready var replay: Button = $Replay;
@onready var quit: Button = $Quit;


func _ready() -> void:
	replay.pressed.connect(_on_replay_pressed);
	quit.pressed.connect(_on_quit_pressed);
#}

func _on_replay_pressed() -> void:
	game_restarted.emit();
#}

func _on_quit_pressed() -> void:
	get_tree().quit();
#}
