extends Area2D

var payload = null
var tween
var decay = 0.02
var payloads = [
	load("res://Powerups/Payload_Grow.tscn")
	,load("res://Powerups/Payload_GrowBall.tscn")
	,load("res://Powerups/Payload_SlowBall.tscn")
	,load("res://Powerups/Payload_AddBall.tscn")
]

var grav_force = 1.0
var velocity = Vector2.ZERO

func _ready():
	randomize()
	payload = payloads[wrapi(randi(), 0, len(payloads))]
	if payload == load("res://Powerups/Payload_Grow.tscn"):
		$ColorRect.color = Color8(34,225,230)
	elif payload == load("res://Powerups/Payload_GrowBall.tscn"):
		$ColorRect.color = Color8(225,0,230)
	elif payload == load("res://Powerups/Payload_SlowBall.tscn"):
		$ColorRect.color = Color8(22,225,62)
	elif payload == load("res://Powerups/Payload_AddBall.tscn"):
		$ColorRect.color = Color8(238,225,62)

func _physics_process(_delta):
	if $ColorRect.color.s > 0:
		$ColorRect.color.s -= decay
	if $ColorRect.color.v < 1:
		$ColorRect.color.v += decay
	position += velocity
	velocity.y += grav_force
	if position.y > Global.VP.y + 100:
		queue_free()

func _on_Powerup_body_entered(body):
	if body.name == "Paddle":
		if payload != null:
			body.powerup(payload.instantiate())
