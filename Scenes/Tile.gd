extends Area2D

var matrixTile
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




onready var HighlightPlaceholder = get_node("HighlightPlaceholder")
onready var RobotModel = get_node("RobotModel")
onready var TileInterior = get_node("TileInterior")

func placeUnit(unit):
	RobotModel.visible = true
	# Set up the robot model:
	RobotModel.color(unit)
	
func removeUnit():
	RobotModel.visible = false

func colorTile(color):
	TileInterior.modulate = color
	
	
func toggleHighlight(toggle):
	HighlightPlaceholder.visible = toggle
	
#func toggleColor(color):
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
	# Handle the selection of this matrix tile
		gameLogicHandler.logicHandler.handleSelect(matrixTile)
		get_tree().get_root().get_node('MainScene').renderUI()



func _on_Tile_mouse_entered():
	gameLogicHandler.logicHandler.handleHover(matrixTile)
	pass # Replace with function body.


func _on_Tile_mouse_exited():
	gameLogicHandler.logicHandler.handleHoverExit(matrixTile)
	pass # Replace with function body.
