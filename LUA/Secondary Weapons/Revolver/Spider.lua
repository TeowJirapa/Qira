return {
	WeaponModes = {"Semi"},
	Damage = 25,
	FireRate = 1,
	ClipSize = 6,
	ReloadDelay = 3,
	--ReloadAmount = 6,
	Range = 400,
	AccurateRange = 60,
	
	Description		=	"This hefty revolver packs a punch with it’s high damage rounds.",	
	
	
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}
