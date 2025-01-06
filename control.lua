local cache_util = require("cache")
local update_rate = (settings.global["update-rate"].value * 60) - 1 -- Irregular value to help with detecting mining drill working intervals.

-- GUI
local function add_quality_status_to_gui(event)
	if settings.get_player_settings(event.player_index)["show-bonus-quality-gui"].value == false then
		return
	end

	local player = game.get_player(event.player_index)
	local registration_number, _, _ = script.register_on_object_destroyed(event.entity)
	if storage.quality_records[registration_number] == nil then
		-- game.print("Quality record not found for opened gui.")
		return
	end
	if storage.quality_records[registration_number].bonus_crafted == 0 then
		-- Don't need to display anything if there's no bonus.
		return
	end

	-- Figure out what type of GUI we need to anchor to
	local type = storage.quality_records[registration_number].entity.type
	local anchor
	if type == "assembling-machine" then
		anchor = {gui=defines.relative_gui_type.assembling_machine_gui, position=defines.relative_gui_position.right}
	elseif type == "furnace" then
		anchor = {gui=defines.relative_gui_type.furnace_gui, position=defines.relative_gui_position.right}
	elseif type == "mining-drill" then
		anchor = {gui=defines.relative_gui_type.mining_drill_gui, position=defines.relative_gui_position.right}
	end

	local frame = player.gui.relative.add{type="frame", anchor=anchor}
	-- TODO: update numbers while open
	frame.add{type="label", caption=string.format("Finished Crafts: %s\nBonus Crafts: %s\n", storage.quality_records[registration_number].seen_crafted, storage.quality_records[registration_number].bonus_crafted)}

end

function handle_gui_opened(event)
	if event.gui_type == defines.gui_type.entity then
		if event.entity.type == "assembling-machine" or event.entity.type == "furnace" or event.entity.type == "mining-drill" then
			add_quality_status_to_gui(event)
			-- TODO: begin tracking crafts for updating the GUI
			return
		end
	end
end


-- TODO: figure out how to specifically target the gui frame we added.  This currently removes all relative guis.
local function remove_quality_status(event)
	if event.gui_type == defines.gui_type.entity then
		local player = game.get_player(event.player_index)
		player.gui.relative.clear()
	end
end

-- Interface with storage
local function add_quality_record(event)
	cache_util.add_quality_record(event.entity)
end
local function remove_quality_record(event)
	local registration_number, _, _ = script.register_on_object_destroyed(event.entity)
	cache_util.remove_quality_record(registration_number)
end
local function remove_quality_record_destroyed(event)
	cache_util.remove_quality_record(event.registration_number)
end

-- Initialization
script.on_init(function()
	cache_util.setup_storage()
	game.forces["player"].unlock_quality("uncommon")
	game.forces["player"].unlock_quality("rare")
	game.forces["player"].unlock_quality("epic")
	game.forces["player"].unlock_quality("legendary")
end)
script.on_configuration_changed(function()
	cache_util.update_quality()
	update_rate = settings.global["update-rate"].value * 60
end)



-- GUI changes
script.on_event(defines.events.on_gui_opened, handle_gui_opened)
script.on_event(defines.events.on_gui_closed, remove_quality_status)


-- Add new items to storage
script.on_event(defines.events.on_built_entity, add_quality_record, {
	{ filter="crafting-machine" },
	{ filter="type", type="mining-drill" },
})


-- Remove mined entity from storage
script.on_event(defines.events.on_player_mined_entity, remove_quality_record, {
	{ filter="crafting-machine" },
	{ filter="type", type="mining-drill" },
})
script.on_event(defines.events.on_robot_mined_entity, remove_quality_record, { 
	{ filter="crafting-machine" },
	{ filter="type", type="mining-drill" },
})
-- Remove destroyed entity from storage
script.on_event(defines.events.on_object_destroyed, remove_quality_record_destroyed)

-- Increase quality values
script.on_nth_tick(update_rate, function()
    cache_util.update_quality()
end)