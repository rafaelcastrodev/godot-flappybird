extends Area2D;

signal pipe_touched;


func _ready() -> void:
	body_entered.connect(_on_body_entered)
#}


func _on_body_entered(body: Node2D):
	pipe_touched.emit();
#}
