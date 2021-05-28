return {
	WeaponModes = {"Auto"},
	Damage = -2,
	FireRate = 8,
	ClipSize = 200,
	ReloadDelay = 1,
	Range = 25,
	AccurateRange = 60,
	IsBarAmmo = true,
	PreventManualReload=true,
	ClipReloadPerSecond=15,	
	InvertTeamKill=true,
	--AllowTeamKill = true,
	NoBarrelEffect = true,
	NoBulletEffect = true,
	NoFlybyEffects = true,
	BeamVisual = true,
	SnapTo = "Enemy", --"Team",
	SnapMinDist = 0,
	SnapMaxDist = 15,
	SnapToRoot = true,
	PreventFireWithoutSnap = true,
	
	Description		=	"",	
	
	LongReloadSound =	true,
	Barrels 		= 	function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}