--[[
Server Name: ▌ Icefuse.net ▌ DarkRP 100k Start ▌ Bitminers-Slots-Unbox ▌
Server IP:   208.103.169.42:27015
File Path:   addons/[server]_skillsystem/lua/skill/init_cl.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local blur = Material 'pp/blurscreen'
local function blurpanel(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end

surface.CreateFont('SkillFont20', {font = 'roboto', size = 20, weight = 400})
surface.CreateFont('SkillFont26', {font = 'roboto', size = 26, weight = 400})

local color_white = Color(255,255,255)
local color_bg = Color(0,0,0,120)

local fr
net.Receive('skill.OpenMenu', function()
	local skills = {}
	local skillcount = net.ReadUInt(8)
	local points = (LocalPlayer():getDarkRPVar('level') or 0) - skillcount
	for i = 1, net.ReadUInt(8) do
		skills[net.ReadString()] = net.ReadUInt(8)
	end
	
	if IsValid(fr) then 
		fr:Remove()
	end

	fr = vgui.Create('DFrame')
	fr:SetTitle('Skills - ' .. points .. ' Points')
	fr:SetSize(ScrW() * .4, ScrH() * .4)
	fr:Center()
	fr:MakePopup()
	fr:RequestFocus()
	fr.Paint = function(self, w, h)
		blurpanel(self)
		Derma_DrawBackgroundBlur(fr)
		surface.SetDrawColor(color_bg)
		surface.DrawRect(0, 0, w, 25)
		surface.DrawRect(0, 0, w, h)
	end
	fr.lblTitle:SetFont('SkillFont20')
	fr.btnMaxim:Remove()
	fr.btnMinim:Remove()
	function fr:PerformLayout()
		self.btnClose:SetPos(self:GetWide() - 31 - 4, 0)
		self.btnClose:SetSize(31, 31)

		self.lblTitle:SetPos(8, 2)
		self.lblTitle:SetSize(self:GetWide() - 25, 20)
	end
	
		
	local scroll = vgui.Create('DPanelList', fr)
	scroll:SetPos(5, 30)
	scroll:EnableVerticalScrollbar()
	scroll:SetSpacing(2)
	scroll:SetSize(fr:GetWide() - 10, fr:GetTall() - 65)

	for k, v in pairs(skill.Skills) do
		local pnl = vgui.Create('DPanel')
		pnl:SetSize(fr:GetWide() - 15, 55)
		pnl.Paint = function(self, w, h)
			surface.SetDrawColor(color_bg)
			surface.DrawRect(0, 0, w, h)

			draw.SimpleText(v.Name, 'SkillFont26', 5, 5, color_white)
			draw.SimpleText((skills[v.ID] or 0) .. '/' .. v.Max, 'SkillFont26', w - 90, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.Desc, 'SkillFont20', 5, 30, color_white)
		end

		local btn = vgui.Create('DButton', pnl)
		btn:SetSize(75, 45)
		btn:SetPos(pnl:GetWide() - 80, 5)
		btn:SetText('Upgrade')
		btn:SetFont('SkillFont20')
		btn:SetTextColor(color_white)
		btn.Paint = function(self, w, h)
			surface.SetDrawColor(color_bg)
			surface.DrawRect(0, 0, w, h)
		end
		btn.DoClick = function()
			surface.PlaySound(skill.ButtonSounds[math.random(#skill.ButtonSounds)])

			RunConsoleCommand('skill_buy', v.ID)
			if (skills[v.ID] and (skills[v.ID] >= v.Max)) or (points <= 0) then return end
			skills[v.ID] = (skills[v.ID] or 0) + 1

			skillcount = skillcount + 1
			points =  (LocalPlayer():getDarkRPVar('level') or 0) - skillcount
			fr:SetTitle('Skills - ' .. points .. ' Points')
		end

		scroll:AddItem(pnl)
	end

	local btnreset = vgui.Create('DButton', fr)
	btnreset:SetSize(fr:GetWide()/2 - 7.5, 25)
	btnreset:SetPos(5, fr:GetTall() - 30)
	btnreset:SetText('Reset All ($' .. skill.ResetPrice .. ')')
	btnreset:SetFont('SkillFont20')
	btnreset:SetTextColor(color_white)
	btnreset.Paint = function(self, w, h)
		surface.SetDrawColor(color_bg)
		surface.DrawRect(0, 0, w, h)
	end
	btnreset.DoClick = function()
		surface.PlaySound(skill.ButtonSounds[math.random(#skill.ButtonSounds)])
		Derma_Query("Are you sure?", "Reset", "Yes", function()
			RunConsoleCommand('skill_reset')
		end, "No", function() end)	
	end

	local btnbuy = vgui.Create('DButton', fr)
	btnbuy:SetSize(fr:GetWide()/2 - 7.5, 25)
	btnbuy:SetPos(fr:GetWide()/2 + 2.5, fr:GetTall() - 30)
	btnbuy:SetText('Upgrade Level')
	btnbuy:SetFont('SkillFont20')
	btnbuy:SetTextColor(color_white)
	btnbuy.Paint = function(self, w, h)
		surface.SetDrawColor(color_bg)
		surface.DrawRect(0, 0, w, h)
	end
	btnbuy.DoClick = function()
		gui.OpenURL(skill.BuyLevelURL)
	end
end)