return {
	WeaponModes = {"Semi"},
	Damage = 20,
	FireRate = 2,
	ClipSize = 4,
	ReloadDelay = .6,
	Range = 110,
	AccurateRange = 35,
	
	ShotsPerClick = 4,
	OneAmmoPerClick = true,
	DistanceDamageModifier = 1,
	
	Description		=	"",	
	
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}
