extends Node

@export var gravity: int = 2200; # ProjectSettings.get_setting("physics/2d/default_gravity");
@export var is_gravity_enabled: bool = true;

@export_category("Pipes")
@export_range(-80,0,.99) var pipes_min_y_position: int = 240;
@export_range(0,60,.99)  var pipes_max_y_position: int = 830;
@export var pipes_spawn_delay: float = 1.6;
@export var pipes_spawn_spacing: int = 450; #Space between pipes instances
@export var pipes_last_placement: float; #
@export var pipes_tunnel_factor: float = 0.8;
#@export var pipes_top_tunnel_factor: float = 0.4;
#@export var pipes_bottom_tunnel_factor: float = 0.8;
@export var pipes_scale_x: float = 7;
@export var pipes_scale_y: float = 3;

@export_category("Player")
@export var is_player_movement_enabled: bool = true;
@export_range(5,100,.99) var player_forward_speed: int = 100;
@export_range(50,300,.99) var player_jump_strength: int = 880;
@export_range(0,100,.99) var player_field_of_view: int = 100;
@export var player_scale: float = 5;
@export var can_jump: bool = true;

const SCENE_PIPE := preload("res://scenes/pipes/pipes.tscn");
const SFX_FLAP := preload("res://assets/sfx/retro_footstep_grass_01.wav");
const BG_MUSIC := preload("res://assets/music/marimba-tropical-african-travel-game-197517.mp3");
var player_calculated_height: float;
var player_center_y: float;
var score: int = 0;
var _pipes_spawned: Dictionary;
var _viewport_height: float;
var _viewport_width: float;
var _pipes_spawn_counter: int = 0;

@onready var background: ParallaxBackground = $Background;
@onready var camera: Camera2D = $Camera2D;
@onready var player: Player = $Player;
@onready var timer_add_pipes: Timer = $TimerAddPipes;
@onready var label_score = $CanvasLayer/Control/HBoxContainer/LabelScore;
@onready var menu_game_over: Control = $CanvasLayer/MenuGameOver;
@onready var menu_main: Control = $CanvasLayer/MainMenu;
@onready var bg_music_player: AudioStreamPlayer2D = $BgMusicPlayer


func _ready() -> void:
	_toggle_pause_game();
	bg_music_player.stream = BG_MUSIC;
	bg_music_player.stream.loop = true;
	bg_music_player.play();
	menu_game_over.hide();
	label_score.hide();
	menu_main.show();
	menu_main.game_started.connect(_start_game);
	menu_game_over.game_restarted.connect(_restart_game);
	_viewport_height = get_viewport().size.y;
	_viewport_width = get_viewport().size.x;
	pipes_last_placement = _viewport_width;
	timer_add_pipes.wait_time = pipes_spawn_delay;
	timer_add_pipes.timeout.connect(_add_more_pipes);
	#killzone.body_entered.connect(_on_background_floor_touched);
	#_set_background_parallax_speed();
	_set_player();
	#_add_more_pipes(true);
#}


func _process(delta: float) -> void:
	if not player:
		return;

	camera.position.x = player.global_position.x + player_field_of_view;
#}


func _start_game() -> void:
	label_score.show();
	menu_main.hide();
	_toggle_pause_game();
#}

func _restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn");
#}


func _add_more_pipes(is_first_pipe: bool = false) -> void:

	#Prevent spawn without player
	if not player or _pipes_spawn_counter == 5:
		return;

	_pipes_spawn_counter += 1;

	# Prevent instantiations without scene
	var pipes_instance = SCENE_PIPE.instantiate();

	if not SCENE_PIPE:
		printerr("Error: Could not load pipes!");
		return;

	# Pipes placement
	var r1 = randf_range(pipes_min_y_position, pipes_max_y_position);
	var r2 = randf_range(pipes_min_y_position, pipes_max_y_position);
	var pipes_pos_y = randf_range(r1, r2);
	var pipes_pos_x = pipes_last_placement + pipes_spawn_spacing;

	if is_first_pipe:
		pipes_pos_x = _viewport_width + player_field_of_view;

	pipes_instance.position = Vector2(pipes_pos_x, pipes_pos_y);
	pipes_last_placement = pipes_instance.position.x;

	# Pipes scaling
	pipes_instance.scale = Vector2(pipes_scale_x, pipes_scale_y);

	# Connect signals
	pipes_instance.pipes_conquered.connect(_on_pipes_conquered);
	pipes_instance.pipes_touched.connect(_on_pipes_touched);
	pipes_instance.pipes_screen_exited.connect(_on_pipes_screen_exited);

	# Register withing spawned pipes.
	pipes_instance.name = pipes_instance.name.to_lower() + str(_get_unique_id());
	_pipes_spawned[pipes_instance.name] = pipes_instance;

	# Display on screen

	add_child(pipes_instance);
	#var rangeFactor = randf_range(pipes_top_tunnel_factor, pipes_bottom_tunnel_factor);
	#pipes_instance.pipe_top.position.y = player_calculated_height * rangeFactor * (-1);
	#pipes_instance.pipe_bottom.position.y = player_calculated_height * rangeFactor;
	#pipes_instance.pipe_top.position.y = player_calculated_height * rangeFactor;
	#pipes_instance.pipe_bottom.position.y = player_calculated_height * rangeFactor *(-1);
	pipes_instance.pipe_top.position.y = player_calculated_height;
	pipes_instance.pipe_bottom.position.y = player_calculated_height *(-1);
#}


func _set_background_parallax_speed() -> void:
	background.bg_sky.scale.x = 0;
	background.bg_clouds.scale.x = 1.5;
	background.bg_buildings.scale.x = 2;
	background.bg_forest.scale.x = 1;
	background.bg_floor.scale.x = 7;
#}


func _set_player() -> void:
	player.sfx_flap_audio_stream_player.stream = SFX_FLAP;
	player.z_index = 1;
	player.scale = Vector2(player_scale,player_scale);
	player_center_y = player.position.y;
	player_calculated_height = abs(player.marker_bottom.position.y) + abs(player.marker_top.position.y) * player_scale * pipes_tunnel_factor;
#}


func _get_unique_id() -> float:
	var rng = RandomNumberGenerator.new();
	return rng.randf_range(-100.0, 100.0);
#}


func _game_over() -> void:
	player.queue_free();
	label_score.hide();
	menu_game_over.show();
	return;
#}


func _toggle_pause_game() -> void:
	var pause_state: bool = get_tree().paused;
	get_tree().paused = not pause_state;
#}


func return_to_main_menu() -> void:
	return;
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
#}


func _on_pipes_conquered() -> void:
	score += 1;
	label_score.text = str(score);
	menu_game_over.label_score_value.text = label_score.text;
#}


func _on_pipes_screen_exited(pipe_name: String) -> void:
	_pipes_spawn_counter -= 1;
	_pipes_spawned.erase(pipe_name);
#}


func _on_background_floor_touched(body: Node2D) -> void:
	if body is Player:
		_game_over();
#}


func _on_pipes_touched() -> void:
	_game_over();
#}
