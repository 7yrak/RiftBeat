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
		game.queue_free()
		await process_frame
		scene = null
		quit(1)
		return

	game.start_game()
	game.obstacles.clear()
	game.beat_count = 0
	game._spawn_piece("light_gravity_zone", 0, 360.0)
	game._spawn_piece("cracked_block", 0, 510.0)
	game._spawn_piece("rhythm_press", 1, 720.0)
	game.jump()
	for _frame in range(14):
		await process_frame
	var gameplay_image := root.get_texture().get_image()
	var gameplay_result := gameplay_image.save_png("res://.godot/riftbeat-gameplay.png")
	if gameplay_result != OK:
		push_error("No se pudo guardar la partida: %s" % error_string(gameplay_result))
		game.queue_free()
		await process_frame
		scene = null
		quit(1)
		return

	if not game.activate_rift_pulse():
		push_error("Rift Pulse no encontró el bloque preparado para la captura.")
		game.queue_free()
		await process_frame
		scene = null
		quit(1)
		return
	for _frame in range(2):
		await process_frame
	var pulse_image := root.get_texture().get_image()
	var pulse_result := pulse_image.save_png("res://.godot/riftbeat-pulse.png")
	if pulse_result != OK:
		push_error("No se pudo guardar Rift Pulse: %s" % error_string(pulse_result))
		game.queue_free()
		await process_frame
		scene = null
		quit(1)
		return

	print("CAPTURAS OK: portada, prototipos y Rift Pulse.")
	game.queue_free()
	await process_frame
	scene = null
	await process_frame
	quit(0)
