class_name Player
extends CharacterBody2D;

var can_jump: bool = true;

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var marker_top: Marker2D = $MarkerTop;
@onready var marker_bottom: Marker2D = $MarkerBottom;
@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D;

func _ready() -> void:
	visible_on_screen.screen_entered.connect(_on_entered_toggle_jump_hability);
	visible_on_screen.screen_exited.connect(_on_exited_toggle_jump_hability);
#}


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

func _on_exited_toggle_jump_hability() -> void:
	can_jump = false;
#}


func _on_entered_toggle_jump_hability() -> void:
	can_jump = true;
#}
