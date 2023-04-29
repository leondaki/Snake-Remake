extends Area2D

export var updateSpeed = 0.001
var moveCounter = updateSpeed
export var moveAmount = 4

var currentDir = Vector2.RIGHT
var nextDir = Vector2.RIGHT
var lastSwitch = Vector2.ZERO

var apple_scene = load("res://Apple/Apple.tscn")
var snake_body_scene = load("res://snake_body.tscn")

var snakeBodyParts
var main
var interface

var partsToAdd = 0
var length = 3
var newLength = length

signal AteApple

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snakeBodyParts = get_node("/root/Main/SnakeBodyParts")
	main = get_node("/root/Main") 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SetNextDir()
							
	for i in snakeBodyParts.get_child_count():
		var bodyPart = snakeBodyParts.get_child(i)
		var prevBodyPart
		if i < snakeBodyParts.get_child_count()-1:
			prevBodyPart = snakeBodyParts.get_child(i+1)
		
		if i == 0:	
			if (nextDir != currentDir):
				snakeBodyParts.get_child(1).destination.push_back(position)
				if fmod(position.x, 64) == 0 and fmod(position.y, 64) == 0:					
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
					if !prevBodyPart.directions.empty() and prevBodyPart.directions[0] != bodyPart.currentDir or \
						(prevBodyPart.directions.empty() and prevBodyPart.currentDir != bodyPart.currentDir):
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
						
		var last = snakeBodyParts.get_child_count()-1		
		var tail = snakeBodyParts.get_child(last) 		

		if partsToAdd > 0 and \
			fmod(tail.position.x, 64) == 0 and \
			fmod(tail.position.y, 64) == 0 and IsNextPartATileAway(last):

			AddBodyPart(last)
			partsToAdd -= 1
			newLength += 1
			
		if length < newLength:
			if !IsNextPartATileAway(last):
				for i in snakeBodyParts.get_child_count()-1:
					MovePart(i)	
				if IsNextPartATileAway(last):
					length += 1
		else:	
			for i in snakeBodyParts.get_child_count():
				MovePart(i)	
				
	
	moveCounter -= delta
	
	

func IsNextPartATileAway(i: int) -> bool:
	return sqrt(pow(snakeBodyParts.get_child(i).position.x - snakeBodyParts.get_child(i-1).position.x, 2) + \
			pow(snakeBodyParts.get_child(i).position.y - snakeBodyParts.get_child(i-1).position.y, 2)) == 64
			
				
func AddBodyPart(i: int) -> void: 
	var newBodyPart = snake_body_scene.instance()	
	newBodyPart.position = snakeBodyParts.get_child(i).position
	newBodyPart.currentDir = snakeBodyParts.get_child(i).currentDir
	snakeBodyParts.add_child(newBodyPart)


func MovePart(i: int) -> void:
	snakeBodyParts.get_child(i).position += \
		snakeBodyParts.get_child(i).currentDir * moveAmount	
		
			
func SetNextDir() -> void: 	
	if Input.is_action_just_pressed("move_right") && currentDir != Vector2.LEFT:
		nextDir = Vector2.RIGHT
	if Input.is_action_just_pressed("move_left")  && currentDir != Vector2.RIGHT:
		nextDir = Vector2.LEFT
	if Input.is_action_just_pressed("move_up") && currentDir != Vector2.DOWN:
		nextDir = Vector2.UP
	if Input.is_action_just_pressed("move_down") && currentDir != Vector2.UP:
		nextDir = Vector2.DOWN
	

func _on_Head_area_entered(area: Area2D) -> void:
	if area.is_in_group("Apple"):
		
		var apple = apple_scene.instance()

		main.call_deferred("add_child", apple)
		emit_signal("AteApple")
		partsToAdd += 1
		
		apple.position.x = int(rand_range(1, 9)) * 64 + 32
		apple.position.y = int(rand_range(1, 9)) * 64 + 32
		apple.add_to_group("Apple")
		area.queue_free()
	else:
		moveAmount = 0
