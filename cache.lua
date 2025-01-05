local cache_util = {}

function setup_storage()
	-- set empty storage
	storage.quality_records = {}
	-- Iterate through existing surfaces
	game.print("[Grog's quality hell] Adding quality to surfaces.")
	for _, surface in pairs(game.surfaces) do
		game.print(surface)
		-- Iterate through all player-owned entities on the surface
		for _, entity in pairs(surface.find_entities_filtered{force="player", type={"assembling-machine", "furnace", "mining-drill"}}) do
			-- Add quality record for each entity
			add_quality_record(entity)
		end
	end
end
cache_util.setup_storage = setup_storage

function add_quality_record(entity)
	local registration_number, _, _ = script.register_on_object_destroyed(entity)
	if storage.quality_records[registration_number] ~= nil then
		return
	end

	local record = {
		entity = entity,
		beacon = nil,
		seen_crafted = 0.0,
		bonus_crafted = 0.0,
	}

	if entity.type == "mining-drill" then 
		record.last_mining_progress = entity.mining_progress
	end
	
	storage.quality_records[registration_number] = record

	set_quality_effect(registration_number)
end
cache_util.add_quality_record = add_quality_record


function update_mining_crafted(registration_number)
	local last_mining_progress = storage.quality_records[registration_number].last_mining_progress
	local current_mining_progress = storage.quality_records[registration_number].mining_progress

	if last_mining_progress ~= current_mining_progress then
		-- Heuristic: assume 1/s base speed, if we crafted, then we crafted the whole time.
		local crafting_speed = 1.0
		local update_rate = (settings.global["update-rate"].value * 60) - 1 -- in ticks
		local just_crafted = crafting_speed * update_rate / 60

		storage.quality_records[registration_number].seen_crafted = storage.quality_records[registration_number].seen_crafted + just_crafted
	end
end

function get_total_crafted(registration_number)
	if storage.quality_records[registration_number] == nil then
		return 0
	end
	return storage.quality_records[registration_number].seen_crafted + storage.quality_records[registration_number].bonus_crafted
end
cache_util.get_total_crafted = get_total_crafted


function get_quality_bonus(registration_number)
	local baseBonus = settings.global["base-quality"].value / 2
	local formula = settings.global["quality-growth-formula"].value
	local growthRate = settings.global["quality-growth-rate"].value
	local crafted = get_total_crafted(registration_number)

	if formula == "logarithmic" then
		if crafted < 2 then
			return baseBonus
		end
		return baseBonus + (0.005 * math.log(crafted) / math.log(growthRate+.01))
	elseif formula == "linear" then
		return baseBonus + (0.005 * crafted / growthRate)
	end
end
cache_util.get_quality_bonus = get_quality_bonus


function set_quality_effect(registration_number)
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

	local bonus = get_quality_bonus(registration_number)
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
	local module_indice = 13
	while bonus > 0 do
		if bonus >= 2^module_indice then
			local quantity = math.floor(bonus / 2^module_indice)
			storage.quality_records[registration_number].beacon.get_module_inventory().insert({name="hidden-quality-module-"..module_indice, count=quantity})
			bonus = bonus - (2^module_indice * quantity)
		end
		module_indice = module_indice - 1
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


function update_storage(registration_number)
	if storage.quality_records[registration_number] == nil then
		return
	end
	local entity = storage.quality_records[registration_number].entity
	if entity == nil or not entity.valid then
		remove_quality_record(registration_number)
		return
	end

	-- Update seen_crafted and get justCrafted
	local justCrafted = 0
	if entity.type == "mining-drill" then
		local oldCrafted = storage.quality_records[registration_number].seen_crafted
		update_mining_crafted(registration_number)
		justCrafted = storage.quality_records[registration_number].seen_crafted - oldCrafted
	elseif entity.type == "assembling-machine" or entity.type == "furnace" then
		local newCrafted = entity.products_finished
		justCrafted = newCrafted - storage.quality_records[registration_number].seen_crafted
		storage.quality_records[registration_number].seen_crafted = newCrafted
	end

	-- Update bonus_crafted
	if justCrafted > 0 then
		-- Check if quality-acceleration modules are in machine, and add bonus_crafted
		local bonusMultiplier = get_total_crafting_multiplier(registration_number)
		storage.quality_records[registration_number].bonus_crafted = storage.quality_records[registration_number].bonus_crafted + (justCrafted * bonusMultiplier)
	end
end

function update_quality()
	-- Iterate through all stored entities
	for registration_number, _ in pairs(storage.quality_records) do
		-- Update storage
		update_storage(registration_number)
		-- Update the quality effect
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