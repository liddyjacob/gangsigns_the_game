extends Area2D

var matrixTile
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



onready var UnitPlaceholder = get_node("UnitPlaceholder")
onready var HighlightPlaceholder = get_node("HighlightPlaceholder")
func placeUnit(unit):
	UnitPlaceholder.texture = unit.texture

func removeUnit():
	UnitPlaceholder.texture = null

	
	
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
	
	pass # Replace with function body.
