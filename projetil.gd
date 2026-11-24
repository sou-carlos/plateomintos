extends Area2D

@export var velocidade: float = 700.0
@export var tempo_de_vida: float = 3.0
@export var shoot_delay: float = 0.7

@onready var shoot_timer: Timer = $ShootTimer
var direcao: Vector2 = Vector2.RIGHT

func _ready() -> void:
	direcao = direcao.normalized()
	rotation = direcao.angle()

	# Remove o projétil depois de alguns segundos.
	get_tree().create_timer(tempo_de_vida).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += direcao * velocidade * delta


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
