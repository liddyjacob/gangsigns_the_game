extends Node



# a gangsign can be one of a select few polyominos
class GangSign:
	var base
	
	func _init(polyomino):
		self.base = polyomino
		pass
	
	#func rotate()
		
	# What is the shape of the gang sign with the coordinates
	func shape(rotations, flipped):
		return self.base
		

# A unit has a team and a gangsign. and a team
class Unit:
	var teamid : String
	var gangsign : GangSign
	
	func _init(teamid, gangsign):
		
		self.teamid = teamid
		self.gangsign = gangsign
		
	func palettePrimary():
		return colorHandler.getColor(self.teamid, 'unit1')

	func paletteSecondry():
		return colorHandler.getColor(self.teamid, 'unit2')
		
	func paletteAntennae():
		return colorHandler.getColor(self.teamid, 'unit3')
	
	


# an element of the matrix
class MatrixPiece:
	var i : int
	var j : int
	var tileid : int
	# What team does this belong to
	var teamid : String = "neutral"
	
	var highlighted : bool = false
	#var owner : Player  = null
	
	# where to render this matrix piece?
	var renderX : int
	var renderY : int
	
	var node : Node
	
	var unit : Unit = null
	
	func _init(i, j, tileid):
		self.i = i
		self.j = j
		self.tileid = tileid
		self.teamid = "neutral"

	func hasUnit():
		return self.unit != null

	
	# attach a node to this matrix piece
	func attachNode(assocNode):
		self.node = assocNode
		assocNode.matrixTile = self
		print('color:')
		print(self.palette())
		assocNode.colorTile(self.palette())
		# attach a node to this piece
		# or vise versa.
		
	func placeUnit(unit):
		self.node.placeUnit(unit)
		self.unit = unit
		
	func removeUnit():
		var old_unit = self.unit
		self.unit = null
		self.node.removeUnit()
		return old_unit

	func palette():
		return colorHandler.getColor(self.teamid, 'tile' + str(self.tileid))
		
	# Apply temporary color to board
	func applyTempColor(teamid):
		var temp_color = colorHandler.getColor(teamid, 'tiletemp' + str(self.tileid))
		self.node.colorTile(temp_color)
		
	func applyOriginalColor():
		var orig_color = self.palette()
		self.node.colorTile(orig_color)
		
	func toggleHighlight(toggle):
		self.highlighted = toggle
		self.node.toggleHighlight(toggle)
		
	# Reset color to whatever it's 'original value' is
	func toggleColor(mode):
		pass
	# associate 


class BoardMatrix:
	# Contains the matrix of spaces
	var internalMatrix = []
	var mode : String
	var boardSize :  Vector2
	
	func _init(mode):
		self.mode = mode
		# Configure the matrix
		self.configure()
		
		# Build the matrix out.
		self.buildmatrix()
		# Use config
		pass
		
	func configure():
		var config = ConfigFile.new()
		# load in the configuration
		var err = config.load("res://Game Properties/gameconfig.cfg")
		
		if err != OK:
			push_error("Missing configure file: res:///gameconfig.cfg")
		
		self.boardSize = config.get_value(self.mode, "boardSize")

		
	func buildmatrix():
		for i in range(self.boardSize[0]):
			internalMatrix.append([])
			for j in range(self.boardSize[1]):
				internalMatrix[i].append(MatrixPiece.new(i, j, 1 + ((i + j) % 2)))

	# Fill matrix with a node, assign a parent node,
	# locate the matrix
	func fillMatrix(childTemplate, parentNode):
		for i in range(self.boardSize[0]):
			for j in range(self.boardSize[1]):
				# Create a new child with the template
				var newChildNode = childTemplate.instance()
				
				# Fit it in the heirarchy
				parentNode.add_child(newChildNode)
				
				# Get the shape of this node.
				var xdelta = newChildNode.get_node('CollisionShape2D').shape.extents[0]
				var ydelta = newChildNode.get_node('CollisionShape2D').shape.extents[1]
				
				# Define the location of this node
				newChildNode.position.x = 80 + (xdelta ) + 2 * xdelta * i
				newChildNode.position.y = 30 + (ydelta ) + 2 * xdelta * j
				
				#newChildNode.position.y = 100
				
				# Add the node to the matrix
				internalMatrix[i][j].attachNode(newChildNode)
	
	# Toggle highlights off.
	func resetAllRenders():
		for i in range(self.boardSize[0]):
			for j in range(self.boardSize[1]):
				internalMatrix[i][j].toggleHighlight(false)
				#internalMatrix[i][j].toggleColor('original')
	
	func get_tile(i, j):
		if (i < 0 || j < 0):
			return null
		if (i >= self.boardSize[0] || j >= self.boardSize[1]):
			return null
			
		return internalMatrix[i][j]
	
	func fillWithNode():
		pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var boardSingleton = BoardMatrix.new("standard")
	