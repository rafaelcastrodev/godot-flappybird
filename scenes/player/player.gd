class_name Player
extends CharacterBody2D

var can_jump: bool = true;

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D;
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D;
@onready var marker_top: Marker2D = $MarkerTop;
@onready var marker_bottom: Marker2D = $MarkerBottom;

func _physics_process(delta: float) -> void:

	if not owner.is_player_movement_enabled:
		return;

	velocity.x = owner.player_forward_speed;

	# Handle gravity
	if owner.is_gravity_enabled:
		velocity.y += owner.gravity * delta;

	# Handle jump.
	if can_jump && Input.is_action_just_pressed("flap"):
		velocity.y = owner.player_jump_strength * (-1);

	move_and_slide();
#}
