extends Node2D;

const PIPE_SPAWN_DELAY: float = 2.0;
const PIPE_SPAWN_THRESOLD: float = 55;

var score: int = 0;
var pipes_scene := preload("res://scenes/pipes/pipes.tscn");
var _pipe_last_placed_position: float = 64;
var _pipes_spawned: Dictionary;
var _viewport_height: float;

@onready var camera: Camera2D = $Camera2D;
@onready var player: Player = $Player;
@onready var timer_add_pipes: Timer = $TimerAddPipes;
@onready var label_score: Label = $CanvasLayer/CenterContainer/Label;


func _ready() -> void:
	_viewport_height = get_viewport().size.y;
	timer_add_pipes.wait_time = PIPE_SPAWN_DELAY;
	timer_add_pipes.timeout.connect(_add_more_pipes);
#}


func _process(delta: float) -> void:
	if not player:
		return;

	camera.position.x = player.global_position.x + player.PLAYER_FIELD_VIEW;
#}


func _add_more_pipes() -> void:

	if not pipes_scene:
		printerr("Error: Could not load pipes!");
		return;

	if not player:
		return;

	var pipes_instance = pipes_scene.instantiate();

	var pipes_pos_y = randf_range(-100,100);
	var pipes_pos_x = _pipe_last_placed_position + PIPE_SPAWN_THRESOLD;
	pipes_instance.position = Vector2(pipes_pos_x, pipes_pos_y)

	#pipes_instance.position.x = _pipe_last_placed_position + PIPE_SPAWN_THRESOLD;
	_pipe_last_placed_position = pipes_instance.position.x;

	# Connect signals
	pipes_instance.pipes_conquered.connect(_on_pipes_conquered);
	pipes_instance.pipes_touched.connect(_on_pipes_touched);
	pipes_instance.pipes_screen_exited.connect(_on_pipes_screen_exited);

	# Register withing spawned pipes.
	pipes_instance.name = pipes_instance.name.to_lower() + str(_get_unique_id());
	_pipes_spawned[pipes_instance.name] = pipes_instance;

	# Display on screen
	add_child(pipes_instance);
#}

func _get_unique_id() -> float:
	var rng = RandomNumberGenerator.new();
	return rng.randf_range(-100.0, 100.0);
#}


func _on_pipes_conquered() -> void:
	score += 1;
	label_score.text = str(score);
#}


func _on_pipes_screen_exited(pipe_name: String) -> void:
	_pipes_spawned[pipe_name].queue_free();
	_pipes_spawned.erase(pipe_name);

func _on_pipes_touched() -> void:
	#player.queue_free();
	return;
#}
