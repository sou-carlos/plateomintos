extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 150.0

var life = 0
var dano_base = 10
var _player_ref: Jogador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group("jogador")
	print("Jogador: %s (%s)" % [_player_ref.name, _player_ref.get_class()])
	$AnimatedSprite2D.play()

	animated_sprite_2d.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_player_ref):
		return

	var direcao := global_position.direction_to(_player_ref.global_position)
	linear_velocity = direcao * speed
	rotation = direcao.angle()
	#teste git

func _on_hitbox_area_entered(area: Area2D) -> void:
	life -= 1
	if life <= 0:
		queue_free()
