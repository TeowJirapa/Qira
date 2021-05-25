local TweenService = game:GetService("TweenService")

local Active = {}

local function RunPowerup(Player, Character, Pos)
	local Grapple = script.Display:Clone()
	Grapple.Size = Grapple.Size * 0.5
	Grapple.Attachment.Position = Grapple.Attachment.Position * 0.5
	Grapple.CFrame = Pos
	Grapple.Anchored = true
	Grapple.Parent = workspace
	
	local Sound = Instance.new("Sound", Character.HumanoidRootPart)
	Sound.SoundId = "rbxassetid://659223262"
	Sound.PlayOnRemove = true
	Sound:Destroy()
	
	local Attachment1 = Instance.new("Attachment", Character.HumanoidRootPart)
	
	local Distance = (Character.HumanoidRootPart.Position - Pos.p).Magnitude
	
	local Rope = Instance.new("RopeConstraint", Grapple)
	Rope.Attachment0 = Grapple.Attachment
	Rope.Attachment1 = Attachment1
	Rope.Visible = true
	Rope.Color = BrickColor.new("Brown")
	Rope.Length = Distance
	
	local Tween = TweenService:Create(Rope, TweenInfo.new(1, Enum.EasingStyle.Quad), {Length = 3})
	Tween:Play()
	Tween.Completed:Connect(function()
		Grapple:Destroy()
	end)
end

return {
	Type = "Active",
	Icon = "1698305765",
	Description = "Grapple onto a nearby surface",
	Cooldown = 13,
	Length = 1,
	NoSitting = true,
	Trigger = RunPowerup,
	WorldDisplay = script.Display
}
