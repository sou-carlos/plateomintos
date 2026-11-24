extends Node2D

@export var raio := 300.0
@export_range(12, 128) var quantidade_pontos: int = 64


@onready var corpo: StaticBody2D = $Corpo

func _ready() -> void:
	var pontos = PackedVector2Array()
	for i in range(quantidade_pontos):
		var angulo := TAU * float(i) / quantidade_pontos
		pontos.append(Vector2(cos(angulo), sin(angulo)) * raio)

	var contorno := CollisionPolygon2D.new()
	contorno.polygon = pontos
	contorno.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
	corpo.add_child(contorno)
	queue_redraw()

func _draw() -> void:
	# Vidro sutil sobre a área de jogo.
	#draw_circle(Vector2.ZERO, raio, Color(0.72, 0.91, 1.0, 0.07))
	draw_circle(Vector2.ZERO, raio, Color(0.0, 0.251, 0.282, 0.235))

	# Aro duplo para dar espessura à placa.
	draw_arc(Vector2.ZERO, raio, 0.0, TAU, quantidade_pontos * 2, Color(0.78, 0.94, 1.0, 0.72), 5.0, true)
	draw_arc(Vector2.ZERO, raio - 8.0, 0.0, TAU, quantidade_pontos * 2, Color(0.35, 0.75, 0.9, 0.32), 2.0, true)

	# Reflexos curvos no aro.
	draw_arc(Vector2.ZERO, raio - 3.0, deg_to_rad(205.0), deg_to_rad(260.0), 32, Color(1.0, 1.0, 1.0, 0.8), 7.0, true)
	draw_arc(Vector2.ZERO, raio - 3.0, deg_to_rad(25.0), deg_to_rad(65.0), 24, Color(1.0, 1.0, 1.0, 0.55), 4.0, true)
