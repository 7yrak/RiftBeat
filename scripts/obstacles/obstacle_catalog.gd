extends RefCounted
class_name RiftObstacleCatalog

const PROPERTY_GROUPS := [
	"dimension",
	"movement",
	"gravity",
	"destructible",
	"rhythm",
	"reaction",
]

const PIECE_IDS := [
	"base_block",
	"tall_wall",
	"dual_barrier",
	"moving_block",
	"pulse_spike",
	"rhythm_press",
	"light_gravity_zone",
	"gravity_well",
	"cracked_block",
	"phase_gate",
	"chain_core",
	"mirror_block",
]


static func piece_ids() -> Array:
	return PIECE_IDS.duplicate()


static func create(
	piece_id: String,
	lane: int,
	x_position: float,
	modifiers: Dictionary = {}
) -> Dictionary:
	assert(PIECE_IDS.has(piece_id), "Pieza de obstáculo desconocida: %s" % piece_id)
	var piece := _base_piece(piece_id, lane, x_position)

	match piece_id:
		"tall_wall":
			piece["display_name"] = "Muro alto"
			piece["height"] = 108.0
			piece["max_height"] = 108.0
			piece["width"] = 52.0
		"dual_barrier":
			piece["display_name"] = "Barrera gemela"
			piece["dimension"]["mode"] = "both"
			piece["width"] = 54.0
			piece["height"] = 78.0
			piece["max_height"] = 78.0
		"moving_block":
			piece["display_name"] = "Bloque móvil"
			piece["movement"] = {
				"mode": "bob",
				"speed_scale": 1.0,
				"amplitude": 32.0,
				"frequency": 1.4,
			}
		"pulse_spike":
			piece["display_name"] = "Pico de pulso"
			piece["width"] = 50.0
			piece["height"] = 58.0
			piece["max_height"] = 58.0
			piece["rhythm"] = _pattern_rhythm(2, [0])
			piece["visual"]["shape"] = "spike"
		"rhythm_press":
			piece["display_name"] = "Prensa rítmica"
			piece["prototype"] = true
			piece["width"] = 74.0
			piece["height"] = 18.0
			piece["min_height"] = 18.0
			piece["max_height"] = 116.0
			piece["rhythm"] = _pattern_rhythm(4, [0, 1])
			piece["visual"]["shape"] = "press"
		"light_gravity_zone":
			piece["display_name"] = "Gravedad ligera"
			piece["prototype"] = true
			piece["width"] = 286.0
			piece["height"] = 132.0
			piece["max_height"] = 132.0
			piece["gravity"] = {
				"mode": "zone",
				"scale": 0.38,
				"radius": 0.0,
			}
			piece["reaction"] = {
				"on_player": "effect",
				"on_destroy": "none",
				"score": 20,
			}
			piece["visual"]["shape"] = "gravity_zone"
		"gravity_well":
			piece["display_name"] = "Pozo gravitacional"
			piece["width"] = 240.0
			piece["height"] = 140.0
			piece["max_height"] = 140.0
			piece["gravity"] = {
				"mode": "radial",
				"scale": 1.7,
				"radius": 160.0,
			}
			piece["reaction"]["on_player"] = "effect"
			piece["visual"]["shape"] = "gravity_zone"
		"cracked_block":
			piece["display_name"] = "Bloque agrietado"
			piece["prototype"] = true
			piece["width"] = 62.0
			piece["height"] = 78.0
			piece["max_height"] = 78.0
			piece["destructible"] = {
				"enabled": true,
				"health": 1,
				"max_health": 1,
				"required_power": "rift_pulse",
			}
			piece["reaction"]["on_destroy"] = "burst"
			piece["reaction"]["score"] = 180
			piece["visual"]["shape"] = "cracked"
		"phase_gate":
			piece["display_name"] = "Compuerta de fase"
			piece["width"] = 42.0
			piece["height"] = 102.0
			piece["max_height"] = 102.0
			piece["rhythm"] = _pattern_rhythm(4, [0, 2])
			piece["visual"]["shape"] = "gate"
		"chain_core":
			piece["display_name"] = "Núcleo en cadena"
			piece["width"] = 68.0
			piece["height"] = 68.0
			piece["max_height"] = 68.0
			piece["destructible"] = {
				"enabled": true,
				"health": 1,
				"max_health": 1,
				"required_power": "rift_pulse",
			}
			piece["reaction"]["on_destroy"] = "chain_burst"
			piece["visual"]["shape"] = "core"
		"mirror_block":
			piece["display_name"] = "Bloque espejo"
			piece["reaction"]["on_player"] = "switch_dimension"
			piece["visual"]["shape"] = "mirror"

	_merge_nested(piece, modifiers)
	return piece


static func _base_piece(piece_id: String, lane: int, x_position: float) -> Dictionary:
	return {
		"piece_id": piece_id,
		"display_name": "Bloque base",
		"prototype": false,
		"x": x_position,
		"lane": lane,
		"width": 48.0,
		"height": 68.0,
		"min_height": 68.0,
		"max_height": 68.0,
		"y_offset": 0.0,
		"activation": 1.0,
		"time": 0.0,
		"passed": false,
		"dimension": {
			"mode": "lane",
			"lane": lane,
		},
		"movement": {
			"mode": "scroll",
			"speed_scale": 1.0,
			"amplitude": 0.0,
			"frequency": 0.0,
		},
		"gravity": {
			"mode": "none",
			"scale": 1.0,
			"radius": 0.0,
		},
		"destructible": {
			"enabled": false,
			"health": 0,
			"max_health": 0,
			"required_power": "",
		},
		"rhythm": {
			"mode": "always",
			"period_beats": 1,
			"active_beats": [0],
			"phase": 0,
			"active": true,
		},
		"reaction": {
			"on_player": "damage",
			"on_destroy": "none",
			"score": 80,
		},
		"visual": {
			"shape": "block",
			"color_role": "lane",
		},
	}


static func _pattern_rhythm(period_beats: int, active_beats: Array) -> Dictionary:
	return {
		"mode": "pattern",
		"period_beats": period_beats,
		"active_beats": active_beats.duplicate(),
		"phase": 0,
		"active": false,
	}


static func _merge_nested(target: Dictionary, modifiers: Dictionary) -> void:
	for key in modifiers:
		var value: Variant = modifiers[key]
		if (
			target.has(key)
			and target[key] is Dictionary
			and value is Dictionary
		):
			_merge_nested(target[key], value)
		else:
			target[key] = value
