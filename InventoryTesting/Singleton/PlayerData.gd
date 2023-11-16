extends Node

#LOADS JSON Files

var inv_data = {} #Reads Inventory Data File


func _ready():
	#Opens and Reads Inventory data file
	var inv_data_file =  FileAccess.open("res://InventoryTesting/Data/Inventory_Data.json", FileAccess.READ)
	var content = inv_data_file.get_as_text()
	var inv_data_json = JSON.new()
	
	#Stores the contents in the file into inv_data
	inv_data = inv_data_json.parse_string(content)
	
	inv_data_file.close()
	
