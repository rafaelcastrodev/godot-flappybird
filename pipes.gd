extends Node

signal pipes_touched;
signal pipes_screen_exited(pipe_name: String);
signal pipes_conquered;

@onready var pipe_top: Area2D = $PipeTop;
@onready var pipe_bottom: Area2D = $PipeBottom;
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D;
@onready var safe_area: Area2D = $SafeArea;


func _ready() -> void:

	# Connect pipes signals
	pipe_top.pipe_touched.connect(_on_pipes_touched);
	pipe_bottom.pipe_touched.connect(_on_pipes_touched);
	safe_area.body_exited.connect(_on_pipe_safe_pass);
	visible_on_screen_notifier.screen_exited.connect(_visible_on_screen_notifier_entered);
#}


func _on_pipe_safe_pass(body: Node2D) -> void:
	pipes_conquered.emit();
#}


func _on_pipes_touched() -> void:
	pipes_touched.emit();
#}


func _visible_on_screen_notifier_entered():
	self.queue_free();
	pipes_screen_exited.emit(self.name);
#}
