extends Panel

onready var level_btn = $MarginContainer/LevelBTN
onready var title = $Title

func init(
	title: String,
	banner: Resource, 
	bind_node: Node, 
	bind_function_name: String, 
	level_id: int
	) -> void:
	self.title.text = title
	level_btn.connect("pressed", bind_node, bind_function_name, [level_id])
	level_btn.texture_normal = banner
