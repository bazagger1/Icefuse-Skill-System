--[[
Server Name: ▌ Icefuse.net ▌ DarkRP 100k Start ▌ Bitminers-Slots-Unbox ▌
Server IP:   208.103.169.42:27015
File Path:   addons/[server]_skillsystem/lua/skill_cfg.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- Warning, if you change the name of the skill after people buy it they won't be able to use it!

skill.ResetPrice = 15000

skill.BuyLevelURL = "https://icefuse.net/store/"

skill.ButtonSounds = {
	"buttons/lightswitch2.wav"
}
---------------------------------------------------------------------------
skill.Add('Health', {
	Desc = 'Increases your spawn health by 5 each stack', 
	Max = 20,
	CallDelay = true,
	Hooks = {
		PlayerSpawn = function(stacks, pl)
			pl:SetHealth((stacks * 5) + pl:Health())
		end
	},
})
---------------------------------------------------------------------------
skill.Add('Armor', {
	Desc = 'Increases your spawn armor by 10 each stack',
	Max = 25,
	CallDelay = true,
	Hooks = {
		PlayerSpawn = function(stacks, pl)
			pl:SetArmor((stacks * 10) + pl:Armor())
		end
	},
})
---------------------------------------------------------------------------
skill.Add('Run Speed', {
	Desc = 'Increases your run speed by 5 each stack',
	CallDelay = true,
	Hooks = {
		PlayerSpawn = function(stacks, pl)
			pl.skill_StarRun = pl.skill_StarRun or pl:GetRunSpeed() -- Cache the start value for things that are persistent after death
			pl:SetRunSpeed((stacks * 5) + pl.skill_StarRun)
		end
	},
})
---------------------------------------------------------------------------
skill.Add('Jump Height', {
	Desc = 'Increases your jump height by 5 each stack',
	Max = 20,
	CallDelay = true,
	Hooks = {
		PlayerSpawn = function(stacks, pl)
			pl.skill_StarJump = pl.skill_StarJump or pl:GetJumpPower()
			pl:SetJumpPower((stacks * 5) + pl.skill_StarJump)
		end
	},
})
---------------------------------------------------------------------------
skill.Add('Endurance', {
	Desc = 'Reduces damage taken by 1% each stack',
	Max = 10,
	Hooks = {
		EntityTakeDamage = function(stacks, ent, dmg)
			if ent:IsPlayer() and (not (IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsWorld())) then
				dmg:ScaleDamage(1 - (stacks * 0.01))
			end
		end
	},
})
---------------------------------------------------------------------------
skill.Add('Fall Damage', {
    Desc = 'Reduces fall damage taken by 5% each stack',
    Max = 20,    
    Hooks = {
        EntityTakeDamage = function(stacks, ent, dmg)
            if ent:IsPlayer() and dmg:GetAttacker() and dmg:GetAttacker():IsWorld() then
                dmg:ScaleDamage(1 - (stacks * 0.05))
            end
        end
    },
})
---------------------------------------------------------------------------
skill.Add('Salary', {
	Desc = 'Increases your salary by 5 each stack',
	Max = 5,
	Hooks = {
		playerGetSalary = function(stacks, pl, amount)
			local amount = amount + (stacks * 5)
			return false, 'Payday! You\'ve earned ¢' .. amount .. '!', amount
		end
	},
})
---------------------------------------------------------------------------
skill.Add('XP', {
	Desc = 'Increases your XP gain by 3% each stack',
	Max = 15,
	Hooks = {
		PlayerAddXP = function(stacks, pl, amount)
			return amount + (amount * (stacks * 0.03))
		end
	},
})
---------------------------------------------------------------------------