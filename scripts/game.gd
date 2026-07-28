extends Node2D

enum GameState {
	TITLE,
	PLAYING,
	GAME_OVER,
	VICTORY,
}

const VIEW_SIZE := Vector2(1280.0, 720.0)
const PLAYER_X := 220.0
const PLAYER_SIZE := Vector2(46.0, 56.0)
const LANE_Y := [350.0, 535.0]
const BPM := 120.0
const BEAT_INTERVAL := 60.0 / BPM
const ROUND_DURATION := 45.0
const GRAVITY := 1900.0
const JUMP_SPEED := -720.0
const RIFT_ROLL_TURNS := 1.25
const RIFT_ROLL_SPEED := 10.5
const TRAIL_INTERVAL := 0.045
const TRAIL_LIFETIME := 0.32
const CLICK_SAMPLE_COUNT := 2600
const SAMPLE_RATE := 44100.0
const OBSTACLE_PATTERN := [0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0]

const COLOR_BG := Color("#06091f")
const COLOR_CYAN := Color("#42f5e9")
const COLOR_PINK := Color("#ff4fd8")
const COLOR_WHITE := Color("#f3f7ff")
const COLOR_MUTED := Color("#7f8ab8")
const COLOR_DANGER := Color("#ff506f")

var game_state: int = GameState.TITLE
var active_lane := 0
var jump_offset := 0.0
var jump_velocity := 0.0
var player_rotation := 0.0
var roll_target := 0.0
var roll_direction := 1.0
var takeoff_squash := 0.0
var landing_impact := 0.0
var trail_timer := 0.0
var elapsed_time := 0.0
var beat_timer := 0.0
var beat_count := 0
var beat_pulse := 0.0
var switch_flash := 0.0
var switch_cooldown := 0.0
var invulnerability := 0.0
var ambient_time := 0.0
var score := 0
var combo := 0
var best_combo := 0
var lives := 3
var is_paused := false
var obstacles: Array[Dictionary] = []
var stars: Array[Vector2] = []
var jump_trail: Array[Dictionary] = []

var audio_player: AudioStreamPlayer
var synth_playback: AudioStreamGeneratorPlayback
var click_samples_left := 0
var click_phase := 0.0
var click_frequency := 880.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_star_field()
	_setup_audio()
	get_viewport().size_changed.connect(queue_redraw)
	queue_redraw()


func _exit_tree() -> void:
	if audio_player != null:
		audio_player.stop()
		audio_player.stream = null
	synth_playback = null


func _process(delta: float) -> void:
	ambient_time += delta
	_fill_audio_buffer()
	beat_pulse = maxf(0.0, beat_pulse - delta * 3.8)
	switch_flash = maxf(0.0, switch_flash - delta * 4.5)

	if game_state == GameState.PLAYING and not is_paused:
		_update_game(delta)

	queue_redraw()


func _update_game(delta: float) -> void:
	elapsed_time += delta
	beat_timer += delta
	switch_cooldown = maxf(0.0, switch_cooldown - delta)
	invulnerability = maxf(0.0, invulnerability - delta)
	takeoff_squash = maxf(0.0, takeoff_squash - delta * 7.5)
	landing_impact = maxf(0.0, landing_impact - delta * 5.5)
	_update_jump_trail(delta)

	while beat_timer >= BEAT_INTERVAL:
		beat_timer -= BEAT_INTERVAL
		_on_beat()

	if jump_offset < 0.0 or jump_velocity < 0.0:
		player_rotation = move_toward(
			player_rotation,
			roll_target,
			RIFT_ROLL_SPEED * delta
		)
		trail_timer -= delta
		while trail_timer <= 0.0:
			_add_jump_trail_sample()
			trail_timer += TRAIL_INTERVAL
		jump_velocity += GRAVITY * delta
		jump_offset += jump_velocity * delta
		if jump_offset >= 0.0:
			jump_offset = 0.0
			jump_velocity = 0.0
			player_rotation = roll_target
			landing_impact = 1.0

	var speed := minf(430.0, 320.0 + elapsed_time * 2.4)
	for index in range(obstacles.size() - 1, -1, -1):
		var obstacle := obstacles[index]
		obstacle["x"] = float(obstacle["x"]) - speed * delta

		if not bool(obstacle["passed"]) and float(obstacle["x"]) < PLAYER_X:
			obstacle["passed"] = true
			combo += 1
			best_combo = maxi(best_combo, combo)
			score += 80 + combo * 5

		if _obstacle_hits_player(obstacle):
			obstacles.remove_at(index)
			_take_hit()
			continue

		if float(obstacle["x"]) < -120.0:
			obstacles.remove_at(index)

	if elapsed_time >= ROUND_DURATION:
		_finish_game(true)


func _on_beat() -> void:
	beat_count += 1
	beat_pulse = 1.0
	score += 5
	_trigger_click(beat_count % 4 == 1)

	if beat_count % 12 == 0:
		_spawn_obstacle(0)
		_spawn_obstacle(1)
	elif beat_count % 2 == 0:
		var pattern_index := posmod((beat_count / 2) - 1, OBSTACLE_PATTERN.size())
		_spawn_obstacle(OBSTACLE_PATTERN[pattern_index])


func _spawn_obstacle(lane: int) -> void:
	var height := 68.0
	if beat_count % 8 == 0:
		height = 82.0
	obstacles.append({
		"x": VIEW_SIZE.x + 70.0,
		"lane": lane,
		"width": 48.0,
		"height": height,
		"passed": false,
	})


func _obstacle_hits_player(obstacle: Dictionary) -> bool:
	if invulnerability > 0.0 or int(obstacle["lane"]) != active_lane:
		return false

	var player_rect := Rect2(
		Vector2(
			PLAYER_X - PLAYER_SIZE.x * 0.5,
			LANE_Y[active_lane] - PLAYER_SIZE.y + jump_offset
		),
		PLAYER_SIZE
	).grow(-6.0)
	var obstacle_rect := Rect2(
		Vector2(
			float(obstacle["x"]) - float(obstacle["width"]) * 0.5,
			LANE_Y[int(obstacle["lane"])] - float(obstacle["height"])
		),
		Vector2(float(obstacle["width"]), float(obstacle["height"]))
	).grow(-4.0)
	return player_rect.intersects(obstacle_rect)


func _take_hit() -> void:
	lives -= 1
	combo = 0
	invulnerability = 1.1
	switch_flash = 1.0
	_trigger_damage_tone()
	if lives <= 0:
		_finish_game(false)


func _finish_game(won: bool) -> void:
	game_state = GameState.VICTORY if won else GameState.GAME_OVER
	is_paused = false
	obstacles.clear()
	_trigger_click(true)


func start_game() -> void:
	game_state = GameState.PLAYING
	active_lane = 0
	jump_offset = 0.0
	jump_velocity = 0.0
	player_rotation = 0.0
	roll_target = 0.0
	roll_direction = 1.0
	takeoff_squash = 0.0
	landing_impact = 0.0
	trail_timer = 0.0
	elapsed_time = 0.0
	beat_timer = 0.0
	beat_count = 0
	beat_pulse = 0.0
	switch_flash = 0.0
	switch_cooldown = 0.0
	invulnerability = 0.0
	score = 0
	combo = 0
	best_combo = 0
	lives = 3
	is_paused = false
	obstacles.clear()
	jump_trail.clear()
	_on_beat()


func jump() -> void:
	if game_state != GameState.PLAYING or is_paused:
		return
	if is_zero_approx(jump_offset) and is_zero_approx(jump_velocity):
		jump_velocity = JUMP_SPEED
		roll_direction = 1.0 if active_lane == 0 else -1.0
		roll_target = player_rotation + roll_direction * TAU * RIFT_ROLL_TURNS
		takeoff_squash = 1.0
		trail_timer = 0.0
		_add_jump_trail_sample()


func switch_dimension() -> void:
	if game_state != GameState.PLAYING or is_paused or switch_cooldown > 0.0:
		return
	active_lane = 1 - active_lane
	switch_cooldown = 0.16
	switch_flash = 1.0


func _update_jump_trail(delta: float) -> void:
	for index in range(jump_trail.size() - 1, -1, -1):
		jump_trail[index]["life"] = float(jump_trail[index]["life"]) - delta
		if float(jump_trail[index]["life"]) <= 0.0:
			jump_trail.remove_at(index)


func _add_jump_trail_sample() -> void:
	jump_trail.append({
		"center": _player_center(),
		"rotation": player_rotation,
		"life": TRAIL_LIFETIME,
		"lane": active_lane,
	})


func _toggle_pause() -> void:
	if game_state == GameState.PLAYING:
		is_paused = not is_paused


func _handle_primary_action() -> void:
	match game_state:
		GameState.TITLE, GameState.GAME_OVER, GameState.VICTORY:
			start_game()
		GameState.PLAYING:
			jump()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_SPACE, KEY_UP, KEY_W, KEY_ENTER:
				_handle_primary_action()
			KEY_TAB, KEY_DOWN, KEY_S, KEY_SHIFT:
				switch_dimension()
			KEY_R:
				start_game()
			KEY_ESCAPE, KEY_P:
				_toggle_pause()
		get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenTouch and event.pressed:
		_handle_pointer(event.position)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_pointer(event.position)
		get_viewport().set_input_as_handled()


func _handle_pointer(position: Vector2) -> void:
	if game_state != GameState.PLAYING:
		start_game()
	elif is_paused:
		_toggle_pause()
	elif position.x < get_viewport_rect().size.x * 0.5:
		switch_dimension()
	else:
		jump()


func _setup_audio() -> void:
	if DisplayServer.get_name() == "headless":
		return
	audio_player = AudioStreamPlayer.new()
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = SAMPLE_RATE
	generator.buffer_length = 0.12
	audio_player.stream = generator
	audio_player.volume_db = -7.0
	add_child(audio_player)
	audio_player.play()
	synth_playback = audio_player.get_stream_playback()


func _trigger_click(accent: bool) -> void:
	click_samples_left = CLICK_SAMPLE_COUNT
	click_phase = 0.0
	click_frequency = 1040.0 if accent else 720.0


func _trigger_damage_tone() -> void:
	click_samples_left = CLICK_SAMPLE_COUNT * 2
	click_phase = 0.0
	click_frequency = 170.0


func _fill_audio_buffer() -> void:
	if synth_playback == null:
		return
	var frames_available := synth_playback.get_frames_available()
	for _frame in range(frames_available):
		var sample := 0.0
		if click_samples_left > 0:
			var envelope := float(click_samples_left) / float(CLICK_SAMPLE_COUNT)
			envelope = minf(1.0, envelope)
			sample = sin(click_phase) * 0.16 * envelope * envelope
			click_phase += TAU * click_frequency / SAMPLE_RATE
			click_samples_left -= 1
		synth_playback.push_frame(Vector2(sample, sample))


func _build_star_field() -> void:
	var random := RandomNumberGenerator.new()
	random.seed = 0x71F7BEA7
	for _index in range(80):
		stars.append(Vector2(
			random.randf_range(0.0, VIEW_SIZE.x),
			random.randf_range(20.0, 600.0)
		))


func _draw() -> void:
	_draw_background()
	_draw_lanes()
	_draw_obstacles()
	_draw_player()
	_draw_hud()
	_draw_touch_controls()

	match game_state:
		GameState.TITLE:
			_draw_title()
		GameState.GAME_OVER:
			_draw_end_screen(false)
		GameState.VICTORY:
			_draw_end_screen(true)

	if is_paused:
		_draw_pause()


func _draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BG)
	draw_circle(Vector2(180.0, 160.0), 300.0, Color(COLOR_CYAN, 0.035))
	draw_circle(Vector2(1110.0, 430.0), 360.0, Color(COLOR_PINK, 0.045))

	for index in range(stars.size()):
		var star := stars[index]
		var shimmer := 0.35 + 0.3 * sin(ambient_time * 1.7 + float(index))
		draw_circle(star, 1.2 + float(index % 3) * 0.45, Color(0.75, 0.84, 1.0, shimmer))

	var grid_offset := fmod(ambient_time * 90.0, 120.0)
	for x in range(-120, 1400, 120):
		var line_x := float(x) - grid_offset
		draw_line(Vector2(line_x, 250.0), Vector2(line_x, 570.0), Color(0.25, 0.34, 0.64, 0.09), 2.0)

	var pulse_alpha := 0.035 + beat_pulse * 0.08
	draw_rect(Rect2(0.0, 240.0, VIEW_SIZE.x, 350.0), Color(COLOR_WHITE, pulse_alpha), true)


func _draw_lanes() -> void:
	for lane in range(2):
		var lane_color := COLOR_CYAN if lane == 0 else COLOR_PINK
		var active_strength := 0.65 if lane == active_lane else 0.18
		draw_line(
			Vector2(0.0, LANE_Y[lane]),
			Vector2(VIEW_SIZE.x, LANE_Y[lane]),
			Color(lane_color, active_strength),
			4.0 if lane == active_lane else 2.0
		)
		draw_line(
			Vector2(0.0, LANE_Y[lane] + 8.0),
			Vector2(VIEW_SIZE.x, LANE_Y[lane] + 8.0),
			Color(lane_color, active_strength * 0.22),
			12.0
		)
		_draw_label(
			"DIMENSIÓN %s" % ("CYAN" if lane == 0 else "MAGENTA"),
			Vector2(32.0, LANE_Y[lane] - 18.0),
			18,
			Color(lane_color, 0.75 if lane == active_lane else 0.3)
		)


func _draw_obstacles() -> void:
	for obstacle in obstacles:
		var lane := int(obstacle["lane"])
		var obstacle_color := COLOR_CYAN if lane == 0 else COLOR_PINK
		var width := float(obstacle["width"])
		var height := float(obstacle["height"])
		var rect := Rect2(
			Vector2(float(obstacle["x"]) - width * 0.5, LANE_Y[lane] - height),
			Vector2(width, height)
		)
		var opacity := 0.95 if lane == active_lane else 0.23
		draw_rect(rect.grow(11.0), Color(obstacle_color, 0.08 * opacity), true)
		draw_rect(rect, Color(obstacle_color, 0.32 * opacity), true)
		draw_rect(rect, Color(obstacle_color, opacity), false, 4.0)
		for stripe in range(3):
			var stripe_y := rect.position.y + 14.0 + stripe * 19.0
			draw_line(
				Vector2(rect.position.x + 8.0, stripe_y),
				Vector2(rect.end.x - 8.0, stripe_y),
				Color(obstacle_color, 0.45 * opacity),
				3.0
			)


func _draw_player() -> void:
	var lane_color := COLOR_CYAN if active_lane == 0 else COLOR_PINK
	var center := _player_center()
	var blink := invulnerability > 0.0 and int(invulnerability * 12.0) % 2 == 0
	var opacity := 0.3 if blink else 1.0
	var glow_strength := 0.12 + beat_pulse * 0.12 + switch_flash * 0.14
	var air_height := clampf(-jump_offset / 145.0, 0.0, 1.0)
	var shadow_width := lerpf(42.0, 23.0, air_height)
	var body_scale := Vector2.ONE
	body_scale.x += takeoff_squash * 0.16 + landing_impact * 0.22
	body_scale.y -= takeoff_squash * 0.13 + landing_impact * 0.18

	_draw_jump_trail()
	draw_ellipse_shadow(
		Vector2(PLAYER_X, LANE_Y[active_lane] + 4.0),
		shadow_width,
		lerpf(10.0, 5.0, air_height)
	)
	if landing_impact > 0.0:
		_draw_landing_wave(lane_color)
	draw_circle(center, 46.0 + switch_flash * 20.0, Color(lane_color, glow_strength))

	var points := _square_points(center, 28.0, player_rotation, body_scale)
	draw_colored_polygon(points, Color(lane_color, opacity))
	var accent_color := COLOR_PINK if active_lane == 0 else COLOR_CYAN
	draw_colored_polygon(
		PackedVector2Array([points[0], points[1], points[2]]),
		Color(accent_color, 0.34 * opacity)
	)
	draw_polyline(_closed_points(points), Color(COLOR_WHITE, opacity), 3.0, true)

	var core_points := _square_points(
		center,
		10.0,
		player_rotation + PI * 0.25,
		Vector2.ONE
	)
	draw_colored_polygon(core_points, Color(COLOR_BG, 0.9 * opacity))
	draw_polyline(_closed_points(core_points), Color(COLOR_WHITE, 0.75 * opacity), 2.0, true)
	var slash_start := center + Vector2(-10.0, 0.0).rotated(player_rotation)
	var slash_end := center + Vector2(10.0, 0.0).rotated(player_rotation)
	draw_line(slash_start, slash_end, Color(accent_color, opacity), 3.0, true)


func _player_center() -> Vector2:
	return Vector2(
		PLAYER_X,
		LANE_Y[active_lane] - PLAYER_SIZE.y * 0.5 + jump_offset
	)


func _square_points(
	center: Vector2,
	half_extent: float,
	rotation: float,
	scale: Vector2
) -> PackedVector2Array:
	var points := PackedVector2Array()
	for local_point in [
		Vector2(-half_extent, -half_extent),
		Vector2(half_extent, -half_extent),
		Vector2(half_extent, half_extent),
		Vector2(-half_extent, half_extent),
	]:
		points.append(center + (local_point * scale).rotated(rotation))
	return points


func _closed_points(points: PackedVector2Array) -> PackedVector2Array:
	var closed := points.duplicate()
	if not points.is_empty():
		closed.append(points[0])
	return closed


func _draw_jump_trail() -> void:
	for sample in jump_trail:
		var life_ratio := clampf(
			float(sample["life"]) / TRAIL_LIFETIME,
			0.0,
			1.0
		)
		var trail_color := COLOR_CYAN if int(sample["lane"]) == 0 else COLOR_PINK
		var points := _square_points(
			Vector2(sample["center"]),
			25.0,
			float(sample["rotation"]),
			Vector2.ONE
		)
		draw_polyline(
			_closed_points(points),
			Color(trail_color, life_ratio * 0.28),
			2.0,
			true
		)


func _draw_landing_wave(color: Color) -> void:
	var center := Vector2(PLAYER_X, LANE_Y[active_lane] + 3.0)
	var expansion := 1.0 - landing_impact
	var radius_x := 40.0 + expansion * 70.0
	var radius_y := 7.0 + expansion * 8.0
	var points := PackedVector2Array()
	for step in range(25):
		var angle := TAU * float(step) / 24.0
		points.append(center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	draw_polyline(points, Color(color, landing_impact * 0.7), 3.0, true)


func draw_ellipse_shadow(center: Vector2, radius_x: float, radius_y: float) -> void:
	var points := PackedVector2Array()
	for step in range(24):
		var angle := TAU * float(step) / 24.0
		points.append(center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	draw_colored_polygon(points, Color(0.0, 0.0, 0.0, 0.35))


func _draw_hud() -> void:
	if game_state == GameState.TITLE:
		return

	_draw_label("PUNTOS  %06d" % score, Vector2(36.0, 54.0), 26, COLOR_WHITE)
	_draw_label("COMBO  x%d" % combo, Vector2(36.0, 88.0), 20, COLOR_CYAN)
	_draw_label("VIDAS  %d/3" % lives, Vector2(1050.0, 54.0), 24, COLOR_WHITE)

	var progress := clampf(elapsed_time / ROUND_DURATION, 0.0, 1.0)
	var progress_rect := Rect2(390.0, 42.0, 500.0, 12.0)
	draw_rect(progress_rect, Color(COLOR_WHITE, 0.1), true)
	draw_rect(
		Rect2(progress_rect.position, Vector2(progress_rect.size.x * progress, progress_rect.size.y)),
		COLOR_CYAN.lerp(COLOR_PINK, progress),
		true
	)
	_draw_text_centered("%02d s" % ceili(maxf(0.0, ROUND_DURATION - elapsed_time)), 82.0, 19, COLOR_MUTED)


func _draw_touch_controls() -> void:
	if game_state != GameState.PLAYING:
		return
	var left_rect := Rect2(54.0, 620.0, 286.0, 70.0)
	var right_rect := Rect2(940.0, 620.0, 286.0, 70.0)
	_draw_button(left_rect, "CAMBIAR", COLOR_PINK)
	_draw_button(right_rect, "SALTAR", COLOR_CYAN)


func _draw_button(rect: Rect2, text: String, color: Color) -> void:
	draw_rect(rect, Color(color, 0.13), true)
	draw_rect(rect, Color(color, 0.7), false, 3.0)
	var font := ThemeDB.fallback_font
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)
	draw_string(
		font,
		Vector2(rect.get_center().x - text_size.x * 0.5, rect.get_center().y + text_size.y * 0.33),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		24,
		color
	)


func _draw_title() -> void:
	var title_pulse := 0.88 + sin(ambient_time * 2.5) * 0.12
	_draw_text_centered("RIFT", 142.0, 78, Color(COLOR_CYAN, title_pulse))
	_draw_text_centered("BEAT", 217.0, 78, Color(COLOR_PINK, title_pulse))
	_draw_text_centered("DOS DIMENSIONES. UN SOLO RITMO.", 270.0, 22, COLOR_WHITE)

	var panel := Rect2(320.0, 315.0, 640.0, 210.0)
	draw_rect(panel, Color(0.03, 0.05, 0.16, 0.92), true)
	draw_rect(panel, Color(COLOR_CYAN, 0.35), false, 2.0)
	_draw_text_centered("TOCA LA MITAD IZQUIERDA PARA CAMBIAR", 365.0, 21, COLOR_PINK)
	_draw_text_centered("TOCA LA MITAD DERECHA PARA SALTAR", 405.0, 21, COLOR_CYAN)
	_draw_text_centered("Sobrevive 45 segundos siguiendo el pulso", 458.0, 18, COLOR_MUTED)
	_draw_text_centered("TOCA PARA EMPEZAR", 590.0, 28, COLOR_WHITE)
	_draw_text_centered("Teclado: Tab cambia · Espacio salta · P pausa", 632.0, 17, COLOR_MUTED)


func _draw_end_screen(won: bool) -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), Color(0.01, 0.015, 0.055, 0.82), true)
	var headline := "RITMO COMPLETADO" if won else "RITMO PERDIDO"
	var color := COLOR_CYAN if won else COLOR_DANGER
	_draw_text_centered(headline, 225.0, 54, color)
	_draw_text_centered("PUNTOS  %06d" % score, 310.0, 30, COLOR_WHITE)
	_draw_text_centered("MEJOR COMBO  x%d" % best_combo, 356.0, 23, COLOR_MUTED)
	_draw_text_centered("TOCA PARA JUGAR OTRA VEZ", 474.0, 26, COLOR_WHITE)
	_draw_text_centered("También puedes presionar R", 516.0, 17, COLOR_MUTED)


func _draw_pause() -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), Color(0.01, 0.015, 0.055, 0.75), true)
	_draw_text_centered("PAUSA", 315.0, 58, COLOR_WHITE)
	_draw_text_centered("Toca la pantalla o presiona P para continuar", 374.0, 20, COLOR_MUTED)


func _draw_label(text: String, position: Vector2, font_size: int, color: Color) -> void:
	draw_string(
		ThemeDB.fallback_font,
		position,
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		color
	)


func _draw_text_centered(text: String, baseline_y: float, font_size: int, color: Color) -> void:
	var font := ThemeDB.fallback_font
	var width := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	draw_string(
		font,
		Vector2((VIEW_SIZE.x - width) * 0.5, baseline_y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		color
	)
