return {
	WeaponModes = {"Semi"},
	Damage = 35,
	FireRate = 1,
	ClipSize = 8,
--	ReloadAmount = 10,
	ReloadDelay = 2.5,
	Range = 1400,
	AccurateRange = 155,
	
	Scope = {Max = 5, Min = 20},
	
	Description		= "A sniper with a high fireate and large magazine. This weapon allows the user to fire high impact bullets at their enemies quickly, so don’t be afraid if you miss a couple shots.",	
	
	LongReloadSound = true,
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}