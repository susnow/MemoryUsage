﻿--susnow

local addon,ns = ...
local AL = ns.AL -- addonlist
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

local function sortMemName(a,b)
	return a.mem > b.mem
end

local cpus = {}

_G["MemoryUseageMainFrame"]:SetScript("OnShow",function(self)
	for k, v in pairs(AL) do
		if IsAddOnLoaded(k) then
			local mem = GetAddOnMemoryUsage(k)
			table.insert(cpus,{name = k, mem = math.ceil(mem)})
		end
	end
	table.sort(cpus,sortMemName)
	for k, v in pairs(cpus) do
		local width  = 1
		if v.mem < 2048 then
			width = v.mem/2048	
		else
			width = 1
		end
		if k <= 20 then
			self.addonmems[k]:Show()
			self.addonmems[k].index:SetText(k)
			cpuAnimate(GetTime(),500*width,v.mem,AL[v.name][GetLocale()],v.mem,self.addonmems[k])
		else
			return
		end
	end
end)


_G["MemoryUseageMainFrame"]:SetScript("OnHide",function(self)
	table.wipe(cpus)
	for i = 1, #self.addonmems do
		local button = self.addonmems[i]
		button:Hide()
		button.bg:SetSize(0,16)
		button.index:SetText("")
	end
end)