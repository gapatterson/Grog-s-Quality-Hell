data:extend({
	{
		type = "technology",
		name = "quality-acceleration-module-1",
		icon = "__grogs-quality-hell__/graphics/technology/quality-acceleration-module-1.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "quality-acceleration-module-1"
			},
		},
		prerequisites = {"quality-module", "automation-science-pack", "logistic-science-pack"},
		unit = {
			count = 250,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
			},
			time = 30,
		},
		quality = true,
	},
	{
		type = "technology",
		name = "quality-acceleration-module-2",
		icon = "__grogs-quality-hell__/graphics/technology/quality-acceleration-module-2.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "quality-acceleration-module-2"
			},
		},
		prerequisites = {"quality-acceleration-module-1", "automation-science-pack", "logistic-science-pack", "production-science-pack"},
		unit = {
			count = 500,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"production-science-pack", 1},
			},
			time = 30,
		},
		quality = true,
	},
	{
		type = "technology",
		name = "quality-acceleration-module-3",
		icon = "__grogs-quality-hell__/graphics/technology/quality-acceleration-module-3.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "quality-acceleration-module-3"
			},
		},
		prerequisites = {"quality-acceleration-module-2", "automation-science-pack", "logistic-science-pack", "chemical-science-pack", "production-science-pack"},
		unit = {
			count = 1000,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
			},
			time = 30,
		},
		quality = true,
	},
})