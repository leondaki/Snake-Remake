extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var deathText
var appleCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deathText = get_node("/root/Main/Interface/DeathText")
	appleCounter = get_node("/root/Main/Interface/AppleCounter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Head_AteApple() -> void:
	appleCounter.get_child(1).text = str(int(appleCounter.get_child(1).text) + 1)


func _on_Head_Died() -> void:
	print('show text')
	deathText.visible = true

