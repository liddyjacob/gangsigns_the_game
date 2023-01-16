extends Node

var colorpalette = ConfigFile.new()

func _init():
	print("EHERE")
		# load in the configuration
	var err = self.colorpalette.load("res://Game Properties/colorpalette.cfg")
		
	if err != OK:
		push_error("Missing configure file: res:///colorpalette.cfg")
		
	
	
func getColor(category, type):
	print(self.colorpalette)
	print("getting " + category + " > " + type)
	print("\t" + str(self.colorpalette.get_sections()))
	var color_vect = self.colorpalette.get_value(category, type)
	return Color(color_vect[0], color_vect[1], color_vect[2])
		
