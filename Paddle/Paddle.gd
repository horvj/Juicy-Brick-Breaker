extends CharacterBody2D

var target = Vector2.ZERO
var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.01
var time_highlight = 0.4
var time_highlight_size = 0.3

var tween


func _ready():
	width = $CollisionShape2D.get_shape().size.x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, width/2, Global.VP.x - width/2)
	position = target
	for c in $Powerups.get_children():
		c.payload()
	if $ColorRect.color.s > 0:
		$ColorRect.color.s -= decay
	if $ColorRect.color.v < 1:
		$ColorRect.color.v += decay
	

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x
		

func hit(_ball):
	var paddle_sound = get_node("/root/Game/Paddle_Sound")
	paddle_sound.play()
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	$ColorRect.color = Color(randf(),randf(),randf())
	tween = get_tree().create_tween()



	

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
