extends KinematicBody

onready var Camera = get_node("/root/Game/Player/Camera")
onready var Pivot = get_node("/root/Game/Player/Pivot")
onready var Credits = get_node("/root/Game/Credits")
onready var BoxesLeft = get_node("/root/Game/BoxesLeft")


#var velocity = Vector3()
var gravity = -9.8
#var speed = 0.2
var drag = -1
var max_speed = 4
var mouse_sensitivity = 0.002
var jump = 2
var jumping = false
var isMoving
var boxesLeft = 25
var score = 0

export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75

var velocity = Vector3.ZERO


func _ready():
	$AnimationPlayer.play("Idle")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	if (boxesLeft == 0):
		var _scene = get_tree().change_scene("res://UI/Win.tscn")
		
	
	if Input.is_action_just_pressed("shoot"):
		$AnimationTree.active = false
		$AnimationPlayer.play("Shoot")
		isMoving = 0
		print("Part one worksin")
		
		$GunShoot.play()
		
		if $RayCast.is_colliding():
			print("turue")
			var target = $RayCast.get_collider()
			print(target.name)
			if target.is_in_group("targets"):
				#var explosion = Explosion.instance()
				#Explosions.add_child(explosion)
				#explosion.global_transform.origin = $Pivot/RayCast.get_collision_point()
				print("It works")
				boxesLeft -= 1
				score += 10
				BoxesLeft.text = "Boxes Left: " + str(boxesLeft)
				Credits.text = "Space Credits (Score): " + str(score)
				
				target.die()
		
		yield($AnimationPlayer, "animation_finished")
		#$AnimationPlayer.play("Walk")
		$AnimationTree.active = true

	#$AnimationTree.active = true
	
	
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		#direction.x += 1
		direction += Camera.global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		#direction.x -= 1
		direction += -Camera.global_transform.basis.x
	if Input.is_action_pressed("move_back"):
		#direction.z += 1
		direction += Camera.global_transform.basis.z
	if Input.is_action_pressed("move_forward"):
		#direction.z -= 1
		direction += -Camera.global_transform.basis.z
		
	
	#if direction != Vector3.ZERO:
		#direction = direction.normalized()
		#Pivot.look_at(translation + direction, Vector3.UP)

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	

	if (direction.x != 0 || direction.z != 0):
		isMoving = 1
	else:
		isMoving = 0
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#Pivot.look_at(translation + direction, Vector3.UP)
	
	$AnimationTree.set("parameters/Idle_Walk/blend_amount", isMoving) 
	velocity = move_and_slide(velocity, Vector3.UP)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
