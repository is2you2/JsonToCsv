extends Control


func _ready():
	get_tree().connect("files_dropped", self, 'drag_drop_catch')


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func drag_drop_catch(list:PoolStringArray, _scr):
	print_debug(list)
	var file:= File.new()
	var new_file:= File.new()
	new_file.open('res://result.txt', File.WRITE)
	file.open(list[0], File.READ)
	
	var raw_json:= file.get_as_text()
	var json:Dictionary = JSON.parse(raw_json).result
	var keys:= json.keys()
	keys.sort()
	
	# id, writer, content, password, is_showing
	var form:= '%s，%s，%s，%s，%s'
	
	for key in keys:
		var retext_cont:String = json[key].content
		var new_line:= form % [
			json[key].id,
			json[key].writer,
			retext_cont.replace('\n','\\n'),
			json[key].password if json[key].has('password') else '',
			json[key].is_showing,
		]
		new_file.store_line(new_line)
	
	file.close()
	new_file.flush()
	new_file.close()
	
	var read:= File.new()
	read.open('res://result.txt',File.READ)
	var line:= read.get_csv_line('§')
	print_debug(line)
	read.close()


func _exit_tree():
	get_tree().disconnect("files_dropped", self, 'drag_drop_catch')
