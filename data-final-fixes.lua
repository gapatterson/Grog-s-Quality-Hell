local machineTypes = {"assembling-machine", "furnace", "mining-drill"};
for _, machineType in pairs(machineTypes) do
	for _, machine in pairs(data.raw[machineType]) do
		log("Adding beacon effects to " .. machine.name);

		if machine.effect_receiver == nil then
			machine.effect_receiver = {};
		end
		if type(machine.allowed_effects) ~= "table" then
			-- For mining machines, nil means all modules?!
			if machine.allowed_effects == nil then
				machine.allowed_effects = {
					"consumption",
					"speed",
					"productivity",
					"pollution"
				};
			end
		end

		function in_array(array, value)
			for _, v in pairs(array) do
				if v == value then
					return true;
				end
			end
			return false;
		end

		if not in_array(machine.allowed_effects, "quality") then
			table.insert(machine.allowed_effects, "quality");
		end

		-- Quality Acceleration modules
		if machine.allowed_module_categories ~= nil then
			machine.allowed_module_categories = {};
			table.insert(machine.allowed_module_categories, "quality-acceleration");
		end
	end
end
