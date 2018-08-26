
local function circlePoints(origin, radius)
	local ret = PointList();
	local p1 = origin;
	if radius == 0 then
		ret:push_back(origin)
	else
		for dir = DIR_START, DIR_END do
			if radius == 1 then
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 0);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 1);		
			elseif radius == 2 then
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 0);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 1);		
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 1);				
			elseif radius == 3 then
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 0);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 1);		
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 1);	
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-1) + (DIR_VECTORS[(dir+1) % 4]) * (radius-1))
			elseif radius == 4 then
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 0);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 1);		
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 1);	
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-1) + (DIR_VECTORS[(dir+1) % 4]) * (radius-1))
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 2);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 2);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-1) + (DIR_VECTORS[(dir+1) % 4]) * (radius-2))
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-2) + (DIR_VECTORS[(dir+1) % 4]) * (radius-1))
			elseif radius == 5 then
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 0);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 1);		
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 1);	
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir+1) % 4]) * 2);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * radius + (DIR_VECTORS[(dir-1) % 4]) * 2);
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-1) + (DIR_VECTORS[(dir+1) % 4]) * (radius-2))
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-2) + (DIR_VECTORS[(dir+1) % 4]) * (radius-1))
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-2) + (DIR_VECTORS[(dir+1) % 4]) * (radius-1))
				ret:push_back(p1 + (DIR_VECTORS[dir]) * (radius-1) + (DIR_VECTORS[(dir+1) % 4]) * (radius-2))
			end
		end
	end
	return ret
end

local function allBounces(ret,origin,radi,bounce)
	local tbl = circlePoints(origin,radi);
	for j, p in pairs(extract_table(tbl)) do 
		ret:AddBounce(p,bounce);
	end
end;

local function explosion(ret,origin,maxrad, delay, maxintensity)
	local factor = 2;
	for i=0,maxrad do 
		if(maxintensity < 0) then
			maxintensity = maxintensity+(i/maxrad*factor)
		else
			maxintensity = maxintensity-(i/maxrad*factor)
		end;
		LOG(maxintensity)
		if(math.abs(maxintensity) < 1) then
			return
		end
		allBounces(ret,origin,i,maxintensity);
		if i ~= maxrad then
			ret:AddDelay(delay)
		end
	end
end


Schippi_Powering_Shot_Tip = Skill:new{
	Damage = 0,
	FirstTurnBoost = 0,
	DefaultDamage = 0,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy1 = Point(2,2),
		Enemy2 = Point(1,2),
		Enemy3 = Point(3,2),
		Enemy4 = Point(2,1),
	}
}

Schippi_Powering_Shot = Skill:new{
	Class = "Prime",
	Icon = "weapons/powering_weapon.png",
	Explosion = "",
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	Range = 8,
	PathSize = 8,
	BuildingDamage = true,
	DmgTable = {},
	Damage = 0,
	DefaultDamage = 0,
	FirstTurnBoost = 0,
	Push = 1,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1, 2},
	--UpgradeList = { "+1 Damage on first use, +1 Damage" },
	CustomTipImage = "Schippi_Powering_Shot_Tip_A",
	UseFunction = Schippi_Powering_Shot_Tip.GetSkillEffect;
}


Schippi_Powering_Shot_Tip_A = Schippi_Powering_Shot_Tip:new{ FirstTurnBoost = 1 }
Schippi_Powering_Shot_Tip_B = Schippi_Powering_Shot_Tip:new{ DefaultDamage = 1 }
Schippi_Powering_Shot_Tip_AB = Schippi_Powering_Shot_Tip:new{ FirstTurnBoost = 1, DefaultDamage = 1 }


function Schippi_Powering_Shot_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local boost = 0;
	if(self.Damage <= self.DefaultDamage) then
		boost = self.FirstTurnBoost;
	end;
	local damage= SpaceDamage(p2, self.Damage+boost)
	damage.sAnimation = "explopush2_"..direction
	damage.iPush = direction;
	ret:AddProjectile(damage, "effects/shot_phaseshot", NO_DELAY);
	if(self.Damage+boost > 2) then
		damage = SpaceDamage(p1,0 );
		damage.iPush = (direction+2) % 4;
		damage.sAnimation = "airpush_"..direction
		ret:AddDamage(damage);	
	end;
	return ret
end

function Schippi_Powering_Shot:adjustDmg()
	local pawnid = 'SkillDmg';
	if not GAME.Schippi_Powering_Shot_Pawns then
		GAME.Schippi_Powering_Shot_Pawns = {};
	end;
	if not GAME.Schippi_Powering_Shot_Pawns[pawnid] then
		GAME.Schippi_Powering_Shot_Pawns[pawnid] = self.DefaultDamage;
	end;
	self.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid]; 
	Schippi_Powering_Shot_Tip.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
	Schippi_Powering_Shot_Tip.DefaultDamage = self.DefaultDamage;
	Schippi_Powering_Shot_Tip_A.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
	Schippi_Powering_Shot_Tip_A.DefaultDamage = self.DefaultDamage;
	Schippi_Powering_Shot_Tip_B.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
	Schippi_Powering_Shot_Tip_B.DefaultDamage = self.DefaultDamage;
	Schippi_Powering_Shot_Tip_AB.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
	Schippi_Powering_Shot_Tip_AB.DefaultDamage = self.DefaultDamage;
end;

function Schippi_Powering_Shot:GetSkillEffect(p1, p2)
	self:adjustDmg();
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local boost = 0;
	if(self.Damage == self.DefaultDamage) then
		boost = self.FirstTurnBoost;
	end;
	local damage= SpaceDamage(p2, self.Damage+boost)
	damage.sAnimation = "explopush2_"..direction
	damage.iPush = direction;
	ret:AddProjectile(damage, "effects/shot_phaseshot", NO_DELAY);
	if(self.Damage+boost > 2) then
		damage = SpaceDamage(p1,0 );
		damage.iPush = (direction+2) % 4;
		damage.sAnimation = "airpush_"..direction
		ret:AddDamage(damage);	
	end;
	ret:AddScript(
		"local pawnid = "..[['SkillDmg']]..";\n"..
		[[
		GAME.Schippi_Powering_Shot_Pawns[pawnid] = GAME.Schippi_Powering_Shot_Pawns[pawnid] +1;
		Schippi_Powering_Shot.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
		Schippi_Powering_Shot_Tip.Damage = GAME.Schippi_Powering_Shot_Pawns[pawnid];
	]]);

	return ret
end

Schippi_Powering_Shot_A = Schippi_Powering_Shot:new{
	FirstTurnBoost = 1,
	CustomTipImage = "Schippi_Powering_Shot_Tip_A",
	UseFunction = Schippi_Powering_Shot_Tip_A.GetSkillEffect;
}

Schippi_Powering_Shot_B = Schippi_Powering_Shot:new{
	DefaultDamage = 1,
	CustomTipImage = "Schippi_Powering_Shot_Tip_B",
	UseFunction = Schippi_Powering_Shot_Tip_B.GetSkillEffect;
}

Schippi_Powering_Shot_AB = Schippi_Powering_Shot:new{
	FirstTurnBoost = 1,
	DefaultDamage = 1,
	CustomTipImage = "Schippi_Powering_Shot_Tip_AB",
	UseFunction = Schippi_Powering_Shot_Tip_AB.GetSkillEffect;
}

Schippi_Nanobot_Heal = Skill:new{
	Class = "Science",
	Icon = "weapons/nanorep.png",
	LaunchSound = "/weapons/enhanced_tractor",
	ImpactSound = "/impact/generic/tractor_beam",
	Damage = 0,
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,2}, --close; range
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,3),
		Target = Point(2,1),
		Enemy2 = Point(2,2),
		Friendly = Point(2,1)
	},
	Range = 2,
	Heal1 = -1,
	Heal2 = -1,
	Push = 1;
}

Schippi_Nanobot_Heal_A = Schippi_Nanobot_Heal:new{
	Heal1 = -2;
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,3),
		Target = Point(2,2),
		Enemy2 = Point(2,1),
		Friendly = Point(2,2)
	};
}

Schippi_Nanobot_Heal_B = Schippi_Nanobot_Heal:new{
	Range = 3;
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,3),
		Target = Point(2,0),
		Enemy2 = Point(2,2),
		Friendly = Point(2,1),
		Friendly2 = Point(2,0)
	},
}

Schippi_Nanobot_Heal_AB = Schippi_Nanobot_Heal:new{
	Range = 3,
	Heal1 = -2,
}


function Schippi_Nanobot_Heal:GetTargetArea(p1)
    local ret = PointList()
	for i = 1,self.Range do
		for dir = DIR_START, DIR_END do
			ret:push_back(p1 + (DIR_VECTORS[dir]) * i);
		end			
	end
    return ret
end


function Schippi_Nanobot_Heal:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local ps = extract_table(Board:GetPath(p1, p2, PATH_FLYER));
	local damage = nil;
	if(#ps == 2) then
		damage = SpaceDamage(ps[2], self.Heal1);
		damage.sAnimation = "Splash_acid";
		damage.iFire = EFFECT_REMOVE;
		if(Board:IsBuilding(ps[2])) then
			damage.iShield = 1;
		end;
		ret:AddDamage(damage);
		ret:AddBounce(damage.loc, 2)
	else
		for i = 2, #ps do
			damage = SpaceDamage(ps[i], self.Heal2);
			damage.sAnimation = "Splash_acid";
			damage.iFire = EFFECT_REMOVE;
			if(Board:IsBuilding(ps[i])) then
				damage.iShield = 1;
			end;
			ret:AddDamage(damage);
			ret:AddBounce(damage.loc, 1)
		end
	end
	if(self.Push == 1) then
		local damagepush = SpaceDamage(p1 + DIR_VECTORS[(direction+1)%4], 0)
		damagepush.sAnimation = "airpush_"..((direction+1)%4)
		damagepush.iPush = (direction+1) %4;
		ret:AddDamage(damagepush) 
		damagepush = SpaceDamage(p1 + DIR_VECTORS[(direction-1)%4], 0)
		damagepush.sAnimation = "airpush_"..((direction-1)%4)
		damagepush.iPush = (direction-1) %4;
		ret:AddDamage(damagepush)
		if(self.Range > 2) then
			damagepush = SpaceDamage(p1 + DIR_VECTORS[(direction+2)%4], 0)
			damagepush.sAnimation = "airpush_"..((direction+2)%4)
			damagepush.iPush = (direction+2) %4;
			ret:AddDamage(damagepush)
		end;
	end;
	
	return ret
end

Schippi_Bomber_Artillery = Skill:new{
	Class = "Ranged",
	Icon = "weapons/brute_bombrun.png",
	LaunchSound = "/weapons/heavy_rocket",
	ImpactSound = "/impact/generic/explosion",
	Damage = 1,
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {2,2},
	TipImage = {
		Unit = Point(1,3),
		Target = Point(3,1),
		Enemy1 = Point(1,2),
		Enemy2 = Point(1,1),
		Enemy3 = Point(3,1),
		Building = Point(2,2)
	},
	SelfDamage = 1,
	DamageFirstBonus =0;
	TargetUpgrade = 0;
	TipPush = 1;
}

Schippi_Bomber_Artillery_A = Schippi_Bomber_Artillery:new{
	DamageFirstBonus = 1;
}

Schippi_Bomber_Artillery_B = Schippi_Bomber_Artillery:new{
	TargetUpgrade = 1,
	TipImage = {
		Unit = Point(0,1),
		Target = Point(3,3),
		Enemy1 = Point(3,3),
		Enemy2 = Point(1,1),
		Enemy3 = Point(3,1),
		Building = Point(2,2)
	};
}

Schippi_Bomber_Artillery_AB = Schippi_Bomber_Artillery:new{
	DamageFirstBonus = 1,
	TargetUpgrade = 1,
	TipImage = {
		Unit = Point(0,1),
		Target = Point(3,3),
		Enemy1 = Point(3,3),
		Enemy2 = Point(1,1),
		Enemy3 = Point(3,1),
		Building = Point(2,2)
	};
}


function Schippi_Bomber_Artillery:GetTargetArea(p1)
    local ret = PointList()
	ret = circlePoints(p1,3);
	if self.TargetUpgrade == 1 then
		for j, p in pairs(extract_table(circlePoints(p1,4))) do 
			ret:push_back(p);
		end
	end
	return ret;
	
end

function Schippi_Bomber_Artillery:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local bnc = 2;
	local dly = 0.2;
	local x = -1;
	if p1.x < p2.x then
		x = 1;
	end
	local y = -1;
	if p1.y < p2.y then
		y = 1;
	end

	local pointsX = PointList();
	local pointsY = PointList();
	local tipPushY = Point(p1.x,p2.y);
	local tipPushX = Point(p2.x,p1.y);
	
	local p3 = Point(p1.x+x,p1.y);
	if(p2.x ~= p1.x) then
		while p3.x ~= p2.x do
			pointsX:push_back(p3);
			p3 = Point(p3.x+x,p3.y);
		end
		while p3.y ~= p2.y do
			pointsX:push_back(p3);
			p3 = Point(p3.x,p3.y+y);
		end
	end
	if(p2.y ~= p1.y) then
		p3 = Point(p1.x,p1.y+y);
		while p3.y ~= p2.y do
			pointsY:push_back(p3);
			p3 = Point(p3.x,p3.y+y);
		end
		while p3.x ~= p2.x do
			pointsY:push_back(p3);
			p3 = Point(p3.x+x,p3.y);
		end
	end
	local xs = extract_table(pointsX);
	local ys = extract_table(pointsY);
	local damage;
	
	if self.SelfDamage > 0 then
		damage = SpaceDamage(p1, self.SelfDamage);
		damage.sSound = self.ImpactSound;
		damage.sAnimation = "ExploArt2";
		ret:AddDamage(damage);
		ret:AddBounce(damage.loc,bnc);
		ret:AddDelay(dly);
	end
		
	for i = 1, math.max(#xs,#ys) do
		if i == 1 then
			damage = SpaceDamage(p1, self.Damage+self.DamageFirstBonus);
		else
			damage = SpaceDamage(p1, self.Damage);
		end
		damage.sSound = self.ImpactSound;
		damage.sAnimation = "ExploArt2";
		if i <= #xs then
			damage.loc = xs[i];
			if self.TipPush and xs[i] == tipPushX then
				--LOG("XX tip:"..xs[i].x.."/"..xs[i].y.." =? "..tipPushY.x.."/"..tipPushY.y);
				damage.iPush = GetDirection(tipPushX-p1);
			end
			ret:AddDamage(damage);
			ret:AddBounce(damage.loc,bnc);
		end
		damage.iPush = GetDirection(p1-p1);
		if i <= #ys then
			damage.loc = ys[i];
			if self.TipPush and ys[i] == tipPushY then
				--LOG("YY tip:"..ys[i].x.."/"..ys[i].y.." =? "..tipPushY.x.."/"..tipPushY.y);
				damage.iPush = GetDirection(tipPushY-p1);
			end
			ret:AddDamage(damage);
			ret:AddBounce(damage.loc,bnc);
		end
		
		ret:AddDelay(dly);
	end
	damage = SpaceDamage(p2, self.Damage);
	damage.sSound = self.ImpactSound;
	damage.sAnimation = "ExploArt2";
	ret:AddDamage(damage);
	ret:AddBounce(damage.loc,bnc);
	
	return ret;
end























