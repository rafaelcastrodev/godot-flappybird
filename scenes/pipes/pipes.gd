class_name Pipes extends Node2D;

signal pipes_touched;
signal pipes_screen_exited(pipe_name: String);
signal pipes_conquered;

var player: Player;

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
