class_name GameManager;
extends Node2D;

@export var gravity: int = 1500;# ProjectSettings.get_setting("physics/2d/default_gravity");
@export var is_gravity_enabled: bool = true;

@export_category("Pipes")
@export_range(-80,0,.99) var pipes_min_y_position: int = 200;
@export_range(0,60,.99)  var pipes_max_y_position: int = 600;
@export_range(0.1,4.0) var pipes_spawn_delay: float = 1.6;
@export_range(50,200,.99) var pipes_spawn_spacing: int = 340; #Space between pipes instances
@export_range(20,200,.99)  var pipes_last_placement: int = 180; #
@export_range(4,5,.99) var pipes_top_tunnel_factor: float = 1;
@export_range(6,8,.99)  var pipes_bottom_tunnel_factor: float = 1.15;
@export var pipes_scale_x: float = 3;
@export var pipes_scale_y: float = 2;

@export_category("Player")
@export var is_player_movement_enabled: bool = true;
@export_range(5,100,.99) var player_forward_speed: int = 60;
@export_range(50,300,.99) var player_jump_strength: int = 550;
@export_range(0,100,.99) var player_field_of_view: int = 100;
@export var player_scale: float = 1;

var player_calculated_height: float;
var player_center_y: float;
var score: int = 0;
var pipes_scene := preload("res://scenes/pipes/pipes.tscn");
var _pipes_spawned: Dictionary;
var _viewport_height: float;

@onready var camera: Camera2D = $Camera2D;
@onready var player: Player = $Player;
@onready var timer_add_pipes: Timer = $TimerAddPipes;
@onready var label_score: Label = $CanvasLayer/CenterContainer/Label;
@onready var background: BackgroundParallax = $Background;
@onready var killzone: Area2D = $Killzone;



func _ready() -> void:

	_viewport_height = get_viewport().size.y;

	timer_add_pipes.wait_time = pipes_spawn_delay;
	timer_add_pipes.timeout.connect(_add_more_pipes);
	killzone.body_entered.connect(_on_background_floor_touched);

	_set_background_parallax_speed();
	_set_player();
#}


func _process(delta: float) -> void:
	if not player:
		return;

	camera.position.x = player.global_position.x + player_field_of_view;
#}


func _set_background_parallax_speed() -> void:
	background.bg_sky.scale.x = 0;
	background.bg_clouds.scale.x = 1.5;
	background.bg_buildings.scale.x = 2;
	background.bg_forest.scale.x = 1;
	background.bg_floor.scale.x = 7;
#}


func _set_player() -> void:
	player.z_index = 1;
	player.scale = Vector2(player_scale,player_scale);
	player_center_y = player.position.y;
	var marker_bottom_distance = abs(player.marker_bottom.position.y - player_center_y);
	var marker_top_distance = abs(player.marker_top.position.y - player_center_y);
	player_calculated_height = abs(marker_top_distance - marker_bottom_distance);
#}


func _add_more_pipes() -> void:

	#Prevent spawn without player
	if not player:
		return;

	# Prevent instantiations without scene
	var pipes_instance = pipes_scene.instantiate();

	if not pipes_scene:
		printerr("Error: Could not load pipes!");
		return;

	# Pipes placement
	var pipes_pos_y = randf_range(pipes_min_y_position, pipes_max_y_position);
	var pipes_pos_x = pipes_last_placement + pipes_spawn_spacing;
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
	pipes_instance.player = player;
	_pipes_spawned[pipes_instance.name] = pipes_instance;

	# Display on screen
	add_child(pipes_instance);

	var rangeFactor = randf_range(pipes_top_tunnel_factor, pipes_bottom_tunnel_factor);
	pipes_instance.pipe_top.position.y = player_calculated_height * rangeFactor * (-1);
	pipes_instance.pipe_bottom.position.y = player_calculated_height * rangeFactor;
#}


func _get_unique_id() -> float:
	var rng = RandomNumberGenerator.new();
	return rng.randf_range(-100.0, 100.0);
#}


func _game_over() -> void:
	player.queue_free();
	return_to_main_menu();
	return;
#}

func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
#}


func _on_pipes_conquered() -> void:
	score += 1;
	label_score.text = str(score);
#}


func _on_pipes_screen_exited(pipe_name: String) -> void:
	_pipes_spawned.erase(pipe_name);
#}


func _on_background_floor_touched(body: Node2D) -> void:
	if body is Player:
		_game_over();
#}


func _on_pipes_touched() -> void:
	_game_over();
#}
