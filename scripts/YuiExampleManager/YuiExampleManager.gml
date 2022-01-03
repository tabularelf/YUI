/// @description here
function YuiExampleManager() constructor {

	yui_log("Welcome to the YUI Example Project!");
		
	app_name = "Example Project";
	
	var items_file = string_from_file("Example Data/inventory.yaml")
	var inventory = snap_from_yaml(items_file);
	
	slots = inventory.slots;
	items = inventory.items;
	
	foreach(slots, function(slot) { slot.equipped_item = undefined });
	
	
	yui_log("Example project loaded");
}