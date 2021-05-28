return {
	WeaponModes = {"Semi"},
	Damage = 14,
	FireRate = 7.7,
	ClipSize = 8,
	--ReloadAmount = 8,
	ReloadDelay = 2.6,
	Range = 400,
	AccurateRange = 60,
	
	Description		=	"The go-to pistol for most TRA soldiers. This handy sidearm is perfect putting in the last shot needed to down a target.",	
	
	LongReloadSound = true,
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}
