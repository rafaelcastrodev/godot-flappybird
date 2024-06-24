class_name Player extends CharacterBody2D;

const FORWARD_SPEED = 20.0;
const JUMP_STRENGTH = 200.0;
const PLAYER_FIELD_VIEW = 40;
var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity");


@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass;
#}

func _physics_process(delta: float) -> void:

	velocity.x = FORWARD_SPEED;

	# Handle gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("flap"):
		velocity.y = JUMP_STRENGTH * (-1);

	move_and_slide()
#}

