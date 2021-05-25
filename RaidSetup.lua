local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RaidLib = require( game:GetService( "ServerStorage" ):FindFirstChild( "RaidLib" ) and game:GetService( "ServerStorage" ).RaidLib:FindFirstChild( "MainModule" ) or 03179000900 )
local Core = require(game:GetService("ReplicatedStorage"):WaitForChild("S2"):WaitForChild("Core"))

RaidLib.GameTick = 1

RaidLib.RaidLimit = 60*20

RaidLib.EqualTeams = false

RaidLib.LockTeams = false --true

RaidLib.ManualStart = true

RaidLib.MaxPlrMultiplier = 0 -- Up to this many players will increase the speed of capturing a capture point

RaidLib.HomeTeams = { [ game:GetService( "Teams" ):WaitForChild("S2_TRA").Value ] = { CountsFor = 0.5, { CountsFor = 1, 165491 }, { unpack( RaidLib.GroupPagesToArray( game:GetService( "GroupService" ):GetAlliesAsync( 165491 ) ) ) } } } -- teams that can capture for the home group

RaidLib.HomeRequired = 10 -- How many of the home teams are required for terminals to be taken

RaidLib.AwayTeams = { [ game:GetService( "Teams" ):WaitForChild("S2_Raiders").Value ] = { CountsFor = 1 } } -- teams that can raid

RaidLib.AwayRequired = 15 -- How many of the home teams are required for terminals to be taken

--RaidLib.RallyMessagePct = 1 -- Away > Away*RallyMessagePct for the PSA to announce a rally

RaidLib.GracePeriod = 0

RaidLib.DefaultAwayEmblemUrl = "rbxassetid://1449842727"

RaidLib.HomeGroup = game:GetService( "GroupService" ):GetGroupInfoAsync( 165491 )

RaidLib.PlaceAcronym = "Frostbyte"

RaidLib.DiscordMessages = {
	
	{
		
		Url = "https://discord.com/api/webhooks/813080588910460949/oV2vbOeflU7BByVE4-Vb_ZVMf8e0vYjKmYLNMz7h9VdWCcrReq6xOadAf9DStGOp6Id5",
		
		Rallying = "**[DefencePending-%PlaceAcronym%-%RaidID%]** %AwayGroup% have started to rally at %PlaceName%! Pend to join to get in on the action! @everyone",
		
		Start = "**[DefenceStart-%PlaceAcronym%-%RaidID%]** Get to %PlaceName% to defend against %AwayGroup%! @everyone",
		
		Left = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have left %PlaceName%!",
		
		Forced = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have lost because an admin ended the raid!",
		
		TimeLimit = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have lost because the time limit was reached at %PlaceName%!",
		
		Won = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** We have won the defence against %AwayGroup% at %PlaceName%!",
		
		Lost = "**[DefenceLost-%PlaceAcronym%-%RaidID%]** %PlaceName% has been lost! %AwayGroup% have won!"
		
	},
	{
		
		Url = "https://discord.com/api/webhooks/813080588910460949/oV2vbOeflU7BByVE4-Vb_ZVMf8e0vYjKmYLNMz7h9VdWCcrReq6xOadAf9DStGOp6Id5",
		
		Rallying = "**[DefencePending-%PlaceAcronym%-%RaidID%]** %AwayGroup% have started to rally at %PlaceName%! Pend to join to get in on the action! @everyone",
		
		Start = "**[DefenceStart-%PlaceAcronym%-%RaidID%]** Get to %PlaceName% to defend against %AwayGroup%! @everyone",
		
		Left = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have left %PlaceName%!",
		
		Forced = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have lost because an admin ended the raid!",
		
		TimeLimit = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** %AwayGroup% have lost because the time limit was reached at %PlaceName%!",
		
		Won = "**[DefenceWon-%PlaceAcronym%-%RaidID%]** We have won the defence against %AwayGroup% at %PlaceName%!",
		
		Lost = "**[DefenceLost-%PlaceAcronym%-%RaidID%]** %PlaceName% has been lost! %AwayGroup% have won!"
		
	},
	
	{
		
		Url = "https://discord.com/api/webhooks/813080588910460949/oV2vbOeflU7BByVE4-Vb_ZVMf8e0vYjKmYLNMz7h9VdWCcrReq6xOadAf9DStGOp6Id5",
		
		Start = "**[DefenceStart-%PlaceAcronym%-%RaidID%]**\nA defence has started!\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Left = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have left!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Forced = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have lost because an admin ended the raid!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		TimeLimit = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have reached the time limit!\n\nDefence lasted for %RaidTime%\n\%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Won = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Lost = "**[DefenceLost-%PlaceAcronym%-%RaidID%]**\nA defence has been lost!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------"
		
	}
}

function AbleSpawns( Model, Enabled )
	
	local Kids = Model:GetDescendants( )
	
	for a = 1, #Kids do
		
		if Kids[ a ]:IsA( "SpawnLocation" ) then
			
			Kids[ a ].Enabled = Enabled
			
		end
		
	end
	
end
--Change indicator to
local TweenService = game:GetService( "TweenService" )
local function UpdateIndicator( Val, Speed )
	local IndicatorColor = Speed > 0 and Color3.fromRGB( 196, 40, 28 ) or Speed < 0 and Color3.fromRGB( 0, 127, 85 ) or BrickColor.new("Mid gray").Color
	if Speed > 0 then
		workspace.Payload.PrimaryPart.Marker.BurstType.Value="Forward"
	elseif Speed < 0 then
		workspace.Payload.PrimaryPart.Marker.BurstType.Value="Back"
	else
		workspace.Payload.PrimaryPart.Marker.BurstType.Value=""
	end
	TweenService:Create(workspace.Payload.Indicator, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Color=IndicatorColor}):Play()
end

UpdateIndicator( 0, 0 )

local function UpdateIndicatorCore( Val, Speed )
	local IndicatorColor = Speed > 0 and Color3.fromRGB( 196, 40, 28 ) or Speed < 0 and Color3.fromRGB( 0, 127, 85 ) or BrickColor.new("Mid gray").Color
	if Speed > 0 then
		workspace.CorePoint.PrimaryPart.Marker.BurstType.Value="Forward"
	elseif Speed < 0 then
		workspace.CorePoint.PrimaryPart.Marker.BurstType.Value="Back"
	else
		workspace.CorePoint.PrimaryPart.Marker.BurstType.Value=""
	end
end

local function UpdateIndicatorVault( Val, Speed )
	local IndicatorColor = Speed > 0 and Color3.fromRGB( 196, 40, 28 ) or Speed < 0 and Color3.fromRGB( 0, 127, 85 ) or BrickColor.new("Mid gray").Color
	if Speed > 0 then
		workspace.VaultPoint.PrimaryPart.Marker.BurstType.Value="Forward"
	elseif Speed < 0 then
		workspace.VaultPoint.PrimaryPart.Marker.BurstType.Value="Back"
	else
		workspace.VaultPoint.PrimaryPart.Marker.BurstType.Value=""
	end
end

--[[
local function UpdateIndicatorEscort( Val, Speed )
	local IndicatorColor = Speed > 0 and Color3.fromRGB( 196, 40, 28 ) or Speed < 0 and Color3.fromRGB( 0, 127, 85 ) or BrickColor.new("Mid gray").Color
	if workspace:FindFirstChild("Flag") then
		if Speed > 0 then
			workspace.Flag.PrimaryPart.Marker.BurstType.Value="Forward"
		elseif Speed < 0 then
			workspace.Flag.PrimaryPart.Marker.BurstType.Value="Back"
		else
			workspace.Flag.PrimaryPart.Marker.BurstType.Value=""
		end	
	end
end
]]

local StartPoint = workspace.Terrain[ "0" ]

local Checkpoints, TurnPoints, Total = RaidLib.OrderedPointsToPayload( StartPoint, { workspace.Terrain["28"], workspace.Terrain["58"] }, workspace.Terrain:GetChildren( ) )

local function setLighting(DayType,Interval)
	if DayType=="Dawn" then
		TweenService:Create(game.Lighting, TweenInfo.new(Interval), { Ambient=Color3.fromRGB(140,140,140), Brightness=0.85, ColorShift_Bottom=Color3.fromRGB(255,255,255), ColorShift_Top=Color3.fromRGB(125,110,48), OutdoorAmbient=Color3.fromRGB(125,121,48), ClockTime=6.117, FogColor=Color3.fromRGB(145,130,130), FogStart=50, FogEnd=3000 } ):Play()	
	elseif DayType=="Dusk" then
		TweenService:Create(game.Lighting, TweenInfo.new(Interval), { Ambient=Color3.fromRGB(143,162,207), Brightness=0.74, ColorShift_Bottom=Color3.fromRGB(0,0,0), ColorShift_Top=Color3.fromRGB(194,141,35), OutdoorAmbient=Color3.fromRGB(36,41,35), ClockTime=19, FogColor=Color3.fromRGB(196,187,211), FogStart=50, FogEnd=3000 } ):Play()	
	elseif DayType=="Night" then
		local FirstTween = TweenService:Create(game.Lighting, TweenInfo.new(Interval/10), { Ambient=Color3.fromRGB(100,120,140), Brightness=0.55, ColorShift_Bottom=Color3.fromRGB(0,0,0), ColorShift_Top=Color3.fromRGB(0,0,0), OutdoorAmbient=Color3.fromRGB(0,0,0), ClockTime=23.99, FogColor=Color3.fromRGB(28,29,32), FogStart=50, FogEnd=2500 } )
		FirstTween.Completed:wait()
		game.Lighting.ClockTime=0		
		TweenService:Create(game.Lighting, TweenInfo.new(Interval), { Ambient=Color3.fromRGB(110,130,150), Brightness=0.55, ColorShift_Bottom=Color3.fromRGB(0,0,0), ColorShift_Top=Color3.fromRGB(0,0,0), OutdoorAmbient=Color3.fromRGB(0,0,0), ClockTime=3.5, FogColor=Color3.fromRGB(28,29,32), FogStart=50, FogEnd=2500 } ):Play()	
	elseif DayType=="Midday" then	
		TweenService:Create(game.Lighting, TweenInfo.new(Interval), { Ambient=Color3.fromRGB(160,160,160), Brightness=1, ColorShift_Bottom=Color3.fromRGB(255,255,255), ColorShift_Top=Color3.fromRGB(255,255,255), OutdoorAmbient=Color3.fromRGB(180,180,180), ClockTime=14, FogColor=Color3.fromRGB(186,192,211), FogStart=50, FogEnd=5000 } ):Play()		
	end	
end

RaidLib.OfficialRaid:GetPropertyChangedSignal("Value"):Connect(function()
	game.Workspace.Payload.PrimaryPart.Marker.Enabled.Value=true	
end)

local Payload = RaidLib.UnidirectionalPoint{ Name = "Payload", PassiveCapture = 1, Dist = 18, CaptureTime = Total, CaptureSpeed = 2, AwayCaptureSpeed = 2, MaxPlrMultiplier=6, MainPart = workspace.Payload.PrimaryPart, Model = workspace.Payload, Checkpoints = Checkpoints, BonusSpeeds = {} }:AsPayload( StartPoint, TurnPoints ):RequireForWin( )

--[[
local TNTs = setmetatable({}, {__mode = "k"})
workspace.PayloadBoostTarget.Touched:Connect(function(Part)
	if RaidLib.RaidStart and TNTs[Part.Parent] then
		local MyKey = {}
		Payload.BonusSpeeds[MyKey] = 2
		TNTs[Part.Parent][1]:Destroy()
		Part.Parent:Destroy()
		TNTs[Part.Parent][2]:Disconnect()
		TNTs[Part.Parent][3]:Disconnect()
		TNTs[Part.Parent] = nil
		
		wait(5)
		
		Payload.BonusSpeeds[MyKey] = nil
	end 
end)

workspace.PayloadBoostTarget.Size = workspace.TRAPayloadTarget.Size
workspace.PayloadBoostTarget.CFrame = workspace.TRAPayloadTarget.CFrame
Payload.Event_CapturingSideChanged.Event:Connect(function(Side)
	print("changed", Side)
	for TNT, Objs in pairs(TNTs) do
		TNT:Destroy()
		Objs[1]:Destroy()
		Objs[2]:Disconnect()
		Objs[3]:Disconnect()
	end
	TNTs = setmetatable({}, {__mode = "k"})		
	
	if RaidLib.HomeTeams[Side] then
		workspace.PayloadBoostTarget.Size = workspace.TRAPayloadTarget.Size
		workspace.PayloadBoostTarget.CFrame = workspace.TRAPayloadTarget.CFrame
	else
		workspace.PayloadBoostTarget.Size = workspace.RaiderPayloadTarget.Size
		workspace.PayloadBoostTarget.CFrame = workspace.RaiderPayloadTarget.CFrame
	end
end)

Payload.Model.InteractObject.Event:Connect(function(Plr)
	if RaidLib.RaidStart and Payload.Active and not Plr.Character:FindFirstChild("TNT") and Payload.CapturingSide[Plr.Team] then
		local Billboard = script.TNTBillboard:Clone()
		Billboard.Parent = Plr.PlayerGui
		local TNT = script.TNT:Clone()
		Plr.Character.Humanoid:AddAccessory(TNT)
		
		local DiedEvent = Plr.Character.Humanoid.Died:Connect(function()
			TNT:Destroy()
			TNTs[TNT][1]:Destroy()
			TNTs[TNT][2]:Disconnect()
			TNTs[TNT][3]:Disconnect()
			TNTs[TNT] = nil
		end)
		
		local RespawnEvent = Plr.CharacterRemoving:Connect(function()
			TNT:Destroy()
			TNTs[TNT][1]:Destroy()
			TNTs[TNT][2]:Disconnect()
			TNTs[TNT][3]:Disconnect()
			TNTs[TNT] = nil
		end)
		
		TNTs[TNT] = {Billboard, DiedEvent, RespawnEvent}
		
		TNT.AncestryChanged:Connect(function()
			if TNT.Parent then
				TNT:Destroy()
				TNTs[TNT][1]:Destroy()
				TNTs[TNT][2]:Disconnect()
				TNTs[TNT][3]:Disconnect()
				TNTs[TNT] = nil
			end
		end)
	end
end)
]]

local function DestroyTower()
	local Tower = workspace.PayloadRadioTower
	
	local TowerBottom = Tower.Bottom
	local TowerUpper = Tower.Upper
	
	local BottomRoot = TowerBottom.PrimaryPart
	local UpperRoot = TowerUpper.PrimaryPart

	local TweenBottom = TweenService:Create(BottomRoot, TweenInfo.new(2, Enum.EasingStyle.Quint), {
    CFrame = BottomRoot.CFrame * CFrame.Angles(math.rad(-20), math.rad(15), 0) * CFrame.new(-5,0,0)
	})
	
	local TweenTop = TweenService:Create(UpperRoot, TweenInfo.new(4, Enum.EasingStyle.Bounce), {
    CFrame = UpperRoot.CFrame * CFrame.Angles(math.rad(90), math.rad(-80), 0) * CFrame.new(-35,-30,-45), 
	})

	TweenBottom:Play()
	TweenTop:Play()
end

local function BombBridge()
	local Plane
	if not game.Workspace:FindFirstChild("BomberPlane") then
		Plane = script.BomberPlane:Clone()
		Plane.Parent = game.Workspace
	else
		Plane = game.Workspace.BomberPlane
	end
	
	local SecondsPerStud = 0.0025
	local PlaneRoute = workspace.BomberPlaneRoute:GetChildren()
	table.sort(PlaneRoute, function(a,b)
		return tonumber(a.Name)<tonumber(b.Name)
	end)
	
	Plane.PrimaryPart.rotorforward:Play()
	TweenService:Create(Plane.PrimaryPart, TweenInfo.new(0), {CFrame = PlaneRoute[1].CFrame}):Play()
	
	wait()
	
	for _,v in pairs(PlaneRoute) do
    	local Info = TweenInfo.new((v.Position - Plane.PrimaryPart.Position).Magnitude * SecondsPerStud, Enum.EasingStyle.Linear)
    	local tween = TweenService:Create(Plane.PrimaryPart, Info, {CFrame = v.CFrame})
    	tween:Play()
	    tween.Completed:Wait() -- yields until the tween is completed.
		if v.Name=="7" then						
			coroutine.wrap(function()
				Plane.PrimaryPart.smash:Play()
				local bomb = script.Bomb:Clone()
				bomb.Parent = game.Workspace
				
				local BombRoot = bomb.PrimaryPart
				BombRoot.Falling:Play()

				local TweenBomb = TweenService:Create(BombRoot, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
   					CFrame = BombRoot.CFrame * CFrame.Angles(0,math.rad(90), 0) * CFrame.new(210,0,0)
				})
				
				TweenBomb:Play()
				TweenBomb.Completed:wait()
				
				local WeaponStat = {Value = script.Parent.Name, Damage = 0, GlobalDamageMultiplier = 1, DistanceDamageModifier = 1 }
				local WeaponStat = setmetatable({Value = script.Parent.Name, Damage = 0, DistanceDamageModifier = 1 }, {__index = Core.Config.WeaponTypeOverrides.All})
				Core.DoExplosion(workspace.OutpostBridge, WeaponStat, workspace.OutpostBridge.Position, {Parent = workspace.OutpostBridge, Visible = true, BlastRadius = 75, BlastPressure = 0, ExplosionType = Enum.ExplosionType.NoCraters})
				bomb:Destroy()
				
				local fadeOutBridge = TweenService:Create(workspace.OutpostBridge, TweenInfo.new(1), { Transparency=1 })
				fadeOutBridge:Play()
				fadeOutBridge.Completed:wait()
				workspace.OutpostBridge.CanCollide=false
			end)()
		end
    end	
end

Payload.Event_CaptureChanged.Event:Connect( UpdateIndicator )

Payload.Event_CheckpointReached.Event:Connect( function ( Checkpoint )

	
	if Checkpoint == 1 then
		
		AbleSpawns( workspace.Spawns.StartSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadCheckSpawns, true)
		AbleSpawns( workspace.Spawns.PayloadSpawns, false )
		AbleSpawns( workspace.Spawns.CoreSpawns, false)
		AbleSpawns( workspace.Spawns.VaultSpawns, false)
		
		setLighting("Midday",120)
	
	elseif Checkpoint == 2 then
		
		game.Workspace.Payload.PrimaryPart.Marker.Enabled.Value=false
		game.Workspace.CorePoint.Part.Marker.Enabled.Value=true
		
		DestroyTower()
		
		game.Workspace.TropicsGrave.Text.music:Play()
		
		AbleSpawns( workspace.Spawns.StartSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadCheckSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadSpawns, true )
		AbleSpawns( workspace.Spawns.CoreSpawns, false)
		AbleSpawns( workspace.Spawns.VaultSpawns, false)
		
		local WeaponStat = {Value = script.Parent.Name, Damage = 0, GlobalDamageMultiplier = 1, DistanceDamageModifier = 1 }
		local WeaponStat = setmetatable({Value = script.Parent.Name, Damage = 0, DistanceDamageModifier = 1 }, {__index = Core.Config.WeaponTypeOverrides.All})
		Core.DoExplosion(workspace.PayloadDestroy, WeaponStat, workspace.PayloadDestroy.Position, {Parent = workspace.PayloadDestroy, Visible = true, BlastRadius = 75, BlastPressure = 0, ExplosionType = Enum.ExplosionType.NoCraters})
		Core.DoExplosion(workspace.PayloadRadioTower.Upper.PrimaryPart, WeaponStat, workspace.PayloadRadioTower.Upper.PrimaryPart.Position, {Parent = workspace.PayloadRadioTower.Upper.PrimaryPart, Visible = true, BlastRadius = 75, BlastPressure = 0, ExplosionType = Enum.ExplosionType.NoCraters})
		TweenService:Create(workspace.PayloadDestroy, TweenInfo.new(0.5), { Transparency=1 }):Play()
		workspace.PayloadDestroy.CanCollide=false
		

		--[[
		for TNT, Objs in pairs(TNTs) do
			TNT:Destroy()
			Objs[1]:Destroy()
			Objs[2]:Disconnect()
			Objs[3]:Disconnect()
		end
		TNTs = setmetatable({}, {__mode = "k"})		
		]]
		
	end
	
end )

local CorePoint = RaidLib.UnidirectionalPoint{ Name = "Core", Dist = 35, PassiveCapture = 1, CaptureTime = 900, MainPart = workspace.CorePoint.Part, Model = workspace.CorePoint, BonusSpeeds = {} }:Require(Payload):RequireForWin( )

local HackingBoostCore = Instance.new("RemoteEvent")
HackingBoostCore.Name = "HackingBoostCore"
HackingBoostCore.OnServerEvent:Connect(function(Plr)
	if CorePoint.Active and CorePoint.CapturingSide[Plr.Team] and Plr.PlayerGui:FindFirstChild("CoreHacking") then
		local MyKey = {}
		CorePoint.BonusSpeeds[MyKey] = 1.2
		
		wait(10)
		
		CorePoint.BonusSpeeds[MyKey] = nil
	end
end)

HackingBoostCore.Parent = game:GetService("ReplicatedStorage")
local CoreGUIs = setmetatable({}, {__mode = "k"})
local CoreSeats = workspace.CorePoint.Seats:GetChildren()
for _, Seat in ipairs(CoreSeats) do
	local Gui
	Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if Seat.Occupant then
            if RaidLib.RaidStart and CorePoint.Active then
                local Plr = game.Players:GetPlayerFromCharacter(Seat.Occupant.Parent)
                if Plr and CorePoint.CapturingSide[Plr.Team] then
                    Gui = script.CoreHacking:Clone()
                    Gui.Parent = Plr.PlayerGui
                    CoreGUIs[Gui] = true
                else
                    wait()
                    Seat.Occupant.Jump = true
                end
            else
                wait()
                Seat.Occupant.Jump = true
            end
        elseif Gui then
            CoreGUIs[Gui] = nil
            Gui.Name = "Destroy"
        end
    end)
end

CorePoint.Event_CaptureChanged.Event:Connect( UpdateIndicatorCore )

CorePoint.Event_Reset.Event:Connect(function()
	for Gui, _ in pairs(CoreGUIs) do
		Gui:Destroy()
	end
	CoreGUIs = setmetatable({}, {__mode = "k"})
end)

CorePoint.Event_CheckpointReached.Event:Connect( function ( Checkpoint )
	if Checkpoint == 1 then
		
		game.Workspace.CorePoint.Part.Marker.Enabled.Value=false
		game.Workspace.VaultPoint.Part.Marker.Enabled.Value=true
		
		AbleSpawns( workspace.Spawns.StartSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadCheckSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadSpawns, false )
		AbleSpawns( workspace.Spawns.CoreSpawns, true)
		AbleSpawns( workspace.Spawns.VaultSpawns, false)

		for Gui, _ in ipairs(CoreGUIs) do
			Gui.Name = "Destroy"
		end
		CoreGUIs = setmetatable({}, {__mode = "k"})
		
		setLighting("Dusk",60)
		
	end
	
end )

local VaultPoint = RaidLib.UnidirectionalPoint{ Name = "Vault", Dist = 35, PassiveCapture = 1, CaptureTime = 1200, MainPart = workspace.VaultPoint.Part, Model = workspace.VaultPoint, BonusSpeeds = {} }:Require(Payload):Require(CorePoint):RequireForWin( )

local function OpenVault()
	local Door  = workspace.VaultDoor
	local DoorRoot = Door.PrimaryPart

	local TweenOpen = TweenService:Create(DoorRoot, TweenInfo.new(5), {
    CFrame = DoorRoot.CFrame * CFrame.Angles(math.rad(-100), 0, 0)
	})

	TweenOpen:Play()
end


local HackingBoostVault = Instance.new("RemoteEvent")
HackingBoostVault.Name = "HackingBoostVault"
HackingBoostVault.OnServerEvent:Connect(function(Plr)
	if VaultPoint.Active and VaultPoint.CapturingSide[Plr.Team] and Plr.PlayerGui:FindFirstChild("VaultHacking") then
		local MyKey = {}
		VaultPoint.BonusSpeeds[MyKey] = 1.2
		
		wait(10)
		
		VaultPoint.BonusSpeeds[MyKey] = nil
	end
end)
HackingBoostVault.Parent = game:GetService("ReplicatedStorage")
local VaultGUIs = setmetatable({}, {__mode = "k"})
local VaultSeats = workspace.VaultPoint.Seats:GetChildren()
for _, Seat in ipairs(VaultSeats) do
	local Gui
	Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		if Seat.Occupant then
			if RaidLib.RaidStart and VaultPoint.Active then
				local Plr = game.Players:GetPlayerFromCharacter(Seat.Occupant.Parent)
				if Plr and VaultPoint.CapturingSide[Plr.Team] then
					Gui = script.VaultHacking:Clone()
					Gui.Parent = Plr.PlayerGui
					VaultGUIs[Gui] = true
				else
					wait()
					Seat.Occupant.Jump = true
				end
			else
				wait()
				Seat.Occupant.Jump = true
			end
		elseif Gui then
			VaultGUIs[Gui] = nil
			Gui.Name = "Destroy"
		end
	end)
end

VaultPoint.Event_CaptureChanged.Event:Connect( UpdateIndicatorVault )

VaultPoint.Event_Reset.Event:Connect(function()
	for Gui, _ in pairs(VaultGUIs) do
		Gui.Name = "Destroy"
	end
	VaultGUIs = setmetatable({}, {__mode = "k"})
end)

local EscortWorkspace = nil
local EscortPct = nil

function EscortFunc()		
	
	if (EscortPct.Value>=0.05 and EscortPct.Value<=0.35) then
	 	AbleSpawns( workspace.Spawns.EscortSpawns["5-35"], true)
		AbleSpawns( workspace.Spawns.EscortSpawns["35-70"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], false)	
		AbleSpawns( workspace.Spawns.VaultSpawns, false)
	elseif (EscortPct.Value>=0.35 and EscortPct.Value<=0.70) then
	 	AbleSpawns( workspace.Spawns.EscortSpawns["5-35"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["35-70"], true)
		AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], false)	
		AbleSpawns( workspace.Spawns.VaultSpawns, false)	
	elseif (EscortPct.Value>=0.70 and EscortPct.Value<=1) then
	 	AbleSpawns( workspace.Spawns.EscortSpawns["5-35"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["35-70"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], true)	
		AbleSpawns( workspace.Spawns.VaultSpawns, false)
	else
	 	AbleSpawns( workspace.Spawns.EscortSpawns["5-35"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["35-70"], false)
		AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], false)	
		AbleSpawns( workspace.Spawns.VaultSpawns, true)	
	end
end

VaultPoint.Event_CheckpointReached.Event:Connect( function ( Checkpoint )
	if Checkpoint == 1 then
		
		OpenVault()
		
		AbleSpawns( workspace.Spawns.StartSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadCheckSpawns, false)
		AbleSpawns( workspace.Spawns.PayloadSpawns, false )
		AbleSpawns( workspace.Spawns.CoreSpawns, false)
		AbleSpawns( workspace.Spawns.VaultSpawns, true)
		
		game.Workspace.VaultPoint.Part.Marker.Enabled.Value=false
		game.Workspace.FlagTarget.Marker.Enabled.Value=true
		local flag = game.Workspace:FindFirstChild("Flag")
		if flag then
			flag.PrimaryPart.Marker.Enabled.Value=true
			EscortWorkspace = game.Workspace:WaitForChild("Flag")
			EscortPct = EscortWorkspace:WaitForChild("CapturePct")
			EscortPct:GetPropertyChangedSignal("Value"):Connect( EscortFunc )
		end
		
		for Gui, _ in ipairs(VaultGUIs) do
			Gui.Name = "Destroy"
		end
		VaultGUIs = setmetatable({}, {__mode = "k"})

		if workspace.OutpostBridge.CanCollide==true then
			coroutine.wrap(BombBridge)()
		end
		
		setLighting("Night",120)
		
	end
	
end )

VaultPoint.Event_Reset.Event:Connect(function()
	for Gui, _ in ipairs(VaultGUIs) do
		Gui.Name = "Destroy"
	end
	VaultGUIs = setmetatable({}, {__mode = "k"})
end)

local Escort = RaidLib.CarryablePoint{ Model = script.Flag, Target = workspace.FlagTarget, TargetDist = 6, Start = workspace.FlagStart, StartDist = 6, PreventTools = true, ResetOnHomePickup = true, DropGui = script.DropCarriedPoint, WalkSpeedModifier = 0.7, JumpPowerModifier=0.7 }:Require(Payload):Require(CorePoint):Require(VaultPoint):RequireForWin( )

Escort.Event_Captured.Event:Connect( function ( Side )
	if RaidLib.AwayTeams[Side] then
		Escort.Active = false
		
		local flag = game.Workspace:FindFirstChild("Flag")
		if flag then
			flag.PrimaryPart.Marker.Enabled.Value=false
		end
		
	end
end )

--[[
	
	AbleSpawns( workspace.Spawns.EscortSpawns["5-30"], false)
	AbleSpawns( workspace.Spawns.EscortSpawns["30-65"], false)
	AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], false)
	
--]]

RaidLib.Event_ResetAll.Event:Connect(function()	
	
	EscortWorkspace = nil
	
	game.Workspace.Payload.PrimaryPart.Marker.Enabled.Value=false	
	game.Workspace.VaultPoint.Part.Marker.Enabled.Value=false
	game.Workspace.CorePoint.Part.Marker.Enabled.Value=false
	if game.Workspace:FindFirstChild("Flag") then
		game.Workspace.Flag.PrimaryPart.Marker.Enabled.Value=false
	end
	game.Workspace.FlagTarget.Marker.Enabled.Value=false
	
	AbleSpawns( workspace.Spawns.StartSpawns, true)
	AbleSpawns( workspace.Spawns.PayloadCheckSpawns, false)
	AbleSpawns( workspace.Spawns.PayloadSpawns, false )
	AbleSpawns( workspace.Spawns.CoreSpawns, false)
	AbleSpawns( workspace.Spawns.VaultSpawns, false)
	
	AbleSpawns( workspace.Spawns.EscortSpawns["5-35"], false)
	AbleSpawns( workspace.Spawns.EscortSpawns["35-70"], false)
	AbleSpawns( workspace.Spawns.EscortSpawns["70-100"], false)
	
	workspace.PayloadDestroy.Transparency=0
	workspace.PayloadDestroy.CanCollide=true
	
	if game.Workspace:FindFirstChild("VaultDoor") then
		game.Workspace.VaultDoor:Destroy()
		local newVault = script.VaultDoor:Clone()
		newVault.Parent = game.Workspace
	end
	
	if game.Workspace:FindFirstChild("PayloadRadioTower") then
		game.Workspace.PayloadRadioTower:Destroy()
		local newtower = script.PayloadRadioTower:Clone()
		newtower.Parent = game.Workspace
	end
	
	setLighting("Dawn",5)
	
end)



-- START OF PR WEBHOOKS

local Players, HttpService, RunService, GroupService = game:GetService("Players"), game:GetService("HttpService"), game:GetService("RunService"), game:GetService("GroupService")

local function HandleRbxAsync(DefualtValue, Function, ...)
	local Result = {pcall(Function, ...)}
	if Result[1] then
		return select(2, unpack(Result))
	else
		warn(Result[2] .. "\n" .. debug.traceback(nil,2))
		return DefualtValue
	end
end

local function FormatTime(Time)
	return ("%.2d:%.2d:%.2d"):format(Time / (60 * 60), Time / 60 % 60, Time % 60)
end


local PracticeHooks = {
	
	{
		
		Url = "https://discord.com/api/webhooks/813080588910460949/oV2vbOeflU7BByVE4-Vb_ZVMf8e0vYjKmYLNMz7h9VdWCcrReq6xOadAf9DStGOp6Id5",
	
		Start = "**[DefenceStart-%PlaceAcronym%-%RaidID%]**\nA defence has started!\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Left = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have left!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Forced = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have lost because an admin ended the raid!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		TimeLimit = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won! %AwayGroup% have reached the time limit!\n\nDefence lasted for %RaidTime%\n\%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Won = "**[DefenceWon-%PlaceAcronym%-%RaidID%]**\nA defence has been won!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------",
		
		Lost = "**[DefenceLost-%PlaceAcronym%-%RaidID%]**\nA defence has been lost!\n\nDefence lasted for %RaidTime%\n\n%HomeGroup%\n%HomeListNewline%\n\n%AwayGroup%\n%AwayListNewline%\n-----------"
		
	}
	
}

RaidLib.OfficialRaid:GetPropertyChangedSignal( "Value" ):Connect( function ( )
	
	if not RaidLib.OfficialRaid.Value then return end
	
	if RaidLib.Practice and PracticeHooks and ( RaidLib.AllowDiscordInStudio or not RunService:IsStudio( ) ) then
		
		local Plrs = Players:GetPlayers( )
		
		local AwayGroup = RaidLib.AwayGroup.Id and ( "[" .. RaidLib.AwayGroup.Name .. "](<https://www.roblox.com/groups/" .. RaidLib.AwayGroup.Id .. "/a#!/about>)" ) or RaidLib.AwayGroup.Name
		
		local HomeGroup = RaidLib.HomeGroup and ( "[" .. RaidLib.HomeGroup.Name .. "](<https://www.roblox.com/groups/" .. RaidLib.HomeGroup.Id .. "/a#!/about>)" )
		
		local PlaceAcronym ="[" .. RaidLib.PlaceAcronym .. "](<https://www.roblox.com/games/" .. game.PlaceId .. "/>)"
		
		local PlaceName = "[" .. RaidLib.PlaceName .. "](<https://www.roblox.com/games/" .. game.PlaceId .. "/>)"
		
		local Home, Away = { }, { }
		
		for a = 1, #Plrs do
			
			if RaidLib.HomeTeams[ Plrs[ a ].Team ] then
				
				Home[ #Home + 1 ] = "[" .. Plrs[ a ].Name .. "](<https://www.roblox.com/users/" .. Plrs[ a ].UserId .. "/profile>) - " .. HandleRbxAsync( "Guest", Plrs[ a ].GetRoleInGroup, Plrs[ a ], RaidLib.HomeGroup.Id )
				
			elseif RaidLib.AwayTeams[ Plrs[ a ].Team ] then
				
				Away[ #Away + 1 ] = "[" .. Plrs[ a ].Name .. "](<https://www.roblox.com/users/" .. Plrs[ a ].UserId .. "/profile>)" .. ( RaidLib.AwayGroup.Id and ( " - " .. HandleRbxAsync( "Guest", Plrs[ a ].GetRoleInGroup, Plrs[ a ], RaidLib.AwayGroup.Id ) ) or "" )
				
			end
			
		end
		
		if #Home == 0 then Home[ 1 ] = "None" end
		
		if #Away == 0 then Away[ 1 ] = "None" end
		
		for a = 1, #PracticeHooks do
			
			if PracticeHooks[ a ].Start then
				
				local Msg = PracticeHooks[ a ].Start:gsub( "%%%w*%%", { [ "%PlaceAcronym%" ] = PlaceAcronym, [ "%PlaceName%" ] = PlaceName, [ "%RaidID%" ] = RaidLib.RaidID.Value, [ "%AwayGroup%" ] = AwayGroup, [ "%AwayList%" ] = table.concat( Away, ", " ), [ "%AwayListNewline%" ] = table.concat( Away, "\n" ), [ "%HomeGroup%" ] = HomeGroup, [ "%HomeList%" ] = table.concat( Home, ", " ), [ "%HomeListNewline%" ] = table.concat( Home, "\n" ) } )
				
				while true do
					print(#Msg, RaidLib.DiscordCharacterLimit)
					local LastNewLine = #Msg <= RaidLib.DiscordCharacterLimit and RaidLib.DiscordCharacterLimit or Msg:sub( 1, RaidLib.DiscordCharacterLimit ):match( "^.*()[\n]" )
					
					local Ran, Error = pcall( HttpService.PostAsync, HttpService, PracticeHooks[ a ].Url, HttpService:JSONEncode{ avatar_url = RaidLib.HomeGroup.EmblemUrl, username = RaidLib.PlaceAcronym .. " Raid Bot", content = Msg:sub( 1, LastNewLine and LastNewLine - 1 or RaidLib.DiscordCharacterLimit ) } )
					
					if not Ran then warn( Error ) end
					
					if #Msg <= ( LastNewLine or RaidLib.DiscordCharacterLimit ) then break end
					
					Msg = Msg:sub( ( LastNewLine or RaidLib.DiscordCharacterLimit ) + 1 )
					
				end
				
			end
			
		end
		
	end
	
end )

RaidLib.Event_RaidEnded.Event:Connect( function ( RaidID, AwayGroupTable, Result, TeamLog, RaidStart ) 
	
	if RaidLib.Practice and PracticeHooks and ( RaidLib.AllowDiscordInStudio or not RunService:IsStudio( ) ) then
		
		local EndTime = tick( )
		
		local AwayGroup = AwayGroupTable.Id and ( "[" .. AwayGroupTable.Name .. "](<https://www.roblox.com/groups/" .. AwayGroupTable.Id .. "/a#!/about>)" ) or AwayGroupTable.Name
		
		local HomeGroup = RaidLib.HomeGroup and ( "[" .. RaidLib.HomeGroup.Name .. "](<https://www.roblox.com/groups/" .. RaidLib.HomeGroup.Id .. "/a#!/about>)" )
		
		local PlaceAcronym ="[" .. RaidLib.PlaceAcronym .. "](<https://www.roblox.com/games/" .. game.PlaceId .. "/>)"
		
		local PlaceName = "[" .. RaidLib.PlaceName .. "](<https://www.roblox.com/games/" .. game.PlaceId .. "/>)"
		
		local Home, Away = { }, { }
		
		for UserId, Logs in pairs( TeamLog ) do
			
			local Teams = { }
			
			local Max
			
			if #Logs == 1 and Logs[ 1 ][ 1 ] == RaidStart then
				
				Teams[ Logs[ 1 ][ 2 ] ] = true
				
				Max = Logs[ 1 ][ 2 ]
				
			else
			
				for Key, Log in ipairs( Logs ) do
					
					if Log[ 2 ] then
						
						Teams[ Log[ 2 ] ] = Teams[ Log[ 2 ] ] or 0
						
						local Next = Logs[ Key + 1 ]
						
						Teams[ Log[ 2 ] ] = Teams[ Log[ 2 ] ] + ( Next and Next[ 1 ] or EndTime ) - Log[ 1 ]
						
						if not Max or Teams[ Max ] < Teams[ Log[ 2 ] ] then
							
							Max = Log[ 2 ]
							
						end
						
					end
					
				end
				
			end
			
			if Max then
				
				if RaidLib.HomeTeams[ Max ] then
					
					local Role
					
					local Groups = GroupService:GetGroupsAsync( UserId )
					
					for c = 1, #Groups do
						
						if Groups[ c ].Id == RaidLib.HomeGroup.Id then
							
							Role = Groups[ c ].Role
							
							break
							
						end
						
					end
					
					local Time = " - helped for " .. ( Teams[ Max ] == true and "the entire raid" or FormatTime( Teams[ Max ] ) )
					
					Home[ #Home + 1 ] = "[" .. Players:GetNameFromUserIdAsync( UserId ) .. "](<https://www.roblox.com/users/" .. UserId .. "/profile>) - " .. ( Role or "Guest" ) .. Time
					
				elseif RaidLib.AwayTeams[ Max ] then
					
					local Role
					
					if AwayGroupTable.Id then
						
						local Groups = GroupService:GetGroupsAsync( UserId )
						
						for c = 1, #Groups do
							
							if Groups[ c ].Id == AwayGroupTable.Id then
								
								Role = Groups[ c ].Role
								
								break
								
							end
							
						end
						
						Role = Role or "Guest"
						
					end
					
					local Time = " - helped for " .. ( Teams[ Max ] == true and "the entire raid" or FormatTime( Teams[ Max ] ) )
					
					Away[ #Away + 1 ] = "[" .. Players:GetNameFromUserIdAsync( UserId ) .. "](<https://www.roblox.com/users/" .. UserId .. "/profile>) " .. ( Role and ( " - " .. ( Role or "Guest" ) ) or "" ) .. Time
					
				end
				
			end
			
		end
		
		if #Home == 0 then Home[ 1 ] = "None" end
		
		if #Away == 0 then Away[ 1 ] = "None" end
		
		local EmblemUrl = Result == "Lost" and AwayGroupTable.EmblemUrl or RaidLib.HomeGroup.EmblemUrl
		
		for a = 1, #PracticeHooks do
			
			if PracticeHooks[ a ][ Result ] then
				
				local Msg = PracticeHooks[ a ][ Result ]:gsub( "%%%w*%%", { [ "%PlaceAcronym%" ] = PlaceAcronym, [ "%PlaceName%" ] = PlaceName, [ "%RaidID%" ] = RaidID, [ "%RaidTime%" ] = FormatTime( EndTime - RaidStart ), [ "%AwayGroup%" ] = AwayGroup, [ "%AwayList%" ] = table.concat( Away, ", " ), [ "%AwayListNewline%" ] = table.concat( Away, "\n" ), [ "%HomeGroup%" ] = HomeGroup, [ "%HomeList%" ] = table.concat( Home, ", " ), [ "%HomeListNewline%" ] = table.concat( Home, "\n" ) } )
				
				while true do
					
					local LastNewLine = #Msg <= RaidLib.DiscordCharacterLimit and RaidLib.DiscordCharacterLimit or Msg:sub( 1, RaidLib.DiscordCharacterLimit ):match( "^.*()[\n]" )
					
					local Ran, Error = pcall( HttpService.PostAsync, HttpService, PracticeHooks[ a ].Url, HttpService:JSONEncode{ avatar_url = EmblemUrl, username = RaidLib.PlaceAcronym .. " Raid Bot", content =  Msg:sub( 1, LastNewLine and LastNewLine - 1 or RaidLib.DiscordCharacterLimit ) } )
					
					if not Ran then warn( Error ) end
					
					if #Msg <= ( LastNewLine or RaidLib.DiscordCharacterLimit ) then break end
					
					Msg = Msg:sub( ( LastNewLine or RaidLib.DiscordCharacterLimit ) + 1 )
					
				end
				
			end
			
		end
		
	end
	
end )

-- END OF PR WEBHOOKS --

local ServerStorage = game:GetService( "ServerStorage" )

local Cur

function ChangeDifficulty( Selected )
	
	if Cur then
		
		Cur:Destroy( )
		
	end
	
	Cur = Selected:Clone( )
	
	Cur.Parent = workspace
	
	local Kids = Cur:GetChildren( )
	
	if Selected.Name == "Easy" then
		
		Payload.PassiveCapture = 5
		VaultPoint.PassiveCapture = 5 
		CorePoint.PassiveCapture = 5
		workspace.OutpostBridge.CanCollide=true
		workspace.OutpostBridge.Transparency=0
		
	elseif Selected.Name == "Normal" then
		
		Payload.PassiveCapture = 3
		VaultPoint.PassiveCapture = 3
		CorePoint.PassiveCapture = 3
		workspace.OutpostBridge.CanCollide=false
		workspace.OutpostBridge.Transparency=1
		
	else
		
		Payload.PassiveCapture = 2
		VaultPoint.PassiveCapture = 2
		CorePoint.PassiveCapture = 2
		workspace.OutpostBridge.CanCollide=false
		workspace.OutpostBridge.Transparency=1
					
	end
	
end

ChangeDifficulty( ServerStorage.RaidLibDifficulties.Normal )

RaidLib.SetGameMode{  --SetGameMode later on
	
	Function = RaidLib.GameModeFunctions.TimeBased,
	
	WinTime = 0, -- 25 minutes holding all capturepoints to win the raid
	
	RollbackSpeed = 4, -- How much the win timer rolls back per second when home owns the points
	
	WinSpeed = 1, -- How much the win timer goes up per second when away owns the points
	
	ExtraTimeForCapture = 60 * 10, -- The amount of extra time added onto the raid timer when a point is captured/a payload reaches its end
	
	ExtraTimeForCheckpoint = 0, -- The amount of extra time added onto the raid timer when a payload reaches a checkpoint
	
}
repeat wait( ) until _G.VH_AddExternalCmds

local Easy, Normal, Hard = { [ "easy" ] = true, [ "e" ] = true, [ "-1" ] = true, [ "-" ] = true }, { [ "normal" ] = true, [ "n" ] = true, [ "0" ] = true }, { [ "hard" ] = true, [ "h" ] = true, [ "1" ] = true, [ "+" ] = true }

_G.VH_AddExternalCmds( function ( Main )
	
	Main.Commands[ "Difficulty" ] = {
		
		Alias = { "difficulty", "setdifficulty", "dif" },
		
		Description = "Sets the difficulty of the raid",
		
		CanRun = "$moderator, $debugger",
		
		Category = "raid",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 ):lower( )
			
			return ( String == Main.TargetLib.ValidChar or Easy[ String ] ) and ServerStorage.RaidLibDifficulties.Easy or Normal[ String ] and ServerStorage.RaidLibDifficulties.Normal or Hard[ String ] and ServerStorage.RaidLibDifficulties.Hard or nil
			
		end, Name = "easy_normal_hard", Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if RaidLib.RaidStart then return false, "Cannot change difficulty once raid has started" end
			
			if Args[ 1 ].Name == Cur.Name then return false, "Already " .. Args[ 1 ].Name end
			
			ChangeDifficulty( Args[ 1 ] )
			
			return true
			
		end
		
	}
	
end )