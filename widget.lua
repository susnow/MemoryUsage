--Susnow

local addon,ns = ...
local texFile = "Interface\\Buttons\\WHITE8X8"
local bgTex = {bgFile = texFile,edgeFile = texFile, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}}
local tex = "Interface\\AddOns\\MemoryUseage\\media\\"

local GUI = CreateFrame("Frame")

function GUI:New()
	local f = CreateFrame("Frame","MemoryUseageMainFrame",UIParent)
	f:SetSize(600,550)
	f:SetBackdrop(bgTex)
	f:SetBackdropColor(.1,.1,.1,.5)
	f:SetBackdropBorderColor(0,0,0,1)
	f:SetPoint("CENTER",UIParent)
	
	f.title = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = f.title:GetFont()
		f.title:SetFont(font,18,"OUTLINE")
	end
	f.title:SetPoint("TOPLEFT",f,20,-20)
	f.title:SetText("Memory usage")

	f.addonmems = {}
	for i = 1, 20 do
		local button = CreateFrame("Button",nil,f)
		button.nextUpdate = 0
		button:SetSize(500,14)
		button.bg = button:CreateTexture(nil,"OVERLAY")
		button.bg:SetTexture(texFile)
		button.bg:SetSize(button:GetWidth(),button:GetHeight())
		button.bg:SetPoint("TOPLEFT",button)
		button.addonName = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
		do 
			local font,size,flag = button.addonName:GetFont()
			button.addonName:SetFont(font,size,"OUTLINE")
		end
		button.addonName:SetText("")
		button.addonName:SetPoint("LEFT",button.bg,"RIGHT",5,0)
		button.index = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
		do 
			local font,size,flag = button.index:GetFont()
			button.index:SetFont(font,size,"OUTLINE")
		end
		button.index:SetSize(button:GetHeight()*1.8,button:GetHeight())
		button.index:SetPoint("TOPRIGHT",button,"TOPLEFT",-5,0)
		button.index:SetText("")
		button.bottomBD = button:CreateTexture(nil,"OVERLAY")
		button.rightBD = button:CreateTexture(nil,"OVERLAY")
		button.bottomBD:SetTexture(bgTex)
		button.rightBD:SetTexture(bgTex)
		button.bottomBD:SetHeight(2)
		button.bottomBD:SetVertexColor(0,0,0,1)
		button.bottomBD:SetPoint("TOPLEFT",button.bg,"BOTTOMLEFT",1,0)
		button.bottomBD:SetPoint("TOPRIGHT",button.bg,"BOTTOMRIGHT",1,0)
		button.rightBD:SetVertexColor(0,0,0,1)
		button.rightBD:SetWidth(2)
		button.rightBD:SetPoint("TOPLEFT",button.bg,"TOPRIGHT",0,-1)
		button.rightBD:SetPoint("BOTTOMLEFT",button.bg,"BOTTOMRIGHT",0,-1)
		if i == 1 then
			button:SetPoint("TOPLEFT",f,50,-60)
		elseif i > 1 then
			button:SetPoint("TOPLEFT",f.addonmems[i-1],"BOTTOMLEFT",0,-8)
		end
		f.addonmems[i] = button
		button:Hide()
	end
	f.tip = CreateFrame("Frame",nil,f)
	f.tip:SetSize(250,2)
	f.tip:SetPoint("BOTTOMRIGHT",f,-20,20)
	f.tip.t1 = f:CreateFontString(nil,"OVERLAY")
	f.tip.t2 = f:CreateFontString(nil,"OVERLAY")
	f.tip.t3 = f:CreateFontString(nil,"OVERLAY")
	f.tip.t1:SetFont(tex.."tip.ttf",10,"OUTLINE")
	f.tip.t2:SetFont(tex.."tip.ttf",10,"OUTLINE")
	f.tip.t3:SetFont(tex.."tip.ttf",10,"OUTLINE")
	f.tip.t1:SetText("Low")
	f.tip.t2:SetText("Medium")
	f.tip.t3:SetText("High")
	f.tip.t1:SetPoint("BOTTOMLEFT",f.tip,"TOPLEFT",0,0)
	f.tip.t2:SetPoint("BOTTOM",f.tip,"TOP",0,0)
	f.tip.t3:SetPoint("BOTTOMRIGHT",f.tip,"TOPRIGHT",0,0)
	for i = 1, 250 do
		local bg = f.tip:CreateTexture(nil,"OVERLAY")
		bg:SetSize(1,2)
		bg:SetTexture(texFile)
		bg:SetVertexColor(GUI:ColorGradient(i*0.004, 0,1,0, 1,1,0, 1,0,0))
		bg:SetPoint("TOPLEFT",f.tip,(i-1)*1,0)
	end

	f:Hide()
end

function GUI:ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

ns.GUI = GUI 
