--[[
Server Name: ▌ Icefuse.net ▌ DarkRP 100k Start ▌ Bitminers-Slots-Unbox ▌
Server IP:   208.103.169.42:27015
File Path:   addons/[server]_skillsystem/lua/skill/init_sh.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

skill.Skills = skill.Skills or {}

function skill.Add(name, inf)
	inf.Name = name
	inf.Max = inf.Max or 10
	inf.ID = name:lower():gsub(' ', '_')
	skill.Skills[inf.ID] = inf
	
	if inf.Hooks then
		for k, v in pairs(inf.Hooks) do
			hook.Add(k, 'skill.' .. k .. name, function(pl, ...)
				if (not pl.Skills) or (not pl.Skills[inf.ID]) then return end
				
				if inf.CallDelay then -- We need to run last, we could do this way more hacky, but we wont
					local dat = {...}
					timer.Simple(0, function()
						if IsValid(pl) then
							//if (not pl.Skills) then
							//	ErrorNoHalt 'Calling skill hook before skills are loaded'
							//	return
							//end
							return v(pl.Skills[inf.ID], pl, unpack(dat))
						end
					end)
				else
					return v(pl.Skills[inf.ID], pl, ...)
				end
			end)
		end
	end
end