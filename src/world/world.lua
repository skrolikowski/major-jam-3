-- Game World
--

local Modern = require 'vendor.modern'
local World  = Modern:extend()

-- New
--
function World:new(game)
	self.game  = game
	self.grid  = Grid(self)
	self.items = {}
end

-- Add to world
--
function World:add(item)
	--
	-- register
	self.items[item.id] = item

	--
	-- add item to cells
	local bounds = item:aabb()
	local cells  = self.grid:queryCellsInBounds(bounds)

	for __, cell in pairs(cells) do
		cell:add(item)
	end

	return item
end

-- Remove from world
--
function World:remove(item)
	if self.items[item.id] then
		local bounds = item:aabb()
		local cells  = self.grid:queryCellsInBounds(bounds)

		-- remove item from cells
		for __, cell in pairs(cells) do
			cell:remove(item)
		end

		-- unregister
		self.items[item.id] = nil
	end
end

-- Tear down
--
function World:destroy()
    for __, item in pairs(self.items) do
    	self:remove(item)
    end
end

-- Clear items
--
function World:clear()
    for __, item in pairs(self.items) do
    	if item.name == 'crate' then
    		self:remove(item)
    	end
    end
end

-- Game tick
--
function World:tick()
	for __, item in pairs(self.items) do
		item:tick()
	end
end

-- Update
--
function World:update(dt)
    for __, item in pairs(self.items) do
		item:update(dt)
	end
end

-- Query items by name
--
function World:queryByName(name)
	local items = {}

	for __, item in pairs(self.items) do
		if item.name == name then
			table.insert(items, item)
		end
	end

	return items
end

-- Query items in cell
--
function World:queryCell(row, col)
	local cell = self.grid:queryCell(row, col)

	if cell then
		return cell.items
	end

	return {}
end

-- Draw
--
function World:draw()
	--
	-- Draw all items
	for __, item in pairs(self.items) do
		item:draw()
	end

	-- Draw the grid
	if Config.debug then
		self.grid:draw()
	end
end

return World