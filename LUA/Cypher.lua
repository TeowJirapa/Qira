return
{
	WeaponModes		=	{ 'Auto' } ,	
	
	Damage			=	11.5 ,
	FireRate		=	7 ,
	ClipSize		=	30 ,
	ReloadDelay		=	2.5 ,
	Range 			= 	620 ,
	AccurateRange	=	135 ,
	
	Description		=	"A newer weapon added to the arsenal of many weapons that a TRA soldier wields. This sleek rifle is a second option for the battlefield and it is best that you don’t overlook it.",	
	
	Barrels			=	function ( obj ) return obj.Parent:WaitForChild( 'Barrel' ) end ,

		
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	
	
	FireSound 		= 	script.Fire ,
	ReloadSound 	= 	script.Reload ,	
	LongReloadSound = 	true ,
} ;