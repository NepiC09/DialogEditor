extends ColorRect

onready var optionButton = $VBoxContainer/OptionButton
onready var indexLabel = $IndexLabel
onready var closeButton = $CloseButton
onready var rightLine1 = $RightLine1
onready var leftPoint = $LeftPoint
onready var rightPoint = $RightPoint

onready var global = Global

var choosedAction: int setget set_choosedAction
var index: int setget set_index
var start_index = 0
var nextNPCBox :ColorRect = null
var prevNPCBox :ColorRect = null

var prevPlayerBox :ColorRect = null
var nextPlayerBox :ColorRect = null

var action = ""
var dragging = false
var y = 10
var leftLine: Line2D = null
var InLine = 0

func set_index(value):
	index = value
	indexLabel.text = index as String

func _physics_process(_delta):
	if dragging:
		self.rect_global_position.y = lerp(self.rect_global_position.y, get_global_mouse_position().y - y, 25*_delta)
		if leftLine != null:
			leftLine.rightPoint = self.leftPoint.rect_global_position + self.leftPoint.rect_size/2
		if rightLine1.get_point_count() == 2:
			rightLine1.rightPoint = rightLine1.rightGlobalPoint

func set_choosedAction(value):
	choosedAction = value
	if(choosedAction == 1):
		action == "Player Continue In Line"
		create_PlayerBox()
	
	if(choosedAction == 2):
		action == "NPC Continue In Line"
		create_NPCBox()
	
	if(choosedAction == 3):
		action == "Stop Dialogue"
		pass
	
	optionButton.disabled = min(value, 1)
	closeButton.disabled = true

func _on_OptionButton_item_selected(index):
	set_choosedAction(index)


func create_NPCBox():
	nextNPCBox = load("res://DialogBoxes/NPCBox.tscn").instance()
	global.NPC_index += 1
	InLine = global.NPC_index
	get_tree().current_scene.add_child(nextNPCBox, true)
	
	nextNPCBox.rect_position.x += rect_size.x + 80 + rect_position.x
	nextNPCBox.rect_position.y = rect_position.y
	nextNPCBox.prevPlayerBox = self
	
	var from = self.rightPoint.rect_global_position + rightPoint.rect_size/2
	var to = nextNPCBox.leftPoint.rect_global_position + nextNPCBox.leftPoint.rect_size/2
	rightLine1.leftPoint = from
	rightLine1.rightPoint = to
	nextNPCBox.leftLine = rightLine1

func create_PlayerBox():
	pass
#	nextPlayerBox = load("res://DialogBoxes/PlayerBox.tscn").instance()
#	global.NPC_index += 1
#	InLine = global.NPC_index
#	get_tree().current_scene.add_child(nextNPCBox, true)
#
#	nextNPCBox.rect_position.x += rect_size.x + 80 + rect_position.x
#	nextNPCBox.rect_position.y = rect_position.y
#	nextNPCBox.prevNPCBox = self
#
#	var from = self.rightPoint.rect_global_position + rightPoint.rect_size/2
#	var to = nextNPCBox.leftPoint.rect_global_position + nextNPCBox.leftPoint.rect_size/2
#	rightLine1.leftPoint = from
#	rightLine1.rightPoint = to
#	nextNPCBox.leftLine = rightLine1

func _exit_tree():
	if prevNPCBox != null:
		leftLine.clear_points()
		if start_index == 0:
			prevNPCBox.nextPlayerBox1 = null
		if start_index == 1:
			prevNPCBox.nextPlayerBox2 = null
		if start_index == 2:
			prevNPCBox.nextPlayerBox3 = null
		prevNPCBox.numOfAnswers -= 1


func _on_CloseButton_pressed():
	queue_free()


func _on_DragAndDropButton_button_down():
	dragging = true


func _on_DragAndDropButton_button_up():
	dragging = false
