extends CanvasLayer


func _on_range_button_pressed() -> void:
	PlayerConf.classe = PlayerConf.Classe.RANGE
	_ir_para_main()


func _on_melee_button_pressed() -> void:
	PlayerConf.classe = PlayerConf.Classe.MELEE
	_ir_para_main()


func _ir_para_main() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
