extends SceneTree

const ObstacleCatalog = preload("res://scripts/obstacles/obstacle_catalog.gd")
const ObstacleRuntime = preload("res://scripts/obstacles/obstacle_runtime.gd")

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var piece_ids := ObstacleCatalog.piece_ids()
	_check(piece_ids.size() == 12, "El catálogo debe registrar 12 piezas básicas.")

	for piece_id in piece_ids:
		var piece := ObstacleCatalog.create(String(piece_id), 0, 1000.0)
		for group in ObstacleCatalog.PROPERTY_GROUPS:
			_check(
				piece.has(group) and piece[group] is Dictionary,
				"%s debe definir la propiedad modular %s." % [piece_id, group]
			)

	var first_block := ObstacleCatalog.create("base_block", 0, 900.0)
	var second_block := ObstacleCatalog.create("base_block", 1, 900.0)
	first_block["movement"]["speed_scale"] = 4.0
	_check(
		is_equal_approx(float(second_block["movement"]["speed_scale"]), 1.0),
		"Cada instancia debe tener propiedades independientes."
	)

	var combined := ObstacleCatalog.create("cracked_block", 0, 900.0, {
		"movement": {
			"mode": "bob",
			"amplitude": 24.0,
			"frequency": 2.0,
		},
		"rhythm": {
			"mode": "pattern",
			"period_beats": 2,
			"active_beats": [1],
		},
	})
	_check(
		String(combined["movement"]["mode"]) == "bob"
		and bool(combined["destructible"]["enabled"]),
		"Las propiedades deben poder combinarse sin perder el tipo base."
	)

	var press := ObstacleCatalog.create("rhythm_press", 0, 800.0)
	_check(
		ObstacleRuntime.rhythm_is_active(press, 0),
		"La prensa debe estar activa al comenzar su patrón."
	)
	_check(
		not ObstacleRuntime.rhythm_is_active(press, 2),
		"La prensa debe retraerse durante la segunda mitad del patrón."
	)
	ObstacleRuntime.update(press, 0.2, 0.0, 2)
	_check(
		float(press["height"]) < float(press["max_height"]),
		"La prensa debe interpolar hacia su posición retraída."
	)

	var gravity_zone := ObstacleCatalog.create(
		"light_gravity_zone",
		0,
		220.0
	)
	_check(
		is_equal_approx(ObstacleRuntime.gravity_scale_at(gravity_zone, 220.0, 0), 0.38),
		"La zona ligera debe reducir la gravedad en su dimensión."
	)
	_check(
		is_equal_approx(ObstacleRuntime.gravity_scale_at(gravity_zone, 220.0, 1), 1.0),
		"La zona ligera no debe afectar la otra dimensión."
	)

	var cracked := ObstacleCatalog.create("cracked_block", 0, 400.0)
	var wrong_power := ObstacleRuntime.apply_power(cracked, "gravity_anchor")
	_check(
		not bool(wrong_power["applied"]),
		"Un poder incorrecto no debe dañar el bloque agrietado."
	)
	var pulse_result := ObstacleRuntime.apply_power(cracked, "rift_pulse")
	_check(
		bool(pulse_result["applied"]) and bool(pulse_result["destroyed"]),
		"Rift Pulse debe destruir el bloque agrietado."
	)

	_finish()


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)


func _finish() -> void:
	if failures.is_empty():
		print("OBSTACLE SYSTEM TEST OK: catálogo, combinación y prototipos.")
		quit(0)
	else:
		print("OBSTACLE SYSTEM TEST FAIL: %d error(es)." % failures.size())
		quit(1)
