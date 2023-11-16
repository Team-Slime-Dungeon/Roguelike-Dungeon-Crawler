extends Node

#LOADS JSON Files

var item_data = {} #Reads Item Table


func _ready():
	#Opens and reads ItemData file
	var item_data_file =  FileAccess.open("res://InventoryTesting/Data/ItemData.json", FileAccess.READ)
	var content = item_data_file.get_as_text()
	var item_data_json = JSON.new()
	
	#Stores ItemData file contents into the item_data 
	item_data = item_data_json.parse_string(content)
	
	item_data_file.close()
	
