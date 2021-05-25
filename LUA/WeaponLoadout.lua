local TweenService = game.TweenService
local Core = require(game:GetService("ReplicatedStorage"):WaitForChild("S2"):WaitForChild("Core"))
local Player = game.Players.LocalPlayer
local starterGui = game.StarterGui
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local MouseMove, Spin

local LoadoutFrame = script.Parent.LoadoutFrame
local ContentScreen = LoadoutFrame.ContentScreen
local InformationScreen = LoadoutFrame.Information
local MenuControls = LoadoutFrame.MenuControls

--Frames to show & load
local ClassMenu = ContentScreen.ClassMenu
local MainMenu = ContentScreen.MainMenu
local PowerupMenu = ContentScreen.PowerupMenu
local WeaponMenuP = ContentScreen.WeaponMenuP
local WeaponMenuS = ContentScreen.WeaponMenuS

--Pcall
local function HandleRbxAsync(DefaultValue, Function, ...)
    local Result = {pcall(Function, ...)}
    if Result[1] then
        return select(2, unpack(Result))
    else
        warn(Result[2] .. "\n" .. debug.traceback(nil,2))
        return DefaultValue
    end
end

--'Intro' stuff
local EnabledGuis = {}
local Pictures = {
	[1] = {
			Name="TRA";
			Image="rbxassetid://3333217330";
			ImageColor=Color3.fromRGB(85,170,127);
			BackgroundColor=Color3.fromRGB(30,30,30)
	};
}
local Interval=1
local Background = script.Parent.Background
local MenuMusic = script.Parent.MenuMusic

local Cameras = game.Workspace.CameraPositions.MenuCamera

--'Home' & deploy button
local menuButton = MenuControls.menuButton

--SFX
local clickSound = script.Parent.Click

repeat wait() until Player:FindFirstChild("Class")
local Class = Player.Class.Value
InformationScreen.ClassTXT.Text=string.upper(Class)

--Player information
local TRARank = HandleRbxAsync( 0, Player.GetRankInGroup, Player, 165491 )
local EliteRank = HandleRbxAsync( 0, Player.GetRankInGroup, Player, 186633 )
local ValkRank = HandleRbxAsync( 0, Player.GetRankInGroup, Player, 4621565 )

if TRARank>0 then
	local TRARole = HandleRbxAsync( "Soldier", Player.GetRoleInGroup, Player, 165491) 
	InformationScreen.PlayerName.Text=string.upper(TRARole).. " "..string.upper(Player.Name)
else
	InformationScreen.PlayerName.Text=string.upper(Player.Name)
end

if EliteRank>1 then
	InformationScreen.Units.Elite.Visible=true
end
if ValkRank>0 then
	InformationScreen.Units.Valkyrie.Visible=true
end

local function buttonEquipped(button)
	if button:IsA("GuiButton") then
		clickSound:Play()
		TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255,255,255) }):Play()
		TweenService:Create(button.ImageLabel, TweenInfo.new(0.2), { ImageTransparency=0 }):Play()
	end
end

local function buttonUnequipped(button)
	if button:IsA("GuiButton") then
		TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0,0,0) }):Play()
		TweenService:Create(button.ImageLabel, TweenInfo.new(0.2), { ImageTransparency=1 }):Play()
	end
end

--indev new

local ClassList = {
	Assault = {
		Name = "Assault",
		Icon = "rbxassetid://4697462258",
		Description= "Assault Teams are tasked to inflict serious damage towards their opponents on the battlefield. They are versatile and therefore a popular choice.",
		Traits = {
			--traitless
		},	
	},
	
	Juggernaut = {
		Name = "Juggernaut",
		Icon = "rbxassetid://4697462394",
		Description= "Juggernaut Units are durable forces that crush whatever is in their path. This brute force allows your team to siege key locations.",
		Traits = {
			Colossus = {
				Name = "Colossus",
				Icon = "rbxassetid://3570718660",
				Description="+50% character size, -2 walkspeed"
			},
			Kevlar = {
				Name = "Kevlar",
				Icon = "rbxassetid://3570718660",
				Description="30% kinetic resistance"
			},
			Dermal = {
				Name = "Dermal",
				Icon = "rbxassetid://3570718660",
				Description="65% explosive resistance"
			},
			Tough = {
				Name = "Tough",
				Icon = "rbxassetid://3570718660",
				Description="+30 health"
			}
		},	
	},
	
	Medic = {
		Name = "Medic",
		Icon = "rbxassetid://4697462500",
		Description= "Medics are capable of turning the tide in prolonged fights by providing strong sustainability. They are most effective when grouped with their team.",
		Traits = {
			Fragile = {
				Name = "Fragile",
				Icon = "rbxassetid://3570718660",
				Description="-35 health"
			},
			Hasted = {
				Name = "Hasted",
				Icon = "rbxassetid://3570718660",
				Description="+2 walkspeed"
			},
		},	
	},
	
	Sapper = {
		Name = "Sapper",
		Icon = "rbxassetid://4697462600",
		Description= "Sappers are technical masterminds with access to strong utility tools. They provide their team tactical advantages.",
		Traits = {
			Fragile = {
				Name = "Fragile",
				Icon = "rbxassetid://3570718660",
				Description="-30 health"
			},
		},	
	},
	
	Tracker = {
		Name = "Tracker",
		Icon = "rbxassetid://4697462712",
		Description= "Trackers are recon units used to scout ahead and eliminate single targets. They focus key-targets and often hunt alone.",
		Traits = {
			Fragile = {
				Name = "Fragile",
				Icon = "rbxassetid://3570718660",
				Description="-50 health"
			},
		},
	},
		
}



--old

--[[
local ClassList = {"Assault", "Juggernaut", "Medic", "Sapper", "Tracker"}
local ClassListDescription = {	
	"Assault Teams are tasked to inflict serious damage towards their opponents on the battlefield. They are versatile and therefore a popular choice.",
	"Juggernaut Units are durable forces that crush whatever is in their path. This brute force allows your team siege key locations.",
	"Medics are capable of turning the tide in prolonged fights by providing strong sustainability. They are most effective when grouped with their team.",
	"Sappers are technical masterminds with access to strong utility tools. They provide their team tactical advantages.",
	"Trackers are recon units used to scout ahead and eliminate single targets. They focus key-targets and often hunt alone."
}
]]

local PowerupFolder = game.ReplicatedStorage:WaitForChild("Powerups")
local Current, CurrentN = Class, 1 --todo
local Primaries = {}
local Secondaries = {}
local Primary, Secondary, Powerup

local function setClass(param)
	game.ReplicatedStorage.SetClass:FireServer(param)
	InformationScreen.ClassTXT.Text=string.upper(param)
end

local function setupWeaponStats(WeaponMenu, Data, Item)
	if Item then
		WeaponMenu.StatisticsFrame.Content.information.weaponName.Text=Item
	end
	
	if Data then
		if Data.Description then
			WeaponMenu.StatisticsFrame.Content.information.weaponDescription.Text=Data.Description
		elseif Data.WeaponModes then
			WeaponMenu.StatisticsFrame.Content.information.weaponDescription.Text=Data.WeaponModes[1]
		end
		
		if Data.Damage then
			WeaponMenu.StatisticsFrame.Content.statistics.Damage.TextLabel.Text = Data.Damage > 0 and "DAMAGE" or "HEALING"	
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Damage.bar.innerBar, TweenInfo.new(0.5), { Size=UDim2.new(math.clamp(math.abs(Data.Damage),0,100)/100,0,1,0) }):Play()
		end
		if Data.FireRate then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Rate.bar.innerBar, TweenInfo.new(0.5),{ Size=UDim2.new(math.clamp(Data.FireRate,0,20)/20,0,1,0) }):Play()
		end
		if Data.ClipSize then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Ammo.bar.innerBar, TweenInfo.new(0.5),{ Size=UDim2.new(math.clamp(Data.ClipSize or 100,0,90)/90,0,1,0) }):Play()
		end
		if Data.ReloadDelay then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Reload.bar.innerBar, TweenInfo.new(0.5),{ Size=UDim2.new(1 - (math.clamp(Data.ReloadDelay,0,4)/4),0,1,0) }):Play()
		end
		if Data.AccurateRange then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Accuracy.bar.innerBar, TweenInfo.new(0.5),{ Size=UDim2.new(math.clamp(Data.AccurateRange,0,500)/500,0,1,0) }):Play()	
		end		
	end	
end

local function setupWeaponStatsCompare(WeaponMenu,Data,EquippedData)
	if EquippedData and Data and WeaponMenu then
		if Data.Damage and EquippedData.Damage then		
			if Data.Damage >= EquippedData.Damage then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Damage.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(math.clamp(math.abs(Data.Damage),0,100)/100,0,1,0) }):Play()
			else
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Damage.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new((Data.Damage-EquippedData.Damage)/100,0,1,0), Position=UDim2.new(math.abs(EquippedData.Damage)/100,0,0,0) }):Play()
			end	
		end
		
		if Data.ClipSize and EquippedData.ClipSize then
			if Data.ClipSize >= EquippedData.ClipSize then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Ammo.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(math.clamp(Data.ClipSize or 100,0,90)/90,0,1,0) }):Play()
			else
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Ammo.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new((Data.ClipSize-EquippedData.ClipSize)/90,0,1,0), Position=UDim2.new(EquippedData.ClipSize/90,0,0,0) }):Play()
			end	
		end
		
		if Data.FireRate and EquippedData.FireRate then
			if Data.FireRate >= EquippedData.FireRate then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Rate.bar.compareHigherBar, TweenInfo.new(0),{ Size=UDim2.new(math.clamp(Data.FireRate,0,20)/20,0,1,0) }):Play()
			else
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Rate.bar.compareLowerBar, TweenInfo.new(0),{ Size=UDim2.new((Data.FireRate-EquippedData.FireRate)/20,0,1,0), Position=UDim2.new(EquippedData.FireRate/20,0,0,0) }):Play()
			end
		end
		
		if Data.ReloadDelay and EquippedData.ReloadDelay then
			if Data.ReloadDelay <= EquippedData.ReloadDelay then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Reload.bar.compareHigherBar, TweenInfo.new(0),{ Size=UDim2.new(1 - (math.clamp(Data.ReloadDelay,0,4)/4),0,1,0)}):Play()
			else
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Reload.bar.compareLowerBar, TweenInfo.new(0),{ Size=UDim2.new(((EquippedData.ReloadDelay-Data.ReloadDelay)/4),0,1,0), Position=UDim2.new(1 - (EquippedData.ReloadDelay/4),0,0,0) }):Play()
			end		
		end
			
		if Data.AccurateRange and EquippedData.AccurateRange then
			if Data.AccurateRange >= EquippedData.AccurateRange then
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Accuracy.bar.compareHigherBar, TweenInfo.new(0),{ Size=UDim2.new(math.clamp(Data.AccurateRange,0,500)/500,0,1,0) }):Play()
			else
			TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Accuracy.bar.compareLowerBar, TweenInfo.new(0),{ Size=UDim2.new((Data.AccurateRange-EquippedData.AccurateRange)/500,0,1,0), Position=UDim2.new(EquippedData.AccurateRange/500,0,0,0) }):Play()
			end		
		end
		
	end
end

local function resetWeaponStatsCompare(WeaponMenu)
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Damage.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Damage.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()

	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Rate.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Rate.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Ammo.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Ammo.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Reload.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Reload.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Accuracy.bar.compareHigherBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(WeaponMenu.StatisticsFrame.Content.statistics.Accuracy.bar.compareLowerBar, TweenInfo.new(0), { Size=UDim2.new(0,0,1,0), Position=UDim2.new(0,0,0,0)}):Play()
end

local function setupWeaponVPF(Model, VPF)
	local ItemTool = Model:Clone()
	local ItemModel = Instance.new("Model")
	ItemModel.Parent = VPF.RotateButton
	ItemTool.Parent = ItemModel
	
	if ItemTool:FindFirstChild("Handle") then
		ItemModel.PrimaryPart = ItemTool.Handle
	elseif ItemTool.Name=="Display" then
		ItemModel.PrimaryPart = ItemTool
	end
	
	ItemModel.PrimaryPart.CFrame = ItemModel.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(90),0)
	--[[
	if ItemModel:FindFirstChild("Display") then
		print("found display in itemmodel")
		ItemModel.Display.CFrame = ItemModel.Display.CFrame * CFrame.Angles(0,math.rad(90),0)
	end
	]]
	
	local Centre = Instance.new("Part")
	Centre.CFrame = ItemModel:GetModelCFrame()
	Centre.Transparency = 1
	Centre.Parent = ItemModel
	ItemModel.PrimaryPart = Centre
	
	local StartZoomDist = ItemModel:GetExtentsSize().magnitude
	local ZoomDist = StartZoomDist
	
	local VPFCam
	if VPF:FindFirstChild("Camera") then
		VPFCam = VPF.Camera
		for i,v in pairs(VPF.Camera:GetChildren()) do
			if v:IsA("Model") then
				v:Destroy()
			end
		end
	else
		VPFCam = Instance.new("Camera")
		VPFCam.Parent = VPF
		VPF.CurrentCamera=VPFCam
	end
	
	local CF, X, Y = ItemModel.PrimaryPart.CFrame, 0, 0
	
	ItemModel.Parent = VPFCam
	ItemModel:SetPrimaryPartCFrame(CF)
	VPFCam.CFrame = CFrame.new(CF.p + CF.lookVector * ZoomDist, CF.p)
	
	VPF.RotateButton.MouseButton1Down:Connect(function()
		if not MouseMove then
			if Spin then
				Spin:Disconnect()
			end

			local LastPos
			MouseMove = UserInputService.InputChanged:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					if LastPos then
						local Delta = LastPos - Input.Position
						X, Y = X + -Delta.X, Y + Delta.Y
						if ItemModel.PrimaryPart then
							ItemModel:SetPrimaryPartCFrame(CF * CFrame.fromOrientation(0, math.rad(X), math.rad(Y)))
						end
					end 
					LastPos = Input.Position
				end
				if Input.UserInputType == Enum.UserInputType.MouseWheel then
					if Input.Position.Z > 0 then
						if ZoomDist<StartZoomDist*5 then
							ZoomDist=ZoomDist+StartZoomDist*0.05
						end	
					elseif ZoomDist>StartZoomDist*0.5 then
						ZoomDist=ZoomDist-StartZoomDist*0.05
					end
					VPFCam.CFrame = CFrame.new(CF.p + CF.lookVector * ZoomDist, CF.p)
				end
			end)

			local MouseUp MouseUp = UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					MouseMove = MouseMove:Disconnect()
					MouseUp:Disconnect()
					if LastPos then
						local Delta = LastPos - Input.Position
						local DeltaX, DeltaY = -Delta.X, Delta.Y
						local OGX, OGY = DeltaX, DeltaY
						Spin = game["Run Service"].Heartbeat:Connect(function(delta)
							DeltaX, DeltaY = (math.sign(DeltaX) == 1 and math.max or math.min)(DeltaX - math.sqrt(math.abs(OGX)) * math.sign(DeltaX) * 2 * delta, 0), (math.sign(DeltaY) == 1 and math.max or math.min)(DeltaY - math.sqrt(math.abs(OGY)) * math.sign(DeltaY) * 2 * delta, 0)
							X, Y = X + DeltaX, Y + DeltaY
							if ItemModel.PrimaryPart then
								ItemModel:SetPrimaryPartCFrame(CF * CFrame.fromOrientation(0, math.rad(X), math.rad(Y)))
							end
				
							if X == 0 and Y == 0 then Spin:Disconnect() end
						end)
					end
				end
			end)
		end
	end)
end

local function setupWeaponVPFmenu(Model, VPF)
	local ItemTool = Model:Clone()
	local ItemModel = Instance.new("Model")
	ItemModel.Parent = VPF
	ItemTool.Parent = ItemModel
	
	if ItemTool:FindFirstChild("Handle") then
		ItemModel.PrimaryPart = ItemTool.Handle
	elseif ItemTool.Name=="Display" then
		ItemModel.PrimaryPart = ItemTool
	elseif ItemTool:FindFirstChild("Display") then
		ItemModel.PrimaryPart = ItemTool.Display
		ItemTool.Display.Transparency=0
	end
	
	ItemModel.PrimaryPart.CFrame = ItemModel.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(-90),0)
	
	local Centre = Instance.new("Part")
	Centre.CFrame = ItemModel:GetModelCFrame()
	Centre.Transparency = 1
	Centre.Parent = ItemModel
	ItemModel.PrimaryPart = Centre
	
	local StartZoomDist = ItemModel:GetExtentsSize().magnitude
	local ZoomDist = StartZoomDist/2.5
	
	local VPFCam
	if VPF:FindFirstChild("Camera") then
		VPFCam = VPF.Camera
		for i,v in pairs(VPF.Camera:GetChildren()) do
			if v:IsA("Model") then
				v:Destroy()
			end
		end
	else
		VPFCam = Instance.new("Camera")
		VPFCam.Parent = VPF
		VPF.CurrentCamera=VPFCam
	end
	
	local CF, X, Y = ItemModel.PrimaryPart.CFrame, 0, 0
	
	ItemModel.Parent = VPFCam
	ItemModel:SetPrimaryPartCFrame(CF)
	VPFCam.CFrame = CFrame.new(CF.p + CF.lookVector * ZoomDist, CF.p)
	
	local White = true
	if White then
   		VPF.Ambient = Color3.new(255, 255, 255)
    	VPF.LightColor = Color3.new(0, 0, 0)
   		for _, Obj in ipairs(Model:GetDescendants()) do
        	if Obj:IsA("BasePart") then
          		Obj.Material = Enum.Material.SmoothPlastic
            	Obj.Color = Color3.new(1, 1, 1)
        	elseif Obj:IsA("SpecialMesh") then
            	Obj.TextureId = ""
        	end
    	end
	else
    	VPF.Ambient = Color3.new(0, 0, 0)
    	VPF.LightColor = Color3.new(0, 0, 0)
	end
end

local function handleClassData()
	MainMenu.ListFrame.classSelection.labelSelection.Text=Class
	MainMenu.ListFrame.classSelection.Image.Image=ClassList[Class].Icon
	ClassMenu.informationFrame.Content.information.classN.Text=Class
	ClassMenu.informationFrame.Content.information.classDescription.Text=ClassList[Class].Description
	ClassMenu.informationFrame.Content.information.ImageLabel.Image=ClassList[Class].Icon
			
	for _,v in pairs(ClassMenu.informationFrame.Content.traits:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
			
	for i,v in pairs(ClassList[Class].Traits) do
		local trait = script.trait:Clone()
		trait.ImageLabel.Image=v.Icon
		trait.traitDescription.Text=v.Description
		trait.traitName.Text=v.Name
		trait.Parent = ClassMenu.informationFrame.Content.traits
	end
end


local function loadClassData()
	--Clear list first
	for i,v in pairs(ClassMenu.ListFrame:GetChildren()) do
		if v:IsA("GuiButton") then
			v:Destroy()
		end
	end
	
	--Setup list
	for i,v in pairs(ClassList) do
		local item = script.menuItem:Clone()
		item.Name = v.Name
		item.itemName.Text = v.Name
		item.Parent = ClassMenu.ListFrame
		if Player:FindFirstChild("Class") then
			if Player.Class.Value == v.Name then
				buttonEquipped(item)	
			end
		end
		
		--On item click
		item.MouseButton1Click:Connect(function()
			setClass(item.Name) --call function to change class
			Class = item.Name
			
			handleClassData()
			--[[
			--'Unequipped' state for all button
			for i,v in pairs(ClassMenu.ListFrame:GetChildren()) do
				buttonUnequipped(v)
			end
			--'Equipped' state for selection button
			buttonEquipped(item)
			]]
		end)
	end

end


local function loadPowerupData()
	--Clear list first
	for i,v in pairs(PowerupMenu.ListFrame:GetChildren()) do
		if v:IsA("GuiButton") then
			v:Destroy()
		end
	end
	
	--Setup list
	for i,v in pairs(PowerupFolder[Class]:GetChildren()) do
		local item = script.menuItem:Clone()
		item.Name = v.Name
		item.itemName.Text = v.Name
		item.Parent = PowerupMenu.ListFrame
		
		local PowerupModule = PowerupFolder[Class][Powerup]		
		local Data = require(PowerupModule)
		
		if tostring(v)==(Powerup) then
			buttonEquipped(item)
			
			setupWeaponVPF(PowerupFolder[Class][Powerup].Display,PowerupMenu.ViewportFrame)
			
			PowerupMenu.StatisticsFrame.Content.information.weaponName.Text=item.Name
			PowerupMenu.StatisticsFrame.Content.information.weaponDescription.Text=Data.Description
			PowerupMenu.StatisticsFrame.Content.information.ImageLabel.Image="rbxassetid://"..Data.Icon
			MainMenu.ListFrame.powerupSelection.Image.Image="rbxassetid://"..Data.Icon
		end
		
		--On item click
		item.MouseButton1Click:Connect(function()
			repeat wait() until _G.SelectPowerup
			Powerup = item.Name
			
			local PowerupModule = PowerupFolder[Class][Powerup]		
			local Data = require(PowerupModule)
			
			setupWeaponVPF(PowerupFolder[Class][Powerup].Display,PowerupMenu.ViewportFrame)
			
			PowerupMenu.StatisticsFrame.Content.information.weaponName.Text=item.Name
			PowerupMenu.StatisticsFrame.Content.information.weaponDescription.Text=Data.Description
			PowerupMenu.StatisticsFrame.Content.information.ImageLabel.Image="rbxassetid://"..Data.Icon
			
			_G.SelectPowerup(Powerup)
			--'Unequipped' state for all button
			for i,v in pairs(PowerupMenu.ListFrame:GetChildren()) do
				buttonUnequipped(v)
			end
			--'Equipped' state for selection button
			buttonEquipped(item)
			MainMenu.ListFrame.powerupSelection.labelSelection.Text=Powerup
			MainMenu.ListFrame.powerupSelection.Image.Image="rbxassetid://"..Data.Icon
		
		end)
	end
end	
	
local function loadPrimaryData()
	--Clear list first
	for i,v in pairs(WeaponMenuP.ListFrame:GetChildren()) do
		if v:IsA("GuiButton") then
			v:Destroy()
		end
	end
	
	local EquippedData
	
	--Setup list
	for i,v in pairs(Primaries) do
		--Fetch gun information
		local StatObj = Core.FindWeaponStat(game.ReplicatedStorage.Weapons:FindFirstChild(v, true))
		if not StatObj then return end
		
		local Data = Core.GetWeaponStats(StatObj)
		local Weapon = game.ReplicatedStorage.Weapons:FindFirstChild(v, true)
		if Weapon:IsA("Folder") then
			Weapon = Weapon:FindFirstChild(v, true)
		end
		if not Data or not Weapon then
			return
		end
		
		local item = script.menuItem:Clone()
		item.Name = v
		item.itemName.Text = v
		item.Parent = WeaponMenuP.ListFrame
		
		if v==Primary then
			--button behaviour
			buttonEquipped(item)
			EquippedData = Data
				
			--statistics
			setupWeaponStats(WeaponMenuP, Data, v)		
				
			--viewportFrame
			setupWeaponVPF(Weapon,WeaponMenuP.ViewportFrame)
			setupWeaponVPFmenu(Weapon,MainMenu.ListFrame.primarySelection.ViewportFrame)
			
		end
		
		--On item click
		item.MouseButton1Click:Connect(function()
			if v~=Primary then
				Primary = v
			end
			
			EquippedData = Data
			
			--statistics
			setupWeaponStats(WeaponMenuP, Data, v)	
			
			--ViewportFrame
			setupWeaponVPF(Weapon,WeaponMenuP.ViewportFrame)
			setupWeaponVPFmenu(Weapon,MainMenu.ListFrame.primarySelection.ViewportFrame)
						
			game.ReplicatedStorage.SelectWeapon:FireServer(Primary, true)
			
			--'Unequipped' state for all button
			for i,v in pairs(WeaponMenuP.ListFrame:GetChildren()) do
				buttonUnequipped(v)
			end
			--'Equipped' state for selection button
			buttonEquipped(item)
				
			MainMenu.ListFrame.primarySelection.labelSelection.Text=Primary
			resetWeaponStatsCompare(WeaponMenuP)
		end)
		
		item.MouseEnter:Connect(function()
			if Data~=EquippedData then
				setupWeaponStatsCompare(WeaponMenuP,Data,EquippedData)
			end
		end)
		
		item.MouseLeave:Connect(function()
			resetWeaponStatsCompare(WeaponMenuP)
		end)
	end
end	

local function loadSecondaryData()
	--Clear list first
	for i,v in pairs(WeaponMenuS.ListFrame:GetChildren()) do
		if v:IsA("GuiButton") then
			v:Destroy()
		end
	end
	
	local EquippedData
	
	--Setup list
	for i,v in pairs(Secondaries) do
		--Fetch gun information
		local StatObj = Core.FindWeaponStat(game.ReplicatedStorage.Weapons:FindFirstChild(v, true))
		if not StatObj then return end
		
		local Data = Core.GetWeaponStats(StatObj)
		local Weapon = game.ReplicatedStorage.Weapons:FindFirstChild(v, true)
		if Weapon:IsA("Folder") then
			Weapon = Weapon:FindFirstChild(v, true)
		end
		if not Data or not Weapon then
			return
		end
		
		local item = script.menuItem:Clone()
		item.Name = v
		item.itemName.Text = v
		item.Parent = WeaponMenuS.ListFrame
		
		if v==Secondary then
			buttonEquipped(item)
			
			EquippedData=Data
			
			--statistics
			setupWeaponStats(WeaponMenuS, Data, v)	
			--viewportFrame
			setupWeaponVPF(Weapon,WeaponMenuS.ViewportFrame)
			setupWeaponVPFmenu(Weapon,MainMenu.ListFrame.secondarySelection.ViewportFrame)
			
		end
		
		--On item click
		item.MouseButton1Click:Connect(function()
			if v~=Secondary then
				Secondary = v
			end
			
			EquippedData=Data
		
			--statistics
			setupWeaponStats(WeaponMenuP, Data, v)	
			
			--viewportFrame
			setupWeaponVPF(Weapon,WeaponMenuS.ViewportFrame)
			setupWeaponVPFmenu(Weapon,MainMenu.ListFrame.secondarySelection.ViewportFrame)
				
			game.ReplicatedStorage.SelectWeapon:FireServer(Secondary, false)
			
			--'Unequipped' state for all button
			for i,v in pairs(WeaponMenuS.ListFrame:GetChildren()) do
				buttonUnequipped(v)
			end
			--'Equipped' state for selection button
			buttonEquipped(item)
			MainMenu.ListFrame.secondarySelection.labelSelection.Text=Secondary
			resetWeaponStatsCompare(WeaponMenuS)
		end)
		
		item.MouseEnter:Connect(function()
			if Data~=EquippedData then
				setupWeaponStatsCompare(WeaponMenuS,Data,EquippedData)
			end
		end)
		
		item.MouseLeave:Connect(function()
			resetWeaponStatsCompare(WeaponMenuS)
		end)
	end
end	
	
local function IsInTable(Name, Table)
	for _, v in pairs(Table) do
		if v == Name then
			return true
		end
	end
end
	
local function classChanged()
	loadClassData()
	
	repeat wait() until _G.ClassWeapons
	
	Primaries = {}
	
	repeat wait() until game.ReplicatedStorage:FindFirstChild("Weapons")
	
	for _, v in pairs(game.ReplicatedStorage.Weapons:WaitForChild("Primary"):GetChildren()) do
		if IsInTable(v.Name, _G.ClassWeapons[Class].Primary) then
			for _, x in pairs(v:GetChildren()) do
				Primaries[#Primaries + 1] = x.Name
			end
		end
	end
	if #Primaries == 0 then
		for _, v in pairs(game.ReplicatedStorage.Weapons.Secondary:GetChildren()) do
			if IsInTable(v.Name, _G.ClassWeapons[Class].Primary) then
				for _, x in pairs(v:GetChildren()) do
					Primaries[#Primaries + 1] = x.Name
				end
			end
		end
	end
	
	Secondaries = {}
	for _, v in pairs(game.ReplicatedStorage.Weapons.Secondary:GetChildren()) do
		if IsInTable(v.Name, _G.ClassWeapons[Class].Secondary) then
			for _, x in pairs(v:GetChildren()) do
				Secondaries[#Secondaries + 1] = x.Name
			end
		end
	end
	
	local Powerups = PowerupFolder[Class]:GetChildren()
	Powerup = Powerups[1].Name
	repeat wait() until _G.SelectPowerup
	_G.SelectPowerup(Powerup)
	loadPowerupData()
	
	Primary = Primaries[1]
	Secondary = Secondaries[1]
	
	if Primary~=nil then
		game.ReplicatedStorage.SelectWeapon:FireServer(Primary, true)
	end
	
	if Secondary~=nil then
		game.ReplicatedStorage.SelectWeapon:FireServer(Secondary, false)
	end
	
	loadPrimaryData()
	loadSecondaryData()
	
	if Class~=nil then
		MainMenu.ListFrame.classSelection.labelSelection.Text=Class
	end
	
	if Powerup~=nil then
		MainMenu.ListFrame.powerupSelection.labelSelection.Text=Powerup
	end
	
	if Primary~=nil then
		MainMenu.ListFrame.primarySelection.labelSelection.Text=Primary
	end
	
	if Secondary~=nil then
		MainMenu.ListFrame.secondarySelection.labelSelection.Text=Secondary
	end
	
end



--Navigation through the menus & events
local function leaveLoadout()
	if LoadoutFrame.Visible then
		
	local tweenIn = TweenService:Create(Background, TweenInfo.new(0.25), { BackgroundColor3=Color3.fromRGB(27,42,53), BackgroundTransparency=0 })
	local tweenMusicOut = TweenService:Create(MenuMusic, TweenInfo.new(5), { Volume=0 })
	tweenMusicOut:Play()
	tweenIn:Play()
	tweenIn.Completed:wait()
	
	game.ReplicatedStorage.DeployPlayer:FireServer()
	
	Camera.FieldOfView = 70
	Camera.CameraType = Enum.CameraType.Custom
	--Camera.CameraSubject = Player:WaitForChild("Character").Humanoid
	
	LoadoutFrame.Visible=false
	
	for _,v in pairs(EnabledGuis) do
		for _,k in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
			if k:IsA("ScreenGui") and k.Name==v then
			k.Enabled=true
			end
		end
	end
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	EnabledGuis = { } --clear list
	
	TweenService:Create(Background, TweenInfo.new(5), { BackgroundTransparency=1 }):Play()
	
	if game.Lighting:FindFirstChild("Blur_UI") then
		TweenService:Create(game.Lighting.Blur_UI, TweenInfo.new(5), { Size = 0 }):Play()
	end
	tweenMusicOut.Completed:wait()
	MenuMusic:Stop()
		
	end
	
end

local function enterLoadout()
	
	for i,v in ipairs(Pictures) do
		local PicFrame = script.PictureFrame:Clone()
		PicFrame.Name=v.Name
		PicFrame.ZIndex=i
		PicFrame.Parent=Background
		
		for j,k in pairs(PicFrame:GetChildren()) do
			if k:IsA("ImageLabel") then
				k.ZIndex=i
				k.Image=v.Image
				k.ImageColor3=v.ImageColor
			end
		end	
		
		local MusicList = {
			"rbxassetid://1839808529", --Intense Strings
			"rbxassetid://1839809225", --Dramatic Time
			"rbxassetid://1839809310", --Timeless Strings
			"rbxassetid://1839809025", --Stirring Strings
			"rbxassetid://1839808944", --Poignant Strings
			"rbxassetid://1839808697", --Majestic Strings
			"rbxassetid://1839808166", --Baroque Strings
			"rbxassetid://1839808568", --Flying Strings
		}
		
		local MusicPitch = {
			0.87, --Intense Strings
			0.93, --Dramatic Time
			1.02, --Timeless Strings
			0.92, --Stirring Strings
			0.97, --Poignant Strings
			0.95, --Majestic Strings
			0.89, --Baroque Strings
			0.95, --Flying Strings
		}
		
		local chosenIndex = math.random(1,#MusicList)
		local chosenSong = MusicList[chosenIndex]
		local chosenPitch = MusicPitch[chosenIndex]
		
		MenuMusic.SoundId=chosenSong
		MenuMusic.PlaybackSpeed=chosenPitch

		TweenService:Create(Background, TweenInfo.new(0.25), { BackgroundColor3=v.BackgroundColor, BackgroundTransparency=0 }):Play()
		MenuMusic:Play()
		TweenService:Create(MenuMusic, TweenInfo.new(5), { Volume=0.15 }):Play()
		
		if v.Name=="TRA" then
			
			local TweenFrameOut = TweenService:Create(PicFrame, TweenInfo.new(Interval*1.3), { Size=UDim2.new(1,0,1,0) })
			TweenFrameOut:Play()
			local LargeTween = TweenService:Create(PicFrame.LargeImage, TweenInfo.new(Interval*0.5), { ImageTransparency=0.95 })
			LargeTween:Play()
			TweenService:Create(PicFrame.SmallImage, TweenInfo.new(Interval*0.5), { ImageTransparency=0, Size=UDim2.new(0.5,0,0.5,0) }):Play()
			LargeTween.Completed:wait()
			wait(0.5)
			TweenService:Create(PicFrame.LargeImage, TweenInfo.new(Interval*0.75), { ImageTransparency=1 }):Play()
			wait(Interval)		
			-----------
			LoadoutFrame.Visible=true
			--todo camera
			local Cam = Cameras:GetChildren()[math.random(1, #Cameras:GetChildren())]
			Camera.FieldOfView = 35
			Camera.CameraType = Enum.CameraType.Scriptable
			Camera.CFrame=Cam.CFrame
			if game.Lighting:FindFirstChild("Blur_UI") then
				game.Lighting.Blur_UI.Size=10
			end
			
			
			--Hide UIs
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
				if v:IsA("ScreenGui") and v.Enabled==true and v.Name~=script.Parent.Name and v.Name~="LoadingScreen" then
					v.Enabled=false
					table.insert(EnabledGuis, i, v.Name)
				end	
			end
			
			TweenService:Create(PicFrame.SmallImage, TweenInfo.new(Interval*0.25), { ImageTransparency=0 }):Play()
			TweenService:Create(PicFrame.loadingBar, TweenInfo.new(0.5), { Size = UDim2.new(0.2,0,0,3), BackgroundTransparency=0}):Play()
			TweenService:Create(PicFrame.loadingText, TweenInfo.new(0.5), { TextTransparency=0}):Play()
			
			TweenService:Create(PicFrame.loadingBar, TweenInfo.new(0.5), { Size=UDim2.new(0,0,0,0) } ):Play()			
			local fadeTextOut = TweenService:Create(PicFrame.loadingText, TweenInfo.new(0.5), { TextTransparency=1 })
			fadeTextOut:Play()
			fadeTextOut.Completed:wait()
			
			local TweenImageOut = TweenService:Create(PicFrame.SmallImage, TweenInfo.new(0.5), { ImageTransparency=1 })
			TweenImageOut:Play()
			TweenImageOut.Completed:wait()
			TweenService:Create(Background, TweenInfo.new(0.5), { BackgroundTransparency=1 }):Play()
		else
			local semiInterval = Interval-(i*0.2)
			local TweenFrameOut = TweenService:Create(PicFrame, TweenInfo.new(semiInterval), { Size=UDim2.new(0,0,0,0) })
			TweenFrameOut:Play()
			TweenService:Create(PicFrame.LargeImage, TweenInfo.new(semiInterval/2), { ImageTransparency=0.95 }):Play()
			TweenService:Create(PicFrame.SmallImage, TweenInfo.new(semiInterval*0.05), {ImageTransparency=0 }):Play()
			wait(semiInterval*0.8)	
		end	
	end
	
	handleClassData()
end

local function menuIn(menuName)
	
	local menu = ContentScreen:FindFirstChild(menuName)
	
	if menu.Name~="MainMenu" then
		menu.Position=UDim2.new(1,0,0,0)
	else
		menu.Position=UDim2.new(-1,0,0,0)
	end
	
	if menu then
		
		for i,v in pairs(ContentScreen:GetChildren()) do
			if v.Name~=menu.Name then
				if v.Name=="MainMenu" then
					TweenService:Create(v,TweenInfo.new(0.5), { Position = UDim2.new(-1,0,0,0)}):Play()
				else
					TweenService:Create(v,TweenInfo.new(0.5), { Position = UDim2.new(1,0,0,0)}):Play()
				end
				--v.Visible=false
			end
		end
		
		--menu.Visible=true
		TweenService:Create(menu, TweenInfo.new(0.5), { Position = UDim2.new(0,0,0,0) }):Play()
		MenuControls.menuButton.labelName.Text="CONFIRM"
		MenuControls.menuButton.Image.Image="rbxassetid://4697463596"
		clickSound:Play()
	else
		warn(menuName.." not found [func menuIn]")
	end
end

local function homeButton()
	local isHome = false
	
	if menuButton.labelName.Text=="DEPLOY" then
		isHome=true
	end
	
	if isHome then
		leaveLoadout()
	else
		--return to main menu
		menuIn("MainMenu")
		MenuControls.menuButton.labelName.Text="DEPLOY"
		MenuControls.menuButton.Image.Image="rbxassetid://4697463691"
	end
end

game.ReplicatedStorage.SetLoadout.OnClientEvent:Connect(enterLoadout)

menuButton.MouseButton1Click:Connect(function()
	homeButton()
end)

MainMenu.ListFrame.classSelection.MouseButton1Click:Connect(function()
	menuIn("ClassMenu")
end)

MainMenu.ListFrame.powerupSelection.MouseButton1Click:Connect(function()
	menuIn("PowerupMenu")
end)

MainMenu.ListFrame.primarySelection.MouseButton1Click:Connect(function()
	menuIn("WeaponMenuP")
end)

MainMenu.ListFrame.secondarySelection.MouseButton1Click:Connect(function()
	menuIn("WeaponMenuS")
end)

Player.Class.Changed:Connect(function(Value)
	Class = Value
	classChanged()
end)

Player.CharacterAdded:Connect(function()
	leaveLoadout()
end)

--run on init
if Primary==nil or Secondary==nil or Class==nil or Powerup==nil then
	classChanged()
end

enterLoadout()
