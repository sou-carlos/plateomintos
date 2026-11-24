extends CanvasLayer





func _on_corpo_a_corpo_pressed() -> void:
	PlayerConf.classe=PlayerConf.Classe.MELEE
	proxima_cena()


func _on_longa_distancea_pressed() -> void:
	PlayerConf.classe=PlayerConf.Classe.RANGE
	proxima_cena()

func proxima_cena() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
