extends Area2D

class_name Jogador

enum Classe { MELEE, RANGE }

@export var speed = 400 
@export var classe: Classe = Classe.MELEE
@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.12
@export var textura_articulacao: Texture2D
@export var distancia_articulacao: float = 40.0

@onready var articulacoes_container: Node2D = $Articulacoes
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox: Area2D = $AttackHitbox

signal hit 

var articulacoes: Array[Sprite2D] = []
var dash_time_left: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var atacando = false
var vida: int
var tamanhoTela 
var cor_original: Color
var tween_dano: Tween
var rastro: Array[Vector2] = []



func _ready() -> void:
	add_to_group("jogador")
	# O 'match' verifica o valor atual da variável 'classe'
	match classe:
		Classe.MELEE:
			vida = 5
			print("Guerreiro Escolhido")
		Classe.RANGE:
			vida = 3 
			print("Atirador Escolhido")
			
	tamanhoTela = get_viewport_rect().size
	attack_hitbox.monitorable = false 
	cor_original = animated_sprite_2d.modulate
	sincronizar_articulacoes()
	reposicionar_articulacoes()
	inicializar_rastro()

func inicio(pos):
	position = pos
	_ready()
	show()
	$CollisionShape2D.disabled = false

#adicionando comentario
func _input(event: InputEvent) -> void:
	if event.is_action_released("ataque basico"):
		ataque()

func ataque():
	if atacando:
		return
	
	atacando = true
	
	dash_direction = global_position.direction_to(
		get_global_mouse_position()
	)
	
	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2.RIGHT.rotated(global_rotation)
		
	look_at(global_position + dash_direction)
	dash_time_left = dash_duration
	
	animated_sprite_2d.play("ataque basico")
	attack_hitbox.monitorable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if dash_time_left >  0.0:
		var dash_step: float = minf(delta, dash_time_left)
		# Converte o deslocamento deste passo em velocidade.
		velocity = dash_direction * dash_speed * (dash_step / delta)

		dash_time_left = maxf(dash_time_left - delta, 0.0)
	else:
		var mouse_pos = get_global_mouse_position()
		
		if mouse_pos != global_position:
			look_at(mouse_pos)
		if Input.is_action_pressed("mvCima"):
			velocity.y -=1
		if Input.is_action_pressed("mvBaixo"):
			velocity.y +=1
		if Input.is_action_pressed("mvDireita"):
			velocity.x +=1
		if Input.is_action_pressed("mvEsquerda"):
			velocity.x -=1
		if velocity.length()>0:
			velocity = velocity.normalized() * speed

	position += velocity * delta
	#position = position.clamp(Vector2.ZERO,tamanhoTela)
	atualizar_articulacoes()

func adicionar_articulacao() -> void:
	var nova = Sprite2D.new()
	nova.scale = Vector2(0.5, 0.5)
	nova.texture = textura_articulacao
	nova.z_index = 0
	
	articulacoes_container.add_child(nova)
	articulacoes_container.move_child(nova, 0)
	
	var posicao_anterior: Vector2 = global_position
	
	if not articulacoes.is_empty():
		posicao_anterior = articulacoes.back().global_position

	var direcao_atras = Vector2.LEFT.rotated(global_rotation)

	nova.global_position = (
		posicao_anterior
		+ direcao_atras * distancia_articulacao
	)

	articulacoes.append(nova)

func reposicionar_articulacoes() -> void:
	var direcao_atras = Vector2.LEFT.rotated(global_rotation)

	for i in range(articulacoes.size()):
		articulacoes[i].global_position = (
			global_position
			+ direcao_atras * distancia_articulacao * (i + 1)
		)

func inicializar_rastro() -> void:
	rastro.clear()
	var direcao_atras = Vector2.LEFT.rotated(global_rotation)
	var distancia_total = distancia_articulacao * (articulacoes.size() + 2)
	var passos = maxi(ceili(distancia_total / 4.0), 1)
	for i in range(passos + 1):
		rastro.append(global_position + direcao_atras * (i * 4.0))

func sincronizar_articulacoes() -> void:
	var quantidade_desejada: int = maxi(vida, 0)

	while articulacoes.size() < quantidade_desejada:
		adicionar_articulacao()

	while articulacoes.size() > quantidade_desejada:
		var ultima: Sprite2D = articulacoes.pop_back()
		ultima.queue_free()
		

func atualizar_articulacoes() -> void:
	if rastro.is_empty():
		rastro.append(global_position)
	elif rastro[0].distance_to(global_position) >= 2.0:
		rastro.push_front(global_position)

	var distancia_percorrida := 0.0
	var indice := 0
	var posicao_anterior := global_position
	var acumulado := 0.0

	for articulacao in articulacoes:
		var distancia_alvo := distancia_percorrida + distancia_articulacao
		while indice < rastro.size() - 1:
			var comprimento := posicao_anterior.distance_to(rastro[indice + 1])
			if acumulado + comprimento >= distancia_alvo:
				var fracao := (distancia_alvo - acumulado) / maxf(comprimento, 0.001)
				articulacao.global_position = posicao_anterior.lerp(rastro[indice + 1], fracao)
				break
			acumulado += comprimento
			indice += 1
			posicao_anterior = rastro[indice]
		if indice >= rastro.size() - 1:
			articulacao.global_position = rastro.back()
		distancia_percorrida = distancia_alvo

	# Descarta o rastro que já ficou atrás da última articulação.
	while rastro.size() > 2 and rastro[-2].distance_to(global_position) > distancia_percorrida + 8.0:
		rastro.pop_back()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "ataque basico":
		atacando = false
		animated_sprite_2d.play("default")
		
	if animated_sprite_2d.animation == "default":
		attack_hitbox.monitorable = false

func piscar_dano() -> void:
	if tween_dano != null and tween_dano.is_valid():
		tween_dano.kill()
		
	animated_sprite_2d.modulate = Color.RED
	tween_dano = create_tween()
	
	#Um `Tween` altera uma propriedade gradualmente ao longo do tempo.
	tween_dano.tween_property(
		animated_sprite_2d,
		"modulate",
		cor_original,
		0.25
	)

		
func _on_area_entered(area: Area2D) -> void:
	vida = maxi(vida - 1, 0)
	
	sincronizar_articulacoes()
	piscar_dano()
	
	print(vida)
	
	if vida <= 0:
		hide()
		hit.emit()
		
		
