-- =============================================
-- سكربت واجهة ماب سرقة البيض العربي المدمج
-- =============================================

local اللاعب = game.Players.LocalPlayer
local الشخصية = اللاعب.Character or اللاعب.CharacterAdded:Wait()
local المكون_البشري = الشخصية:WaitForChild("Humanoid")
local الجزء_الرئيسي = الشخصية:WaitForChild("HumanoidRootPart")
local الكاميرا = workspace.CurrentCamera

local الواجهة = script.Parent
local صورة_انفنسبل = الواجهة:WaitForChild("ImageLabel")
local زر_السرعة = الواجهة:WaitForChild("زر_السرعة")
local زر_الحماية = الواجهة:WaitForChild("زر_الحماية")
local زر_الوحش_ما_يضربك = الواجهة:WaitForChild("زر_الوحش_ما_يضربك")
local زر_الشاشة = الواجهة:WaitForChild("زر_الشاشة")
local زر_اخذ_بيض_تلقائي = الواجهة:WaitForChild("زر_اخذ_بيض_تلقائي")

local حالة_السرعة = false
local حالة_الحماية = false
local حالة_الوحش_ما_يضربك = false
local حالة_زر_الشاشة = false
local حالة_اخذ_البيض = false

-- إعادة التحديث عند موت الشخصية
اللاعب.CharacterAdded:Connect(function(شخصية_جديدة)
	الشخصية = شخصية_جديدة
	المكون_البشري = شخصية_جديدة:WaitForChild("Humanoid")
	الجزء_الرئيسي = شخصية_جديدة:WaitForChild("HumanoidRootPart")
	الكاميرا = workspace.CurrentCamera
	حالة_السرعة = false
	حالة_الحماية = false
	حالة_الوحش_ما_يضربك = false
	حالة_زر_الشاشة = false
	حالة_اخذ_البيض = false
end)

-- 1. زر تفعيل وإيقاف السرعة (بسعر 1000 بيضة)
زر_السرعة.MouseButton1Click:Connect(function()
	local بيانات_اللاعب = اللاعب:FindFirstChild("leaderstats")
	if not بيانات_اللاعب then return end
	local عداد_البيض = بيانات_اللاعب:FindFirstChild("البيض 🥚")
	if not عداد_البيض then return end

	if حالة_الحماية then return end

	if not حالة_السرعة then
		if عداد_البيض.Value >= 1000 then
			عداد_البيض.Value = عداد_البيض.Value - 1000
			حالة_السرعة = true
			المكون_البشري.WalkSpeed = 32
			زر_السرعة.Text = "إيقاف السرعة"
		end
	else
		حالة_السرعة = false
		المكون_البشري.WalkSpeed = 16
		زر_السرعة.Text = "تفعيل السرعة (1000 بيضة)"
	end
end)

-- 2. زر تفعيل وإيقاف الحماية
زر_الحماية.MouseButton1Click:Connect(function()
	if not حالة_الحماية then
		حالة_الحماية = true
		زر_الحماية.Text = "إيقاف الحماية"
		if حالة_السرعة then
			حالة_السرعة = false
			المكون_البشري.WalkSpeed = 16
			زر_السرعة.Text = "تفعيل السرعة (1000 بيضة)"
		end
	else
		حالة_الحماية = false
		زر_الحماية.Text = "تفعيل الحماية"
	end
end)

-- 3. زر "الوحش ما يضربك"
زر_الوحش_ما_يضربك.MouseButton1Click:Connect(function()
	if not حالة_الوحش_ما_يضربك then
		حالة_الوحش_ما_يضربك = true
		زر_الوحش_ما_يضربك.Text = "إيقاف (الوحش ما يضربك)"
		for _, جزء in pairs(الشخصية:GetChildren()) do
			if جزء:IsA("BasePart") then جزء:SetAttribute("الوحش_ما_يضربك", true) end
		end
	else
		حالة_الوحش_ما_يضربك = false
		زر_الوحش_ما_يضربك.Text = "تفعيل (الوحش ما يضربك)"
		for _, جزء in pairs(الشخصية:GetChildren()) do
			if جزء:IsA("BasePart") then جزء:SetAttribute("الوحش_ما_يضربك", false) end
		end
	end
end)

-- 4. زر الشاشة (FOV 120)
زر_الشاشة.MouseButton1Click:Connect(function()
	if not حالة_زر_الشاشة then
		حالة_زر_الشاشة = true
		الكاميرا.FieldOfView = 120
		زر_الشاشة.Text = "زر الشاشة (إيقاف FOV 120)"
	else
		حالة_زر_الشاشة = false
		الكاميرا.FieldOfView = 70
		زر_الشاشة.Text = "زر الشاشة (تفعيل FOV 120)"
	end
end)

-- 5. زر اخذ بيض تلقائي
زر_اخذ_بيض_تلقائي.MouseButton1Click:Connect(function()
	if not حالة_اخذ_البيض then
		حالة_اخذ_البيض = true
		زر_اخذ_بيض_تلقائي.Text = "إيقاف اخذ البيض التلقائي"
		task.spawn(function()
			while حالة_اخذ_البيض do
				local أقرب_بيضة = nil
				local أقل_مسافة = math.huge
				for _, عنصر in pairs(workspace:GetDescendants()) do
					if (عنصر.Name == "بيضة" or عنصر.Name == "Egg") and عنصر:IsA("BasePart") and عنصر.Transparency < 1 then
						local المسافة = (الجزء_الرئيسي.Position - عنصر.Position).Magnitude
						if المسافة < أقل_مسافة then
							أقل_مسافة = المسافة
							أقرب_بيضة = عنصر
						end
					end
				end
				if أقرب_بيضة then المكون_البشري:MoveTo(أقرب_بيضة.Position) end
				task.wait(1)
			end
		end)
	else
		حالة_اخذ_البيض = false
		زر_اخذ_بيض_تلقائي.Text = "تفعيل اخذ بيض تلقائي"
	end
end)
