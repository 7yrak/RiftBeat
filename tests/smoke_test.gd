extends SceneTree

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	_check(scene != null, "La escena principal debe cargar.")
	if scene == null:
		_finish()
		return

	var game := scene.instantiate()
	root.add_child(game)
	await process_frame

	_check(game.has_method("start_game"), "El juego debe exponer start_game().")
	_check(game.has_method("jump"), "El juego debe exponer jump().")
	_check(game.has_method("switch_dimension"), "El juego debe exponer switch_dimension().")
	_check(game.has_method("activate_rift_pulse"), "El juego debe exponer Rift Pulse.")
	_check(game.game_state == 0, "El estado inicial debe ser TITLE.")
	_check(
		int(ProjectSettings.get_setting("display/window/handheld/orientation")) == 4,
		"Android debe usar orientación horizontal automática."
	)
	_check(
		int(ProjectSettings.get_setting("display/window/size/viewport_width")) >
		int(ProjectSettings.get_setting("display/window/size/viewport_height")),
		"El viewport debe ser horizontal."
	)

	game.start_game()
	await process_frame
	_check(game.game_state == 1, "start_game() debe iniciar la partida.")
	_check(game.lives == 3, "La partida debe comenzar con tres vidas.")
	_check(game.active_lane == 0, "La partida debe comenzar en la dimensión cyan.")

	game.switch_dimension()
	_check(game.active_lane == 1, "switch_dimension() debe alternar la dimensión.")

	game.jump()
	_check(game.jump_velocity < 0.0, "jump() debe aplicar velocidad vertical.")
	_check(
		is_equal_approx(absf(game.roll_target), TAU * 1.25),
		"El Rift Roll debe preparar cinco cuartos de giro."
	)
	game._update_game(0.1)
	_check(absf(game.player_rotation) > 0.1, "El cubo debe girar durante el salto.")
	_check(not game.jump_trail.is_empty(), "El salto debe dejar una estela visual.")
	_check(game.obstacles.size() == 0, "La partida no debe comenzar con obstáculos inmediatos.")

	game.jump_offset = -1.0
	game.jump_velocity = 200.0
	game._update_game(0.02)
	_check(is_zero_approx(game.jump_offset), "El salto debe terminar sobre la pista.")
	_check(
		is_equal_approx(game.player_rotation, game.roll_target),
		"El cubo debe encajar en el cuarto de giro objetivo al aterrizar."
	)
	_check(game.landing_impact > 0.0, "El aterrizaje debe activar su impacto visual.")

	game.start_game()
	game._on_beat()
	_check(game.obstacles.size() == 1, "El segundo pulso debe generar un obstáculo.")
	game.obstacles[0]["x"] = 220.0
	game._update_game(0.0)
	_check(game.lives == 2, "Una colisión en la dimensión activa debe quitar una vida.")
	_check(game.obstacles.is_empty(), "El obstáculo que golpea debe eliminarse.")

	game.start_game()
	game.jump_offset = -120.0
	game._spawn_piece("base_block", 0, 220.0)
	game._update_game(0.0)
	_check(game.lives == 3, "Un salto suficiente debe evitar la colisión.")

	game.start_game()
	game.obstacles.clear()
	game._spawn_piece("light_gravity_zone", 0, 220.0)
	game._update_game(0.0)
	_check(
		is_equal_approx(game.current_gravity_scale, 0.38),
		"La zona ligera debe modificar la gravedad del jugador."
	)

	game.start_game()
	game.obstacles.clear()
	game.beat_count = 0
	game._spawn_piece("rhythm_press", 0, 220.0)
	game._update_game(0.0)
	_check(game.lives == 2, "La prensa activa debe causar una colisión.")

	game.start_game()
	game.obstacles.clear()
	game._spawn_piece("cracked_block", 0, 400.0)
	var initial_charges: int = game.rift_charges
	var pulse_activated: bool = game.activate_rift_pulse()
	_check(pulse_activated, "Rift Pulse debe encontrar un bloque agrietado cercano.")
	_check(game.obstacles.is_empty(), "Rift Pulse debe destruir el bloque agrietado.")
	_check(
		game.rift_charges == initial_charges - 1,
		"Rift Pulse debe consumir una carga al impactar."
	)

	game.start_game()
	game.obstacles.clear()
	var charges_without_target: int = game.rift_charges
	_check(
		not game.activate_rift_pulse(),
		"Rift Pulse debe rechazar la activación sin objetivo."
	)
	_check(
		game.rift_charges == charges_without_target,
		"Rift Pulse no debe consumir una carga sin objetivo."
	)

	game.start_game()
	for _beat in range(3):
		game._on_beat()
	_check(
		_contains_piece(game.obstacles, "light_gravity_zone"),
		"El patrón debe introducir gravedad ligera en el pulso 4."
	)
	for _beat in range(6):
		game._on_beat()
	_check(
		_contains_piece(game.obstacles, "rhythm_press"),
		"El patrón debe introducir la prensa en el pulso 10."
	)
	for _beat in range(8):
		game._on_beat()
	_check(
		_contains_piece(game.obstacles, "cracked_block"),
		"El patrón debe introducir el bloque agrietado en el pulso 18."
	)

	game.start_game()
	game.elapsed_time = 45.0
	game._update_game(0.0)
	_check(game.game_state == 3, "Sobrevivir 45 segundos debe activar VICTORY.")

	game.queue_free()
	await process_frame
	scene = null
	await process_frame
	_finish()


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)


func _contains_piece(items: Array[Dictionary], piece_id: String) -> bool:
	for item in items:
		if String(item["piece_id"]) == piece_id:
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("SMOKE TEST OK: juego, Rift Roll, obstáculos modulares y Rift Pulse.")
		quit(0)
	else:
		print("SMOKE TEST FAIL: %d error(es)." % failures.size())
		quit(1)
