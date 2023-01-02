extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 100
export var ROLL_SPEED = 120
export var FRICTION = 800

enum{MOVE,ATK}
enum{MACHADO,ESPADA,PICARETA,MAGIA}

var espada={"tipo":ESPADA,"nv":1,"dano":10,"durabilidade":100,"gastoStamina":1}
var machado={"tipo":MACHADO,"nv":1,"dano":10,"durabilidade":100,"gastoStamina":1}
var picareta={"tipo":PICARETA,"nv":1,"dano":10,"durabilidade":100,"gastoStamina":1}
var magia={"tipo":MAGIA,"nv":1,"dano":10,"durabilidade":100,"gastoStamina":1}

var velocity = Vector2.ZERO
var state = MOVE 
var toolIndex = machado

onready var animation = $AnimationPlayer
onready var animaTree = $AnimationTree
onready var animaState = animaTree.get("parameters/playback")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_atk"):
		if state != ATK:
			state=ATK
	
	match state:
		MOVE:
			Move(delta)	
		ATK:
			Atk()
	
	
func Atk():
	animaState.travel("atk")

func AnimaEndAtk():
	state = MOVE

func Move(delta):
	$Atqespada.visible = false
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
		animaTree.set("parameters/idle/blend_position",input_vector)
		animaTree.set("parameters/run/blend_position",input_vector)
		animaTree.set("parameters/atk/blend_position",input_vector)
		animaState.travel("run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
		animaState.travel("idle")
		
	velocity = move_and_slide(velocity)


func _on_area_body_entered(body):
	print(body.name)
	if body.has_method("Levar_dano"):
		body.Levar_dano(toolIndex)
