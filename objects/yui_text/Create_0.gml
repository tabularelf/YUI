/// @description init

// Inherit the parent event
event_inherited();

scribble_element = undefined;
typist = undefined;
element_xoffset = 0;
element_yoffset = 0;



onLayoutInit = function() {
	highlight_color = layout_props.highlight_color;
}

build = function() {
	trace = yui_element.props.trace; // hack
	
	// used in Draw GUI
	text_color = bound_values.color;
		
	scribble_element = scribble(bound_values.text, string(id))
		.starting_format(bound_values.font)
		.align(layout_props.halign, layout_props.valign);
	
	if bound_values.typist {
		typist = bound_values.typist;
		typist.__associate(scribble_element);
	}
	else if bound_values.autotype != undefined {
		typist = scribble_typist();
		var autotype = bound_values.autotype;
		if autotype == true {
			typist.in(0.15, 0);
		}
		else if is_struct(autotype) {
			typist.in(autotype.speed, autotype.smoothness);
		}
		else {
			throw "invalid autotype value";
		}
	}	
}

arrange  = function(available_size) {		
	if !visible return;
	
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	
	var padding = layout_props.padding;	
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		yui_resize_instance(self, 0, 0);
		return draw_size;
	}
	
	element_xoffset = padding.left;
	element_yoffset = padding.top;
	
	if trace {
		DEBUG_BREAK
	}
	
	scribble_element.wrap(padded_rect.w, padded_rect.h);

	var new_bbox = scribble_element.get_bbox(x, y, padding.left, padding.top, padding.right, padding.bottom);
	
	// update draw size
	var draw_width = layout_props.halign
		|| scribble_element.get_wrapped() ? available_size.w : new_bbox.width;
	var draw_height = layout_props.valign ? available_size.h : new_bbox.height;
	
	var drawn_size = yui_apply_element_size(layout_props.size, available_size, {
		w: draw_width + padding.w,
		h: draw_height + padding.h,
	});
	
	yui_resize_instance(self, drawn_size.w, drawn_size.h);
	
	// when centering, center on the center of the padded rect
	if layout_props.halign == fa_center {
		element_xoffset += padded_rect.w / 2;
	}
	if layout_props.valign == fa_middle {
		element_yoffset += padded_rect.h / 2;
	}
	
	return draw_size;
}