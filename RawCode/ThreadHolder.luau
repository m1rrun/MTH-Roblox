------------------------------------------------------
---Services/Modules-----------------------------------
------------------------------------------------------

local HTTP = game:GetService('HttpService')

local te = require(script:WaitForChild('Type'))

------------------------------------------------------
---Assign---------------------------------------------
------------------------------------------------------

local api: te.api = {}

local Overwrite
local UpdateTime

local addWarn = ", you can disable this warn and overwrite thread by enable Overwrite_Old_Thread attribute"

------------------------------------------------------
---Do-------------------------------------------------
------------------------------------------------------

do
	Overwrite = script:GetAttribute('Overwrite_Old_Thread')
	UpdateTime = math.abs(script:GetAttribute('AutoClear_Update_Time'))
	
	if UpdateTime < 1 then error(`{UpdateTime} is lower than 1, it may cause excessive load`) end
end

------------------------------------------------------
---LoclaFn--------------------------------------------
------------------------------------------------------

local function autoClear(self)
	return task.spawn(function(self: te.handlerPrivate)
		while task.wait(UpdateTime) do
			for i,v in self.rawCache do
				if typeof(v) ~= "thread" then
					warn(`{i} is not a thread`, debug.traceback())
					self.rawCache[i] = nil
					continue
				end
				if coroutine.status(v) == "dead" then
					self.rawCache[i] = nil
				end
			end
		end
	end, self)
end

------------------------------------------------------
---Class----------------------------------------------
------------------------------------------------------

function api.new(id: string?, disableAutoClear: boolean?)
	local self = setmetatable({}, {
		__index = function(self, key)
			if key == "isAutoClear" then
				return not not self.autoClear
			end
			
			if key == "isEmpty" then
				return not next(self.rawCache)
			end
			
			return rawget(self, key)
		end,
	})
	self.id = id or HTTP:GenerateGUID(false)
	
	self._ch_mt = {
		__newindex = function(tbl, key, value)
			local oldKey = self.rawCache[key]
			
			if typeof(oldKey) == "thread" and coroutine.status(oldKey) ~= "dead" then
				coroutine.close(oldKey)
			end

			if not (typeof(value) == "thread" or value == nil) then warn(value, " is not a thread or nil") return end
			self.rawCache[key] = value
		end,
		__index = function(tbl, key)
			return self.rawCache[key]
		end,
	}
	
	self.rawCache = {}
	self.cache = setmetatable({}, self._ch_mt)
	self.autoClear = not disableAutoClear and autoClear(self) or false
	
	function self:AddThread(id: string, thread: thread)
		if not Overwrite and self.rawCache[id] then warn(`{id} already exists in cache{addWarn}`) return end
		self.cache[id] = thread
		return self
	end
	
	function self:GetAutoCache(reMeta: boolean?)
		if reMeta then
			return setmetatable(self.cache, self._ch_mt)
		end
		return self.cache
	end
	
	function self:RemoveThread(id: string)
		self.rawCache[id] = nil
		return self
	end
	
	function self:CancelThread(id: string)
		self.cache[id] = nil
		return self
	end
	
	function self:CancelAllThreads()
		for i,_ in self.rawCache do
			self.cache[i] = nil
		end
		return self
	end
	
	function self:Destroy()
		if self.autoClear then
			if coroutine.status(self.autoClear) ~= "dead" then
				coroutine.close(self.autoClear)
			end
		end
		self:CancelAllThreads()
		setmetatable(self.cache, nil)
		setmetatable(self, nil)
		table.clear(self)
	end
	
	return self
end


return api