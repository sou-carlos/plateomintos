extends CanvasLayer

signal start_game

func show_message(texto):
	$MessageLabel.text=texto
	$MessageLabel.show()
	$Timer.start()

func game_over():
	show_message("game over")
	await $Timer.timeout
	$MessageLabel.text="PLATEOMINTOS"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text=str(score)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_timer_timeout() -> void:
	$MessageLabel.hide()
