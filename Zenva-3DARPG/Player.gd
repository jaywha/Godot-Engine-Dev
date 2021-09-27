extends KinematicBody

var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackRate : float = 0.3
var lastAttackTime : int = 0

var moveSpeed : float = 5.0
var jumpForce : float = 10.0
var gravity : float = 15.0

var vel : Vector3 = Vector3()

onready var camera = get_node("CameraOrbit")
onready var attackRayCast = get_node("AttackRayCast")
onready var swordAnim = get_node("WeaponHolder/SwordAnimator")
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")

func _ready():
	
	# initialize UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_gold_text(gold)

func _process(delta):
	
	if Input.is_action_just_pressed("attack"):
		try_attack()

# called every physics step (60 times per second)
func _physics_process(delta):
	
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()
	
	# movement inputs
	if Input.is_action_pressed("move_forward"):
		input.z += 1
	if Input.is_action_pressed("move_backward"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
	
	# normalize the input vector to prevent increased diagonal speed
	input = input.normalized()
	
	# get the relative direction
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)	
	
	# apply the direction to our velocity
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	# gravity
	vel.y -= gravity * delta
	
	# jump input
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		
	# move along the current velocity
	vel = move_and_slide(vel, Vector3.UP)

func try_attack():
	
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
	
	lastAttackTime = OS.get_ticks_msec()
	
	swordAnim.stop()
	swordAnim.play("attack")
	
	if attackRayCast.is_colliding():
		if attackRayCast.get_collider().has_method("take_damage"):
			attackRayCast.get_collider().take_damage(damage)

# called when we collect coin
func give_gold(amount):
	gold += amount
	ui.update_gold_text(gold)
	
func take_damage(damageToTake):
	curHp -= damageToTake
	ui.update_health_bar(curHp, maxHp)
	
	if curHp <= 0:
		die()

func die():
	get_tree().reload_current_scene()
