extends Node2D

var on_floor : bool = false
var right_contact : bool = false
var left_contact : bool = false
var top_contact : bool = false



func _on_Top_body_entered(body):
	top_contact = true


func _on_Buttom_body_entered(body):
	on_floor = true


func _on_Right_body_entered(body):
	right_contact = true


func _on_Left_body_entered(body):
	left_contact = true
	

func _on_Top_body_exited(body):
	top_contact = false


func _on_Buttom_body_exited(body):
	on_floor = false
	

