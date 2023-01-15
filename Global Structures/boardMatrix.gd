extends Node

# a gangsign can be one of a select few polyominos
class GangSign:
	func _init():
		pass

# A unit has a team and a gangsign. also a texture.
class Unit:
	var texture 
	var teamid : int
	var gangsign : GangSign
	
	func _init(texture, teamid, gangsign):
		self.texture = texture
		self.teamid = teamid
		self.gangsign = gangsign
		
		
	
	
	


# an element of the matrix
class MatrixPiece:
	var i : int
	var j : int
	
	var highlighted : bool = false
	#var owner : Player  = null
	
	# where to render this matrix piece?
	var renderX : int
	var renderY : int
	
	var node : Node
	
	var unit : Unit = null
	
	func _init(i, j):
		self.i = i
		self.j = j

	func hasUnit():
		return self.unit != null

	
	# attach a node to this matrix piece
	func attachNode(assocNode):
		self.node = assocNode
		assocNode.matrixTile = self
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
		
		
		
	func toggleHighlight(toggle):
		self.highlighted = toggle
		self.node.toggleHighlight(toggle)
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
				internalMatrix[i].append(MatrixPiece.new(i, j))

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
				newChildNode.position.x = (xdelta ) + 2 * xdelta * i
				newChildNode.position.y = (ydelta ) + 2 * xdelta * j
				
				# To highlight the difference in nodes, we need to
				# slightly alter the color.
				if (i + j) % 2:
					newChildNode.get_node('Sprite').modulate = Color(1,1,1)
					
				#newChildNode.position.y = 100
				
				# Add the node to the matrix
				internalMatrix[i][j].attachNode(newChildNode)
	
	# Toggle highlights off.
	func resetAllRenders():
		for i in range(self.boardSize[0]):
			for j in range(self.boardSize[1]):
				internalMatrix[i][j].toggleHighlight(false)
	
	func get_tile(i, j):
		return internalMatrix[i][j]
	
	func fillWithNode():
		pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var boardSingleton = BoardMatrix.new("standard")
	