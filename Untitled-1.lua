--[[

    WindUI Example (wip)
    
]]


local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

WindUI.Services = WindUI.Services or {}
WindUI.Services.keyguardian = {
    Name = "KeyGuardian",
    Icon = "key",
    Args = { "ServiceId" },

    New = function(ServiceId)
        local function validateKey(key)
            if tostring(key) == "114514" then
                return true, "Key valid"
            else
                return false, "Key invalid"
            end
        end

        local function copyLink()
            setclipboard("https://keyguardian.example.com/get?service=" .. ServiceId)
        end

        return {
            Verify = validateKey,
            Copy = copyLink
        }
    end
}

--[[

WindUI.Creator.AddIcons("solar", {
    ["CheckSquareBold"] = "rbxassetid://132438947521974",
    ["CursorSquareBold"] = "rbxassetid://120306472146156",
    ["FileTextBold"] = "rbxassetid://89294979831077",
    ["FolderWithFilesBold"] = "rbxassetid://74631950400584",
    ["HamburgerMenuBold"] = "rbxassetid://134384554225463",
    ["Home2Bold"] = "rbxassetid://92190299966310",
    ["InfoSquareBold"] = "rbxassetid://119096461016615",
    ["PasswordMinimalisticInputBold"] = "rbxassetid://109919668957167",
    ["SolarSquareTransferHorizontalBold"] = "rbxassetid://125444491429160",
})--]]


function createPopup()
    -- 改用右下角通知代替弹窗
    createBottomRightNotification(
        "欢迎使用北楠脚本",
        "🔗 群号: 1059240553\n有时候会更新\n已检测您的设备分辨率"
    )
end

-- Confirm loader: show popup and load remote script only if user confirms
local function confirmLoad(url)
    WindUI:Popup({
        Title = "确认加载脚本",
        Icon = "info",
        Content = "是否加载该脚本？\n" .. tostring(url),
        Buttons = {
            {
                Title = "取消",
                Callback = function() end,
                Variant = "Tertiary",
            },
            {
                Title = "继续",
                Icon = "arrow-right",
                Callback = function()
                    local ok, body = pcall(function() return game:HttpGet(url) end)
                    if not ok or not body then
                        WindUI:Notify({ Title = "加载失败", Content = "无法获取脚本" })
                        return
                    end
                    local fn, err = (loadstring or load)(body)
                    if not fn then
                        WindUI:Notify({ Title = "加载失败", Content = "解析失败: " .. tostring(err) })
                        return
                    end
                    local suc, err2 = pcall(fn)
                    if not suc then
                        WindUI:Notify({ Title = "执行失败", Content = tostring(err2) })
                    end
                end,
                Variant = "Primary",
            }
        }
    })
end

-- Example popup from user
local function showExamplePopup()
    WindUI:Popup({
        Title = "Popup Title",
        Icon = "info",
        Content = "Popup content",
        Buttons = {
            {
                Title = "Cancel",
                Callback = function() end,
                Variant = "Tertiary",
            },
            {
                Title = "Continue",
                Icon = "arrow-right",
                Callback = function() end,
                Variant = "Primary",
            }
        }
    })
end

-- Screen resolution detection and bottom-right notification system
local function getScreenResolution()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player or not player:FindFirstChild("PlayerGui") then
        return { X = 1920, Y = 1080 }
    end
    
    local playerGui = player.PlayerGui
    local screenSize = playerGui.AbsoluteSize
    return { X = screenSize.X, Y = screenSize.Y }
end

local function createBottomRightNotification(title, content)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player then return end
    
    local playerGui = player:WaitForChild("PlayerGui")
    local screenRes = getScreenResolution()
    
    -- Create notification GUI
    local notif = Instance.new("ScreenGui")
    notif.Name = "BottomRightNotif"
    notif.ResetOnSpawn = false
    notif.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notif.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Name = "NotifFrame"
    frame.Size = UDim2.new(0, 320, 0, 100)
    frame.Position = UDim2.new(1, -340, 1, -120)  -- 右下角，留边距
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = notif
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 200, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -10, 0, 30)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -10, 0, 60)
    contentLabel.Position = UDim2.new(0, 5, 0, 35)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = frame
    
    -- Auto remove after 4 seconds
    task.delay(4, function()
        pcall(function() notif:Destroy() end)
    end)
    
    return notif
end

-- Show notification immediately on script load with screen info
pcall(function()
    local screenRes = getScreenResolution()
    createBottomRightNotification(
        "脚本已加载",
        string.format("分辨率: %dx%d\n点击钥匙图标输入密钥", screenRes.X, screenRes.Y)
    )
end)

-- Loader UI: draggable, transparent, progress bar
local function createLoaderUI()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player then return end

    local playerGui = player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "ftgsLoader"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "LoaderFrame"
    frame.Size = UDim2.new(0, 300, 0, 84)
    frame.Position = UDim2.new(0.5, -150, 0.06, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.55
    frame.Active = true

    -- Acrylic overlay (tiled noise texture) for glassy look
    local acrylic = Instance.new("ImageLabel")
    acrylic.Name = "Acrylic"
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.Position = UDim2.new(0, 0, 0, 0)
    acrylic.BackgroundTransparency = 1
    acrylic.Image = "rbxassetid://89828019713131" -- WindUI Glass texture
    acrylic.ImageTransparency = 0.6 -- 亚克力效果 (原0.5)
    acrylic.ScaleType = Enum.ScaleType.Tile
    acrylic.TileSize = UDim2.new(0, 128, 0, 128)
    local acrylicCorner = Instance.new("UICorner")
    acrylicCorner.CornerRadius = UDim.new(0, 8)
    acrylicCorner.Parent = acrylic
    acrylic.Parent = frame

    -- Subtle border stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.95
    stroke.Thickness = 1
    stroke.Parent = frame

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 22)
    title.Position = UDim2.new(0, 0, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "加载中..."
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Parent = frame

    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBg"
    progressBg.Size = UDim2.new(1, -20, 0, 20)
    progressBg.Position = UDim2.new(0, 10, 0, 32)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.BackgroundTransparency = 0.25
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0, 6)
    progressBgCorner.Parent = progressBg
    progressBg.Parent = frame

    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(44, 204, 115)
    progressFill.Parent = progressBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = progressFill

    local pctLabel = Instance.new("TextLabel")
    pctLabel.Size = UDim2.new(1, -20, 0, 20)
    pctLabel.Position = UDim2.new(0, 10, 0, 56)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = Color3.new(1, 1, 1)
    pctLabel.Font = Enum.Font.SourceSans
    pctLabel.TextSize = 14
    pctLabel.TextXAlignment = Enum.TextXAlignment.Center
    pctLabel.Parent = frame

    -- make draggable
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            lastInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and dragStart and startPos then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        end
    end)

    return {
        Gui = gui,
        Frame = frame,
        Fill = progressFill,
        Pct = pctLabel,
    }
end

local Loader = createLoaderUI()
if Loader and Loader.Gui then
    Loader.Gui.Enabled = false
end

local function LoaderShow()
    if Loader and Loader.Gui then
        Loader.Gui.Enabled = true
    end
end

local function LoaderUpdate(pct, message)
    if not Loader or not Loader.Fill then return end
    pct = math.clamp(pct, 0, 1)
    pcall(function()
        Loader.Fill.Size = UDim2.new(pct, 0, 1, 0)
        Loader.Pct.Text = string.format("%d%% %s", math.floor(pct * 100), message or "")
    end)
end

local function LoaderHide()
    if Loader and Loader.Gui then
        Loader.Gui.Enabled = false
    end
end

-- Debug: Preload image to verify accessibility and log results
task.spawn(function()
    local cp = game:GetService("ContentProvider")
    local url = "rbxassetid://89828019713131"
    local ok, err = pcall(function() cp:PreloadAsync({url}) end)
    print("[WindUI Debug] Preload:", url, ok, err)
    if not ok then
        pcall(function() WindUI:Notify({ Title = "Preload Failed", Content = tostring(err) }) end)
    end
end)

-- Debug: Check WindUI Icon parsing behavior for raw asset id
task.spawn(function()
    local ok, res = pcall(function()
        if WindUI and WindUI.Icons and WindUI.Icons.Icon then
            return WindUI.Icons.Icon("rbxassetid://89828019713131")
        end
        return nil
    end)

    if ok and res then
        if type(res) == "table" then
            print("[WindUI Debug] Icon parsed image:", res[1])
            pcall(function() WindUI:Notify({ Title = "Icon Parsed", Content = tostring(res[1]) }) end)
        else
            print("[WindUI Debug] Icon returned:", res)
            pcall(function() WindUI:Notify({ Title = "Icon Parsed", Content = tostring(res) }) end)
        end
    else
        print("[WindUI Debug] Icon parse failed:", res)
        pcall(function() WindUI:Notify({ Title = "Icon Parse Failed", Content = tostring(res) }) end)
    end
end)

-- */  Window  /* --
local Window = WindUI:CreateWindow({
    Title = ".ftgs hub  |  WindUI Example",
    --Author = "by .ftgs • Footagesus",
    Folder = "ftgshub",
    Icon = "solar:folder-2-bold-duotone",
    --IconSize = 22*2,
    NewElements = true,
    Background = "rbxassetid://89828019713131", -- set background decal
    BackgroundTransparency = 0.5, -- 亚克力效果 (0=不透明, 1=完全透明)
    BackgroundImage = "rbxassetid://89828019713131", -- 噪点纹理
    BackgroundImageTransparency = 0.7, -- 噪点纹理透明度
    --Size = UDim2.fromOffset(700,700),
    
    HideSearchBar = false,
    
    OpenButton = {
        Title = "Open .ftgs hub UI", -- can be changed
        CornerRadius = UDim.new(1,0), -- fully rounded
        StrokeThickness = 3, -- removing outline
        Enabled = true, -- enable or disable openbutton
        Draggable = true,
        OnlyMobile = false,
        
        Color = ColorSequence.new( -- gradient
            Color3.fromHex("#30FF6A"), 
            Color3.fromHex("#e7ff2f")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", -- Default or Mac
    },

    KeySystem = {
        Title = "北楠制作  |  优质脚本缝合",
        Note = "进群不定期更新 1059240553",
        KeyValidator = function(EnteredKey)
            if tostring(EnteredKey) == "114514" then
                -- Show loader and preload assets
                task.spawn(function()
                    local assets = {
                        "rbxassetid://89828019713131",
                    }

                    -- Auto-include Window.Background if it's an rbxassetid
                    pcall(function()
                        if Window and type(Window.Background) == "string" and Window.Background:match("^rbxassetid://") then
                            local bg = Window.Background
                            local found = false
                            for _, v in ipairs(assets) do
                                if v == bg then found = true break end
                            end
                            if not found then table.insert(assets, bg) end
                        end
                    end)

                    LoaderShow()

                    for i, asset in ipairs(assets) do
                        local ok, err = pcall(function()
                            game:GetService("ContentProvider"):PreloadAsync({asset})
                        end)

                        local pct = i / #assets
                        LoaderUpdate(pct, (ok and "已加载" or "加载失败") .. " " .. asset)
                        if not ok then
                            warn("Failed preload:", asset, err)
                        end
                    end

                    LoaderUpdate(1, "完成")
                    task.wait(0.3)
                    LoaderHide()

                    -- Show bottom-right notification instead of popup
                    createBottomRightNotification(
                        "预加载完成 ✓",
                        "UI 贴图与资源已加载\n所有模块已准备就绪"
                    )

                    -- Refresh images gently to nudge WindUI to re-render
                    pcall(function()
                        local function refreshImages(parent)
                            for _, child in pairs(parent:GetDescendants()) do
                                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                                    local img = child.Image
                                    if img and img ~= "" then
                                        child.Image = img
                                    end
                                end
                            end
                        end

                        if WindUI and WindUI.ScreenGui then
                            for _, sg in pairs(WindUI.ScreenGui:GetChildren()) do
                                if sg:IsA("ScreenGui") or sg:IsA("Folder") or sg:IsA("Frame") then
                                    refreshImages(sg)
                                end
                            end
                        end

                        if Window then refreshImages(Window) end
                    end)

                    -- Show the popup / normal flow
                    createPopup()
                end)

                return true
            end
            return false
        end
    }
})

Window:EditOpenButton({
    Title = "北楠ovo制作",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--createPopup()

--Window:SetUIScale(.8)

-- */  Tags  /* --
do
    local tag = Window:Tag({
        Title = "v0.0.1 北楠缝合脚本",
        Icon = "github",
        Color = Color3.fromHex("#30ff6a"),
        Radius = 13, -- from 0 to 13 (rounded corners)
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
    })
    
    -- 五颜六色循环渐变
    task.spawn(function()
        local hue = 0
        while true do
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            if tag and tag.SetColor then
                tag:SetColor(color)
            end
            task.wait(0.05)
        end
    end)
end

-- Set window background image (safe, pcall)
-- Directly set background image
if Window and Window.SetBackgroundImage then
    Window:SetBackgroundImage("rbxassetid://89828019713131")
elseif Window and Window.Background ~= nil then
    Window.Background = "rbxassetid://89828019713131"
end

-- Add blur effect for acrylic look
pcall(function()
    local lighting = game:GetService("Lighting")
    local blur = Instance.new("BlurEffect")
    blur.Name = "WindUIBlur"
    blur.Size = 24
    blur.Parent = lighting
end)

-- Toggle background transparency
pcall(function()
    if Window and type(Window.ToggleTransparency) == "function" then
        Window:ToggleTransparency(true)
    end
end)

-- */  Theme (soon)  /* --
do
    --[[WindUI:AddTheme({
        Name = "Stylish",
        
        Accent = Color3.fromHex("#3b82f6"), 
        Dialog = Color3.fromHex("#1a1a1a"), 
        Outline = Color3.fromHex("#3b82f6"),
        Text = Color3.fromHex("#f8fafc"),  
        Placeholder = Color3.fromHex("#94a3b8"),
        Button = Color3.fromHex("#334155"), 
        Icon = Color3.fromHex("#60a5fa"), 
        
        WindowBackground = Color3.fromHex("#0f172a"),
        
        TopbarButtonIcon = Color3.fromHex("#60a5fa"),
        TopbarTitle = Color3.fromHex("#f8fafc"),
        TopbarAuthor = Color3.fromHex("#94a3b8"),
        TopbarIcon = Color3.fromHex("#3b82f6"),
        
        TabBackground = Color3.fromHex("#1e293b"),    
        TabTitle = Color3.fromHex("#f8fafc"),
        TabIcon = Color3.fromHex("#60a5fa"),
        
        ElementBackground = Color3.fromHex("#1e293b"),
        ElementTitle = Color3.fromHex("#f8fafc"),
        ElementDesc = Color3.fromHex("#cbd5e1"),
        ElementIcon = Color3.fromHex("#60a5fa"),
    })--]]
    
    -- WindUI:SetTheme("Stylish")
end


-- */  Colors  /* --
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")


-- */ Other Functions /* --
local function parseJSON(luau_table, indent, level, visited)
    indent = indent or 2
    level = level or 0
    visited = visited or {}
    
    local currentIndent = string.rep(" ", level * indent)
    local nextIndent = string.rep(" ", (level + 1) * indent)
    
    if luau_table == nil then
        return "null"
    end
    
    local dataType = type(luau_table)
    
    if dataType == "table" then
        if visited[luau_table] then
            return "\"[Circular Reference]\""
        end
        
        visited[luau_table] = true
        
        local isArray = true
        local maxIndex = 0
        
        for k, _ in pairs(luau_table) do
            if type(k) == "number" and k > maxIndex then
                maxIndex = k
            end
            if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
                isArray = false
                break
            end
        end
        
        local count = 0
        for _ in pairs(luau_table) do
            count = count + 1
        end
        if count ~= maxIndex and isArray then
            isArray = false
        end
        
        if count == 0 then
            return "{}"
        end
        
        if isArray then
            if count == 0 then
                return "[]"
            end
            
            local result = "[\n"
            
            for i = 1, maxIndex do
                result = result .. nextIndent .. parseJSON(luau_table[i], indent, level + 1, visited)
                if i < maxIndex then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            
            result = result .. currentIndent .. "]"
            return result
        else
            local result = "{\n"
            local first = true
            
            local keys = {}
            for k in pairs(luau_table) do
                table.insert(keys, k)
            end
            table.sort(keys, function(a, b)
                if type(a) == type(b) then
                    return tostring(a) < tostring(b)
                else
                    return type(a) < type(b)
                end
            end)
            
            for _, k in ipairs(keys) do
                local v = luau_table[k]
                if not first then
                    result = result .. ",\n"
                else
                    first = false
                end
                
                if type(k) == "string" then
                    result = result .. nextIndent .. "\"" .. k .. "\": "
                else
                    result = result .. nextIndent .. "\"" .. tostring(k) .. "\": "
                end
                
                result = result .. parseJSON(v, indent, level + 1, visited)
            end
            
            result = result .. "\n" .. currentIndent .. "}"
            return result
        end
    elseif dataType == "string" then
        local escaped = luau_table:gsub("\\", "\\\\")
        escaped = escaped:gsub("\"", "\\\"")
        escaped = escaped:gsub("\n", "\\n")
        escaped = escaped:gsub("\r", "\\r")
        escaped = escaped:gsub("\t", "\\t")
        
        return "\"" .. escaped .. "\""
    elseif dataType == "number" then
        return tostring(luau_table)
    elseif dataType == "boolean" then
        return luau_table and "true" or "false"
    elseif dataType == "function" then
        return "\"function\""
    else
        return "\"" .. dataType .. "\""
    end
end

local function tableToClipboard(luau_table, indent)
    indent = indent or 4
    local jsonString = parseJSON(luau_table, indent)
    setclipboard(jsonString)
    return jsonString
end


-- */  About Tab  /* --
do
    local AboutTab = Window:Tab({
        Title = "详细信息",
        Desc = "Description Example", 
        Icon = "solar:info-square-bold",
        IconColor = Grey,
        IconShape = "Square",
        Border = true,
    })
    
    local AboutSection = AboutTab:Section({
        Title = "说的一些话",
    })
    
    AboutSection:Image({
        Image = "rbxassetid://89828019713131",
        AspectRatio = "16:9",
        Radius = 9,
    })
    
    AboutSection:Space({ Columns = 3 })
    
    AboutSection:Section({
        Title = "---------",
        TextSize = 24,
        FontWeight = Enum.FontWeight.SemiBold,
    })

    AboutSection:Space()
    
    AboutSection:Section({
        Title = [[这个脚本就是网站一个叫windui的开源脚本框架做出来的脚本是我找的一些很优质的塞进去的可能不会更新可能说不定也会更新我能力有限如果有人想要这个源代码进群加我QQ免费给你欢迎2改，脚本UI背景图我一直搞不明白怎么加载有人看见可以加我qq教一下ovo]],
        TextSize = 18,
        TextTransparency = .35,
        FontWeight = Enum.FontWeight.Medium,
    })
    
    AboutTab:Space({ Columns = 4 }) 
    
    
    -- Default buttons
    
    AboutTab:Button({
        Title = "Export WindUI JSON (copy)",
        Color = Color3.fromHex("#a2ff30"),
        Justify = "Center",
        IconAlign = "Left",
        Icon = "", -- removing icon
        Callback = function()
            setclipboard("1059240553")
            WindUI:Notify({
                Title = "1059240553",
                Content = "Copied to Clipboard!"
            })
        end
    })
    AboutTab:Space({ Columns = 1 }) 
    
    
    AboutTab:Button({
        Title = "卸载脚本(不留痕迹)",
        Color = Color3.fromHex("#ff4830"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
        end
    })
end

-- Doors Tab
local DoorsTab = Window:Tab({
    Title = "StarRing doors",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})

local DoorsSection = DoorsTab:Section({
    Title = "Sapphire",
})

-- Create 10 Open Door buttons
for i = 1, 1 do
    local idx = i
    DoorsSection:Button({
        Title = "点击开启运行" .. idx,
        Callback = function()
            print("Open Door " .. idx .. " pressed")
            WindUI:Notify({ Title = "Doors", Content = "StarRing 💎 Sapphire已运行请稍等" })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
        end
    })
end

-- Select the Doors tab programmatically
DoorsTab:Select()

Window:Divider()

-- Additional Tabs
local GeneralTab = Window:Tab({
    Title = "通用",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})

local GeneralSpeedSection = GeneralTab:Section({ Title = "速度调节", })

GeneralSpeedSection:Slider({
    Title = "移动速度",
    Desc = "调整角色移动速度 (16-100)",
    Step = 1,
    Value = {
        Min = 16,
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
})

GeneralSpeedSection:Slider({
    Title = "跳跃高度",
    Desc = "调整角色跳跃高度 (50-200)",
    Step = 5,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
        end
    end
})

GeneralTab:Button({
    Title = "飞行 1",
    Callback = function()
        print("飞行 1 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 1 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 2",
    Callback = function()
        print("飞行 2 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 2 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 3",
    Callback = function()
        print("飞行 3 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 3 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 4",
    Callback = function()
        print("飞行 4 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 4 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 5",
    Callback = function()
        print("飞行 5 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 5 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 6",
    Callback = function()
        print("飞行 6 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 6 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 7",
    Callback = function()
        print("飞行 7 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 7 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralTab:Button({
    Title = "飞行 8",
    Callback = function()
        print("飞行 8 pressed")
        WindUI:Notify({ Title = "通用飞行", Content = "正在加载飞行 8 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

-- Select the General (通用) tab programmatically
GeneralTab:Select()

-- Additional Doors Control inside General
local GeneralDoorsControl = GeneralTab:Section({ Title = "Doors Control (追加)", })

GeneralDoorsControl:Button({
    Title = "Door 1",
    Callback = function()
        print("Door 1 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 1 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 2",
    Callback = function()
        print("Door 2 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 2 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 3",
    Callback = function()
        print("Door 3 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 3 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 4",
    Callback = function()
        print("Door 4 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 4 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 5",
    Callback = function()
        print("Door 5 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 5 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 6",
    Callback = function()
        print("Door 6 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 6 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 7",
    Callback = function()
        print("Door 7 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 7 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl:Button({
    Title = "Door 8",
    Callback = function()
        print("Door 8 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Door 8 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

-- Another Doors Control inside General
local GeneralDoorsControl2 = GeneralTab:Section({ Title = "自然灾害黑洞", })

GeneralDoorsControl2:Button({
    Title = "黑洞 1",
    Callback = function()
        print("黑洞 1 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 1 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 2",
    Callback = function()
        print("黑洞 2 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 2 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 3",
    Callback = function()
        print("黑洞 3 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 3 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 4",
    Callback = function()
        print("黑洞 4 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 4 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 5",
    Callback = function()
        print("黑洞 5 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 5 脚本..." })
        loadstring(game:HttpGet("https://pastefy.app/xV1T3PAi/raw"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 6",
    Callback = function()
        print("黑洞 6 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 6 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 7",
    Callback = function()
        print("黑洞 7 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 7 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl2:Button({
    Title = "黑洞 8",
    Callback = function()
        print("黑洞 8 pressed")
        WindUI:Notify({ Title = "自然灾害", Content = "正在加载黑洞 8 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

-- Another Doors Control inside General
local GeneralDoorsControl3 = GeneralTab:Section({ Title = "Doors Control", })

GeneralDoorsControl3:Button({
    Title = "Control 1",
    Callback = function()
        print("Control 1 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 1 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 2",
    Callback = function()
        print("Control 2 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 2 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 3",
    Callback = function()
        print("Control 3 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 3 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 4",
    Callback = function()
        print("Control 4 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 4 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 5",
    Callback = function()
        print("Control 5 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 5 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 6",
    Callback = function()
        print("Control 6 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 6 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 7",
    Callback = function()
        print("Control 7 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 7 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

GeneralDoorsControl3:Button({
    Title = "Control 8",
    Callback = function()
        print("Control 8 pressed")
        WindUI:Notify({ Title = "Doors Control", Content = "正在加载 Control 8 脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

-- MimicTab and GenshinTab removed as requested

-- Additional Doors-like Tabs
local Doors2Tab = Window:Tab({
    Title = "脚本中心",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})

Doors2Tab:Button({
    Title = "脚本 1",
    Callback = function()
        print("脚本 1 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "BS脚本中心",
    Callback = function()
        print("BS脚本 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本耐心等待" })
        loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\103\101\109\120\72\119\65\49"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 3",
    Callback = function()
        print("脚本 3 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 4",
    Callback = function()
        print("脚本 4 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 5",
    Callback = function()
        print("脚本 5 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 6",
    Callback = function()
        print("脚本 6 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 7",
    Callback = function()
        print("脚本 7 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Doors2Tab:Button({
    Title = "脚本 8",
    Callback = function()
        print("脚本 8 pressed")
        WindUI:Notify({ Title = "脚本中心", Content = "正在加载脚本..." })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
    end
})

Window:Divider()

local Doors3Tab = Window:Tab({
    Title = "doors3",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})
local Doors3Section = Doors3Tab:Section({ Title = "Doors Control", })

-- Create 10 Open Door buttons
for i = 1, 1 do
    local idx = i
    Doors3Section:Button({
        Title = "Open Door " .. idx,
        Callback = function()
            print("Open Door " .. idx .. " pressed")
            WindUI:Notify({ Title = "Doors", Content = "Running remote script..." })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
        end
    })
end

local Doors4Tab = Window:Tab({
    Title = "doors4",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})
local Doors4Section = Doors4Tab:Section({ Title = "Doors Control", })

-- Create 10 Open Door buttons
for i = 1, 1 do
    local idx = i
    Doors4Section:Button({
        Title = "Open Door " .. idx,
        Callback = function()
            print("Open Door " .. idx .. " pressed")
            WindUI:Notify({ Title = "Doors", Content = "Running remote script..." })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
        end
    })
end

local Doors5Tab = Window:Tab({
    Title = "doors5",
    Icon = "door",
    IconColor = Grey,
    Border = true,
})
local Doors5Section = Doors5Tab:Section({ Title = "Doors Control", })

-- Create 10 Open Door buttons
for i = 1, 1 do
    local idx = i
    Doors5Section:Button({
        Title = "Open Door " .. idx,
        Callback = function()
            print("Open Door " .. idx .. " pressed")
            WindUI:Notify({ Title = "Doors", Content = "Running remote script..." })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XxxStellatexxX/Sapphire-is-the-best/refs/heads/main/Script"))()
        end
    })
end

-- */  Elements Section  /* --
local ElementsSection = Window:Section({
    Title = "Elements",
})
local ConfigUsageSection = Window:Section({
    Title = "Config Usage",
})
local OtherSection = Window:Section({
    Title = "Other",
})
local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird", -- optional
    Locked = false,
})
local Section = Window:Section({
    Title = "Section for the tabs",
    Icon = "bird",
    Opened = true,
})




-- */  Overview Tab  /* --
do
    local OverviewTab = ElementsSection:Tab({
        Title = "Overview",
        Icon = "solar:home-2-bold",
        IconColor = Grey,
        IconShape = "Square",
        Border = true,
    })
    
    local OverviewSection1 = OverviewTab:Section({
        Title = "Group's Example"
    })
    
    local OverviewGroup1 = OverviewTab:Group({})
    
    OverviewGroup1:Button({ Title = "Button 1", Justify = "Center", Icon = "", Callback = function() print("clicked button 1") end })
    OverviewGroup1:Space()
    OverviewGroup1:Button({ Title = "Button 2", Justify = "Center", Icon = "", Callback = function() print("clicked button 2") end })
    
    OverviewTab:Space()
    
    local OverviewGroup2 = OverviewTab:Group({})
    
    OverviewGroup2:Button({ Title = "Button 1", Justify = "Center", Icon = "", Callback = function() print("clicked button 1") end })
    OverviewGroup2:Space()
    OverviewGroup2:Toggle({ Title = "Toggle 2",  Callback = function(v) print("clicked toggle 2:", v) end })
    OverviewGroup2:Space()
    OverviewGroup2:Colorpicker({ Title = "Colorpicker 3", Default = Color3.fromHex("#30ff6a"), Callback = function(color) print(color) end })
    
    OverviewTab:Space()
    
    local OverviewGroup3 = OverviewTab:Group({})
    
    
    local OverviewSection1 = OverviewGroup3:Section({
        Title = "Section 1",
        Desc = "Section exampleee",
        Box = true,
        BoxBorder = true,
        Opened = true,
    })
    OverviewSection1:Button({ Title = "Button 1", Justify = "Center", Icon = "", Callback = function() print("clicked button 1") end })
    OverviewSection1:Space()
    OverviewSection1:Toggle({ Title = "Toggle 2",  Callback = function(v) print("clicked toggle 2:", v) end })
    
    
    OverviewGroup3:Space()
    
    
    local OverviewSection2 = OverviewGroup3:Section({
        Title = "Section 2",
        Box = true,
        BoxBorder = true,
        Opened = true,
    })
    OverviewSection2:Button({ Title = "Button 1", Justify = "Center", Icon = "", Callback = function() print("clicked button 1") end })
    OverviewSection2:Space()
    OverviewSection2:Button({ Title = "Button 2", Justify = "Center", Icon = "", Callback = function() print("clicked button 2") end })

    --OverviewTab:Space()
    
end


-- */  Toggle Tab  /* --
do
    local ToggleTab = ElementsSection:Tab({
        Title = "Toggle",
        Icon = "solar:check-square-bold",
        IconColor = Green,
        IconShape = "Square",
        Border = true,
    })
    
    
    ToggleTab:Toggle({
        Title = "Toggle",
    })
    
    ToggleTab:Space()
    
    ToggleTab:Toggle({
        Title = "Toggle",
        Desc = "Toggle example"
    })
    
    ToggleTab:Space()
    
    local ToggleGroup1 = ToggleTab:Group()
    ToggleGroup1:Toggle({})
    ToggleGroup1:Space()
    ToggleGroup1:Toggle({})
    
    ToggleTab:Space()
    
    ToggleTab:Toggle({
        Title = "Checkbox",
        Type = "Checkbox",
    })
    
    ToggleTab:Space()
    
    ToggleTab:Toggle({
        Title = "Checkbox",
        Desc = "Checkbox example",
        Type = "Checkbox",
    })
    
    ToggleTab:Space()
    
    
    ToggleTab:Toggle({
        Title = "Toggle",
        Locked = true,
        LockedTitle = "This element is locked",
    })
    
    ToggleTab:Toggle({
        Title = "Toggle",
        Desc = "Toggle example",
        Locked = true,
        LockedTitle = "This element is locked",
    })
end


-- */  Button Tab  /* --
do
    local ButtonTab = ElementsSection:Tab({
        Title = "Button",
        Icon = "solar:cursor-square-bold",
        IconColor = Blue,
        IconShape = "Square",
        Border = true,
    })
    
    
    local HighlightButton
    HighlightButton = ButtonTab:Button({
        Title = "Highlight Button",
        Icon = "mouse",
        Callback = function()
            print("clicked highlight")
            HighlightButton:Highlight()
        end
    })

    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Blue Button",
        Color = Color3.fromHex("#305dff"),
        Icon = "",
        Callback = function()
        end
    })

    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Blue Button",
        Desc = "With description",
        Color = Color3.fromHex("#305dff"),
        Icon = "",
        Callback = function()
        end
    })
    
    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Notify Button",
        --Desc = "Button example",
        Callback = function()
            WindUI:Notify({
                Title = "Hello",
                Content = "Welcome to the WindUI Example!",
                Icon = "solar:bell-bold",
                Duration = 5,
                CanClose = false,
            })
        end
    })
    
    
    ButtonTab:Button({
        Title = "Notify Button 2",
        --Desc = "Button example",
        Callback = function()
            WindUI:Notify({
                Title = "Hello",
                Content = "Welcome to the WindUI Example!",
                --Icon = "solar:bell-bold",
                Duration = 5,
                CanClose = false,
            })
        end
    })
    
    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Button",
        Locked = true,
        LockedTitle = "This element is locked",
    })
    
    
    ButtonTab:Button({
        Title = "Button",
        Desc = "Button example",
        Locked = true,
        LockedTitle = "This element is locked",
    })
end


-- */  Input Tab  /* --
do
    local InputTab = ElementsSection:Tab({
        Title = "Input",
        Icon = "solar:password-minimalistic-input-bold",
        IconColor = Purple,
        IconShape = "Square",
        Border = true,
    })
    
    
    InputTab:Input({
        Title = "Input",
        Icon = "mouse"
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        --Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Desc = "Input example",
        Type = "Textarea",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Locked = true,
        LockedTitle = "This element is locked",
    })
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
        Locked = true,
        LockedTitle = "This element is locked",
    })
end


-- */  Slider Tab  /* --
do
    local SliderTab = ElementsSection:Tab({
        Title = "Slider",
        Icon = "solar:square-transfer-horizontal-bold",
        IconColor = Green,
        IconShape = "Square",
        Border = true,
    })
    
    SliderTab:Section({
        Title = "Default Slider with Tooltip and without textbox",
        TextSize = 14,
    })
    
    SliderTab:Slider({
        Title = "Slider Example",
        Desc = "Hahahahaha hello",
        IsTooltip = true,
        IsTextbox = false,
        Width = 200,
        Step = 1,
        Value = {
            Min = 0,
            Max = 200,
            Default = 100,
        },
        Callback = function(value)
            print(value)
        end
    })

    SliderTab:Space()
    
    SliderTab:Section({
        Title = "Slider without description",
        TextSize = 14,
    })
    
    SliderTab:Slider({
        Title = "Slider Example",
        Step = 1,
        Width = 200,
        Value = {
            Min = 0,
            Max = 200,
            Default = 100,
        },
        Callback = function(value)
            print(value)
        end
    })

    SliderTab:Space()
    
    SliderTab:Section({
        Title = "Slider without titles",
        TextSize = 14,
    })
    
    SliderTab:Slider({
        IsTooltip = true,
        Step = 1,
        Value = {
            Min = 0,
            Max = 200,
            Default = 100,
        },
        Callback = function(value)
            print(value)
        end
    })

    SliderTab:Space()
    
    SliderTab:Section({
        Title = "Slider with icons ('from' only)",
        TextSize = 14,
    })
    
    SliderTab:Slider({
        IsTooltip = true,
        Step = 1,
        Value = {
            Min = 0,
            Max = 200,
            Default = 100,
        },
        Icons = {
            From = "sfsymbols:sunMinFill",
            --To = "sfsymbols:sunMaxFill",
        },
        Callback = function(value)
            print(value)
        end
    })

    SliderTab:Space()
    
    SliderTab:Section({
        Title = "Slider with icons (from & to)",
        TextSize = 14,
    })
    
    SliderTab:Slider({
        IsTooltip = true,
        Step = 1,
        Value = {
            Min = 0,
            Max = 100,
            Default = 50,
        },
        Icons = {
            From = "sfsymbols:sunMinFill",
            To = "sfsymbols:sunMaxFill",
        },
        Callback = function(value)
            print(value)
        end
    })
end


-- */  Dropdown Tab  /* --
do
    local DropdownTab = ElementsSection:Tab({
        Title = "Dropdown",
        Icon = "solar:hamburger-menu-bold",
        IconColor = Yellow,
        IconShape = "Square",
        Border = true,
    })
    
    
    DropdownTab:Dropdown({
        Title = "Advanced Dropdown (example)",
        Values = {
            {
                Title = "New file",
                Desc = "Create a new file",
                Icon = "file-plus",
                Callback = function() 
                    print("Clicked 'New File'")
                end
            },
            {
                Title = "Copy link",
                Desc = "Copy the file link",
                Icon = "copy",
                Callback = function() 
                    print("Clicked 'Copy link'")
                end
            },
            {
                Title = "Edit file",
                Desc = "Allows you to edit the file",
                Icon = "file-pen",
                Callback = function() 
                    print("Clicked 'Edit file'")
                end
            },
            {
                Type = "Divider",
            },
            {
                Title = "Delete file",
                Desc = "Permanently delete the file",
                Icon = "trash",
                Callback = function() 
                    print("Clicked 'Delete file'")
                end
            },
        }
    })
    
    DropdownTab:Space()
    
    DropdownTab:Dropdown({
        Title = "Multi Dropdown",
        Values = {
            "Привет", "Hello", "Сәлем", "Bonjour"
        },
        Value = nil,
        AllowNone = true,
        Multi = true,
        Callback = function(selectedValue)
            print("Selected: " .. selectedValue)
        end
    })
    
    DropdownTab:Space()
    
    DropdownTab:Dropdown({
        Title = "No Multi Dropdown (default",
        Values = {
            "Привет", "Hello", "Сәлем", "Bonjour"
        },
        Value = 1,
        --AllowNone = true,
        Callback = function(selectedValue)
            print("Selected: " .. selectedValue)
        end
    })
    
    DropdownTab:Space()
    
    
end



--[[  idk. VideoFrame is not working with custom video on exploits
      I don't know why
    
-- */  Video Tab  /* --
do
    local VideoTab = ElementsSection:Tab({
        Title = "Video",
        Icon = "video",
    })
    
    VideoTab:Video({
        Title = "My Video Hahahah", -- optional
        Author = ".ftgs", -- optional
        Video = "https://cdn.discordapp.com/attachments/1337368451865645096/1402703845657673878/VID_20250616_180732_158.webm?ex=68fc5f01&is=68fb0d81&hm=f4f0a88dbace2d3cef92535b2e57effae6d4c4fc444338163faafa7f3fdac529&"
    })
end

--]]


-- */  Config Usage  /* --
do -- config elements
    local ConfigElementsTab = ConfigUsageSection:Tab({
        Title = "Config Elements",
        Icon = "solar:file-text-bold",
        IconColor = Blue,
        IconShape = nil,
        Border = true,
    })
    
    -- All elements are taken from the official documentation: https://footagesus.github.io/WindUI-Docs/docs
    
    -- Saving elements to the config using `Flag`
    
    ConfigElementsTab:Colorpicker({
        Flag = "ColorpickerTest",
        Title = "Colorpicker",
        Desc = "Colorpicker Description",
        Default = Color3.fromRGB(0, 255, 0),
        Transparency = 0,
        Locked = false,
        Callback = function(color) 
            print("Background color: " .. tostring(color))
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Dropdown({
        Flag = "DropdownTest",
        Title = "Advanced Dropdown",
        Values = {
            {
                Title = "Category A",
                Icon = "bird"
            },
            {
                Title = "Category B",
                Icon = "house"
            },
            {
                Title = "Category C",
                Icon = "droplet"
            },
        },
        Value = "Category A",
        Callback = function(option) 
            print("Category selected: " .. option.Title .. " with icon " .. option.Icon) 
        end
    })
    ConfigElementsTab:Dropdown({
        Flag = "DropdownTest2",
        Title = "Advanced Dropdown 2",
        Values = {
            {
                Title = "Category A",
                Icon = "bird"
            },
            {
                Title = "Category B",
                Icon = "house"
            },
            {
                Title = "Category C",
                Icon = "droplet",
                Locked = true,
            },
        },
        Value = "Category A",
        Multi = true,
        Callback = function(options) 
            local titles = {}
            for _, v in ipairs(options) do
                table.insert(titles, v.Title)
            end
            print("Selected: " .. table.concat(titles, ", "))
        end
    })
    
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Input({
        Flag = "InputTest",
        Title = "Input",
        Desc = "Input Description",
        Value = "Default value",
        InputIcon = "bird",
        Type = "Input", -- or "Textarea"
        Placeholder = "Enter text...",
        Callback = function(input) 
            print("Text entered: " .. input)
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Keybind({
        Flag = "KeybindTest",
        Title = "Keybind",
        Desc = "Keybind to open ui",
        Value = "G",
        Callback = function(v)
            Window:SetToggleKey(Enum.KeyCode[v])
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Slider({
        Flag = "SliderTest",
        Title = "Slider",
        Step = 1,
        Value = {
            Min = 20,
            Max = 120,
            Default = 70,
        },
        Callback = function(value)
            print(value)
        end
    })
    ConfigElementsTab:Slider({
        Flag = "SliderTest2",
        --Title = "Slider",
        Icons = {
            From = "sfsymbols:sunMinFill",
            To = "sfsymbols:sunMaxFill",
        },
        Step = 1,
        IsTooltip = true,
        Value = {
            Min = 0,
            Max = 100,
            Default = 50,
        },
        Callback = function(value)
            print(value)
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Toggle({
        Flag = "ToggleTest",
        Title = "Toggle Panel Background",
        --Desc = "Toggle Description",
        --Icon = "house",
        --Type = "Checkbox",
        Value = not Window.HidePanelBackground,
        Callback = function(state) 
            Window:SetPanelBackground(state)
        end
    })
    
    ConfigElementsTab:Toggle({
        Flag = "ToggleTest",
        Title = "Toggle",
        Desc = "Toggle Description",
        --Icon = "house",
        --Type = "Checkbox",
        Value = false,
        Callback = function(state) 
            print("Toggle Activated" .. tostring(state))
        end
    })
end

do -- config panel
    local ConfigTab = ConfigUsageSection:Tab({
        Title = "Config Usage",
        Icon = "solar:folder-with-files-bold",
        IconColor = Purple,
        IconShape = nil,
        Border = true,
    })

    local ConfigManager = Window.ConfigManager
    local ConfigName = "default"

    local ConfigNameInput = ConfigTab:Input({
        Title = "Config Name",
        Icon = "file-cog",
        Callback = function(value)
            ConfigName = value
        end
    })

    ConfigTab:Space()
    
    -- local AutoLoadToggle = ConfigTab:Toggle({
    --     Title = "Enable Auto Load to Selected Config",
    --     Value = false,
    --     Callback = function(v)
    --         Window.CurrentConfig:SetAutoLoad(v)
    --     end
    -- })

    -- ConfigTab:Space()

    local AllConfigs = ConfigManager:AllConfigs()
    local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

    local AllConfigsDropdown = ConfigTab:Dropdown({
        Title = "All Configs",
        Desc = "Select existing configs",
        Values = AllConfigs,
        Value = DefaultValue,
        Callback = function(value)
            ConfigName = value
            ConfigNameInput:Set(value)
            
            AutoLoadToggle:Set(ConfigManager:GetConfig(ConfigName).AutoLoad or false)
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Save Config",
        Icon = "",
        Justify = "Center",
        Callback = function()
            Window.CurrentConfig = ConfigManager:Config(ConfigName)
            if Window.CurrentConfig:Save() then
                WindUI:Notify({
                    Title = "Config Saved",
                    Desc = "Config '" .. ConfigName .. "' saved",
                    Icon = "check",
                })
            end
            
            AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Load Config",
        Icon = "",
        Justify = "Center",
        Callback = function()
            Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
            if Window.CurrentConfig:Load() then
                WindUI:Notify({
                    Title = "Config Loaded",
                    Desc = "Config '" .. ConfigName .. "' loaded",
                    Icon = "refresh-cw",
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Print AutoLoad Configs",
        Icon = "",
        Justify = "Center",
        Callback = function()
            print(HttpService:JSONDecode(ConfigManager:GetAutoLoadConfigs()))
        end
    })
end




-- */  Other  /* --
do
    local InviteCode = "ftgs-development-hub-1300692552005189632"
    local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

    local Response = WindUI.cloneref(game:GetService("HttpService")):JSONDecode(WindUI.Creator.Request({
        Url = DiscordAPI,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "WindUI/Example",
            ["Accept"] = "application/json"
        }
    }).Body)
    
    local DiscordTab = OtherSection:Tab({
        Title = "Discord",
        Border = true,
    })
    
    if Response and Response.guild then
        DiscordTab:Section({
            Title = "Join our Discord server!",
            TextSize = 20,
        })
        local DiscordServerParagraph = DiscordTab:Paragraph({
            Title = tostring(Response.guild.name),
            Desc = tostring(Response.guild.description),
            Image = "rbxassetid://89828019713131",
            Thumbnail = "rbxassetid://89828019713131",
            ImageSize = 48,
            Buttons = {
                {
                    Title = "Copy link",
                    Icon = "link",
                    Callback = function()
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                }
            }
        })
        
    end
end



-- */ Using Nebula Icons /* --
--[[
do
    local NebulaIcons = loadstring(game:HttpGetAsync("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
    
    -- Adding icons (e.g. Fluency)
    WindUI.Creator.AddIcons("fluency",    NebulaIcons.Fluency)
    --               ^ Icon name          ^ Table of Icons
    
    -- You can also add nebula icons
    WindUI.Creator.AddIcons("nebula",    NebulaIcons.nebulaIcons)
    
    -- Usage ↑ ↓
    
    local TestSection = Window:Section({
        Title = "Custom icons usage test (nebula)",
        Icon = "nebula:nebula",
    })
end
]]
--[[

local EndButStartTab = Window:Tab({
    Title = "EndButStartTab",
    -- u can use `Before` or `After`
    Before = AboutTab, -- put this tab Before AboutTab
    
})
--]]