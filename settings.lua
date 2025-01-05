data:extend({
	{
		type = "double-setting",
		name = "base-quality",
		setting_type = "runtime-global",
		minimum_value = 0,
		default_value = 0.1,
		maximum_value = 10000,
	},
	{
		type = "string-setting",
		name = "quality-growth-formula",
		setting_type = "runtime-global",
		allowed_values = {"logarithmic", "linear"},
		default_value = "logarithmic",
	},
	{
		type = "int-setting",
		name = "quality-growth-rate",
		setting_type = "runtime-global",
		minimum_value = 1,
		default_value = 10,
	},
	{
		type = "int-setting",
		name = "update-rate",
		setting_type = "runtime-global",
		minimum_value = 0.1,
		default_value = 1,
	},
	{
		type = "bool-setting",
		name = "show-bonus-quality-gui",
		setting_type = "runtime-per-user",
		default_value = true,
	},
})