-- 🌟 FPS BOOST + เมนูภาษาไทย สวยๆ 🌟
local p=game.Players.LocalPlayer
local rs=game:GetService("RunService")
local l=game:GetService("Lighting")

local originals={Textures={},Particles={},LightingFx={},SkyFog={},Sounds={},DeadlyFx={}}
local toggles={Textures=false,Particles=false,LightingFx=false,SkyFog=false,Sounds=false,DeadlyFx=false}

local function applySettings()
    for _,v in next, workspace:GetDescendants() do
        if v:IsA("Texture") or v:IsA("Decal") or v:IsA("SurfaceAppearance") then
            if toggles.Textures then if not originals.Textures[v] then originals.Textures[v]=v end v:Destroy() end
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            if toggles.Particles then originals.Particles[v]=true v.Enabled=false
            elseif originals.Particles[v] then v.Enabled=true originals.Particles[v]=nil end
        elseif v:IsA("Sound") then
            if toggles.Sounds then originals.Sounds[v]=v.Playing v:Stop()
            elseif originals.Sounds[v]~=nil then v.Playing=originals.Sounds[v] originals.Sounds[v]=nil end
        end
    end
    for _,v in next, l:GetChildren() do
        if v:IsA("PostEffect") then
            if toggles.LightingFx then originals.LightingFx[v]=v.Enabled v.Enabled=false
            elseif originals.LightingFx[v]~=nil then v.Enabled=originals.LightingFx[v] originals.LightingFx[v]=nil end
        elseif v:IsA("Atmosphere") or v:IsA("Sky") then
            if toggles.SkyFog then if not originals.SkyFog[v] then originals.SkyFog[v]=v end v:Destroy() end
        end
    end
    if toggles.SkyFog then l.FogEnd=9e9 l.GlobalShadows=false end
end

local function optimizeDeadMonsters()
    if not toggles.DeadlyFx then return end
    for _, obj in next, workspace:GetChildren() do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health <= 0 then
            for _, child in next, obj:GetDescendants() do
                if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Fire") or child:IsA("Smoke") then
                    child:Destroy()
                end
            end
        end
    end
end
rs.Heartbeat:Connect(optimizeDeadMonsters)

-- 🌈 GUI สวย ๆ
local g=Instance.new("ScreenGui")
g.Name="FPSBoostTH"
g.ResetOnSpawn=false
g.Parent=p:WaitForChild("PlayerGui")

-- 🔘 ปุ่มเปิด/ปิดเมนูลอย (ปรับสีและขนาดให้ลงตัว)
local tb=Instance.new("TextButton",g)
tb.Size=UDim2.new(0,60,0,60) -- ลดขนาดเล็กน้อย
tb.Position=UDim2.new(0,20,0,20)
tb.BackgroundColor3=Color3.fromRGB(45,45,55) -- เปลี่ยนสีให้เข้ากับธีม
tb.Text=""
tb.AutoButtonColor=true
tb.Active=true tb.Draggable=true
local tbCorner=Instance.new("UICorner",tb)
tbCorner.CornerRadius=UDim.new(0,10) -- ปรับความโค้ง

local logo=Instance.new("ImageLabel",tb)
logo.Size=UDim2.new(0.8,0,0.8,0)
logo.Position=UDim2.new(0.5,0,0.5,0)
logo.AnchorPoint=Vector2.new(0.5,0.5)
logo.BackgroundTransparency=1
logo.Image="rbxassetid://11293942993"

-- 🌟 หน้าต่างเมนูสวย ๆ (ปรับขนาดและ Padding)
local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,250,0,320) -- เพิ่มขนาดเฟรมอีกเล็กน้อย
f.Position=UDim2.new(0,20,0,90)
f.BackgroundColor3=Color3.fromRGB(30,30,40)
f.Visible=false
f.Active=true f.Draggable=true
Instance.new("UICorner",f).CornerRadius=UDim.new(0,15)

local u=Instance.new("UIListLayout",f)
u.Padding=UDim.new(0,8) -- เพิ่มระยะห่างระหว่างปุ่ม
u.FillDirection=Enum.FillDirection.Vertical

-- เพิ่มระยะห่างจากขอบเฟรม
local pad=Instance.new("UIPadding",f)
pad.PaddingTop=UDim.new(0,10)
pad.PaddingBottom=UDim.new(0,10)
pad.PaddingLeft=UDim.new(0,10)
pad.PaddingRight=UDim.new(0,10)

local function makeButton(thName,key)
    local b=Instance.new("TextButton",f)
    b.Size=UDim2.new(1,0,0,40) -- ปรับขนาดปุ่ม
    b.BackgroundColor3=Color3.fromRGB(45,45,55) -- สีปุ่มที่เข้ากับพื้นหลัง
    b.TextColor3=Color3.new(0.9,0.9,0.9) -- สีตัวอักษรเทาอ่อน
    b.Font=Enum.Font.GothamBold
    b.TextSize=17
    b.Text=thName.." : ปิด"
    b.AutoButtonColor=false -- ปิดการเปลี่ยนสีอัตโนมัติ
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)

    -- เพิ่มเอฟเฟกต์เมื่อวางเมาส์เหนือปุ่ม
    b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(60,60,70) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(45,45,55) end)

    b.MouseButton1Click:Connect(function()
        toggles[key]=not toggles[key]
        b.Text=thName.." : "..(toggles[key] and "เปิด" or "ปิด")
        applySettings()
        optimizeDeadMonsters()
    end)
end

makeButton("ลบพื้นผิว","Textures")
makeButton("ปิดเอฟเฟกต์อนุภาค","Particles")
makeButton("ปิดเอฟเฟกต์แสง","LightingFx")
makeButton("ปิดหมอก/ท้องฟ้า","SkyFog")
makeButton("ปิดเสียง","Sounds")
makeButton("ปิดเอฟเฟกต์การตาย","DeadlyFx")

-- 🔁 ปุ่มเปิด/ปิดเมนู
tb.MouseButton1Click:Connect(function() f.Visible=not f.Visible end)

-- 🎯 FPS Counter สวย ๆ (ปรับสีและตำแหน่ง)
local fl=Instance.new("TextLabel",g)
fl.Size=UDim2.new(0,120,0,30)
fl.Position=UDim2.new(1,-140,0,10)
fl.BackgroundTransparency=0.8 -- ปรับความโปร่งใส
fl.BackgroundColor3=Color3.fromRGB(0,0,0)
fl.TextColor3=Color3.fromRGB(0,255,100)
fl.Font=Enum.Font.GothamBold
fl.TextSize=18
fl.Text="FPS: 0"
Instance.new("UICorner",fl).CornerRadius=UDim.new(0,10)

local frames,last=0,tick()
rs.RenderStepped:Connect(function()
    frames+=1 local n=tick()
    if n-last>=1 then fl.Text="FPS: "..frames frames=0 last=n end
end)
