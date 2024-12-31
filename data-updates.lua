-- Add beacon effects to machines
data.raw["furnace"]["stone-furnace"].effect_receiver.uses_beacon_effects = true
data.raw["furnace"]["stone-furnace"].allowed_effects = {"quality"}
data.raw["furnace"]["steel-furnace"].effect_receiver.uses_beacon_effects = true
data.raw["furnace"]["steel-furnace"].allowed_effects = {"quality"}
data.raw["assembling-machine"]["assembling-machine-1"].effect_receiver.uses_beacon_effects = true
data.raw["mining-drill"]["burner-mining-drill"].allowed_effects = {"quality"}
data.raw["assembling-machine"]["assembling-machine-1"].effect_receiver.uses_beacon_effects = true
data.raw["assembling-machine"]["assembling-machine-1"].allowed_effects = {"quality"}

-- Update machines that already can use beacon effects
data.raw["assembling-machine"]["assembling-machine-1"].allowed_effects = {"consumption", "speed", "pollution", "quality"}
data.raw["assembling-machine"]["assembling-machine-2"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
data.raw["assembling-machine"]["assembling-machine-3"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
data.raw["furnace"]["electric-furnace"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
data.raw["mining-drill"]["electric-mining-drill"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
data.raw["assembling-machine"]["chemical-plant"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
data.raw["assembling-machine"]["centrifuge"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}

-- Space Age compatibility
if mods["SpaceAge"] then
	-- Update machines that already can use beacon effects
	data.raw["mining-drill"]["big-mining-drill"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["biochamber"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["foundry"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["furnace"]["recycler"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["cryogenic-plant"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["electromagnetic-plant"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["crusher"].allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}
	data.raw["assembling-machine"]["captive-biter-spawner"].allowed_effects = {"quality"}
end
