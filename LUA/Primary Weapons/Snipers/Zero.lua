return {
	WeaponModes = {"Semi"},
	Damage = 70,
	FireRate = 1,
	ClipSize = 3,
--	ReloadAmount = 3,
	ReloadDelay = 3.2,
	Range = 1400,
	AccurateRange = 500,
	
	Scope = {Max = 1, Min = 20},
	
	Description		=	"This sniper has a small magazine but packs high damage shots. It excels at punishing anyone who decides to peek for too long, or leave their head in the open. This is truly the Tracker's best friend.",	
	
	LongReloadSound = true,
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}
