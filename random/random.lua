-- Title: Random
-- Author: Kalvin Lyle
-- Version: 1.0
-- Description: Defold module for generating random values using a variety of methods

local M = {}

function M.table(list) -- roll an option from a list in a weighted table formatted { Weight = num, Option = { table } }

	local range = #list 				-- table range
	local roll = math.random(1, range) 	-- random selection
	local choice = list[roll]		-- find result in table

	return choice
end

function M.table_weighted_draw(list) -- roll an option from a list in a weighted table formatted { Weight = num, Volume = num, Inventory = num, Option = { table } }
	local range = 0
	local totalInventory = 0

	for n in ipairs(list) do
		totalInventory = totalInventory + list[n]["Inventory"]
	end 

	-- build total range of options for random roll
	for n in ipairs(list) do
		if totalInventory == 0 then list[n]["Inventory"] = list[n]["Volume"] end
		if list[n]["Inventory"] > 0 then range = range + list[n]["Weight"] end
	end 

	-- roll within total range
	local roll = math.random(1, range)

	-- find result in options
	local choice = {}
	for n in ipairs(list) do
		if list[n]["Inventory"] > 0 then
			choice = list[n]["Option"]
			if roll <= list[n]["Weight"] then 
				list[n]["Inventory"] = list[n]["Inventory"] - 1
				break	
			end
			roll = roll - list[n]["Weight"]
		end
	end

	return list, choice
end

function M.table_weighted(list) -- roll an option from a list in a weighted table formatted { Weight = num, Option = { table } }
	local range = 0
	
	-- build total range of options for random roll
	for n in ipairs(list) do
		range = range + list[n]["Weight"]
	end 

	-- roll within total range
	local roll = math.random(1, range)

	-- find result in options
	local choice = {}
	for n in ipairs(list) do
		choice = list[n]["Option"]
		if roll <= list[n]["Weight"] then break end
		roll = roll - list[n]["Weight"]
	end

	return choice
end

function M.dice_exploding(list) -- roll an option from a list in a weighted table formatted { Die = num, Explode = num, Option = { table } }
	local roll = 0
	local range = 100
	local choice = {}

	-- roll in each option, if the roll in Range equals or exceeds Above escalate to the next option
	for num in ipairs(list) do
		roll = math.random(1, list[num].Die)
		choice = list[num].Option
		if roll < list[num].Explode then
			break
		end
	end

	return choice
end

return M
