class_name Card
extends PanelContainer

signal card_clicked

enum Symbol {CLUB, DIAMOND, HEART, SPADE, APPLE, ATOM, BOT, BURGER, CITRUS}
const TEXTURES: Dictionary[Symbol, String] = {
	Symbol.CLUB: "res://assets/img/club.svg",
	Symbol.DIAMOND: "res://assets/img/diamond.svg",
	Symbol.HEART: "res://assets/img/heart.svg",
	Symbol.SPADE: "res://assets/img/spade.svg",
	Symbol.APPLE : "res://assets/img/apple.svg",
	Symbol.ATOM : "res://assets/img/atom.svg",
	Symbol.BOT : "res://assets/img/bot.svg",
	Symbol.BURGER : "res://assets/img/burger.svg",
	Symbol.CITRUS : "res://assets/img/citrus.svg",
}

@export var symbol: Symbol = Symbol.CLUB: set=set_symbol
@export var is_active: bool = false
var is_resolved: bool = false

@export_group("Textures")
@export var normal_texture: Texture
@export var active_texture : CompressedTexture2D = load(TEXTURES[symbol])

@export_group("Colors")
@export var normal_background: Color
@export var active_background: Color

@export_group("_Nodes")
@export var texture_rect : TextureRect


func _ready() -> void:
	reload_texture()


func set_symbol(value: Symbol) -> void:
	symbol = value
	active_texture = load(TEXTURES[symbol])


# Este método debe llamarse después de _ready
func toggle_active(active: bool) -> void:
	is_active = active
	reload_texture()


func reload_texture() -> void:
	texture_rect.texture = active_texture if is_active else normal_texture
	self_modulate = active_background if is_active else normal_background


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_resolved or not Global.selection_enabled:
			mouse_default_cursor_shape = Control.CURSOR_ARROW
		else:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	if is_click(event) and not is_resolved and Global.selection_enabled:
		if not is_active:
			# La señal no se dispara si la carta ya estaba activada
			card_clicked.emit()
		is_active = true
		reload_texture()


func is_click(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		return (event as InputEventMouseButton).is_pressed()
	if event is InputEventScreenTouch:
		return (event as InputEventScreenTouch).is_pressed()
	return false


func has_same_symbol(other: Card) -> bool:
	return self.symbol == other.symbol


func set_resolved() -> void:
	is_resolved = true
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	texture_rect.queue_free()
