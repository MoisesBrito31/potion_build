extends StaticBody2D

enum{BROTO,JOVEM,ADULTA,CORTADA}
enum{MACHADO,ESPADA,PICARETA,MAGIA}

export var state = ADULTA
export var vida = 100
export var Armadura = 1

var danoTomado = 0

onready var tronco = $Sprite
onready var animation = $AnimationPlayer
onready var efeitoLuz = $efeito
onready var barraVida = $Node/ProgressBar
onready var timeBarraVida = $Node/ProgressBar/show
onready var interpolar = $Node/ProgressBar/Tween

func _ready():
	efeitoLuz.visible=false
	match state:
		BROTO:
			tronco.frame = 0
			$copaBroto.visible = true
			$copaJovem.visible = false
			$copaAdulata.visible = false
		JOVEM:
			tronco.frame = 1
			$copaBroto.visible = false
			$copaJovem.visible = true
			$copaAdulata.visible = false
		ADULTA:
			tronco.frame = 1
			$copaBroto.visible = false
			$copaJovem.visible = false
			$copaAdulata.visible = true
		CORTADA:
			tronco.frame = 2
			$copaBroto.visible = false
			$copaJovem.visible = false
			$copaAdulata.visible = false
	

func Levar_dano(ferramenta):
	var podeSofrerDano = false
	var multiplicador = 1
	match state:
		BROTO:
			podeSofrerDano = true
			multiplicador = 10
		JOVEM:
			podeSofrerDano = true
			multiplicador = 2
		ADULTA:
			podeSofrerDano = true
		CORTADA:
			podeSofrerDano = false
	if podeSofrerDano:
		var dano = 0
		match ferramenta.tipo:
			MACHADO:
				dano = (ferramenta.dano - Armadura)
			ESPADA:
				dano = (ferramenta.dano - Armadura)*0.1
			PICARETA:
				dano = (ferramenta.dano - Armadura)*0.5
			MAGIA:
				pass
		dano = dano*multiplicador
		if dano<0:
			dano = 0
		danoTomado = dano
		barraVida.visible = true
		interpolar.interpolate_property(barraVida,"value",vida,vida-danoTomado,0.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
		interpolar.start()
		timeBarraVida.start(2)
		animation.play("brilho")
	
	
func Conta_Dano():
	print("levei: ",danoTomado)
	vida = vida-danoTomado
	if vida<0:
		match state:
			BROTO:morer()
			JOVEM:ArvoreCortada()
			ADULTA:
				tronco.frame = 2
				animation.play("copaAdultaCaindo")
			CORTADA:morer()
	
func ArvoreCortada():
	state = CORTADA
	tronco.frame = 2
	$copaBroto.visible = false
	$copaJovem.visible = false
	$copaAdulata.visible = false
	
	
func morer():
	.queue_free()

func _on_show_timeout():
	barraVida.visible=false
