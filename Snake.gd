extends Area2D
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var updateSpeed = 0.02
var moveCounter = updateSpeed
export var moveAmount = 4

var currentDir = Vector2.RIGHT
var nextDir = Vector2.RIGHT
var lastSwitch = Vector2.ZERO

var apple_scene = load("res://Apple.tscn")
var snake_body_scene = load("res://snake_body.tscn")

var snakeBodyParts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snakeBodyParts = get_node("/root/Main/SnakeBodyParts")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SetNextDir()
	
	# restricts movement to grid, must turn at least one box apart
	if fmod(position.x, 64) == 0 and fmod(position.y, 64) == 0:
						
		for i in snakeBodyParts.get_child_count():
			var bodyPart = snakeBodyParts.get_child(i)
			var prevBodyPart = snakeBodyParts.get_child(i+1)
			
			if i == 0:	
				if (nextDir != currentDir):
					snakeBodyParts.get_child(1).destination.push_back(position)					
					currentDir = nextDir	
					snakeBodyParts.get_child(1).directions.push_back(currentDir)
			
			if i >= 1:
				if !bodyPart.directions.empty():
					
					if bodyPart.position.x == bodyPart.destination[0].x and \
					   bodyPart.position.y == bodyPart.destination[0].y:		
						
						bodyPart.currentDir = bodyPart.directions[0]
					
						bodyPart.destination.pop_front()		
						bodyPart.directions.pop_front()	
				
				if i < snakeBodyParts.get_child_count()-1:	
					if bodyPart.currentDir != prevBodyPart.currentDir:
						prevBodyPart.destination.push_back(bodyPart.position)						
						prevBodyPart.directions.push_back(bodyPart.currentDir)	
											
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
		for i in snakeBodyParts.get_child_count():
			snakeBodyParts.get_child(i).position += \
				snakeBodyParts.get_child(i).currentDir * moveAmount
				
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
