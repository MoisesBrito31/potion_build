extends RigidBody2D

var forca = "applied_force"
var torque = "applied_torque"
onready var forcedTime = $TimerForced
onready var interpolacao = $Tween

func _ready():
	var vetor = Vector2(1000,0)
	interpolacao.interpolate_method(self,"applied_force",vetor,Vector2.ZERO,1,Tween.TRANS_BOUNCE,Tween.EASE_IN)
	interpolacao.start()
	#.set(forca,vetor)
	#.set(torque,10)
	forcedTime.start(1)
	print(forca)
	

	
	


func _on_TimerForced_timeout():
	pass
	#.set(forca,Vector2.ZERO)
	#.set(torque,0)
