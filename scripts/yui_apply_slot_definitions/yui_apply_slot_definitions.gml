/// @desc applies slot_definitions to template_renderer props, and returns the slot_values for the template instance
function yui_apply_slot_definitions(
	slot_definitions,
	parent_slot_values,
	template_instance_props,
	template_renderer_props,
	resources
	) {
	
	// copy the slot definiton values to the slot_values since these are the default values
	var slot_values = snap_deep_copy(slot_definitions);
	
	// loop through the values in template_instance_props and overlay them on the slot_values
	// OR onto the template_renderer_props if there is not a slot for them
	var input_keys = variable_struct_get_names(template_instance_props);
	var i = 0; repeat array_length(input_keys) {
		var input_key = input_keys[i++];
		
		// NOTE: this is ugly, ideally should delete these from the instance props first?
		if input_key == "type"
		
		// these have to do with data templates
		// TODO: should change the data template to define the element in a subprop, to avoid this
		|| input_key == "resource_group"
		|| input_key == "resource_key"
		
		|| input_key == "item_key" {
			continue;
		}
				
		var slot_exists = variable_struct_exists(slot_definitions, input_key);
		if slot_exists {
			// if slot exists, bind it and copy value into slot
			var slot_value = template_instance_props[$ input_key];
			var bound_value = yui_bind(template_instance_props[$ input_key], resources, parent_slot_values);
			slot_values[$ input_key] = bound_value;
		}
		else {
			// otherwise, just copy it to the template_renderer props
			template_renderer_props[$ input_key] = template_instance_props[$ input_key];
		}
	}
	
	// now copy the parent slot values into the output slot values
	// this way the instance props for an inner template can use $slot binding
	// to access the slot values defined on an outer template
	// (AKA using template instances inside the template definition of another template)
	if parent_slot_values {
		var parent_slot_names = variable_struct_get_names(parent_slot_values);
		var i = 0; repeat array_length(parent_slot_names) {
			var parent_slot_name = parent_slot_names[i++];
			
			var slot_overlaps = variable_struct_exists(slot_values, parent_slot_name);
			if slot_overlaps {
				// if the child has the same slot as the parent, leave the child slot alone
				// an example where this can happen is a recursive template (see menu.yui)
			}
			else {
				slot_values[$ parent_slot_name] = parent_slot_values[$ parent_slot_name];
			}
		}
	}
	
	return slot_values;
}