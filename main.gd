extends Node
@export var mob_scene: PackedScene
var score



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_jogador_hit() -> void:
	game_over()


func game_over():
	$PontosTimer.stop()
	$InimigoTimer.stop()
	$HUD.game_over()
	$SomF.play()
	$Musica.stop()

func novo_jogo():
	score = 0
	$Jogador.inicio($StartPosition.position)
	$InicioTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("!!!")
	$Musica.play()


func _on_inicio_timer_timeout() -> void:
	#$InimigoTimer.start()
	$PontosTimer.start()


func _on_pontos_timer_timeout() -> void:
	score+=1
	$HUD.update_score(score)


func _on_inimigo_timer_timeout() -> void:
	var inimigo=mob_scene.instantiate()
	var inimigo_spawn_location=$Path2D/InimigoSpawnLocation
	inimigo_spawn_location.progress_ratio=randf()
	inimigo.position=inimigo_spawn_location.position
	var direction=inimigo_spawn_location.rotation+ PI/2
	direction+=randf_range(-PI/4,PI/4)
	inimigo.rotation=direction
	var velocity=Vector2(randf_range(150.0,250.0),0.0)
	inimigo.linear_velocity=velocity.rotated(direction)
	add_child(inimigo)


func _on_hud_start_game() -> void:
	novo_jogo()
