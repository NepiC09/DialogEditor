extends Line2D

var leftPoint = Vector2.ZERO setget set_leftPoint
var rightPoint = Vector2.ZERO setget set_rightPoint
var rightGlobalPoint

func set_leftPoint(value):
	leftPoint = value - global_position
	add_point(leftPoint, 0)


func set_rightPoint(value):
	rightGlobalPoint = value
	rightPoint = value - global_position
	if get_point_count() == 2:
		set_point_position(1, rightPoint)
	else:
		add_point(rightPoint, 1)

func update_rightPoint():
	set_point_position(1, rightPoint)
