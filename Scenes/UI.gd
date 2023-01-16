extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var attackButton : Button = get_node('AttackButton')
onready var cancelButton : Button = get_node('CancelButton')
onready var rotateButton : Button = get_node('RotateButton')
onready var reflectButton : Button = get_node('ReflectButton')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func toggleAttackButton(toggle):
	attackButton.visible = toggle

func toggleAttackOpts(toggle):
	cancelButton.visible = toggle
	rotateButton.visible = toggle
	reflectButton.visible = toggle
	
func _on_AttackButton_pressed():
	gameLogicHandler.logicHandler.handleAttack()
	get_tree().get_root().get_node('MainScene').renderUI()
	# 
	pass # Replace with function body.


func _on_CancelButton_pressed():
	gameLogicHandler.logicHandler.handleCancelAttack()
	get_tree().get_root().get_node('MainScene').renderUI()
	pass # Replace with function body.


func _on_Dummy_toggled(button_pressed):

	pass # Replace with function body.


func _on_Dummy_pressed():
	print("dummy pressed")
	pass # Replace with function body.
