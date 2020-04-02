local function init(self)
	RescourcePath = self.resourcePath
	modApi:appendAsset("img/weapons/nanorep.png",self.resourcePath.."img/weapons/nanorep.png");
	modApi:appendAsset("img/weapons/powering_weapon.png",self.resourcePath.."img/weapons/powering_weapon.png");
	modApi:addWeapon_Texts(require(self.scriptPath.."text_weapons"))	
	
	require(self.scriptPath.."squad_sprite_loader")(self, {
    {
        Name = "TroupeBomber",
        Filename = "sch_art",
		Path = "units",
        Default =           { PosX = -19, PosY = 0 },
        Animated =          { PosX = -19, PosY = 0, NumFrames = 4 },
        Submerged =         { PosX = -20, PosY = 10 },
        Broken =            { PosX = -19, PosY = 1 },
        SubmergedBroken =   { PosX = -14, PosY = 12 },
        Icon =              {},
    },
	});
	require(self.scriptPath.."squad_sprite_loader")(self, {
    {
        Name = "TroupeHealer",
        Filename = "sch_heal",
		Path = "units",
        Default =           { PosX = -19, PosY = 0 },
        Animated =          { PosX = -19, PosY = 0, NumFrames = 4 },
        Submerged =         { PosX = -20, PosY = 10 },
        Broken =            { PosX = -17, PosY = -2 },
        SubmergedBroken =   { PosX = -19, PosY = 15 },
        Icon =              {},
    },
	});
	require(self.scriptPath.."squad_sprite_loader")(self, {
    {
        Name = "TroupeShooter",
        Filename = "sch_shoot",
        Default =           { PosX = -14, PosY = -5 },
        Animated =          { PosX = -14, PosY = -5, NumFrames = 5 },
        Submerged =         { PosX = -16, PosY = 5 },
        Broken =            { PosX = -12, PosY = -7 },
        SubmergedBroken =   { PosX = -9, PosY = 5 },
        Icon =              {},
    },
	});
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."pawns")

	
	
	local oldMissionStartDeployment = Mission.StartDeployment;

	function Mission:StartDeployment()
		GAME.Schippi_Powering_Shot_Pawns = {};
		Schippi_Powering_Shot:adjustDmg();
		oldMissionStartDeployment(self);
	end;
end

local oldMissionStartDeployment = Mission.StartDeployment;

function Mission:StartDeployment()
    GAME.Schippi_Powering_Shot_Pawns = {};
	Schippi_Powering_Shot:adjustDmg();
    oldMissionStartDeployment(self);
end;

local function load(self,options,version)
modApi:addSquadTrue({"Collateral","Schippi_MortarMech","Schippi_EnhancingMech","Schippi_NanobotMech"},
	"Collateral","Big Area Damage restricted by targeting",
	self.resourcePath.."/collateral.png");
	
	modApi:addMissionEndHook(function(mission,ret)
		--LOG("dmg cleared02");
		GAME.Schippi_Powering_Shot_Pawns = {};
	end,1)
	modApi:addMissionStartHook(function()
		--LOG("dmg cleared01");
		--GAME.Schippi_Powering_init = true;
		GAME.Schippi_Powering_Shot_Pawns = {};
	end,1)
	modApi:addPostStartGameHook(function()
		--LOG("dmg cleared01");
		--GAME.Schippi_Powering_init = true;
		if not GAME.Schippi_Powering_Shot_Pawns then
			GAME.Schippi_Powering_Shot_Pawns = {};
		end		
	end,1)
	local hook = function(prevMission, nextMission)
		GAME.Schippi_Powering_Shot_Pawns = {};
	end

	modApi:addMissionNextPhaseCreatedHook(hook)
	
	modApi:addNextTurnHook(function(mission)
		--LOG("NEXT TURN")
		--if(GAME.Schippi_Powering_init == true) then
			--LOG("START OF GAME")
			--GAME.Schippi_Powering_init = false;
			--GAME.Schippi_Powering_Shot_Pawns = {};
			--Schippi_Powering_Shot:adjustDmg();
		--end;
	end,1)
end

function dumpc(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. type(v) .. ',\n'
      end
      return s .. '} '
   else
      return type(o);
   end
end

return {
	id = "Schippi_Collateral",
	name = "Collateral",
	version = "1.4",
	requirements = {},
	init = init,
	load = load,
}
