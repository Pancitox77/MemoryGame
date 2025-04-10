extends Control


const CardScene : PackedScene = preload("res://scenes/game/card/card.tscn")


var first_card_selected : bool = false
var card1 : Card
var card2 : Card
var remaining_cards : int

@export_group("_Nodes")
@export var grid: GridContainer
@export var match_timer: Timer


func _ready() -> void:
	var width = Global.grid_width
	var height = Global.grid_height
	
	grid.columns = width
	remaining_cards = width * height
	
	clear_grid()
	generate_cards(width, height)


func clear_grid() -> void:
	for node in grid.get_children():
		node.queue_free()


func generate_cards(width: int, height: int) -> void:
	var symbols : PackedStringArray = Card.Symbol.keys()
	var cards : Array[Card] = []
	
	var max_quantity : int = width * height
	var quantity : int = 0
	var symbol_index = 0
	
	while quantity < max_quantity:
		var symbol_key : String = symbols[ symbol_index % symbols.size() ]
		
		var card1 : Card = CardScene.instantiate()
		card1.symbol = Card.Symbol.get(symbol_key)
		
		var card2 : Card = CardScene.instantiate()
		card2.symbol = Card.Symbol.get(symbol_key)
		
		card1.card_clicked.connect(func(): self._on_card_clicked(card1))
		card2.card_clicked.connect(func(): self._on_card_clicked(card2))
		
		cards.append(card1)
		cards.append(card2)
		
		symbol_index += 1
		quantity += 2
	
	# Agregar cartas mezcladas
	cards.shuffle()
	cards.shuffle()
	for card in cards:
		grid.add_child(card)


func _on_card_clicked(card: Card) -> void:
	if not first_card_selected:
		card1 = card
		first_card_selected = true
	else:
		card2 = card
		first_card_selected = false
		check_cards()


func check_cards() -> void:
	if card1.has_same_symbol(card2):
		correct_selection()
		check_win()
	else:
		wrong_selection()


func correct_selection() -> void:
	card1.set_resolved()
	card2.set_resolved()
	remaining_cards -= 2


func wrong_selection() -> void:
	Global.selection_enabled = false
	match_timer.start()
	await match_timer.timeout
	card1.toggle_active(false)
	card2.toggle_active(false)


func check_win() -> void:
	if remaining_cards <= 0:
		# Juego terminado
		# ... (mostrar Fin de partida, n° de intentos, etc.)
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_match_timer_timeout() -> void:
	Global.selection_enabled = true
