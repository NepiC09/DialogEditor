extends Node2D

var NPC_index = 1

var ReadFilePath = ""

var min_up :int = 0
var min_down :int = 0

func middle_line():
	return min_up == min_down
