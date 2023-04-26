extends Area2D
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var updateSpeed = 0.01
var moveCounter = updateSpeed
export var moveAmount = 2

var currentDir = Vector2.RIGHT
var nextDir = Vector2.RIGHT
var lastSwitch = Vector2.ZERO

var apple_scene = load("res://Apple.tscn")
var snake_body_scene = load("res://snake_body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SetNextDir()
	
	if (fmod(position.x - 32, 64) == 0 and abs(position.x - lastSwitch.x) >= 64) \
		or (fmod(position.y - 32, 64) == 0 and abs(position.y - lastSwitch.y) >= 64):
		lastSwitch.x = position.x
		lastSwitch.y = position.y
		currentDir = nextDir

	match currentDir:
		Vector2.UP:
			rotation_degrees = -90
		Vector2.DOWN:
			rotation_degrees = 90
		Vector2.LEFT:
			rotation_degrees = 180
		Vector2.RIGHT:
			rotation_degrees = 0
			
	if moveCounter <= 0:
		moveCounter = updateSpeed
		position += currentDir * moveAmount
		print('x: ', position.x, ', y: ', position.y )
	moveCounter -= delta

func SetNextDir() -> void: 
	if Input.is_action_just_pressed("move_right") && currentDir != Vector2.LEFT:
		nextDir = Vector2.RIGHT
	if Input.is_action_just_pressed("move_left")  && currentDir != Vector2.RIGHT:
		nextDir = Vector2.LEFT
	if Input.is_action_just_pressed("move_up") && currentDir != Vector2.DOWN:
		nextDir = Vector2.UP
	if Input.is_action_just_pressed("move_down") && currentDir != Vector2.UP:
		nextDir = Vector2.DOWN
		
	

# spawn apples
#func _on_Snake_area_entered(area: Area2D) -> void:
#	var apple = apple_scene.instance()
#	get_tree().get_root().add_child(apple)
#	apple.position.x = int(rand_range(1, 9)) * 64 + 32
#	apple.position.y = int(rand_range(1, 9)) * 64 + 32
#	print(apple.position.x, " ", apple.position.y)
#	apple.scale.x = 3
#	apple.scale.y = 3
#	area.queue_free()
