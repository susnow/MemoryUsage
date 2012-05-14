--susnow

local addon,ns = ...
local GUI = ns.GUI

GUI:New()

local cpuAnimate = function(time,widthArg,cpuArg,name,kb,obj)
	local oldTime = time or GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.001 then
			local newTime = GetTime()
			if newTime - oldTime < 0.5 then
				local tempColor = (widthArg/0.5)/500 * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				local tempWidth = (widthArg/0.5) * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				local tempCpu = (cpuArg/0.5) * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				self.bg:SetSize(tempWidth,14)
				self.bg:SetVertexColor(GUI:ColorGradient(tempColor,0,1,0, 1,1,0, 1,0,0))
				self.addonName:SetText(format("%s : %s",name,tempCpu <= 2048 and math.ceil(tempCpu).."kb" or "大于2M"))
			else
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end

local hideAnimate = function(obj)
	local oldTime = GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.0001 then
			local newTime = GetTime()
			if newTime - oldTime < 0.2 then
				local tempScale = (1/0.2) * (tonumber(string.format("%6.2f",(newTime - oldTime)))) + 1
				local tempAlpha = 1 - (1/0.2) * tonumber(string.format("%6.2f",(newTime - oldTime)))
				obj:SetScale(tempScale)
				obj:SetAlpha(tempAlpha)
			else
				obj:SetScale(2)
				obj:SetAlpha(0)
				obj:SetPoint("CENTER",UIParent,150,0)
				obj:Hide()
				obj:SetScript("OnUpdate",nil)
			end
		end
		self.nextUpdate = 0
	end)
end

local showAnimate = function(obj)
	local oldTime = GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.0001 then
			local newTime = GetTime()
			if newTime - oldTime < 0.2 then
				local tempOffset = (150/0.2) * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				local tempAlpha = 1/0.2 * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				self:SetPoint("CENTER",UIParent,150-tempOffset,0)
				self:SetAlpha(tempAlpha)
			else
				self:SetPoint("CENTER",UIParent)
				self:SetAlpha(1)
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end


local function sortMemName(a,b)
	return a.mem > b.mem
end

local addons = {}

_G["MemoryUseageMainFrame"]:SetScript("OnShow",function(self)
	self:SetScale(1)
	showAnimate(self)
	for i = 1, GetNumAddOns() do
		local name,title,enabled,loadable,reason,security = GetAddOnInfo(i)
		if enabled and not GetAddOnMetadata(name,"RequiredDeps") then
			local mem = GetAddOnMemoryUsage(name)
			table.insert(addons,{name = name, mem = math.ceil(mem)})	
		end
	end
	table.sort(addons,sortMemName)
	for k, v in pairs(addons) do
		local width  = 1
		if v.mem < 2048 then
			width = v.mem/2048	
		else
			width = 1
		end
		if k <= 20 then
			self.addonmems[k]:Show()
			self.addonmems[k].index:SetText(k)
			local title = GetAddOnMetadata(v.name,"Title-"..GetLocale())
			if title == nil then
				title = v.name
			end
			cpuAnimate(GetTime(),500*width,v.mem,title,v.mem,self.addonmems[k])
		else
			return
		end
	end
end)

_G["MemoryUseageMainFrame"]:EnableKeyboard(true)

_G["MemoryUseageMainFrame"]:SetScript("OnKeyDown",function(self,key)
	if key == "ESCAPE" then
		hideAnimate(self)
	elseif key == "ENTER" then
		ChatFrame1EditBox:Show()
		ChatFrame1EditBox:SetFocus()
	elseif key == "PRINTSCREEN" then
		Screenshot()
	end
end)

_G["MemoryUseageMainFrame"]:SetScript("OnHide",function(self)
	table.wipe(addons)
	for i = 1, #self.addonmems do
		local button = self.addonmems[i]
		button:Hide()
		button.bg:SetSize(0,16)
		button.index:SetText("")
	end
end)
