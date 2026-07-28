extends RefCounted
class_name RiftObstacleRuntime


static func update(
	obstacle: Dictionary,
	delta: float,
	world_speed: float,
	beat_count: int
) -> void:
	obstacle["time"] = float(obstacle["time"]) + delta
	var movement: Dictionary = obstacle["movement"]
	obstacle["x"] = (
		float(obstacle["x"])
		- world_speed * float(movement["speed_scale"]) * delta
	)

	match String(movement["mode"]):
		"bob":
			obstacle["y_offset"] = (
				sin(float(obstacle["time"]) * TAU * float(movement["frequency"]))
				* float(movement["amplitude"])
			)
		_:
			obstacle["y_offset"] = 0.0

	var rhythm: Dictionary = obstacle["rhythm"]
	rhythm["active"] = rhythm_is_active(obstacle, beat_count)
	obstacle["rhythm"] = rhythm

	if String(obstacle["visual"]["shape"]) == "press":
		var target := 1.0 if bool(rhythm["active"]) else 0.0
		obstacle["activation"] = move_toward(
			float(obstacle["activation"]),
			target,
			delta * 5.5
		)
		obstacle["height"] = lerpf(
			float(obstacle["min_height"]),
			float(obstacle["max_height"]),
			float(obstacle["activation"])
		)


static func rhythm_is_active(obstacle: Dictionary, beat_count: int) -> bool:
	var rhythm: Dictionary = obstacle["rhythm"]
	if String(rhythm["mode"]) == "always":
		return true
	var period := maxi(1, int(rhythm["period_beats"]))
	var beat_in_pattern := posmod(beat_count + int(rhythm["phase"]), period)
	return Array(rhythm["active_beats"]).has(beat_in_pattern)


static func affects_lane(obstacle: Dictionary, lane: int) -> bool:
	var dimension: Dictionary = obstacle["dimension"]
	return (
		String(dimension["mode"]) == "both"
		or int(dimension["lane"]) == lane
	)


static func is_solid(obstacle: Dictionary) -> bool:
	var reaction: Dictionary = obstacle["reaction"]
	return (
		String(reaction["on_player"]) in ["damage", "switch_dimension"]
		and bool(obstacle["rhythm"]["active"])
	)


static func collision_rect(obstacle: Dictionary, lane_y: float) -> Rect2:
	var width := float(obstacle["width"])
	var height := float(obstacle["height"])
	return Rect2(
		Vector2(
			float(obstacle["x"]) - width * 0.5,
			lane_y - height + float(obstacle["y_offset"])
		),
		Vector2(width, height)
	)


static func gravity_scale_at(
	obstacle: Dictionary,
	player_x: float,
	lane: int
) -> float:
	if not affects_lane(obstacle, lane):
		return 1.0
	var gravity: Dictionary = obstacle["gravity"]
	if String(gravity["mode"]) == "none":
		return 1.0
	var influence_range := float(obstacle["width"]) * 0.5
	if String(gravity["mode"]) == "radial":
		influence_range = float(gravity["radius"])
	if absf(player_x - float(obstacle["x"])) > influence_range:
		return 1.0
	return float(gravity["scale"])


static func can_receive_power(obstacle: Dictionary, power_id: String) -> bool:
	var destructible: Dictionary = obstacle["destructible"]
	return (
		bool(destructible["enabled"])
		and int(destructible["health"]) > 0
		and String(destructible["required_power"]) == power_id
	)


static func apply_power(obstacle: Dictionary, power_id: String) -> Dictionary:
	if not can_receive_power(obstacle, power_id):
		return {
			"applied": false,
			"destroyed": false,
			"health": int(obstacle["destructible"]["health"]),
		}

	var destructible: Dictionary = obstacle["destructible"]
	destructible["health"] = maxi(0, int(destructible["health"]) - 1)
	obstacle["destructible"] = destructible
	return {
		"applied": true,
		"destroyed": int(destructible["health"]) == 0,
		"health": int(destructible["health"]),
	}
