extends Node2D

onready var firstNPCBox = $NPCBox1
onready var middle_point = firstNPCBox.rect_position.y

var dialogFolder = ""
var fileName = ""
var global = Global
var array: String = "" #dialog array
var dialogue

func _ready():
	if global.ReadFilePath != "":
		set_readed_dialogue()

func _on_FolderPath_folder_choosed(dir):
	dialogFolder = dir


func _on_FolderPath_save_game(value):
	fileName = value
	
	array = "[{"
	var current_NPCBox: ColorRect = null
	var i = 1
	while i <= global.NPC_index:
		if i != 1: array += ','
		var str_index = '"' + i as String + '"'
		
		current_NPCBox = get_node("NPCBox" + i as String)
		var str_text = '"' + current_NPCBox.textEdit.text + '"'
		var str_action = '"' + current_NPCBox.action + '"'
		var str_inLine = '"' + current_NPCBox.InLine as String + '"'
		var textSpeed = '"' + current_NPCBox.textSpeed.value as String + '"'
		
		array += str_index + ':{'
		array += '"Text":' + str_text + ','
		array += '"Action":' + str_action + ','
		array += '"Text Speed":' + textSpeed + ','
		array += '"In Line":' + str_inLine + ''
		
		if str_action == '"Player Turn"':
			array += ',"Player": {'
			add_player_turn(current_NPCBox, 1)
			array += '}'
		i+=1
		array += '}'
	array += '}]'
	
	save_file()

func add_player_turn(NPCBox, index):
	if index != 1: array += ','
	array += '"' + index as String + '":{'
	var num_of_answers = NPCBox.numOfAnswers
	var action_1 = ""
	var action_2 = ""
	var action_3 = ""
	
	if num_of_answers >= 1:
		_player_answer(NPCBox.nextPlayerBox1, 1)
		action_1 = NPCBox.nextPlayerBox1.action
	if num_of_answers >= 2:
		_player_answer(NPCBox.nextPlayerBox2, 2)
		action_2 = NPCBox.nextPlayerBox2.action
	if num_of_answers >= 3:
		_player_answer(NPCBox.nextPlayerBox3, 3)
		action_3 = NPCBox.nextPlayerBox3.action
	
	array += '}'
	
	if action_1 == "Player Continue In Line":
		var cur_player_box: ColorRect = NPCBox.nextPlayerBox1
		_player_continue(cur_player_box)
	if action_2 == "Player Continue In Line":
		var cur_player_box: ColorRect = NPCBox.nextPlayerBox2
		_player_continue(cur_player_box)
	if action_3 == "Player Continue In Line":
		var cur_player_box: ColorRect = NPCBox.nextPlayerBox3
		_player_continue(cur_player_box)

func _player_answer(answer: ColorRect, index):
	if index != 1: array += ','
	array += '"' + index as String + '":{'
	
	var str_text = '"' + answer.textEdit.text + '"'
	var str_action = '"' + answer.action + '"'
	var str_inLine = '"' + answer.InLine as String + '"'
	var str_textSpeed = '"' + answer.textSpeed.value as String + '"'
	
	array += '"Text":' + str_text + ','
	array += '"Action":' + str_action + ','
	array += '"Text Speed":' + str_textSpeed + ','
	array += '"In Line":' + str_inLine + ''
	
	array += '}'

func _player_continue(cur_player_box: ColorRect):
	while cur_player_box.action == "Player Continue In Line":
		array += ',"' + cur_player_box.InLine as String + '":{'
		_player_answer(cur_player_box.nextPlayerBox, 1)
		cur_player_box = cur_player_box.nextPlayerBox
		array += '}'


func save_file():
	var file = File.new()
	file.open(dialogFolder + "//" + fileName + ".json", File.WRITE)
	file.store_string(array)
	file.close()


func _on_ReadFileDialog_file_selected(path):
	global.ReadFilePath = path
	get_tree().change_scene("res://Main.tscn")


func _on_Main_tree_exited():
	global.NPC_index = 1


func set_readed_dialogue():
	if !global.ReadFilePath.ends_with(".json"):
		return
	
	dialogue = get_dialogue(); assert(dialogue, "Dialog not found")
	
	create_NPC_boxes(firstNPCBox)


func get_dialogue() -> Array:
	var file = File.new() 
	assert(file.file_exists(global.ReadFilePath), "File path doesn't exist")
	file.open(global.ReadFilePath, file.READ)
	
	var json = file.get_as_text()
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY: 
		return output 
	else: 
		return []


func create_NPC_boxes(box):
	var index = box.index as String
	box.textEdit.text = dialogue[0][index]["Text"]
	box.textSpeed = dialogue[0][index]["Text Speed"]
	box.action = dialogue[0][index]["Action"]
	box.InLine = dialogue[0][index]["In Line"]
	match box.action:
		"Continue":
			box.optionButton.selected = 1
			box.optionButton.disabled = true
			if box.create_NPCBox():
				create_NPC_boxes(box.nextNPCBox)
		"Player Turn":
			var num_of_answer = len(dialogue[0][index]["Player"]["1"])
			box.optionButton.selected = 2
			box.optionButton.disabled = true
			
			var start_position = 0
			if global.middle_line():
				start_position = 0
			elif box.rect_position.y < middle_point:
				start_position = global.min_up
			elif box.rect_position.y > middle_point:
				start_position = global.min_up
			if box.create_PlayerBox(192*start_position):
				if num_of_answer == 3:
					create_Player_boxes(box.nextPlayerBox2, index)
					create_Player_boxes(box.nextPlayerBox1, index)
					create_Player_boxes(box.nextPlayerBox3, index)
		"Open Name":
			box.optionButton.selected = 3
			box.optionButton.disabled = true
			if box.create_NPCBox():
				create_NPC_boxes(box.nextNPCBox)

func create_Player_boxes(box, npc_index):
	if box.index <= 3:
		var index = box.index as String
		box.textEdit.text = dialogue[0][npc_index]["Player"]["1"][index]["Text"]
		box.textSpeed = dialogue[0][npc_index]["Player"]["1"][index]["Text Speed"]
		box.action = dialogue[0][npc_index]["Player"]["1"][index]["Action"]
		box.InLine = dialogue[0][npc_index]["Player"]["1"][index]["In Line"]
	else:
		var index = box.index as String
		box.textEdit.text = dialogue[0][npc_index]["Player"][index]["1"]["Text"]
		box.textSpeed = dialogue[0][npc_index]["Player"][index]["1"]["Text Speed"]
		box.action = dialogue[0][npc_index]["Player"][index]["1"]["Action"]
		box.InLine = dialogue[0][npc_index]["Player"][index]["1"]["In Line"]
