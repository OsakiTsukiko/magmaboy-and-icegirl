extends Control

onready var CharacterSelectorINP = $BG/CenterContainer/VBoxContainer/CharacterSelector

func _ready():
	CharacterSelectorINP.add_item("Magma Boy")
	CharacterSelectorINP.add_item("Ice Girl")
	pass
