extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var map : Node = get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing creating a new node
	var tileScene = load("res://Scenes/Tile.tscn")
	var instance = tileScene.instance()
	
	map.add_child(instance)
	instance.set_owner(map)
	
	# Works! Now lets create 
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
