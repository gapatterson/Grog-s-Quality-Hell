data:extend({
	{
		type = "beacon",
		name = "hidden-beacon",
		distribution_effectivity = 1.0,
		energy_usage = "1kW",
		energy_source = {type = "void"},
		flags = {},
		allowed_effects = {"quality"},
		supply_area_distance = 1,
		module_slots = 128,--Why not?,
		allowed_module_categories = {"hidden-quality"},
		collision_mask = {
			layers = {},
		},

		--Debug visuals
		-- icon = "__grogs-quality-hell__/graphics/icons/hidden-module-1.png",
		-- icon_size = 64,
		-- graphics_set = {
		-- 	module_icons_suppressed = false,
		-- 	animation_list = {
		-- 	  {
		-- 		render_layer = "above-inserters",
		-- 		always_draw = true,
		-- 		animation = {
		-- 		  layers = {
		-- 			{
		-- 			  filename = "__grogs-quality-hell__/graphics/icons/hidden-module-1.png",
		-- 			  width = 64,
		-- 			  height = 64,
		-- 			  scale = 0.67,
		-- 			},
		-- 		  }
		-- 		}
		-- 	  }
		-- 	}
		-- },
		-- selection_box = {{-1, -1}, {1, 1}},
		-- selectable_in_game = true,
	},
})