extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	if scene == null:
		push_error("No se pudo cargar la escena para la captura.")
		quit(1)
		return

	var game := scene.instantiate()
	root.add_child(game)
	for _frame in range(5):
		await process_frame

	var title_image := root.get_texture().get_image()
	var title_result := title_image.save_png("res://.godot/riftbeat-preview.png")
	if title_result != OK:
		push_error("No se pudo guardar la portada: %s" % error_string(title_result))
		game.free()
		quit(1)
		return

	game.start_game()
	for _frame in range(5):
		await process_frame
	var gameplay_image := root.get_texture().get_image()
	var gameplay_result := gameplay_image.save_png("res://.godot/riftbeat-gameplay.png")
	if gameplay_result != OK:
		push_error("No se pudo guardar la partida: %s" % error_string(gameplay_result))
		game.free()
		quit(1)
		return

	print("CAPTURAS OK: portada y partida.")
	game.free()
	quit(0)
