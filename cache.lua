local cache_util = {}

function setup_storage()
	-- set empty storage
	storage.quality_records = {}
	-- Iterate through existing surfaces
	game.print("[Grog's quality hell] Adding quality to surfaces.")
	for _, surface in pairs(game.surfaces) do
		game.print(surface)
		-- Iterate through all player-owned entities on the surface
		for _, entity in pairs(surface.find_entities_filtered{force="player", type={"assembling-machine", "furnace"}}) do
			-- Add quality record for each entity
			add_quality_record(entity)
		end
	end
end
cache_util.setup_storage = setup_storage

function add_quality_record(entity)
	local registration_number, _, _ = script.register_on_object_destroyed(entity)
	local record = {
		seen_crafted = 0,
		bonus_crafted = 0,
		entity = entity,
		beacon = nil,
	}
	storage.quality_records[registration_number] = record

	set_quality_effect(registration_number)
end
cache_util.add_quality_record = add_quality_record

function get_table_size(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

local function get_total_crafted(entity)
	local registration_number, _, _ = script.register_on_object_destroyed(entity)
	return entity.products_finished + storage.quality_records[registration_number].bonus_crafted
end

function get_quality_bonus(registration_number)
	local entity = storage.quality_records[registration_number].entity
	local totalBonus = settings.global["base-quality"].value
	local formula = settings.global["quality-growth-formula"].value
	local growthRate = settings.global["quality-growth-rate"].value
	local crafted = get_total_crafted(entity)

	if formula == "logarithmic" then
		if crafted < 2 then
			return totalBonus
		end
		totalBonus = totalBonus + (0.01 * math.log(crafted) / math.log(growthRate+.01))
	elseif formula == "linear" then
		totalBonus = totalBonus + (0.01 * crafted / growthRate)
	end

	return totalBonus
end
cache_util.get_quality_bonus = get_quality_bonus



function set_quality_effect(registration_number)
	local bonus = get_quality_bonus(registration_number)
	-- Obtain beacon attached to entity
	if storage.quality_records[registration_number].beacon == nil then
		-- Check if beacon already exists
		local entity = storage.quality_records[registration_number].entity
		local currentBeacon = next(entity.surface.find_entities_filtered{position=entity.position, name="hidden-beacon"})
		if currentBeacon ~= nil then
			storage.quality_records[registration_number].beacon = currentBeacon
		else
			local newBeacon = entity.surface.create_entity({name="hidden-beacon", position=entity.position})
			storage.quality_records[registration_number].beacon = newBeacon
		end
	end
	
	set_beacon_quality_modules(registration_number, bonus)
end

function set_beacon_quality_modules(registration_number, bonus)
	-- Items can be destroyed between the update function this one, so we need to check if the record is still valid. 
	if not storage.quality_records[registration_number].beacon.valid then
		return
	end

	-- Remove all modules from beacon
	storage.quality_records[registration_number].beacon.get_module_inventory().clear()
	-- Add modules that add up to the bonus
	bonus = math.floor(bonus * 100)
	local i = 13
	while bonus > 0 do
		if bonus >= 2^i then
			storage.quality_records[registration_number].beacon.get_module_inventory().insert({name="hidden-quality-module-"..i, count=1})
			bonus = bonus - 2^i
		else
			i = i - 1
		end
	end
end


function remove_quality_record(registration_number)
	if storage.quality_records[registration_number] == nil then
		return
	end

	-- Destroy beacon
	storage.quality_records[registration_number].beacon.destroy()
	-- Remove record from storage
	storage.quality_records[registration_number] = nil
end
cache_util.remove_quality_record = remove_quality_record


function update_quality()
	-- Iterate through all stored entities
	for registration_number, record in pairs(storage.quality_records) do
		-- Check how many items have been crafted since last update
		local newCrafted = record.entity.products_finished - record.seen_crafted
		-- Check if quality-acceleration modules are in machine, and add bonus_crafted
		local bonusMultiplier = get_total_crafting_multiplier(registration_number)
		storage.quality_records[registration_number].bonus_crafted = storage.quality_records[registration_number].bonus_crafted + (newCrafted * bonusMultiplier)
		storage.quality_records[registration_number].seen_crafted = record.entity.products_finished
		-- Update quality effect
		set_quality_effect(registration_number)
	end
end
cache_util.update_quality = update_quality

function get_total_crafting_multiplier(registration_number)
	local entity = storage.quality_records[registration_number].entity
	local totalBonus = 0
	local modules = entity.get_module_inventory().get_contents()
	for _, module in pairs(modules) do
		if module.name == "quality-acceleration-module-1" then
			totalBonus = totalBonus + module.count
		elseif module.name == "quality-acceleration-module-2" then
			totalBonus = totalBonus + (module.count * 2)
		elseif module.name == "quality-acceleration-module-3" then
			totalBonus = totalBonus + (module.count * 4)
		end
	end
	return totalBonus
end

return cache_util