extends Area2D
var velocidade :float=700
var tempo_vida :float=3
var direcao :Vector2=Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direcao=direcao.normalized()
	rotation=direcao.angle()
	get_tree().create_timer(tempo_vida).timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position+=direcao*velocidade*delta


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
