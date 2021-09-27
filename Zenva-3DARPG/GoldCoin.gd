extends Area

export var goldToGive : int = 1
var rotateSpeed : float = 5.0

func _process(delta):
	
	# rotate along the Y axis
	rotate_y(rotateSpeed * delta)

func _on_GoldCoin_body_entered(body):
	
	# is this the Player? If so give them gold
	if body.name == "Player":
		body.give_gold(goldToGive)
		queue_free()
