extends Node


# The singleton here will handle all of the game logic.

# Useful to see what the user is intending on doing
# None -> UnitSelected implies moving
enum SELECT_STATE {SELECT_NONE, SELECT_UNIT, SELECT_TILE, SELECT_ATTACK}



class GameLogic:
	var board
	var selection = SELECT_STATE.SELECT_NONE
	var locationInFocus = null
	var reflected : bool = false
	var rotations : int = 0
	
	# not game logic.
	var gangsignHoverRegistry = []
	
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
		
	func handleRotate():
		if self.reflected:
			self.rotations = (self.rotations - 1) % 4
		else: 
			self.rotations = (self.rotations + 1) % 4
	
	func handleReflect():
		self.reflected = !self.reflected
		#self.rotations = (-self.rotations) % 4
		

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
				
		# deal with attacking:
		if self.selection == SELECT_STATE.SELECT_ATTACK:
			# See of this is a valid location for this gangsign
			var attackTiles = self.validateAttackLocation(matrixPiece)
			
			# invalid move
			if attackTiles == [] || ! self.validateAttackTouchesPlayer(attackTiles):
				return
			else:
				for tile in attackTiles:
					tile.teamid = self.locationInFocus.unit.teamid
				self.selection = SELECT_STATE.SELECT_NONE
				self.locationInFocus = null
				self.reflected = false
				self.rotations = 0
		#	self.locationInFocus = matrixPiece
			
	func handleHover(matrixPiece):
		if self.selection != SELECT_STATE.SELECT_ATTACK:
			return
		
		# Use locationinfocus with matrixpiece to render a hover
		self.renderHover(matrixPiece)
		
		
		# Render pieces back to their original color.
	func handleHoverExit(matrixPiece):
		if self.selection != SELECT_STATE.SELECT_ATTACK:
			return
		self.renderHoverExit(matrixPiece)
		pass
	
	func validateAttackLocation(matrixPiece):
		var teamid = self.locationInFocus.unit.teamid
		var gangsignPattern = self.locationInFocus.unit.gangsign.shape(self.rotations,self.reflected)
		
		# Get all of the locations for this gangsign
		var gangsignTiles = []
		for delta in gangsignPattern:
			var currTile = self.board.get_tile(matrixPiece.i + delta[0], matrixPiece.j + delta[1])
			
			# No out of bounds
			if currTile == null:
				return []
				
			# No painting on self
			if currTile == self.locationInFocus:
				return []
				
			# No painting on own team:
			if currTile.teamid == teamid:
				return []
			
			# Action allowed at this point:
			gangsignTiles.append(currTile)
		
		return gangsignTiles
		
	func validateAttackTouchesPlayer(gangsignTiles):
		for gangTile in gangsignTiles:
			if (gangTile.i == self.locationInFocus.i - 1) and \
			  (gangTile.j == self.locationInFocus.j):
				return true
			if (gangTile.i == self.locationInFocus.i + 1) and \
			  (gangTile.j == self.locationInFocus.j):
				return true
			if (gangTile.i == self.locationInFocus.i) and \
			  (gangTile.j == self.locationInFocus.j - 1):
				return true
			if (gangTile.i == self.locationInFocus.i ) and \
			  (gangTile.j == self.locationInFocus.j + 1):
				return true

		return false
		
	func render():
		self.resetRenders()
		self.resolveSelection()
		self.renderBoard()
		
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
		
	# Make everything on the board it's proper color	
	func renderBoard():
		for i in self.board.boardSize[0]:
			for j in self.board.boardSize[1]:
				self.board.get_tile(i, j).applyOriginalColor()
		
			
	func renderMovements():
		var movements = self.getPossibleDestinations()
		
		for tile in movements:
			tile.toggleHighlight(true)
		
	func renderHover(matrixPiece):
		# Color these blocks temporarily
		var teamid = self.locationInFocus.unit.teamid
		var gangsignPattern = self.locationInFocus.unit.gangsign.shape(self.rotations, self.reflected)
		
		var gangsignTiles = validateAttackLocation(matrixPiece)
		# Get all of the locations for this gangsign

		self.gangsignHoverRegistry = gangsignTiles
		
		for tile in gangsignTiles:
			tile.applyTempColor(teamid)
		
		# Hold these colors : Do not let exit render modify them!
		self.gangsignHoverRegistry = gangsignTiles
			
		pass
		
	func renderHoverExit(matrixPiece):
		var gangsignPattern = self.locationInFocus.unit.gangsign.shape(self.rotations,self.reflected)
		for delta in gangsignPattern:
			var currTile = self.board.get_tile(matrixPiece.i + delta[0], matrixPiece.j + delta[1])
			if currTile in gangsignHoverRegistry:
				continue
				
			if currTile != null:
				currTile.applyOriginalColor()
		pass
		
		
	# Make an attack button on unit selection:
	func renderUIBar():
		pass
		
		
	# Get al the locations this unit can go:
	func getPossibleDestinations():
		# Empty list of movements if a unit is not selected.
		if self.selection != SELECT_STATE.SELECT_UNIT:
			return []
		
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
