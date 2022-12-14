local input

function lib.inputDialog(heading, rows)
	if input then return end
	input = promise.new()

	-- Backwards compat with string tables
	for i = 1, #rows do
		if type(rows[i]) == 'string' then
			rows[i] = {type = 'input', label = rows[i]}
		end

	end

	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openDialog',
		data = {
			heading = heading,
			rows = rows
		}
	})

	return Citizen.Await(input)
end

RegisterNUICallback('inputData', function(data, cb)
	cb(1)
	SetNuiFocus(false, false)
	local promise = input
	input = nil
	promise:resolve(data)
end)
