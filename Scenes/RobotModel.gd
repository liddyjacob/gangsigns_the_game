extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var primary = get_node("Primary")
onready var secondry = get_node("Secondry")
onready var antennae = get_node("Antennae")


func color(unit):
	primary.modulate = unit.palettePrimary()
	secondry.modulate = unit.paletteSecondry()
	antennae.modulate = unit.paletteAntennae()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
