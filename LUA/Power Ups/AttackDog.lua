local TweenService = game:GetService("TweenService")
local Core = require(game:GetService("ReplicatedStorage"):WaitForChild("S2"):WaitForChild("Core"))

local Active = {}
local Dogs = {}

local DogColours = {BrickColor.new("Flint"),BrickColor.new("Dark taupe"),BrickColor.new("Dark stone grey"),BrickColor.new("Fossil")}
local DogMaterials = {Enum.Material.Pebble,Enum.Material.Granite,Enum.Material.Sand,Enum.Material.Marble,Enum.Material.Concrete}

local function NiceDir(a)
	return (a + 180) % 360 - 180
end

local function rainbowify(part)
	while part do
	for i = 0,1,0.0025 do
		part.Color = Color3.fromHSV(i,1,1) --creates a color using i
		wait()
	end
	end	
end

local function RainBowDogFunction(Dog)
if Dog then
	for i,v in pairs(Dog:GetChildren()) do
		if v:IsA("MeshPart") then
			if (v.Name == "Head") or (v.Name == "Left Arm") or (v.Name == "Left Leg") or (v.Name == "Right Arm") or (v.Name == "Right Leg") or (v.Name == "Torso") then
				v.Material = Enum.Material.Neon	
				coroutine.wrap(rainbowify)(v)
			end
		end
	end
end	
end

local LastShots = {}
if game:GetService("RunService"):IsServer() then
	local Core = require(game:GetService("ReplicatedStorage"):WaitForChild("S2"):WaitForChild("Core"))
	Core.WeaponTypes.RaycastGun.AttackEvent.Event:Connect(function(StatObj, User, Barrel, Hit, End, Normal, Material, Offset, BulNum, Humanoids)
		if not Barrel or not StatObj or not StatObj.Parent then return end
		if not User then return end

		local Dir = CFrame.new(Vector3.new(), Barrel.CFrame:pointToObjectSpace(End)).lookVector
		LastShots[User] = {tick(), NiceDir(math.deg(math.atan2(Dir.x, Dir.z) - 180 + 45))}
	end)
	
	local PhysicsService = game:GetService("PhysicsService")
	
	function HandleCharacter(Char)
		for _, Part in ipairs(Char:GetDescendants()) do
			if Part:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(Part, "Characters")
			end
		end
		
		Char.DescendantAdded:Connect(function(Part)
			if Part:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(Part, "Characters")
			end
		end)
	end
	
	for _, Plr in ipairs(game:GetService("Players"):GetPlayers()) do
		if Plr.Character then
			HandleCharacter(Plr.Character)
		end
		
		Plr.CharacterAdded:Connect(HandleCharacter)
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(Plr)
		if Plr.Character then
			HandleCharacter(Plr.Character)
		end
		
		Plr.CharacterAdded:Connect(HandleCharacter)
	end)
end

local function Raycast(Start, Direction, Ignore)
	local Hit, Pos, Normal, Material = workspace:FindPartOnRayWithIgnoreList(Ray.new(Start, Direction), Ignore, false, true)
	if Hit and not Hit.CanCollide then
		local List = Ignore
		repeat
			List[#List + 1] = Hit
			Hit, Pos, Normal, Material = workspace:FindPartOnRayWithIgnoreList(Ray.new(Start, Direction), List, false, true)
		until not Hit or Hit.CanCollide
	end
	return Hit, Pos, Normal, Material
end

function RunPowerup(Player, Character)
	local Dog = script.Dog:Clone()
	
	local DogChosenColor = DogColours[math.random(1, #DogColours)].Color
	local DogChosenMaterial = DogMaterials[math.random(1,#DogMaterials)]
	
	for i,v in pairs(Dog:GetChildren()) do
		if v:IsA("MeshPart") then
			if (v.Name == "Head") or (v.Name == "Left Arm") or (v.Name == "Left Leg") or (v.Name == "Right Arm") or (v.Name == "Right Leg") or (v.Name == "Torso") then
				v.Material = DogChosenMaterial
				v.Color = DogChosenColor
			end
		end
	end
	
	local RainBowDog
	local Chance = math.random(1,1000)
	if Chance==1 then
		RainBowDog=true
	end
	
	Dog.Torso.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(4, 0, 0)
	Dog.Parent = workspace
	Active[Player] = true
	if Dogs[Player] then
		Dogs[Player]:Destroy()
	end
	Dogs[Player] = Dog
	
	local Root = Character.HumanoidRootPart
	local Humanoid = Character.Humanoid
	local DogTorso = Dog.Torso
	local DogHumanoid = Dog.Humanoid
	
	DogHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	
	if RainBowDog==true then
		coroutine.wrap(RainBowDogFunction)(Dog)
	end	
	
	local Dead = false
	DogHumanoid.TeamColor.Value = Player.TeamColor
	DogHumanoid.HealthChanged:Connect(function(New)
		if New <= 0 and not Dead then
			Dead = true
			Dog:BreakJoints()
			DogHumanoid:Destroy()
			for _, v in pairs(Dog:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
			wait(5)
			if Active[Player] and Dog and Dog.Parent and Character then
				Dog:Destroy()
				Dogs[Player] = nil
				wait(30)
				if Active[Player] and not Dogs[Player] and Character then
					RunPowerup(Player, Character)
				end
			end
		end
	end)
	
	local Target
	local LastBite, NextBite = 0, 0
	while wait() and Active[Player] and Character and Root and Humanoid and DogTorso and DogHumanoid and not Dead do			
		if Target and (Target.Position - Root.Position).Magnitude < 75 and Target.Parent:FindFirstChild("Humanoid") and Target.Parent.Humanoid.Health > 0 then
			DogHumanoid.WalkToPoint = Target.Position + Vector3.new(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3))
			DogHumanoid.WalkSpeed = math.min((DogTorso.Position - Target.Position).Magnitude * 3, 30)
			local barkChance = math.random(1,100)
			if barkChance==1 and DogTorso:FindFirstChild("Bark") and DogTorso:FindFirstChild("ShortBark") then
				if DogTorso.Bark.Playing==false and DogTorso.ShortBark.Playing==false then
					DogTorso.Bark:Play()
				end	
			elseif barkChance==2 and DogTorso:FindFirstChild("Bark") and DogTorso:FindFirstChild("ShortBark") then
				if DogTorso.Bark.Playing==false and DogTorso.ShortBark.Playing==false then
					DogTorso.ShortBark:Play()
				end					
			end
			if Target.Position.Y - 4 > DogTorso.Position.Y then
				DogHumanoid.Jump = true
			end
			if (DogTorso.Position - Target.Position).Magnitude < 5 and tick() - LastBite > NextBite then
				local WeaponStat = setmetatable({Value = "AttackDog", Damage = math.random(16, 32)}, {__index = Core.Config.WeaponTypeOverrides.All})
				local Damageable, Damage = Core.DamageHelper(Player, Target, WeaponStat, Core.DamageType.Slash)
				if Damageable then
					LastBite = tick()
					NextBite = math.random(100, 120) / 100
					if DogTorso:FindFirstChild("Bite") then
						DogTorso.Bite.PlaybackSpeed = 1 + math.random(10,40)/10
						DogTorso.Bite:Play()
					end
				end
			end
		else
			if Target then
				Target = nil
			end
			for _, v in pairs(game.Players:GetPlayers()) do
				if v.Team ~= Player.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") and v:DistanceFromCharacter(Root.Position) < 75 then
					local Hit = Raycast(DogTorso.Position, CFrame.new(DogTorso.Position, v.Character.HumanoidRootPart.Position).lookVector, {Dog, Character})
					Target = v.Character:FindFirstChild("Torso") or v.Character:FindFirstChild("UpperTorso")
					break
				end
			end
			
			if not Target then
				local Left = Root.CFrame * CFrame.new(4, 0, 0)
				local Right = Root.CFrame * CFrame.new(-4, 0, 0)
				
				local Closest = (DogTorso.Position - Left.p).Magnitude < (DogTorso.Position - Right.p).Magnitude and Left or Right
				
				if LastShots[Player] and tick() - LastShots[Player][1] < 4 then
					local Dir = LastShots[Player][2]
					if Dir > 90 then
						Dir = 180 - Dir
					elseif Dir < -90 then
						Dir = -180 - Dir
					end
					if Dir > 15 then
						Closest = Left
					elseif Dir < -15 then
						Closest = Right
					end
				end
				
				DogHumanoid.WalkToPoint = Closest.p
				DogHumanoid.WalkSpeed = math.min((DogTorso.Position - Closest.p).Magnitude * 3, 30)
				if Closest.Y - 4 > DogTorso.Position.Y then
					DogHumanoid.Jump = true
				end
				
				if (DogTorso.Position - Closest.p).Magnitude > 30 then
					DogTorso.CFrame = Closest
				end
			end
		end
	end
end

function EndPowerup(Player, Character)
	if Active[Player] then
		Active[Player] = nil
	end
	if Dogs[Player] then
		Dogs[Player]:Destroy()
		Dogs[Player] = nil
	end
end

return {
	Type = "Passive",
	Icon = "1677371931",
	Description = "A cute pet doggo",
	Trigger = RunPowerup,
	EndTrigger = EndPowerup,
	WorldDisplay = script.Display
}
