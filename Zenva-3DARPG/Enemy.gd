extends KinematicBody

var curHp : int = 3
var maxHp : int = 3

var damage : int = 1
var attackDist : float = 1.5
var attackRate : float = 1.0

var moveSpeed : float = 2.5

var vel : Vector3 = Vector3()

onready var timer = get_node("Timer")
onready var player = get_node("/root/MainScene/Player")

func _ready():
	
	# set timer wait time
	timer.wait_time = attackRate
	timer.start()

# called every "attackRate" seconds
func _on_Timer_timeout():
	
	# if we're within the attack distance - attack the player
	if translation.distance_to(player.translation) <= attackDist:
		player.take_damage(damage)

func _physics_process(delta):
	
	# distance to player
	var dist = translation.distance_to(player.translation)
	
	# chase after player, if we're outside of the attack distance
	if dist > attackDist:
		# direction between us and the player
		var dir = (player.translation - translation).normalized()
		
		vel.x = dir.x * moveSpeed
		vel.y = 0
		vel.z = dir.z * moveSpeed
		
		# move towards the player
		vel = move_and_slide(vel, Vector3.UP)

# called when the player deals damage to us
func take_damage(damageToTake):
	
	curHp -= damageToTake
	
	# if our health reaches 0 - die
	if curHp <= 0:
		die()

# called when our health reaches 0
func die():
	queue_free()
