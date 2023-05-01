extends Node
class_name Utils

class Level:
	var name: String
	var scene: Resource
	var banner: Resource
	
	func _init(name: String, scene: Resource, banner: Resource):
		self.name = name
		self.scene = scene
		self.banner = banner

class NPI: # Network Player Info
	var pos: Vector2
	var direction: bool

	func _init(p_pos: Vector2, p_direction: bool):
		pos = p_pos
		direction = p_direction
