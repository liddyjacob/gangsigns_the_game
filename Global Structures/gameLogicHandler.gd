extends Node


# The singleton here will handle all of the game logic.





class GameLogic:
	var board
	
	func _init():
		self.board = boardMatrix.boardSingleton
		pass

	# handle the logic in here, not in the tile.gd script
	func handleSelect(MatrixPiece):
		pass
		






var logicHandler = GameLogic.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
