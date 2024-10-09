---@diagnostic disable: undefined-global, deprecated, lowercase-global -- for visual studio code


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
loadstring(game:HttpGet('https://pastebin.com/raw/ZudrLkis'))()
local Window = Rayfield:CreateWindow({
   Name = "putinware alpha (v0.8)",
   LoadingTitle = "putinware client is now injecting",
   LoadingSubtitle = "please wait a few seconds",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "putinware"
   },
   Discord = {
      Enabled = true,
      Invite = "Puhp2hjCSs",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "putinware",
      Subtitle = "key guard",
      Note = "get key from discord (#client-key)",
      FileName = "putinkey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "MuZiQ7d1wOP"
   }
})

local Tab = Window:CreateTab("visuals")
local Section = Tab:CreateSection("player esp") 

local Toggle = Tab:CreateToggle({
    Name = "simple esp",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        local Players = game:GetService("Players")

        local function ApplyHighlight(Player)
            local Connections = {}
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            local Highlight = Instance.new("Highlight", Character)

            local function UpdateFillColor()
                local DefaultColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillColor = (Player.TeamColor and Player.TeamColor.Color) or DefaultColor
            end

            local function Disconnect()
                Highlight:Destroy()
                for _, Connection in next, Connections do
                    Connection:Disconnect()
                end
            end
            table.insert(Connections, Player:GetPropertyChangedSignal("TeamColor"):Connect(UpdateFillColor))
            table.insert(Connections, Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if Humanoid.Health <= 0 then
                    Disconnect()
                end
            end))

            Player.CharacterAdded:Connect(function()
                Disconnect()
                ApplyHighlight(Player)
            end)

            UpdateFillColor()
        end
        local function ToggleHighlight(Value)
            if Value == true then
                for _, Player in next, Players:GetPlayers() do
                    local Highlight = Player.Character:FindFirstChildOfClass("Highlight")
                    if Highlight then
                        Highlight:Destroy()
                    end
                    ApplyHighlight(Player)
                end
                Players.PlayerAdded:Connect(ApplyHighlight)
            elseif Value == false then
                for _, Player in next, Players:GetPlayers() do
                        local Highlight = Player.Character:FindFirstChildOfClass("Highlight")
                        if Highlight then
                            Highlight:Destroy()
                            end
                         end
                      end
                end
        ToggleHighlight(Value)
    end,
})

local Section = Tab:CreateSection("tracers")

local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end


local Find_Required = API_Check()

if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Exunys Developer";
        Text = "Tracer script could not be loaded because your exploit is unsupported.";
        Duration = math.huge;
        Button1 = "OK"
    })

    return
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TestService = game:GetService("TestService")

local Typing = false

_G.SendNotifications = false   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
_G.DefaultSettings = false   -- If set to true then the tracer script would run with default settings regardless of any changes you made.
_G.TTeamCheck = false   -- If set to true then the script would create tracers only for the enemy team members.
_G.FromMouse = false   -- If set to true, the tracers will come from the position of your mouse curson on your screen.
_G.FromCenter = true   -- If set to true, the tracers will come from the center of your screen.
_G.FromBottom = false  -- If set to true, the tracers will come from the bottom of your screen.
_G.TracersVisible = false   -- If set to true then the tracers will be visible and vice versa.
_G.TracerColor = Color3.fromRGB(255, 255, 255)   -- The color that the tracers would appear as.
_G.TracerThickness = 1
_G.TracerTransparency = 1
_G.ModeSkipKey = Enum.KeyCode.M
_G.DisableKey = Enum.KeyCode.N 

local function CreateTracers()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= game.Players.LocalPlayer.Name then
            local TracerLine = Drawing.new("Line")
    
            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                    local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                    local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                    
                    TracerLine.Thickness = _G.TracerThickness
                    TracerLine.Transparency = _G.TracerTransparency
                    TracerLine.Color = _G.TracerColor

                    if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    end

                    if OnScreen == true  then
                        TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                        if _G.TTeamCheck == true then 
                            if Players.LocalPlayer.Team ~= v.Team then
                                TracerLine.Visible = _G.TracersVisible
                            else
                                TracerLine.Visible = false
                            end
                        else
                            TracerLine.Visible = _G.TracersVisible
                        end
                    else
                        TracerLine.Visible = false
                    end
                else
                    TracerLine.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                TracerLine.Visible = false
            end)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(v)
            if v.Name ~= game.Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
        
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                    	local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                        
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor

                        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        if OnScreen == true  then
                            TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                            if _G.TTeamCheck == true then 
                                if Players.LocalPlayer.Team ~= Player.Team then
                                    TracerLine.Visible = _G.TracersVisible
                                else
                                    TracerLine.Visible = false
                                end
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end
                        else
                            TracerLine.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                    end
                end)

                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                end)
            end
        end)
    end)
end

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == _G.ModeSkipKey and Typing == false then
        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false and _G.TracersVisible == true then
            _G.FromCenter = false
            _G.FromBottom = true
            _G.FromMouse = false

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the bottom of your screen (Mode 1)";
                    Duration = 5;
                })
            end
        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true and _G.TracersVisible == true then
            _G.FromCenter = true
            _G.FromBottom = false
            _G.FromMouse = false

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the center of your screen (Mode 2)";
                    Duration = 5;
                })
            end
        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false and _G.TracersVisible == true then
            _G.FromCenter = false
            _G.FromBottom = false
            _G.FromMouse = true

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the position of your mouse cursor on your screen (Mode 3)";
                    Duration = 5;
                })
            end
        end
    elseif Input.KeyCode == _G.DisableKey and Typing == false then
        _G.TracersVisible = not _G.TracersVisible
        
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "The tracers' visibility is now set to "..tostring(_G.TracersVisible)..".";
                Duration = 5;
            })
        end
    end
end)

if _G.DefaultSettings == true then
    _G.TTeamCheck = false
    _G.FromMouse = false
    _G.FromCenter = false
    _G.FromBottom = false
    _G.TracersVisible = false
    _G.TracerColor = Color3.fromRGB(40, 90, 255)
    _G.TracerThickness = 1
    _G.TracerTransparency = 1
    _G.ModeSkipKey = Enum.KeyCode.E
    _G.DisableKey = Enum.KeyCode.Q
end

local Success, Errored = pcall(function()
    CreateTracers()
end)

if Success and not Errored then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "Tracer script has successfully loaded.";
            Duration = 5;
        })
    end
elseif Errored and not Success then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "Tracer script has errored while loading, please check the developer console! (F9)";
            Duration = 5;
        })
    end
    TestService:Message("The tracer script has errored, please notify Exunys with the following information :")
    warn(Errored)
    print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
end

    local Toggle = Tab:CreateToggle({
        Name = "tracers active",
        CurrentValue = false,
        Flag = "Toggle1",
        Callback = function(Value)
            _G.TracersVisible = Value
                if _G.FromMouse == false or _G.FromBottom == false or _G.FromCenter == false then
                    _G.FromCenter = true
                end
            end
        })

        local Toggle = Tab:CreateToggle({
            Name = "tracers team check",
            CurrentValue = false,
            Flag = "Toggle1",
            Callback = function(Value)
                _G.TTeamCheck = Value
                end
            })

            local Slider = Tab:CreateSlider({
                Name = "tracers thickness",
                Range = {1, 10},
                Increment = 0.5,
                CurrentValue = 1,
                Flag = "Slider1",
                Callback = function(Value)
                    _G.TracerThickness = Value
                end,
            })

                local ColorPicker = Tab:CreateColorPicker({
                    Name = "tracers color",
                    Color = Color3.fromRGB(255,255,255),
                    Flag = "ColorPicker1", 
                    Callback = function(Value)
                        _G.TracerColor = Value
                    end
                })

local Tab = Window:CreateTab("movement")
local Slider = Tab:CreateSlider({
    Name = "walkspeed",
    Range = {20, 300},
    Increment = 5,
    CurrentValue = 20,
    Flag = "Slider1",
    Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
 })
 local Slider = Tab:CreateSlider({
    Name = "jump power",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Flag = "Slider1",
    Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
 })
 local Toggle = Tab:CreateToggle({
    Name = "inf jump",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
            _G.infinjump = not _G.infinjump

            if _G.infinJumpStarted == nil then
                _G.infinJumpStarted = true
                local plr = game:GetService('Players').LocalPlayer
                local m = plr:GetMouse()
                m.KeyDown:connect(function(k)
                    if _G.infinjump then
                        if k:byte() == 32 then
                            if Value == true then
                                humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                                humanoid:ChangeState('Jumping')
                                wait()
                                humanoid:ChangeState('Seated')
                             end
                          end
                      end
                end)
            end
        end,
    })

    local Tab = Window:CreateTab("miscellaneous")

    local Button = Tab:CreateButton({
        Name = "unhook client",
        Callback = function()
            Rayfield:Destroy()
        end,
    })
    
    local Button = Tab:CreateButton({
        Name = "server reconnect",
        Callback = function()
            reconnect()
        end,
    })
    
    function reconnect()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
    
    local Toggle = Tab:CreateToggle({
        Name = "anti afk",
        CurrentValue = false,
        Flag = "Toggle1",
        Callback = function(Value)
        
            if Value == true then
                local vu = game:GetService("VirtualUser")
                    game:GetService("Players").LocalPlayer.Idled:connect(function()
                    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                    wait(1)
                    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                 end)
            end
        end,
     })



     local Camera = workspace.CurrentCamera
     local Players = game:GetService("Players")
     local RunService = game:GetService("RunService")
     local UserInputService = game:GetService("UserInputService")
     local TweenService = game:GetService("TweenService")
     local LocalPlayer = Players.LocalPlayer
     local Holding = false
     
     _G.AimbotEnabled = true
     _G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
     _G.AimPart = "Head" -- Where the aimbot script would lock at.
     _G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
     
     _G.CircleSides = 64 -- How many sides the FOV circle would have.
     _G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
     _G.CircleTransparency = 0.3 -- Transparency of the circle.
     _G.CircleRadius = 80 -- The radius of the circle / FOV.
     _G.CircleFilled = false -- Determines whether or not the circle is filled.
     _G.CircleVisible = false -- Determines whether or not the circle is visible.
     _G.CircleThickness = 0 -- The thickness of the circle.
     
     local FOVCircle = Drawing.new("Circle")
     FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
     FOVCircle.Radius = _G.CircleRadius
     FOVCircle.Filled = _G.CircleFilled
     FOVCircle.Color = _G.CircleColor
     FOVCircle.Visible = _G.CircleVisible
     FOVCircle.Radius = _G.CircleRadius
     FOVCircle.Transparency = _G.CircleTransparency
     FOVCircle.NumSides = _G.CircleSides
     FOVCircle.Thickness = _G.CircleThickness
     
    
     local function GetClosestPlayer()
         local MaximumDistance = _G.CircleRadius
         local Target = nil
     
         for _, v in next, Players:GetPlayers() do
             if v.Name ~= LocalPlayer.Name then
                 if _G.TeamCheck == true then
                     if v.Team ~= LocalPlayer.Team then
                         if v.Character ~= nil then
                             if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                 if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                     local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                     local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                     
                                     if VectorDistance < MaximumDistance then
                                         Target = v
                                     end
                                 end
                             end
                         end
                     end
                 else
                     if v.Character ~= nil then
                         if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                             if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                 local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                 local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                 
                                 if VectorDistance < MaximumDistance then
                                     Target = v
                                 end
                             end
                         end
                     end
                 end
             end
         end
     
         return Target
     end
     
     RunService.RenderStepped:Connect(function()
         FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
         FOVCircle.Radius = _G.CircleRadius
         FOVCircle.Filled = _G.CircleFilled
         FOVCircle.Color = _G.CircleColor
         FOVCircle.Visible = _G.CircleVisible
         FOVCircle.Radius = _G.CircleRadius
         FOVCircle.Transparency = _G.CircleTransparency
         FOVCircle.NumSides = _G.CircleSides
         FOVCircle.Thickness = _G.CircleThickness
     
         if Holding == true and _G.AimbotEnabled == true then
             TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
         end
     end)

     local Tab = Window:CreateTab("aimbot")
     local Section = Tab:CreateSection("aimbot")
            local Toggle = Tab:CreateToggle({
                Name = "aimbot active (manual)",
                CurrentValue = false,
                Flag = "Toggle1",
                Callback = function(Value)
                     Holding = Value
                    end
                })
                    local Toggle = Tab:CreateToggle({
                        Name = "team check",
                        CurrentValue = false,
                        Flag = "Toggle1",
                        Callback = function(Value)
                            _G.TeamCheck = Value
                            end
                        })

                        local Keybind = Tab:CreateKeybind({
                            Name = "aimbot bind",
                            CurrentKeybind = "R",
                            HoldToInteract = false,
                            Flag = "Keybind1", 
                            Callback = function(Keybind)
                                if Holding == true then
                                    Holding = false
                                else Holding = true
                                end
                            end
                        })

                            local Section = Tab:CreateSection("circle fov")

                                local Toggle = Tab:CreateToggle({
                                    Name = "draw circle fov",
                                    CurrentValue = false,
                                    Flag = "Toggle1",
                                    Callback = function(Value)    
                                        _G.CircleVisible = Value
                                            end
                                        })
            
                                    local Toggle = Tab:CreateToggle({
                                        Name = "filled circle fov",
                                        CurrentValue = false,
                                        Flag = "Toggle1",
                                        Callback = function(Value)    
                                            _G.CircleFilled = Value
                                                end
                                            })
                
                                        local Slider = Tab:CreateSlider({
                                            Name = "circle fov radius",
                                            Range = {50, 360},
                                            Increment = 10,
                                            CurrentValue = 80,
                                            Flag = "Slider1",
                                            Callback = function(Value)
                                                _G.CircleRadius = Value
                                            end,
                                        })
                                            local ColorPicker = Tab:CreateColorPicker({
                                                Name = "circle fov color",
                                                Color = Color3.fromRGB(255,255,255),
                                                Flag = "ColorPicker1",
                                                Callback = function(Value)
                                                    _G.CircleColor = Value
                                                    FOVCircle.Color = Value
                                                end
                                            })
