extends Control

signal folder_choosed
signal save_game
var global = Global

func _on_ChooseFolderButton_pressed():
	$FileDialog.popup_centered()
#	$FileDialog.rect_scale = Vector2(0.7, 0.7)


func _on_FileDialog_dir_selected(dir):
	$FileFolderContainer/FolderPathLabel.text = dir
	emit_signal("folder_choosed", dir)



func _on_SaveFileButton_pressed():
	var fileName = $FileNameContainer/FileNameTextEdit.text
	emit_signal("save_game", fileName)


func _on_ReadFileButton_pressed():
	$ReadFileDialog.popup_centered()


func _on_ResetButton_pressed():
	global.ReadFilePath = ""
	get_tree().change_scene("res://Main.tscn")
