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
