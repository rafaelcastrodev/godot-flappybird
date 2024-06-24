class_name Pipes extends Node2D;

signal pipes_touched;
signal pipes_screen_exited(pipe_name: String);
signal pipes_conquered;

const POS_GAP_MIN_THRESHOLD: float = 25;

@onready var pipe_top: Pipe = $PipeTop
@onready var pipe_bottom: Pipe = $PipeBottom;
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D;
@onready var area_2d: Area2D = $Area2D;


func _ready() -> void:

	# Connect pipes signals
	pipe_top.pipe_touched.connect(_on_pipes_touched);
	pipe_bottom.pipe_touched.connect(_on_pipes_touched);
	area_2d.body_exited.connect(_on_pipe_safe_pass);
	visible_on_screen_notifier.screen_exited.connect(_visible_on_screen_notifier_entered);

	_define_tunnel_space();
#}


func _on_pipe_safe_pass(body: Node2D) -> void:
	pipes_conquered.emit();
#}


func _on_pipes_touched() -> void:
	pipes_touched.emit();
#}


func _visible_on_screen_notifier_entered():
	pipes_screen_exited.emit(self.name);
#}


func _define_tunnel_space() -> void:
	#var min_gap = 150  # Adjust this value as needed
	#var max_gap = 300  # Adjust this value as needed
	#var random_gap = randf_range(min_gap, max_gap)
	#var scene_height = get_viewport().get_size().y
	#var top_pipe_bottom_position = scene_height - random_gap
#
	#pipe_top.set_position(Vector2.ZERO)  # Assuming top pipe starts at (0, 0)
	#pipe_bottom.set_position(Vector2(0, top_pipe_bottom_position))
	return;
#}
