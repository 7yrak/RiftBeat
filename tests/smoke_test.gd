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
	_check(game.game_state == 0, "El estado inicial debe ser TITLE.")

	game.start_game()
	await process_frame
	_check(game.game_state == 1, "start_game() debe iniciar la partida.")
	_check(game.lives == 3, "La partida debe comenzar con tres vidas.")
	_check(game.active_lane == 0, "La partida debe comenzar en la dimensión cyan.")

	game.switch_dimension()
	_check(game.active_lane == 1, "switch_dimension() debe alternar la dimensión.")

	game.jump()
	_check(game.jump_velocity < 0.0, "jump() debe aplicar velocidad vertical.")
	_check(game.obstacles.size() == 0, "La partida no debe comenzar con obstáculos inmediatos.")

	game.start_game()
	game._on_beat()
	_check(game.obstacles.size() == 1, "El segundo pulso debe generar un obstáculo.")
	game.obstacles[0]["x"] = 220.0
	game._update_game(0.0)
	_check(game.lives == 2, "Una colisión en la dimensión activa debe quitar una vida.")
	_check(game.obstacles.is_empty(), "El obstáculo que golpea debe eliminarse.")

	game.start_game()
	game.jump_offset = -120.0
	game.obstacles.append({
		"x": 220.0,
		"lane": 0,
		"width": 48.0,
		"height": 68.0,
		"passed": false,
	})
	game._update_game(0.0)
	_check(game.lives == 3, "Un salto suficiente debe evitar la colisión.")

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


func _finish() -> void:
	if failures.is_empty():
		print("SMOKE TEST OK: escena, controles, ritmo, colisiones y victoria.")
		quit(0)
	else:
		print("SMOKE TEST FAIL: %d error(es)." % failures.size())
		quit(1)
