extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var map : Node = get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	Color(.93, .93, .93)
	# Testing creating a new node
	var tileScene = load("res://Scenes/Tile.tscn")
	
	boardMatrix.boardSingleton.fillMatrix(tileScene, map)
	print('goodbye')
	var gangsigncoords = [Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0),
		Vector2(1,-1), Vector2(3,-1)]
	var gangsign = boardMatrix.GangSign.new(gangsigncoords)
	var new_unit = boardMatrix.Unit.new("player1", gangsign)
	boardMatrix.boardSingleton.get_tile(5,5).placeUnit(new_unit)
	print('goodbye')
	# Works! Now lets create





	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Handle UI
func renderUI():

	var ui = get_node('UI')
	
	if gameLogicHandler.logicHandler.selection == gameLogicHandler.SELECT_STATE.SELECT_UNIT:
		ui.toggleAttackButton(true)
		ui.toggleAttackOpts(false)
		return
		
	if gameLogicHandler.logicHandler.selection == gameLogicHandler.SELECT_STATE.SELECT_ATTACK:
		ui.toggleAttackButton(false)
		ui.toggleAttackOpts(true)
		return
		
	ui.toggleAttackButton(false)
	ui.toggleAttackOpts(false)