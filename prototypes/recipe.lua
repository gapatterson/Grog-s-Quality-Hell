data:extend({
	{
		type = "recipe",
		name = "quality-acceleration-module-1",
		enabled = false,
		ingredients = {
			{type = "item", name = "quality-module", amount = 1},
			{type = "item", name = "electronic-circuit", amount = 5},
			{type = "item", name = "advanced-circuit", amount = 5},
		},
		energy_required = 15,
		results = {{type="item", name="quality-acceleration-module-1", amount=1}},
	},
	{
		type = "recipe",
		name = "quality-acceleration-module-2",
		enabled = false,
		ingredients = {
			{type = "item", name = "quality-acceleration-module-1", amount = 4},
			{type = "item", name = "advanced-circuit", amount = 5},
			{type = "item", name = "processing-unit", amount = 5},
		},
		energy_required = 30,
		results = {{type="item", name="quality-acceleration-module-2", amount=1}},
	},
	{
		type = "recipe",
		name = "quality-acceleration-module-3",
		enabled = false,
		ingredients = {
			{type = "item", name = "quality-acceleration-module-2", amount = 4},
			{type = "item", name = "processing-unit", amount = 5},
			{type = "item", name = "raw-fish", amount = 1},
		},
		energy_required = 60,
		results = {{type="item", name="quality-acceleration-module-3", amount=1}},
	},
})