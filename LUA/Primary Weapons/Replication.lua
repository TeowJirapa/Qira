return
{
	WeaponModes		=	{ 'Auto' } ,	
	
	Damage			=	10 ,
	FireRate		=	8.10 ,
	ClipSize		=	30 ,
	ReloadDelay		=	2.5 ,
	Range 			= 	620 ,
	AccurateRange	=	135 ,	

	Description		=	"Since its development, the Replication has been the standard Rifle of most TRA personnel.",	

	Barrels			=	function ( obj ) return obj.Parent:WaitForChild( 'Barrel' ) end ,

		
	LeftWeld 		= 	CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(300), 0, math.rad(-90)) ,
	RightWeld 		= 	CFrame.new(-.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) ,	
	
	FireSound 		= 	script.Fire ,
	ReloadSound 	= 	script.Reload ,	
	LongReloadSound = 	true ,
} ;
