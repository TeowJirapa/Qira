return 
{
	WeaponModes = {"Semi"},
	
	Damage = 20,
	FireRate = 1,
	ClipSize = 1,
	ReloadDelay = 2.7,
	Range = 320,
	AccurateRange = 80,
	
	NoChambering	=	true,
	
--	ShotKnockbackPercentage = 5,
	DistanceDamageModifier = 0.75,
	
	PreventSprint = true,
	BulletType = {Name = "Explosive", BlastRadius = 15, BlastPressure = 10000, ExplosionType = Enum.ExplosionType.NoCraters},
	
	Description		=	"This grenade launcher excels in taking out clusters of enemies. You better ensure your opposition isn’t carrying this in close quarters.",		
	
	LongReloadSound = true,
	Barrels = function (StatObj) return StatObj.Parent:WaitForChild("Barrel") end,
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	

	FireSound = script.Fire,
	ReloadSound = script.Reload
}