extends Area2D

@onready var timer = $Timer;
@onready var sfx_player_dies = $SfxPlayerDies


func _on_body_entered(body):
	print("You died!");
	sfx_player_dies.play()
	Engine.time_scale = 0.5;
	body.get_node("CollisionShape2D").queue_free();
	timer.start();


func _on_timer_timeout():
	Engine.time_scale = 1;
	get_tree().reload_current_scene();
