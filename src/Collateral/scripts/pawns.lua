Schippi_MortarMech = {
	Name = "Mortar Mech",
	Class = "Ranged",
	Health = 4,
	Image = "TroupeBomber",
	ImageOffset = 1,
	MoveSpeed = 3,
	SkillList = { "Schippi_Bomber_Artillery" },
	SoundLocation = "/mech/distance/artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	didShoot = false
}

AddPawn("Schippi_MortarMech") -- necessary AFTER each declaration
-- // --

Schippi_EnhancingMech = {
	Name = "Enhancing Mech",
	Class = "Prime",
	Health = 3,
	Image = "TroupeShooter",
	ImageOffset = 1,
	MoveSpeed = 3,
	SkillList = { "Schippi_Powering_Shot" },
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

AddPawn("Schippi_EnhancingMech") -- necessary AFTER each declaration

-- // --

Schippi_NanobotMech = {
	Name = "Nanobot Mech",
	Class = "Science",
	Health = 2,
	Image = "TroupeHealer",
	ImageOffset = 1,
	MoveSpeed = 4,
	SkillList = { "Schippi_Nanobot_Heal"},
	SoundLocation = "/mech/brute/tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}

AddPawn("Schippi_NanobotMech") -- necessary AFTER each declaration

-- // --
