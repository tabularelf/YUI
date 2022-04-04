/// @description creates a top level YUI document
function YuiDocument(_yui_file) constructor {
	yui_file = _yui_file;
			
	previous_animation_states = {};
	next_animation_states = {};
		
	load_error = undefined;
	
	// for the loaded document
	static default_props = {
		id: undefined,
		data_type: undefined,
		import: [], // list of .resource.yui filepaths relative to the yui_folder
		resources: {},
		root: undefined,
	}
	
	loadDocument();
	
	static loadDocument = function() {
		
		var yui_filepath = global.__yui_live_reload_enabled
			? YUI_LOCAL_PROJECT_DATA_FOLDER + yui_file
			: yui_file;
		
		if !file_exists(yui_filepath) {
			load_error = yui_string_concat("Could not find yui document file at", yui_filepath);
			yui_error(load_error);
			return;
		}
		
		// load the file data from disk
		yui_log("loading yui_file:", yui_filepath);
		var file_text = string_from_file(yui_filepath);
		
		var file_data = snap_from_yui(file_text);
		
		// apply default props		
		document = yui_init_props(file_data, default_props);
		
		// resolve imports
		var yui_folder = filename_dir(yui_filepath);		
		resources = yui_resolve_resource_imports(
			document.resources,
			document.import,
			yui_folder);
		
		// resolve root element
		root_element = yui_resolve_element(document.root, resources, undefined, document.id);		
	}
}