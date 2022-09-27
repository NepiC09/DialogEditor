extends ColorRect

onready var optionButton = $VBoxContainer/OptionButton
onready var indexLabel = $IndexLabel
onready var closeButton = $CloseButton
onready var rightLine1 = $RightLine1
onready var rightLine2 = $RightLine2
onready var rightLine3 = $RightLine3
onready var leftPoint = $LeftPoint
onready var rightPoint = $RightPoint
onready var PlayerBox = preload("res://DialogBoxes/PlayerBox.tscn")

onready var global = Global

var choosedAction: int setget set_choosedAction
var index: int
var nextNPCBox :ColorRect = null
var prevNPCBox :ColorRect = null

var numOfAnswers = 0 setget set_numOfAnswers
var nextPlayerBox1 :ColorRect = null
var nextPlayerBox2 :ColorRect = null
var nextPlayerBox3 :ColorRect = null
var prevPlayerBox :ColorRect = null

var action = ""
var dragging = false
var x = rect_size.x/2
var y = 10
var leftLine: Line2D = null
var InLine = 0

func _ready():
	index = global.NPC_index
	indexLabel.text = index as String
	if index == 0:
		closeButton.visible = false
	else:
		closeButton.visible = true

func _physics_process(_delta):
	if dragging:
#		self.rect_global_position.x = lerp(self.rect_global_position.x, get_global_mouse_position().x - x, 25*_delta)
		self.rect_global_position.y = lerp(self.rect_global_position.y, get_global_mouse_position().y - y, 25*_delta)
		if leftLine != null:
			leftLine.rightPoint = self.leftPoint.rect_global_position + self.leftPoint.rect_size/2
		if rightLine1.get_point_count() == 2:
			rightLine1.rightPoint = rightLine1.rightGlobalPoint

func set_choosedAction(value):
	choosedAction = value
	if(choosedAction == 1):
		action == "Continue"
		create_NPCBox()
	
	if(choosedAction == 2):
		action == "Player Turn"
		create_PlayerBox()
	
	if(choosedAction == 3):
		action == "Open Name"
		create_NPCBox()
	
	optionButton.disabled = min(value, 1)
	closeButton.disabled = true

func _on_OptionButton_item_selected(index):
	set_choosedAction(index)


func create_NPCBox():
	nextNPCBox = self.duplicate()
	global.NPC_index += 1
	InLine = global.NPC_index
	get_tree().current_scene.add_child(nextNPCBox, true)
	
	nextNPCBox.optionButton.selected = 0
	nextNPCBox.rect_position.x += rect_size.x + 80
	nextNPCBox.prevNPCBox = self
	
	var from = self.rightPoint.rect_global_position + rightPoint.rect_size/2
	var to = nextNPCBox.leftPoint.rect_global_position + nextNPCBox.leftPoint.rect_size/2
	rightLine1.leftPoint = from
	rightLine1.rightPoint = to
	nextNPCBox.leftLine = rightLine1

func create_PlayerBox():
	numOfAnswers = 3
	var playerBox1 = PlayerBox.instance()

func set_numOfAnswers(value):
	numOfAnswers = value


func _exit_tree():
	global.NPC_index -= 1
	if prevNPCBox != null:
		prevNPCBox.optionButton.selected = 0
		prevNPCBox.optionButton.disabled = false
		prevNPCBox.closeButton.disabled = false
		leftLine.clear_points()


func _on_CloseButton_pressed():
	queue_free()


func _on_DragAndDropButton_button_down():
	dragging = true


func _on_DragAndDropButton_button_up():
	dragging = false
