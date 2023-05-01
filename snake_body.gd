extends Area2D

export var currentDir = Vector2.RIGHT
var destination = []
var directions = []

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_node("/root/Main") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match currentDir:
		Vector2.UP:
			rotation_degrees = -90
		Vector2.DOWN:
			rotation_degrees = 90
		Vector2.LEFT:
			rotation_degrees = 180
		Vector2.RIGHT:
			rotation_degrees = 0


func _on_Body_area_entered(area: Area2D) -> void:
	if area.is_in_group("Apple"):
		var apple = main.get_child(5)
		apple.position.x = int(rand_range(1, 9)) * 64 + 32
		apple.position.y = int(rand_range(1, 9)) * 64 + 32
