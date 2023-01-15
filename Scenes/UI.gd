extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var attackButton : Button = get_node('AttackButton')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func toggleAttackButton(toggle):
	attackButton.visible = toggle

func _on_AttackButton_pressed():
	gameLogicHandler.logicHandler.handleAttack()
	get_tree().get_root().get_node('MainScene').renderUI()
	# 
	pass # Replace with function body.
