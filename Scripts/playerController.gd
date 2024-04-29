extends CharacterBody2D

#Declarando variáveis que podem ser modificadas enquanto o jogo roda (public variables)
@export var speed = 300.0
@export var jumpVelocity = -510.0

#Variáveis relacionadas à nodos
@onready var audioStep = $Steps
@onready var audiosJump = $Jump
@onready var spritePlayer = $SpriteChar


# Declaração de variáveis
var direction
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Funções do loop principal
func _process(delta):
	if direction: #para economizar processamento, ele só faz a chamada se o personagem estiver se movendo
		lookAt()
	walkAnim() #essa função pode ocorrer até sem input do jogador, então ele precisa ser checada com frequência


func _physics_process(delta): #essa função é muito mais pesada que a _process normal, usar o mínimo de coisas aqui
	#Gravidade que só puxa o player se ele não estiver no chão
	if not is_on_floor():  #o player está no chão?
		velocity.y += gravity * delta #não? Então puxa para baixo

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): #se apertar espaço (ui_accept) mover ele para cima e tocar som
		velocity.y = jumpVelocity
		audiosJump.play()

	direction = Input.get_axis("ui_left", "ui_right") #mapemento de entrada entre direita e esquerda, de -1 até 1
	if direction: # se a direção é válida
		velocity.x = direction * speed # mova ele
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide() 

func lookAt(): #função para o player estar sempre olhando para onde ele anda
	if direction == 1:
		spritePlayer.flip_h = true
	if direction == -1:
		spritePlayer.flip_h = false

func walkAnim(): #Função para animar o sprite do player
	if direction != 0 && is_on_floor(): 
		var clock = (Time.get_ticks_msec()/100)%2 #eu uso a sobra do tempo atual em milisegundos para 
		#											criar uma cadência de 0 e 1 constante. Divido por 100 para ficar mais lento.
		spritePlayer.frame = clock #uso a variável clock para alternar entre o sprite 1 e 0 da animação, 
									#isso só funciona com esse personagem, pois os sprites dele são o 1 e 0.
									#Em caso de outro personagem, precisaria adicionar uma soma a esse número
		if clock == 1: # aproveito o clock para fazer o som de passos
			audioStep.play() # tive que modificar o som original para ele ficar com uma duração que encaixe bem

	else:
		if is_on_floor(): # esse sou eu aproveitando os sprites de andar para fazer o sprite dele pulando
			spritePlayer.frame = 0 #se estiver parado no chão, fique com a perninha fechada (sprite 0)
		else:
			spritePlayer.frame = 1 #se estiver no ar, abra as pernas (sprite 1)
