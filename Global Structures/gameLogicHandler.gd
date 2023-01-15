extends Node


# The singleton here will handle all of the game logic.

# Useful to see what the user is intending on doing
# None -> UnitSelected implies moving
enum SELECT_STATE {SELECT_NONE, SELECT_UNIT, SELECT_TILE, SELECT_ATTACK}



class GameLogic:
	var board
	var selection = SELECT_STATE.SELECT_NONE
	var locationInFocus = null
	
	func _init():
		self.board = boardMatrix.boardSingleton
		pass


	# handle an attack request
	func handleAttack():
		if self.locationInFocus == null:
			push_error("Attempting an attack init without a tile selected!")
		if not self.locationInFocus.hasUnit():
			push_error("Attempting an attack on an empty tile!")
		
		self.selection = SELECT_STATE.SELECT_ATTACK
		
		self.render()
	# do not attacl anymore.
	func handleCancelAttack():
		self.selection = SELECT_STATE.SELECT_UNIT
		self.render()
		pass
		
		

	# handle the logic in here, not in the tile.gd script
	func handleSelect(matrixPiece):
		
		# This is so return allows me to execute a function after.
		self._handleSelectHelper(matrixPiece)
		
		# react to the current state, send signals to any location we need to
		self.render()

	func _handleSelectHelper(matrixPiece):
		# Select unit if not attacking
		if matrixPiece.hasUnit():
			if self.selection != SELECT_STATE.SELECT_ATTACK:
				self.selection = SELECT_STATE.SELECT_UNIT
				# This location is now 'in focus'
				self.locationInFocus = matrixPiece
				return
			
		# If a unit has been selected, and 
		# it can move, then we move the unit
		if matrixPiece.highlighted:
			if self.selection == SELECT_STATE.SELECT_UNIT:
				# Strip unit from old location
				var unit = self.locationInFocus.removeUnit()
				self.locationInFocus = null
				matrixPiece.placeUnit(unit)
				self.selection = SELECT_STATE.SELECT_NONE
				
				
				
		if ! matrixPiece.highlighted:
			if self.selection != SELECT_STATE.SELECT_ATTACK:
				self.selection = SELECT_STATE.SELECT_NONE
		#	self.locationInFocus = matrixPiece
			
	func handleHover(matrixPiece):
		pass
		
		
	func render():
		self.resetRenders()
		self.resolveSelection()
	
	func resetRenders():
		self.board.resetAllRenders()
	
	# Do graphical stuff. Does not affect game logic.
	# Just lets you know what actions you can take.
	func resolveSelection():
		# See if we need to highlight any tiles
		self.renderMovements()
		
		self.renderUIBar()
		#
		#self.render_attack()
		#
		#self.render_end_turn()
		#
			
			
	func renderMovements():
		var movements = self.getPossibleDestinations()
		
		for tile in movements:
			tile.toggleHighlight(true)
			
		
	# Make an attack button on unit selection:
	func renderUIBar():
		pass
		
		
	# Get al the locations this unit can go:
	func getPossibleDestinations():
		# Empty list of movements if a unit is not selected.
		if self.selection != SELECT_STATE.SELECT_UNIT:
			return []
		
		print(self.selection)
		
		var i = self.locationInFocus.i
		var j = self.locationInFocus.j
		
		return [self.board.get_tile(i+1, j), self.board.get_tile(i - 1, j),   
				self.board.get_tile(i, j+1), self.board.get_tile(i, j - 1),
				self.board.get_tile(i+1,j+1), self.board.get_tile(i+1,j-1),
				self.board.get_tile(i-1,j+1), self.board.get_tile(i-1,j-1)]
				
			
		
				
			
			
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
