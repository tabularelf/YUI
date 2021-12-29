/// @description bind / layout

if layout_props == undefined {
	if yui_element == undefined {
		yui_element = new element_constructor(default_props, {});
	}
	initLayout();
}

if parent && !parent.visible {
	visible = false;
	rebuild = false;
	exit;
}
	

rebuild = bind_values();

if rebuild {
	build();
	
	// way to detect if build() requires re-arrange?
	// have build return a boolean
	arrange(draw_rect);
	
	if parent {
		parent.onChildLayoutComplete(self);
	}
}

// create/destroy tooltip item
if tooltip_renderer {
	if highlight {
	
		// make sure we don't orphan an existing item
		if tooltip_item {
			instance_destroy(tooltip_item);
		}
	
		tooltip_item = yui_make_render_instance(
			tooltip_renderer,
			bound_values.data_source, 
			/* no index */,
			1000); // ensures tooltips appear above popup layers
	
		var popup_space = yui_calc_popup_space(tooltip_item);
		tooltip_item.arrange(popup_space);
	}
	else if tooltip_item {
		instance_destroy(tooltip_item);
		tooltip_item = undefined;
	}
}