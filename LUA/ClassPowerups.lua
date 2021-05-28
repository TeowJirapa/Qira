local Player = game.Players.LocalPlayer
local Core = require(game:GetService("ReplicatedStorage"):WaitForChild("S2"):WaitForChild("Core"))

local ClassWeapons = {
	
	Assault = {
		Primary = {"AssaultRifle"},
		Secondary = {"Revolver"}
	},
	Juggernaut = {
		Primary = {"MachineGun"},
		Secondary = {"Pistol"}
	},
	Medic = {
		Primary = {"Pistol","SMG"},
		Secondary = {"Healing"}
	},
	Sapper = {
		Primary = {"RPG","Shotgun"}, --Added Rotational to RPG folder, as it's too overpowered as GrenadeLauncher child (secondary)
		Secondary = {"Shotgun", "Revolver","GrenadeLauncher"}
	},
	Tracker = {
		Primary = {"Sniper"},
		Secondary = {"Pistol"}
	}
	
}
_G.ClassWeapons = ClassWeapons

local PowerupFolder = game.ReplicatedStorage:WaitForChild("Powerups")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local KeybindUtil = require (game:GetService("Players").LocalPlayer:WaitForChild( "PlayerScripts" ):WaitForChild("S2"):WaitForChild("KeybindUtil") )

repeat wait() until --[[Player.Character and]] Player:FindFirstChild("Class")

local UI = require(script.UI)
if Player.Character then
	UI.Create()
end

local Class = Player.Class.Value

local Powerup
local PowerupModule
local Data
local Primary, Secondary
local CanCancel, Cancelled = false, false

local function IsInTable(Name, Table)
	for _, v in pairs(Table) do
		if v == Name then
			return true
		end
	end
end

Player.Class.Changed:Connect(function(Value)
	Class = Value
end)
Player.ChildAdded:Connect(function(Child)
	if Child.Name == "Class" then
		Class = Child.Value
		Child.Changed:Connect(function(Value)
			Class = Value
		end)
	end
end)

local function IsAlive()
	return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0
end

-- Handle S2 BackpackState
local BackpackDisabled = false
function ChangeBackpackState(Disabled)
    if Disabled then
        BackpackDisabled=true
		UI.SetVisible(false)
    else
        BackpackDisabled=false
		UI.SetVisible(true)
    end
end

-- Select Powerup
local function SelectPowerup(Text, ModuleOverride)
	if not ModuleOverride and not PowerupFolder[Class]:FindFirstChild(Text) then
		SelectPowerup(PowerupFolder[Class]:GetChildren()[math.random(1, #PowerupFolder[Class]:GetChildren())].Name)
		return
	end
	if PowerupModule then
		game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, false)
		if PowerupModule:FindFirstChild("Client") then
			local ClientData = require(PowerupModule.Client)
			if ClientData.EndTrigger then
				ClientData.EndTrigger()
			end
		end
		PowerupModule = nil
	end
	
	_G.Powerup = Text
	Powerup = Text
	if ModuleOverride then
		PowerupModule = ModuleOverride
	else
		PowerupModule = PowerupFolder[Class][Powerup]
	end
	
	Data = require(PowerupModule)
	if Data.Type == "Passive" then
		game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, true)
		if PowerupModule:FindFirstChild("Client") then
			local ClientData = require(PowerupModule.Client)
			local Input = {}
			if ClientData.Input then
				for _, v in pairs(ClientData.Input) do
					Input[#Input + 1] = UI[v]
				end
			end
			spawn(function()
				if ClientData.Trigger then
					ClientData.Trigger(unpack(Input))
				end
			end)
		end
		UI.SetBarPercentage(1)
	end
	
	CanCancel, Cancelled = false, false

	UI.SetIcon(Data.Icon)
	UI.SetText(PowerupModule.Name)
end

game.ReplicatedStorage:WaitForChild("SetPowerup").OnClientEvent:Connect(function(Text)
	SelectPowerup(Text, PowerupFolder:FindFirstChild(Text, true))
end)
_G.SelectPowerup = SelectPowerup

local Active = false

-- Create and Hide UI
local SitLocked = false
local function RunCharacter(Character)
	--[[
	if UI.UI then
		UI.UI:Destroy()
	end
	]]
	if not UI.UI then
		UI.Create()
	end
	
	Character:WaitForChild("Humanoid")
	
	UI.SetVisible(true)
	
	if Powerup then
		SelectPowerup(Powerup)
	end
	Character.Humanoid.Died:Connect(function()
		Active = false
		if PowerupModule then
			game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, false)
			if PowerupModule:FindFirstChild("Client") then
				local ClientData = require(PowerupModule.Client)
				if ClientData.EndTrigger then
					ClientData.EndTrigger()
				end
			end
			PowerupModule = nil
		end
		--UI.Destroy()
	end)
	SitLocked = false
	Character.Humanoid.Seated:Connect(function(Sit)
		if UI and PowerupModule then
			Data = require(PowerupModule)
			if Sit and Data.NoSitting then
				UI.SetVisible(false)
				SitLocked = true
			else
				UI.SetVisible(true)
				SitLocked = false
			end
		end
	end)
	
	ChangeBackpackState(next(Core.DisableBackpack))
	Core.BackpackStateChanged.Event:Connect(ChangeBackpackState)
	
end

Player.CharacterAdded:Connect(RunCharacter)
if Player.Character then
	RunCharacter(Player.Character)
end

local ResetBindable = Instance.new("BindableEvent")
ResetBindable.Event:connect(function()
	if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		Player.Character.Humanoid.Health = 0
		Active = false
		if PowerupModule then
			game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, false)
			if PowerupModule:FindFirstChild("Client") then
				local ClientData = require(PowerupModule.Client)
				if ClientData.EndTrigger then
					ClientData.EndTrigger()
				end
			end
			PowerupModule = nil
		end
		UI.SetVisible(false)
		Cancelled=true
		UI.SetBarPercentage(1)
		wait()
		Cancelled=false
		--UI.Destroy()
	end
end)

while not success do
	success = pcall(function()
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", ResetBindable)
	end)
	if success then
		break
	end
	wait(.2)
end

-- Run Powerup
local function RunPowerup(Began)
	local Cache = Powerup
	if Began and Active and CanCancel then
		Cancelled = true
	end
	if Data.Type == "Active" and not Active and Began and IsAlive() and PowerupModule and not SitLocked and (BackpackDisabled==false) then
		Active = true
		
		local Args
		if PowerupModule:FindFirstChild("Client") then
			local ClientData = require(PowerupModule.Client)
			if ClientData.CanTrigger then
				Args = ClientData.CanTrigger(Player, Player.Character)
				if not Args then
					Active = false
					return
				end
			end
		end
		game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, true, Args)
		if PowerupModule:FindFirstChild("Client") then
			local ClientData = require(PowerupModule.Client)
			local Input = {}
			if ClientData.Input then
				for _, v in pairs(ClientData.Input) do
					Input[#Input + 1] = UI[v]
				end
			end
			spawn(function()
				if ClientData.Trigger then
					ClientData.Trigger(unpack(Input))
				end
			end)
		end
		
		UI.SetCancel(Data.CanCancel)
		if Data.CanCancel then
			delay(1.5, function()
				if Cache == Powerup then
					CanCancel, Cancelled = true, false
				end
			end)
		end
		
		if Data.Length then
			local Start = tick()
			local Point = 0
			UI.SetBarPercentage(1)
			repeat
				Point = tick() - Start
				UI.SetBarPercentage(1 - Point / Data.Length)
				wait()
			until Cache ~= Powerup or Point > Data.Length or Cancelled
			UI.SetBarPercentage(0)
		end
		
		CanCancel, Cancelled = false, false
		UI.SetCancel(false)
		
		if Cache ~= Powerup or not PowerupModule then
			Active = false
			return
		end
		
		game.ReplicatedStorage.RunPowerup:FireServer(PowerupModule, false)
		if PowerupModule:FindFirstChild("Client") then
			local ClientData = require(PowerupModule.Client)
			if ClientData.EndTrigger then
				ClientData.EndTrigger()
			end
		end
		
		if Data.Cooldown then
			local Start = tick()
			local Point = 0
			repeat
				Point = tick() - Start
				UI.SetBarPercentage(Point / Data.Cooldown)
				wait()
			until Cache ~= Powerup or Point > Data.Cooldown or Cancelled
		end
		
		if Cache ~= Powerup then
			Active = false
			return
		end
		
		Active = false
	end
end

UI.Callback = function()
	RunPowerup(true)
end

KeybindUtil.AddBind({Name = "Powerup", Category = "TRA", Callback = RunPowerup, Key = Enum.KeyCode.G, NoHandled = true})
UI.SetKeybind(KeybindUtil.GetKeyInContext("Powerup"))

KeybindUtil.ContextChanged:Connect(function()
	UI.SetKeybind(KeybindUtil.GetKeyInContext("Powerup"))
end)

KeybindUtil.BindChanged.Event:Connect( function ( Name )
	if Name == "Powerup" then
		UI.SetKeybind( KeybindUtil.GetKeyInContext( "Powerup" ) )		
	end
end )