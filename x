local Library = {
    open = true,
    accent = Color3.fromRGB(246, 149, 255),
    dragging = false,
    flags = {},
    tabs = {},
    tabammount = {},
    sections = {},
    multisections = {},
    unnamedflags = {},
    unloaded = false,
    holder = nil,
    key = Enum.KeyCode.End,
    Folders = {
        Default = "uilibrary",
        Config = "uilibrary/config"
    },
    connections = {},
    keys = {
        [Enum.KeyCode.Space] = "space",
        [Enum.KeyCode.Return] = "return",
        [Enum.KeyCode.LeftShift] = "leftshift",
        [Enum.KeyCode.RightShift] = "rightshift",
        [Enum.KeyCode.LeftControl] = "lctrl",
        [Enum.KeyCode.RightControl] = "rctrl",
        [Enum.KeyCode.LeftAlt] = "lalt",
        [Enum.KeyCode.RightAlt] = "ralt",
        [Enum.KeyCode.CapsLock] = "caps",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "num1",
        [Enum.KeyCode.KeypadTwo] = "num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "num4",
        [Enum.KeyCode.KeypadFive] = "num5",
        [Enum.KeyCode.KeypadSix] = "num6",
        [Enum.KeyCode.KeypadSeven] = "num7",
        [Enum.KeyCode.KeypadEight] = "num8",
        [Enum.KeyCode.KeypadNine] = "num9",
        [Enum.KeyCode.KeypadZero] = "num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "m1",
        [Enum.UserInputType.MouseButton2] = "m2",
        [Enum.UserInputType.MouseButton3] = "m3"
    };
    priorities = {},
    friendly = {},
    enemies = {},
    friends = {},
    notificationholder = nil,
    notifications = 0,
}

local Players, UserInputService, LocalPlayer, INew = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer, Instance.new
local Flags = {}
local Mouse = LocalPlayer:GetMouse()
local CurrentList = {}

Library.__index = Library
Library.tabs.__index = Library.tabs
Library.sections.__index = Library.sections

if isfile("menu_plex.font") then
	delfile("menu_plex.font")
end

if not isfile("ProggyTiny.ttf") then
    writefile("ProggyTiny.ttf", game:HttpGet("https://github.com/f1nobe7650/other/raw/main/ProggyTiny.ttf"))
end

local round = function(number,float)
    return float * math.floor(number / float)
end

do
	getsynasset = getcustomasset or getsynasset
	Font = setreadonly(Font, false);
	function Font:Register(Name, Weight, Style, Asset)
		if not isfile(Name .. ".font") then
			if not isfile(Asset.Id) then
				writefile(Asset.Id, Asset.Font);
			end;
			--
			local Data = {
				name = Name,
				faces = {{
					name = "Regular",
					weight = Weight,
					style = Style,
					assetId = getsynasset(Asset.Id);
				}}
			};
			--
			writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data));
			return getsynasset(Name .. ".font");
		else 
			warn("Font already registered");
		end;
	end;
	--
	function Font:GetRegistry(Name)
		if isfile(Name .. ".font") then
			return getsynasset(Name .. ".font");
		end;
	end;

	Font:Register("menu_plex", 400, "normal", {Id = "ProggyTiny.ttf", Font = ""});
end

local realfont = Font.new(Font:GetRegistry("menu_plex"))

local function NewInstance(Class, Properties)
    local NewInstance = INew(Class)

    for Property, Value in next, Properties do
        NewInstance[Property] = Value 
    end

    return NewInstance
end

local mouseoverframe = function(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

        return true;
    end;

    return false;
end;

local SGUI = NewInstance("ScreenGui", {
    Parent = game.CoreGui or gethui(),
    ResetOnSpawn = false
})

function Library:UpdateNotificationPositions(position)
   local i = self.notifications
    local Position = Vector2.new(20, 0)
    return UDim2.new(0,Position.X,0,Position.Y + (i * 25))
end

Library.holder = SGUI

function Library:Notify(options)
    local Notification = {
        Name = options.Name or options.name or 'Notification',
        Duration = options.Duration or options.duration or 3,
        Color = options.color or options.Color or self.accent
    }

    self.notifications += 1

    local notification = NewInstance("Frame", {
        Name = "notification";
        Parent = self.holder;
        BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 11, 0, 15);
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = notification,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Transparency = 1
    })

    local notificationtitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = notification;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(0, 0, 0, 17);
        FontFace =realfont;
        Text = Notification.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Left;
        AutomaticSize = Enum.AutomaticSize.X;
        TextTransparency = 1
    })

    notification.Size = UDim2.new(0, notification.Size.X.Offset + notificationtitle.TextBounds.X + 10, 0 ,0)

    local Accent = NewInstance("Frame", {
        Name = "liner";
        Parent = notification;
        BackgroundColor3 = Notification.Color;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(0, 0, 0, 1);
        BackgroundTransparency = 1
    })

    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 143, 143))};
        Rotation = 90;
        Parent = notification;
    })

    task.spawn(function()
        local tween1 = game:GetService("TweenService"):Create(notification, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0})
        local tween2 = game:GetService("TweenService"):Create(UIStroke1, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0})
        tween1:Play()
        tween2:Play()
        tween2.Completed:Wait()
        task.wait(0.3)
        Accent.BackgroundTransparency = 0
        task.wait(0.1)
        local tween3 = game:GetService("TweenService"):Create(Accent, TweenInfo.new(0.74, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1,0,0,1)})
        tween3:Play()
        tween3.Completed:Wait()
        local tween4 = game:GetService("TweenService"):Create(notificationtitle, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0})
        tween4:Play()

        task.delay(Notification.Duration, function()
            local tween14 = game:GetService("TweenService"):Create(notificationtitle, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 1})
            tween14:Play()
            tween14.Completed:Wait()
            local tween344 = game:GetService("TweenService"):Create(Accent, TweenInfo.new(0.74, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0,0,0,1)})
            task.wait(0.1)
            tween344:Play()
            tween344.Completed:Wait()
            task.wait(0.3)
            local tween144 = game:GetService("TweenService"):Create(notification, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
            local tween244 = game:GetService("TweenService"):Create(UIStroke1, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 1})
            tween144:Play()
            tween144.Completed:Wait()
            tween244:Play()
            --
            notification:Destroy()
        end)
    end)

    local pos = Vector2.new(20, 0)
    notification.Position = Library:UpdateNotificationPositions(pos)
    return Notification
end

function Library:Watermark(options)
    local Watermark = {
        Name = options.Name or options.name or 'Watermark',
        DisplayFPS = options.Fps or options.fps or true,
        DisplayPing = options.Ping or options.ping or true
    }

    local watermark = NewInstance("Frame", {
        Name = "watermark";
        Parent = Library.holder;
        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 152, 0, -27);
        Size = UDim2.new(0, 100, 0, 20);
        AutomaticSize = Enum.AutomaticSize.X;
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = watermark,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local Gradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 143, 143))};
        Rotation = 90;
        Parent = watermark;
    })

    local TextLabel = NewInstance("TextLabel", {
        Name = "text";
        Parent = watermark;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Watermark.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
        AutomaticSize = Enum.AutomaticSize.X
    })

    local Liner = NewInstance("Frame", {
        Name = "liner";
        Parent = watermark;
        BackgroundColor3 = Library.accent;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 5, 0, 1);
    })

    local FrameTimer = tick()
    local FrameCounter = 0;
    local FPS = 60;

    local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
        FrameCounter += 1;

        if (tick() - FrameTimer) >= 1 then
            FPS = FrameCounter;
            FrameTimer = tick();
            FrameCounter = 0;
        end;

        if Watermark.DisplayFPS then
            if Watermark.DisplayPing then 
                TextLabel.Text = `{Watermark.Name} | fps: {math.floor(FPS)} |  {math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())}ms`
            else
                TextLabel.Text = `{Watermark.Name} | {math.floor(FPS)}`
            end
        else
            TextLabel.Text = `{Watermark.Name}`
        end

        --watermark.Size = UDim2.new(0, watermark.Size.X.Offset + TextLabel.TextBounds.X , 0,20)
    end);

    return Watermark
end

function Library:Window(options)
    if not options then
        options = {}
    end

    local Window = {Name = options.Name or options.name, Properties = {}}

    local NewWindow = NewInstance("Frame", {
        Name = "mainframe";
        Parent = Library.holder;
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(21, 21, 21);
        BorderColor3 = Color3.fromRGB(13, 13, 13);
        BorderSizePixel = 2;
        Position = UDim2.new(0.5, 0, 0.5, 0);
        Size = UDim2.new(0, 557, 0, 450);
        ZIndex = 1;
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = NewWindow,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local Notificationholder = NewInstance("Frame", {
        Name = "notificationholder";
        Parent = Library.holder;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 11, 0, 15);
        Size = UDim2.new(0.125, 100, 1, -30);
        AutomaticSize = Enum.AutomaticSize.XY
    })

    Library.notificationholder = Notificationholder

    local listlayoutw = NewInstance("UIListLayout", {
        Parent = Notificationholder;
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Bottom;
        Padding = UDim.new(0, 8);
    })

    local WindowTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewWindow;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 0, 0, -10);
        Size = UDim2.new(1, 0, 0, 20);
        ZIndex = 5;
        FontFace = realfont;
        Text = Window.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextWrapped = false;
    })

    local AccentColor = NewInstance("Frame", {
        Name = "liner";
        Parent = NewWindow;
        BackgroundColor3 = Library.accent;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 1);
    })

    local Inline = NewInstance("Frame", {
        Name = "inline";
        Parent = NewWindow;
        BackgroundColor3 = Color3.fromRGB(13, 13, 13);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 7, 0, 10);
        Size = UDim2.new(1, -14, 1.00888884, -18);
    })

    local UIStroke2 = NewInstance("UIStroke", {
        Parent = Inline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local TabHolder = NewInstance("Frame", {
        Name = "tabholder";
        Parent = Inline;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 7, 0, 3);
        Size = UDim2.new(1, -14, 0, 20);
    })

    local UIListLayout = NewInstance("UIListLayout", {
        Parent = TabHolder;
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        HorizontalFlex = Enum.UIFlexAlignment.Fill
    })

    local NewInline = NewInstance("Frame", {
        Name = "newinline";
        Parent = Inline;
        BackgroundColor3 = Color3.fromRGB(11, 11, 11);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 5, 0, 25);
        Size = UDim2.new(1, -10, 1, -30);
    })

    local UIStroke3 = NewInstance("UIStroke", {
        Parent = NewInline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local ContentContainer = NewInstance("Frame", {
        Name = "content";
        Parent = NewInline;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
    })
    -- 
    Window.Properties = {
        Content = ContentContainer,
        Tabs = TabHolder,
    }
    --
    local gui = NewWindow
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Library.dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Library.dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and Library.dragging then
            update(input)
        end
    end)

    return setmetatable(Window,Library)
end

function Library:Tab(options)
    if not options then
        options = {}
    end

    local Tab = {
        Window = self,
        Name = options.Name or options.name or 'Tab',
        Active = false,
        Hovered = false,
        Properties = {},
        Sections = {}
    }

    local TabButton = NewInstance("TextButton", {
        Name = "inactive";
        Parent = Tab.Window.Properties.Tabs;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(0, 200, 0, 20);
        AutoButtonColor = false;
        FontFace = realfont;
        Text = Tab.Name;
        TextColor3 = Color3.fromRGB(175, 175, 175);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local TabContent = NewInstance("Frame", {
        Name = Tab.Name;
        Parent = Tab.Window.Properties.Content;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        Visible = false;
    })

    local SectionHolders = NewInstance("ScrollingFrame", {
        Name = "sectionholders";
        Parent = TabContent;
        Active = true;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        ScrollBarThickness = 0;
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local LeftSide = NewInstance("Frame", {
        Name = "left";
        Parent = SectionHolders;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 7, 0, 7);
        Size = UDim2.new(0.469999999, 0, 1, 0);
    })

    local ListLayout1 = NewInstance("UIListLayout", {
        Parent = LeftSide;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 8);
    })

    local RightSide = NewInstance("Frame", {
        Name = "left";
        Parent = SectionHolders;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1, -7, 0, 7);
        Size = UDim2.new(0.469999999, 0, 1, 0);
    })

    local ListLayout2 = NewInstance("UIListLayout", {
        Parent = RightSide;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 8);
    })
    -- 
    Tab.Properties = {
        Left = LeftSide,
        Right = RightSide,
        Main = SectionHolders
    }
    -- 
    function Tab:Switch(bool)
		Tab.active = bool
		TabContent.Visible = bool
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		if bool then
			TabContent.Visible = true 
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		elseif not Tab.Hovered then
			TabContent.Visible = false 
            TabButton.TextColor3 = Color3.fromRGB(175, 175, 175)
		end
	end

	TabButton.InputBegan:Connect(function(inp,gpe)
		if gpe then return end 
				
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then 
			Library.dragging = nil
			for _, v in pairs(Library.tabammount) do
				v:Switch(v == Tab)
			end
		end
	end)

    table.insert(Library.tabammount, Tab)
    return setmetatable(Tab, Library.tabs)
end

function Library.tabs:Section(options)
    if not options then
        options = {}
    end

    local Section = {
        Tab = self,
        Name = options.Name or options.name or 'section',
        Side = options.side or options.Side or "left",
        Properties = {}
    }

    local NewSection = NewInstance("Frame", {
        Name = "section";
        Parent = Section.Side:lower() == "left" and Section.Tab.Properties.Left or Section.Side:lower() == "right" and Section.Tab.Properties.Right;
        BackgroundColor3 = Color3.fromRGB(8, 8, 8);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Size = UDim2.new(1, 0, 0, 25);
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local UIStroke1 = NewInstance("UIStroke", {
        Parent = NewSection,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local SectionContent = NewInstance("Frame", {
        Name = "content";
        Parent = NewSection;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 7, 0, 20);
        Size = UDim2.new(0.0599999987, 0, 1, -15);
    })

    
    local UIListLayout = NewInstance("UIListLayout", {
        Parent = SectionContent;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 6);
    })

    local SectionTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewSection;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 2);
        Size = UDim2.new(1, 0, 0, 15);
        FontFace = realfont;
        Text = Section.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })
    -- 
    Section.Properties = {
        Main = SectionContent
    }
    --
    return setmetatable(Section, Library.sections)
end

function Library.tabs:MultiSection(options)
    local Section = {
        Page = self,
        Tab = self,
        Sections = options.sections or options.Sections or {},
        Side = options.side or options.Side or 'left',
        Properties = {},
        Content = {},
        RealSections = {}
    }

    local  NewSection = NewInstance("Frame", {
        Name = "multisections";
        Parent = Section.Side:lower() == "left" and Section.Tab.Properties.Left or Section.Side:lower() == "right" and Section.Tab.Properties.Right;
        BackgroundColor3 = Color3.fromRGB(8, 8, 8);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Size = UDim2.new(1, 0, 0, 40);
        AutomaticSize = Enum.AutomaticSize.Y
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = NewSection,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local SectionTop = NewInstance("Frame", {
        Name = "topbar";
        Parent = NewSection;
        BackgroundColor3 = Color3.fromRGB(16, 16, 16);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 20);
    })

    local Gradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 143, 143))};
        Rotation = 90;
        Parent = SectionTop;
    })

    local UIStroke2 = NewInstance("UIStroke", {
        Parent = SectionTop,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local UIListLayout = NewInstance("UIListLayout", {
        Parent = SectionTop;
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        HorizontalFlex = Enum.UIFlexAlignment.Fill
    })

    Section.Properties = {
        Top = SectionTop;
    }
    local SectionShit = Section.Sections;
    local SectionShit2 = Section;
    local SectionButtons = {};

    for Index, Value in SectionShit do
        local MultiSection = {
            Open = false,
            Content = {},
            NoUpdate = true,
            ContentAxis = 0,
            Properties = {}
        }

        local SectionName = NewInstance("TextButton", {
            Name = "inactive";
            Parent = SectionTop;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            FontFace = realfont;
            Text = Value;
            TextColor3 = Color3.fromRGB(175, 175, 175);
            TextSize = 9;
        })

        local SectionContent = NewInstance("Frame", {
            Name = "content";
            Parent = NewSection;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 7, 0, 25);
            Size = UDim2.new(0.0599999987, 0, 1, -15);
            Visible = false
        })

        local UIListLayout = NewInstance("UIListLayout", {
            Parent = SectionContent;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Padding = UDim.new(0, 6);
        })

        table.insert(SectionButtons, SectionName)
        
        function MultiSection:Turn(bool)
            MultiSection.Open = bool
            game:GetService("TweenService"):Create(SectionName, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = MultiSection.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175,175,175)}):Play()
            SectionContent.Visible = MultiSection.Open
        end;

        SectionName.MouseButton1Click:Connect(function()
            if not MultiSection.Open then
                MultiSection:Turn(true)
                for index, other_page in pairs(SectionShit2.RealSections) do
                    if other_page.Open and other_page ~= MultiSection then
                        other_page:Turn(false)
                    end
                end
            end
        end)

        if #SectionShit == 0 then
            MultiSection:Turn(true);
        end;

        
        MultiSection.Properties = {
            Title = SectionName;
            Main = SectionContent;
        };

        SectionShit2.RealSections[#SectionShit2.RealSections + 1] = setmetatable(MultiSection, Library.sections)
    end

    Section.Page.Sections[#Section.Page.Sections + 1] = Section;
    Section.RealSections[1]:Turn(true)
    return table.unpack(Section.RealSections)
end

function Library.sections:Toggle(options)
    if not options then
        options = {}
    end

    local Toggle = {
        Name = options.name or options.Name or 'toglge',
        Flag = options.flag or options.Flag or math.random(1,math.random(1,1000)),
        State = options.state or options.State or options.Default or options.default or false,
        Callback = options.Callback or options.callback or function() end,
        Toggled = false,
        Pickers = 0
    }

    local NewToggle = NewInstance("Frame", {
        Name = "toggle";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 13);
    })

    local ToggleOutline = NewInstance("TextButton", {
        Name = "outline";
        Parent = NewToggle;
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Size = UDim2.new(0, 13, 0, 13);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = ToggleOutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local ToggleInline = NewInstance("Frame", {
        Name = "inline";
        Parent = ToggleOutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })

    local InlineGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = ToggleInline;
    })

    local ToggleTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewToggle;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 20, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Toggle.Name;
        TextColor3 = Color3.fromRGB(185, 185, 185);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    ToggleOutline.MouseEnter:Connect(function()
        UIStroke1.Color = Library.accent
    end)

    ToggleOutline.MouseLeave:Connect(function()
        UIStroke1.Color = Color3.fromRGB(35,35,35)
    end)

    local function SetState()
        Toggle.Toggled = not Toggle.Toggled

        if Toggle.Toggled then
            ToggleInline.BackgroundColor3 = Library.accent
        else
            ToggleInline.BackgroundColor3 = Color3.fromRGB(24,24,24)
        end

        Library.flags[Toggle.Flag] = Toggle.Toggled
        Toggle.Callback(Toggle.Toggled)
    end
    --
    ToggleOutline.MouseButton1Down:Connect(SetState)

    function Toggle:Colorpicker(options)
        local Colorpicker = {
            State = options.default or options.Default or Color3.fromRGB(255,255,255),
            Alpha = options.Alpha or options.alpha or 1,
            Flag = options.flag or options.Flag or math.random(1,100005),
            Callback = options.Callback or options.callback or function() end
        }

        Toggle.Pickers += 1

        local ColorButton = NewInstance("TextButton", {
            Name = "color";
            Parent = NewToggle;
            AnchorPoint = Vector2.new(1, 0);
            BackgroundColor3 = Color3.fromRGB(255, 0, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0.0799999982, 0, 1, 0);
            AutoButtonColor = false;
            Font = Enum.Font.SourceSans;
            Text = "";
            TextColor3 = Color3.fromRGB(0, 0, 0);
            TextSize = 14.000;
        })

        if Toggle.Pickers == 1 then
            ColorButton.Position = UDim2.new(1, - (Toggle.Pickers * 2),0,0)
        else
            ColorButton.Position = UDim2.new(1, - (Toggle.Pickers * 8) - (Toggle.Pickers * 4),0,0)
        end
    
        local UIGradient = NewInstance("UIGradient", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(89, 89, 89))};
            Rotation = 90;
            Parent = ColorButton;
        })
    
        local ColorWindow = NewInstance("Frame", {
            Name = "window";
            Parent = NewToggle;
            AnchorPoint = Vector2.new(1, 0);
            BackgroundColor3 = Color3.fromRGB(11, 11, 11);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 2;
            Position = UDim2.new(1, 0, 0, 15);
            Size = UDim2.new(0, 135, 0, 120);
            Visible = false;
        })
    
        local UIStroke1 = NewInstance("UIStroke", {
            Parent = ColorWindow,
            Color = Color3.fromRGB(35,35,35),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    
        local Palette = NewInstance("TextButton", {
            Name = "color";
            Parent = ColorWindow;
            BackgroundColor3 = Color3.fromRGB(255, 0, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 7, 0, 7);
            Size = UDim2.new(0, 100, 0, 90);
            AutoButtonColor = false;
            Font = Enum.Font.SourceSans;
            Text = "";
            TextColor3 = Color3.fromRGB(0, 0, 0);
            TextSize = 14.000;
        })
    
        local UIStroke5 = NewInstance("UIStroke", {
            Parent = Palette,
            Color = Color3.fromRGB(35,35,35),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    
        local WindowSat = NewInstance("ImageLabel", {
            Name = "sat";
            Parent = Palette;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Image = "http://www.roblox.com/asset/?id=14684562507";
        })
    
        local WindowVal = NewInstance("ImageLabel", {
            Name = "val";
            Parent = Palette;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Image = "http://www.roblox.com/asset/?id=14684563800";
        })
    
        local PaletteSlide = NewInstance("Frame", {
            Name = "dragger";
            Parent = Palette;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(0, 2, 0, 2);
        })
    
        local UIStroke2 = NewInstance("UIStroke", {
            Parent = PaletteSlide,
            Color = Color3.fromRGB(0,0,0),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    
        local HuePalette = NewInstance("ImageButton", {
            Name = "hue";
            Parent = ColorWindow;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 2;
            Position = UDim2.new(1, -19, 0, 7);
            Size = UDim2.new(0, 12, 0, 90);
            Image = "http://www.roblox.com/asset/?id=14684557999";
        })
    
        local HueSlide = NewInstance("Frame", {
            Name = "dragger";
            Parent = HuePalette;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 1);
        })
        
        local UIStroke3 = NewInstance("UIStroke", {
            Parent = HueSlide,
            Color = Color3.fromRGB(0,0,0),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    
        local WindowAlpha = NewInstance("TextButton", {
            Parent = ColorWindow,
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            Text = "",
            Position = UDim2.new(0, 7, 1, -17),
            Size = UDim2.new(0, 122, 0, 12),
            BorderSizePixel = 2,
            TextSize = 14,
            BorderColor3 = Color3.fromRGB(0,0,0);
            BackgroundColor3 = Library.accent,
            AutoButtonColor = false
        })
    
        local CheckersImage = NewInstance("ImageLabel", {
            Name = "checkers";
            Parent = WindowAlpha;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Image = "http://www.roblox.com/asset/?id=18274452449";
            ScaleType = Enum.ScaleType.Tile;
            TileSize = UDim2.new(0, 6, 0, 6);
        })
    
        local UIGradient2 = NewInstance("UIGradient", {
           Parent = CheckersImage,
           Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
           Rotation = 0
        })
    
        local AlphaSlide = NewInstance("Frame", {
            Parent = WindowAlpha,
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        })
    
        local UIStroke4 = NewInstance("UIStroke", {
            Parent = AlphaSlide,
            Color = Color3.fromRGB(0,0,0),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    
        ColorButton.MouseButton1Click:Connect(function()
            ColorWindow.Visible = not ColorWindow.Visible
    
            if ColorWindow.Visible then
                ColorWindow.ZIndex = 15
                for _, object in ColorWindow:GetDescendants() do
                    if object.ClassName ~= "UIStroke" and object.ClassName ~= "UIGradient" then
                        object.ZIndex = 15 
                    end
                end
            else
                ColorWindow.ZIndex = 1
                for _, object in ColorWindow:GetDescendants() do
                    if object.ClassName ~= "UIStroke" and object.ClassName ~= "UIGradient" then
                        object.ZIndex = 1 
                    end
                end
            end
        end)
    
        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false
        local Saturation, Hue, Value = Colorpicker.State:ToHSV()
        local HSV = Colorpicker.State:ToHSV()
        local Hex = Colorpicker.State:ToHex()
        local Alpha = Colorpicker.Alpha
    
        local function SetState()
            local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y - 37) 
            
            local RelativePaletteX = (MousePosition.X - Palette.AbsolutePosition.X)
            local RelativePaletteY = (MousePosition.Y - Palette.AbsolutePosition.Y)
    
            local RelativeHueY = (MousePosition.Y - HuePalette.AbsolutePosition.Y)
    
            local RelativeAlphaX = (MousePosition.X - WindowAlpha.AbsolutePosition.X)
    
            if SlidingPalette and mouseoverframe(Palette) then
                Saturation =  math.clamp(1 - RelativePaletteX / Palette.AbsoluteSize.X, 0, 1)
                Value = math.clamp(1 - RelativePaletteY / Palette.AbsoluteSize.Y, 0, 1)
                PaletteSlide.Position = UDim2.new(0, RelativePaletteX ,0, RelativePaletteY)
            end
    
            if SlidingHue and mouseoverframe(HuePalette) then
                Hue = math.clamp(RelativeHueY / HuePalette.AbsoluteSize.Y, 0, 1)
                HueSlide.Position = UDim2.new(0,0,0,RelativeHueY)
            end
    
            if SlidingAlpha and mouseoverframe(WindowAlpha) then
                Alpha = math.clamp(RelativeAlphaX / WindowAlpha.AbsoluteSize.X, 0, 1)
                AlphaSlide.Position = UDim2.new(0,RelativeAlphaX,0,0)
            end
    
            HSV = Color3.fromHSV(Hue, Saturation, Value)
            local r,g,b = HSV.R * 255, HSV.G * 255, HSV.B * 255
            Palette.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
            WindowAlpha.BackgroundColor3 = HSV
            ColorButton.BackgroundColor3 = HSV
    
            Library.flags[Colorpicker.Flag] = HSV 
            Colorpicker.Callback(HSV)
        end
    
        local function SetDefaults(color, alpha)
            if type(color) == "table" then
                alpha = color[4]
                color = Color3.fromHSV(color[1],color[2],color[3])
            end
    
            if type(color) == "string" then
                color = Color3.fromHex(color)
            end
    
            local OldColor = HSV 
            local OldAlpha = Alpha
    
            Hue, Saturation, Value = color:ToHSV()
            Alpha = alpha or 1 
            HSV = Color3.fromHSV(Hue, Saturation, Value)
            
            if HSV ~= OldColor then
                Palette.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
                WindowAlpha.BackgroundColor3 = HSV
                ColorButton.BackgroundColor3 = HSV
    
                HueSlide.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
                PaletteSlide.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
                AlphaSlide.Position = UDim2.new(math.clamp(Hue, 0.005, 0.990),0,0,0)
    
                Library.flags[Colorpicker.Flag] = HSV 
                Colorpicker.Callback(HSV)
            end
        end
    
        Palette.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                SetState()
            end
        end)
    
        Palette.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)
    
        HuePalette.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                SetState()
            end
        end)
    
        HuePalette.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)
    
        WindowAlpha.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                SetState()
            end
        end)
    
        WindowAlpha.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)
    
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and SlidingPalette or SlidingAlpha or SlidingHue then
                SetState()
            end
        end)
    
        SetDefaults(Colorpicker.State)
        
        return Colorpicker
    end

    function Toggle:Keybind(options)
        local Keybind = {
            Flag = options.Flag or options.flag or  math.random(1,math.random(1,1000)),
            UseKey = options.usekey or options.UseKey or false,
            Mode = options.Mode or options.mode or 'Toggle',
            Callback = options.Callback or options.callback or function() end 
        }

        local Key
        local State = false
        local c
    
        local keybutton = NewInstance("TextButton", {
            Name = "key";
            Parent = NewToggle;
            AnchorPoint = Vector2.new(1, 0);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 15, 0, 15);
            AutoButtonColor = false;
            FontFace = realfont;
            Text = "[ None ]";
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 9.000;
            TextStrokeTransparency = 0.000;
            AutomaticSize = Enum.AutomaticSize.X;
            TextXAlignment = Enum.TextXAlignment.Right
        })
    
        local function set(newkey)
            if string.find(tostring(newkey), "Enum") then
                if c then
                    c:Disconnect()
                    if Keybind.Flag then
                        Library.flags[Keybind.Flag] = false
                    end
                    Keybind.Callback(false)
                end
                if tostring(newkey):find("Enum.KeyCode.") then
                    newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                elseif tostring(newkey):find("Enum.UserInputType.") then
                    newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                end
                if newkey == Enum.KeyCode.Backspace then
                    Key = nil
                    if Keybind.UseKey then
                        if Keybind.Flag then
                            Library.flags[Keybind.Flag] = Key
                        end
                        Keybind.Callback(Key)
                    end
                    local text = "None"
                    keybutton.TextColor3 = Color3.fromRGB(255,255,255)
                    keybutton.Text = text
                elseif newkey ~= nil then
                    Key = newkey
                    if Keybind.UseKey then
                        if Keybind.Flag then
                            Library.flags[Keybind.Flag] = Key
                        end
                        Keybind.Callback(Key)
                    end
                    local text = (Library.keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                    keybutton.TextColor3 = Color3.fromRGB(255,255,255)
                    keybutton.Text = `[ {text} ]`
                end
    
                Library.flags[Keybind.Flag .. "_KEY"] = newkey
            elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
                if not Keybind.UseKey then
                    Library.flags[Keybind.Flag .. "_KEY STATE"] = newkey
                    Keybind.Mode = newkey
                    if Keybind.Mode == "Always" then
                        State = true
                        if Keybind.Flag then
                            Library.flags[Keybind.Flag] = State
                        end
                        Keybind.Callback(true)
                    elseif Keybind.Mode == 'Hold' then
                        State = false
                        if Keybind.Flag then
                            Library.flags[Keybind.Flag] = State
                        end
                        Keybind.Callback(false)
                    end
                end
            else
                State = newkey
                if Keybind.Flag then
                    Library.flags[Keybind.Flag] = newkey
                end
                Keybind.Callback(newkey)
            end
        end
        --
        set(Keybind.State)
        set(Keybind.Mode)
        keybutton.MouseButton1Click:Connect(function()
            if not Keybind.Binding then
    
                keybutton.TextColor3 = Library.accent
    
                Keybind.Binding = 
                    game:GetService("UserInputService").InputBegan:Connect(
                    function(input, gpe)
                        set(
                            input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
                                or input.UserInputType
                        )
                        Keybind.Binding:Disconnect()
                        task.wait()
                        Keybind.Binding = nil
                    end
                )
            end
        end)
        --
        game:GetService("UserInputService").InputBegan:Connect(function(inp)
            if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                if Keybind.Mode == "Hold" then
                    if Keybind.Flag then
                        Library.flags[Keybind.Flag] = true
                    end
                    c = game:GetService("RunService").RenderStepped:Connect(function()
                        if Keybind.Callback then
                            Keybind.Callback(true)
                        end
                    end)
                elseif Keybind.Mode == "Toggle" then
                    State = not State
                    if Keybind.Flag then
                        Library.flags[Keybind.Flag] = State
                    end
                    Keybind.Callback(State)
                end
            end
        end)
        --
        game:GetService("UserInputService").InputEnded:Connect(function(inp)
            if Keybind.Mode == "Hold" and not Keybind.UseKey then
                if Key ~= "" or Key ~= nil then
                    if inp.KeyCode == Key or inp.UserInputType == Key then
                        if c then
                            c:Disconnect()
                            if Keybind.Flag then
                                Library.flags[Keybind.Flag] = false
                            end
                            if Keybind.Callback then
                                Keybind.Callback(false)
                            end
                        end
                    end
                end
            end
        end)

        return Keybind
    end
	-- 
	function Toggle.Set(bool)
		bool = type(bool) == "boolean" and bool or false

		if Toggle.Toggled ~= bool then
			SetState()
		end
	end

    Toggle.Set(Toggle.State)
	Library.flags[Toggle.Flag] = Toggle.State
	Flags[Toggle.Flag] = Toggle.Set
    return Toggle
end

function Library.sections:Button(options)
    if not options then
        options = {}
    end

    local Button = {
        Name = options.name or options.Name or 'button',
        Callback = options.callback or options.Callback or function() end,
        Hovered = false
    }

    local ButtonOutline = NewInstance("TextButton", {
        Name = "buttonoutline";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Size = UDim2.new(15.6700001, 0, 0, 16);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = ButtonOutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local ButtonInline = NewInstance("Frame", {
        Name = "inline";
        Parent = ButtonOutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })

    local ButtonGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = ButtonInline;
    })

    local ButtonTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = ButtonOutline;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Button.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    ButtonOutline.MouseEnter:Connect(function()
        UIStroke1.Color = Library.accent
        Button.Hovered = true
    end)

    ButtonOutline.MouseLeave:Connect(function()
        UIStroke1.Color = Color3.fromRGB(35,35,35)
        Button.Hovered = false 
    end)

    ButtonOutline.MouseButton1Click:Connect(function()
        Button.Callback()
    end)

    return Button
end

function Library.sections:Slider(options)
    if not options then
        options = {}
    end

    local Slider = {
        Name = options.name or options.Name or 'slider',
        Min = options.min or options.Min or 1,
        Max = options.max or options.Max or 10,
        Decimals = options.Decimals or options.decimals or 1,
        Suffix = options.suffix or options.Suffix or '',
        State = options.default or options.Default or 5,
        Flag = options.Flag or options.flag or math.random(1,math.random(1,1000)),
        Callback = options.callback or options.Callback or function() end 
    }

    local TextValue = ("[value]" .. Slider.Suffix)

    local NewSlider = NewInstance("Frame", {
        Name = "slider";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 24);
    })

    local SliderTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewSlider;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 13);
        FontFace = realfont;
        Text = Slider.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local SliderOutline = NewInstance("Frame", {
        Name = "slideroutline";
        Parent = NewSlider;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 0, 1, 0);
        Size = UDim2.new(1, 0, 0, 9);
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = SliderOutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local SliderInline = NewInstance("Frame", {
        Name = "inline";
        Parent = SliderOutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })

    local InlineGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = SliderInline;
    })

    local Accent = NewInstance("Frame", {
        Name = "indicator";
        Parent = SliderInline;
        BackgroundColor3 = Library.accent;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(0.5, 0, 1, 0);
    })

    local AccentGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = Accent;
    })

    local SliderValue = NewInstance("TextLabel", {
        Name = "value";
        Parent = SliderInline;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = "50";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local PlusButton = NewInstance("TextButton", {
        Name = "plus";
        Parent = NewSlider;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0, 15, 0, 15);
        FontFace =realfont;
        Text = "+";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Right;
    })

    local MinusButton = NewInstance("TextButton", {
        Name = "minus";
        Parent = NewSlider;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, -15, 0, 0);
        Size = UDim2.new(0, 15, 0, 15);
        FontFace = realfont;
        Text = "-";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Right;
    })

    SliderOutline.MouseEnter:Connect(function()
        UIStroke1.Color = Library.accent
    end)

    SliderOutline.MouseLeave:Connect(function()
        UIStroke1.Color = Color3.fromRGB(35,35,35)
    end)

    local Sliding = false
    local Val = Slider.State
    local function Set(value)
        value = math.clamp(round(value, Slider.Decimals), Slider.Min, Slider.Max)

        local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
        Accent.Size = UDim2.new(sizeX, 0, 1, 0)
        SliderValue.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
        Val = value

        Library.flags[Slider.Flag] = value
        Slider.Callback(value)
    end				
    --
    local function ISlide(input)
        local sizeX = (input.Position.X - SliderInline.AbsolutePosition.X) / SliderInline.AbsoluteSize.X
        local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
        Set(value)
    end

    Accent.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = true 
            Library.dragging = nil
            ISlide(inp)
        end
    end)

    Accent.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = false 
        end
    end)

    SliderInline.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = true 
            Library.dragging = nil
            ISlide(inp)
        end
    end)

    SliderInline.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = false 
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if Sliding then
                Library.dragging = nil
                ISlide(input)
            end
        end
    end)

    PlusButton.MouseButton1Click:Connect(function()
        Set(Val + Slider.Decimals)
    end)

    MinusButton.MouseButton1Click:Connect(function()
        Set(Val - Slider.Decimals)
    end)

    function Slider:Set(value)
        Set(value)
    end

    Flags[Slider.Flag] = Set
    Library.flags[Slider.Flag] = Slider.State
    Set(Slider.State)
    return Slider
end

function Library.sections:Dropdown(options)
    if not options then
        options = {}
    end

    local Dropdown = {
        Name = options.name or options.Name or 'dropdown',
        State = options.Default or options.default or nil,
        Options = options.Options or options.options or {"one","two","three","four","five"},
        Flag = options.flag or options.Flag or math.random(1,math.random(1,1000)),
        Callback = options.callback or options.Callback or function() end,
        Multi = options.multi or options.Multi or false
    }

    local optioninstances = {}
    local option = nil
    local chosen = Dropdown.Multi and {} or nil 
    local optioncount = 0
    
    local NewDropdown = NewInstance("Frame", {
        Name = "dropdown";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 16);
    })

    local DropdownTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewDropdown;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace =realfont;
        Text = Dropdown.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local DropdownOutline = NewInstance("Frame", {
        Name = "dropdownoutline";
        Parent = NewDropdown;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0.469999999, 0, 1, 0);
    })

    local DropdownInline = NewInstance("Frame", {
        Name = "inline";
        Parent = DropdownOutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = DropdownOutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local InlineGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = DropdownInline;
    })

    local OpenButton = NewInstance("TextButton", {
        Name = "plus";
        Parent = DropdownInline;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(1, 0, 0, 15);
        FontFace = realfont;
        Text = "+";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Right;
    })

    local Value = NewInstance("TextLabel", {
        Name = "value";
        Parent = DropdownInline;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, -20, 1, 0);
        FontFace = realfont;
        Text = "dropdown";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local OptionHolderOutline = NewInstance("Frame", {
        Name = "optionoutline";
        Parent = NewDropdown;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, 0, 0, 17);
        Size = UDim2.new(0.469999999, 0, 0, 16);
        Visible = false;
        AutomaticSize = Enum.AutomaticSize.Y
    })

    local UIStroke2 = NewInstance("UIStroke", {
        Parent = OptionHolderOutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local OptionHolderInline = NewInstance("Frame", {
        Name = "inline";
        Parent = OptionHolderOutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })

    local InlineGradient2 = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = OptionHolderInline;
    })
    
    local UIListLayout = NewInstance("UIListLayout", {
        Parent = OptionHolderInline;
        SortOrder = Enum.SortOrder.LayoutOrder;
    })

    OpenButton.MouseButton1Click:Connect(function()
        OptionHolderOutline.Visible = not OptionHolderOutline.Visible

        if OptionHolderOutline.Visible then
            OptionHolderOutline.ZIndex = 15 
            OpenButton.Text = "-"
            for i,v in next, optioninstances do
                v.text.ZIndex = 15
            end
        else
            OptionHolderOutline.ZIndex = 1
            OpenButton.Text = "+"
            for i,v in next, optioninstances do
                v.text.ZIndex = 1
            end
        end
    end)

    DropdownOutline.MouseEnter:Connect(function()
        UIStroke1.Color = Library.accent
    end)

    DropdownOutline.MouseLeave:Connect(function()
        UIStroke1.Color = Color3.fromRGB(35,35,35)
    end)

    local function updatevalues(option,text)
        optioninstances[option].button.MouseButton1Click:Connect(function()
            if OptionHolderOutline.Visible then
                if Dropdown.Multi then 
                    local index = table.find(chosen, option)

                    if index then
                         table.remove(chosen, index)
                    else
                         table.insert(chosen, option)
                    end

                    Value.Text = table.concat(chosen, ", ")
                    text.TextColor3 = index and Color3.fromRGB(175,175,175) or Library.accent
    
                    Library.flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                else
                    for i,v in next, optioninstances do 
                        if i ~= option then
                            v.text.TextColor3 = Color3.fromRGB(175,175,175)
                        end
                    end

                    chosen = option
                    Value.Text = option
                    text.TextColor3 = Library.accent
                    Library.flags[Dropdown.Flag] = option
                    Dropdown.Callback(option)
                end
            end
        end)
    end

    local CreateOptions = function(Options)
        for _, option in next, Options do
            optioninstances[option] = {}

            local NewOption = NewInstance("TextButton", {
                Name = "option1";
                Parent = OptionHolderInline;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 15);
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local OptionText = NewInstance("TextLabel", {
                Name = "text";
                Parent = NewOption;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = option;
                TextColor3 = Color3.fromRGB(175, 175, 175);
                TextSize = 9.000;
                TextStrokeTransparency = 0.000;
            })

            optioninstances[option].button = NewOption
            optioninstances[option].text = OptionText

            optioncount += 1 

            updatevalues(option, OptionText)
        end
    end

    CreateOptions(Dropdown.Options)

    local function Set(Option)
        if Dropdown.Multi then
            table.clear(chosen)

            option = type(Option) == "table" and Option or {}

            for i, v in next, optioninstances do
                if not table.find(option, i) then
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
            end

            for i,v in next, Option do 
                if table.find(Dropdown.Options, v) and Dropdown.Multi then
                    table.insert(chosen, v)
                    optioninstances[v].text.TextColor3 = Library.accent
                end
            end

            local textchosen = {}
            
            for _, v in next, chosen do 
                table.insert(textchosen, v)
            end

            Value.Text = table.concat(textchosen, ", ")
            optioninstances[Option].text.TextColor3 = Library.accent
            Library.flags[Dropdown.Flag] = chosen
            Dropdown.Callback(chosen)
        end
    end

    Dropdown.Set = function(option)
        if Dropdown.Multi then
            Set(option)
        else
            for i,v in next, optioninstances do 
                if i ~= option then
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
            end

            if table.find(Dropdown.Options, option) then
                optioninstances[option].text.TextColor3 = Library.accent
                chosen = option
                Library.flags[Dropdown.Flag] = chosen
                Dropdown.Callback(chosen)
                Value.Text = option
            else
                chosen = nil
                Value.Text = "none"
                for i, v in next, optioninstances do
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
                Library.flags[Dropdown.Flag] = chosen
                Dropdown.Callback(chosen)
            end
        end
    end


    function Dropdown:Refresh(tbl)
        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Destroy()
            end)()
        end
        table.clear(optioninstances)

        CreateOptions(tbl)

        if Dropdown.Multi then
            table.clear(chosen)
        else
            chosen = nil
        end

        Library.flags[Dropdown.Flag] = chosen
        Dropdown.Callback(chosen)
    end
    
    Dropdown.Set(Dropdown.State)
    return Dropdown
end

function Library.sections:Colorpicker(options)
    if not options then
        options = {}
    end

    local Colorpicker = {
        Name = options.name or options.Name or 'Colorpicker',
        State = options.default or options.Default or Color3.fromRGB(255,255,255),
        Alpha = options.Alpha or options.alpha or 1,
        Flag = options.flag or options.Flag or math.random(1,100005),
        Callback = options.Callback or options.callback or function() end
    }

    local NewColorpicker = NewInstance("Frame" , {
        Name = "colorpicker";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 12);
    })

    local ColorpickerTitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = NewColorpicker;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Colorpicker.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local ColorButton = NewInstance("TextButton", {
        Name = "color";
        Parent = NewColorpicker;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 0, 0);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0.0799999982, 0, 1, 0);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(89, 89, 89))};
        Rotation = 90;
        Parent = ColorButton;
    })

    local ColorWindow = NewInstance("Frame", {
        Name = "window";
        Parent = NewColorpicker;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(11, 11, 11);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, 0, 0, 15);
        Size = UDim2.new(0, 135, 0, 120);
        Visible = false;
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = ColorWindow,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local Palette = NewInstance("TextButton", {
        Name = "color";
        Parent = ColorWindow;
        BackgroundColor3 = Color3.fromRGB(255, 0, 0);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 7, 0, 7);
        Size = UDim2.new(0, 100, 0, 90);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke5 = NewInstance("UIStroke", {
        Parent = Palette,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local WindowSat = NewInstance("ImageLabel", {
        Name = "sat";
        Parent = Palette;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        Image = "http://www.roblox.com/asset/?id=14684562507";
    })

    local WindowVal = NewInstance("ImageLabel", {
        Name = "val";
        Parent = Palette;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        Image = "http://www.roblox.com/asset/?id=14684563800";
    })

    local PaletteSlide = NewInstance("Frame", {
        Name = "dragger";
        Parent = Palette;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(0, 2, 0, 2);
    })

    local UIStroke2 = NewInstance("UIStroke", {
        Parent = PaletteSlide,
        Color = Color3.fromRGB(0,0,0),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local HuePalette = NewInstance("ImageButton", {
        Name = "hue";
        Parent = ColorWindow;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, -19, 0, 7);
        Size = UDim2.new(0, 12, 0, 90);
        Image = "http://www.roblox.com/asset/?id=14684557999";
    })

    local HueSlide = NewInstance("Frame", {
        Name = "dragger";
        Parent = HuePalette;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 1);
    })
    
    local UIStroke3 = NewInstance("UIStroke", {
        Parent = HueSlide,
        Color = Color3.fromRGB(0,0,0),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local WindowAlpha = NewInstance("TextButton", {
        Parent = ColorWindow,
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Text = "",
        Position = UDim2.new(0, 7, 1, -17),
        Size = UDim2.new(0, 122, 0, 12),
        BorderSizePixel = 2,
        TextSize = 14,
        BorderColor3 = Color3.fromRGB(0,0,0);
        BackgroundColor3 = Library.accent,
        AutoButtonColor = false
    })

    local CheckersImage = NewInstance("ImageLabel", {
        Name = "checkers";
        Parent = WindowAlpha;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        Image = "http://www.roblox.com/asset/?id=18274452449";
        ScaleType = Enum.ScaleType.Tile;
        TileSize = UDim2.new(0, 6, 0, 6);
    })

    local UIGradient2 = NewInstance("UIGradient", {
       Parent = CheckersImage,
       Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
       Rotation = 0
    })

    local AlphaSlide = NewInstance("Frame", {
        Parent = WindowAlpha,
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255)
    })

    local UIStroke4 = NewInstance("UIStroke", {
        Parent = AlphaSlide,
        Color = Color3.fromRGB(0,0,0),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    ColorButton.MouseButton1Click:Connect(function()
        ColorWindow.Visible = not ColorWindow.Visible

        if ColorWindow.Visible then
            ColorWindow.ZIndex = 15
            for _, object in ColorWindow:GetDescendants() do
                if object.ClassName ~= "UIStroke" and object.ClassName ~= "UIGradient" then
                    object.ZIndex = 15 
                end
            end
        else
            ColorWindow.ZIndex = 1
            for _, object in ColorWindow:GetDescendants() do
                if object.ClassName ~= "UIStroke" and object.ClassName ~= "UIGradient" then
                    object.ZIndex = 1 
                end
            end
        end
    end)

    local SlidingPalette = false
	local SlidingHue = false
	local SlidingAlpha = false
	local Saturation, Hue, Value = Colorpicker.State:ToHSV()
	local HSV = Colorpicker.State:ToHSV()
	local Hex = Colorpicker.State:ToHex()
	local Alpha = Colorpicker.Alpha

    local function SetState()
        local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y - 37) 
        
        local RelativePaletteX = (MousePosition.X - Palette.AbsolutePosition.X)
        local RelativePaletteY = (MousePosition.Y - Palette.AbsolutePosition.Y)

        local RelativeHueY = (MousePosition.Y - HuePalette.AbsolutePosition.Y)

        local RelativeAlphaX = (MousePosition.X - WindowAlpha.AbsolutePosition.X)

        if SlidingPalette and mouseoverframe(Palette) then
            Saturation =  math.clamp(1 - RelativePaletteX / Palette.AbsoluteSize.X, 0, 1)
            Value = math.clamp(1 - RelativePaletteY / Palette.AbsoluteSize.Y, 0, 1)
            PaletteSlide.Position = UDim2.new(0, RelativePaletteX ,0, RelativePaletteY)
        end

        if SlidingHue and mouseoverframe(HuePalette) then
            Hue = math.clamp(RelativeHueY / HuePalette.AbsoluteSize.Y, 0, 1)
            HueSlide.Position = UDim2.new(0,0,0,RelativeHueY)
        end

        if SlidingAlpha and mouseoverframe(WindowAlpha) then
            Alpha = math.clamp(RelativeAlphaX / WindowAlpha.AbsoluteSize.X, 0, 1)
            AlphaSlide.Position = UDim2.new(0,RelativeAlphaX,0,0)
        end

        HSV = Color3.fromHSV(Hue, Saturation, Value)
        local r,g,b = HSV.R * 255, HSV.G * 255, HSV.B * 255
        Palette.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
        WindowAlpha.BackgroundColor3 = HSV
        ColorButton.BackgroundColor3 = HSV

        Library.flags[Colorpicker.Flag] = HSV 
        Colorpicker.Callback(HSV)
    end

    local function SetDefaults(color, alpha)
        if type(color) == "table" then
            alpha = color[4]
            color = Color3.fromHSV(color[1],color[2],color[3])
        end

        if type(color) == "string" then
            color = Color3.fromHex(color)
        end

        local OldColor = HSV 
        local OldAlpha = Alpha

        Hue, Saturation, Value = color:ToHSV()
        Alpha = alpha or 1 
        HSV = Color3.fromHSV(Hue, Saturation, Value)
        
        if HSV ~= OldColor then
            Palette.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
            WindowAlpha.BackgroundColor3 = HSV
            ColorButton.BackgroundColor3 = HSV

            HueSlide.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
            PaletteSlide.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
            AlphaSlide.Position = UDim2.new(math.clamp(Hue, 0.005, 0.990),0,0,0)

            Library.flags[Colorpicker.Flag] = HSV 
            Colorpicker.Callback(HSV)
        end
    end

    Palette.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingPalette = true
            SetState()
        end
    end)

    Palette.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingPalette = false
        end
    end)

    HuePalette.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingHue = true
            SetState()
        end
    end)

    HuePalette.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingHue = false
        end
    end)

    WindowAlpha.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingAlpha = true
            SetState()
        end
    end)

    WindowAlpha.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SlidingAlpha = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and SlidingPalette or SlidingAlpha or SlidingHue then
            SetState()
        end
    end)

    SetDefaults(Colorpicker.State)

    return Colorpicker
end

function Library.sections:Keybind(options)
    local Keybind = {
        Name = options.Name or options.name or 'keybind',
        Flag = options.Flag or options.flag or  math.random(1,math.random(1,1000)),
        UseKey = options.usekey or options.UseKey or false,
        Mode = options.Mode or options.mode or 'Toggle',
        Callback = options.Callback or options.callback or function() end 
    }

    
	local Key
	local State = false
	local c

    local keybind = NewInstance("Frame", {
        Name = "keybind";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 15);
    })

    local keybindtext = NewInstance("TextLabel", {
        Name = "text";
        Parent = keybind;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Keybind.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local keybutton = NewInstance("TextButton", {
        Name = "key";
        Parent = keybind;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0, 15, 0, 15);
        AutoButtonColor = false;
        FontFace = realfont;
        Text = "[ None ]";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        AutomaticSize = Enum.AutomaticSize.X;
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local function set(newkey)
		if string.find(tostring(newkey), "Enum") then
			if c then
				c:Disconnect()
				if Keybind.Flag then
					Library.flags[Keybind.Flag] = false
				end
				Keybind.Callback(false)
			end
			if tostring(newkey):find("Enum.KeyCode.") then
				newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
			elseif tostring(newkey):find("Enum.UserInputType.") then
				newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
			end
			if newkey == Enum.KeyCode.Backspace then
				Key = nil
				if Keybind.UseKey then
					if Keybind.Flag then
						Library.flags[Keybind.Flag] = Key
					end
					Keybind.Callback(Key)
				end
				local text = "None"
				keybutton.TextColor3 = Color3.fromRGB(255,255,255)
				keybutton.Text = text
			elseif newkey ~= nil then
				Key = newkey
				if Keybind.UseKey then
					if Keybind.Flag then
						Library.flags[Keybind.Flag] = Key
					end
					Keybind.Callback(Key)
				end
				local text = (Library.keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
				keybutton.TextColor3 = Color3.fromRGB(255,255,255)
				keybutton.Text = `[ {text} ]`
			end

			Library.flags[Keybind.Flag .. "_KEY"] = newkey
		elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
			if not Keybind.UseKey then
				Library.flags[Keybind.Flag .. "_KEY STATE"] = newkey
				Keybind.Mode = newkey
				if Keybind.Mode == "Always" then
					State = true
					if Keybind.Flag then
						Library.flags[Keybind.Flag] = State
					end
					Keybind.Callback(true)
				elseif Keybind.Mode == 'Hold' then
					State = false
					if Keybind.Flag then
						Library.flags[Keybind.Flag] = State
					end
					Keybind.Callback(false)
				end
			end
		else
			State = newkey
			if Keybind.Flag then
				Library.flags[Keybind.Flag] = newkey
			end
			Keybind.Callback(newkey)
		end
	end
	--
	set(Keybind.State)
	set(Keybind.Mode)
	keybutton.MouseButton1Click:Connect(function()
		if not Keybind.Binding then

			keybutton.TextColor3 = Library.accent

			Keybind.Binding = 
				game:GetService("UserInputService").InputBegan:Connect(
				function(input, gpe)
					set(
						input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
							or input.UserInputType
					)
					Keybind.Binding:Disconnect()
					task.wait()
					Keybind.Binding = nil
				end
			)
		end
	end)
	--
	game:GetService("UserInputService").InputBegan:Connect(function(inp)
		if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
			if Keybind.Mode == "Hold" then
				if Keybind.Flag then
					Library.flags[Keybind.Flag] = true
				end
				c = game:GetService("RunService").RenderStepped:Connect(function()
					if Keybind.Callback then
						Keybind.Callback(true)
					end
				end)
			elseif Keybind.Mode == "Toggle" then
				State = not State
				if Keybind.Flag then
					Library.flags[Keybind.Flag] = State
				end
				Keybind.Callback(State)
			end
		end
	end)
	--
	game:GetService("UserInputService").InputEnded:Connect(function(inp)
		if Keybind.Mode == "Hold" and not Keybind.UseKey then
			if Key ~= "" or Key ~= nil then
				if inp.KeyCode == Key or inp.UserInputType == Key then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.flags[Keybind.Flag] = false
						end
						if Keybind.Callback then
							Keybind.Callback(false)
						end
					end
				end
			end
		end
	end)

    return Keybind
end

function Library.sections:Textbox(Options)
    local Textbox = {
		Section = self,
		Name = Options.Name or Options.name or Options.Title or Options.title or 'Textbox',
		Placeholder = Options.PlaceHolder or Options.Placeholder or '...',
		Flag = Options.Flag or Options.flag or Options.Pointer or Options.pointer or "fsafsaj"..math.random(1,999),
		Callback = Options.Callback or Options.callback or function() end,
		State = Options.Default or Options.State or Options.state or Options.default or 'Value'
	}

    local texbox = NewInstance("Frame", {
        Name = "textbox";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, 16);
    })

    local textboxoutline = NewInstance("Frame", {
        Name = "textboxoutline";
        Parent = texbox;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0.469999999, 0, 1, 0);
    })

    local UIStroke1 = NewInstance("UIStroke", {
        Parent = textboxoutline,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local realtextbox = NewInstance("TextBox", {
        Name = "textboxinline";
        Parent = textboxoutline;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        FontFace = realfont;
        PlaceholderText = Textbox.Placeholder;
        Text = "pro hax";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local textboxtitle = NewInstance("TextLabel", {
        Name = "text";
        Parent = texbox;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = Textbox.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    realtextbox.FocusLost:Connect(function()
		Library.flags[Textbox.Flag] = realtextbox.Text
		Textbox.Callback(realtextbox.Text)
	end)

	local function set(str)
		realtextbox.Text = str
		Library.flags[Textbox.Flag] = str
		Textbox.Callback(str)
	end

	set(Textbox.State)
    return Textbox
end

function Library.sections:Listbox(options)
    local Listbox = {
        Name = options.name or options.Name or 'ListBox',
        Size = options.Size or options.size or 150,
        Flag = options.Flag or options.flag or math.random(1,999999),
        Options = options.Options or options.options or {"config slot 1","config slot 2","config slot 3","config slot 4"},
        State = options.Default or options.default or nil,
        Multi = options.multi or options.Multi or false,
        Callback = options.callback or options.Callback or function() end
    }

    local optioninstances = {}
    local option = nil
    local chosen = Listbox.Multi and {} or nil 
    local optioncount = 0

    local listbox = NewInstance("Frame", {
        Name = "listbox";
        Parent = self.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(18, 18, 18);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(15.6700001, 0, 0, Listbox.Size);
    })

    local listboxtext = NewInstance("TextLabel", {
        Name = "text";
        Parent = listbox;
        BackgroundColor3 = Color3.fromRGB(9, 9, 9);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 15);
        FontFace = realfont;
        Text = Listbox.Name;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local realbox = NewInstance("ScrollingFrame", {
        Name = "realbox";
        Parent = listbox;
        Active = true;
        BackgroundColor3 = Color3.fromRGB(9, 9, 9);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 0, 0, 19);
        Size = UDim2.new(1, 0, 1, -20);
        CanvasSize = UDim2.new(0, 0, 0, 0);
        ScrollBarThickness = 1;
        ScrollBarImageColor3 = Library.accent;
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local UIStroke = NewInstance("UIStroke", {
        Parent = realbox,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local UIListLayout = NewInstance("UIListLayout", {
        Parent = realbox;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 0);
    })

    local function updatevalues(option, text)
        optioninstances[option].button.MouseButton1Down:Connect(function()
            if Listbox.Multi then
                local index = table.find(chosen, option)

                if index then
                     table.remove(chosen, index)
                else
                     table.insert(chosen, option)
                end

                text.TextColor3 = index and Color3.fromRGB(175,175,175) or Library.accent
                Library.flags[Listbox.Flag] = chosen
                Listbox.Callback(chosen)
            else
                for opt, _ in optioninstances do 
                    if opt ~= option then
                        _.text.TextColor3 = Color3.fromRGB(175,175,175)
                    end
                end

                chosen = option 
                text.TextColor3 = Library.accent
                Library.flags[Listbox.Flag] = option
                Listbox.Callback(option)
            end
        end)
    end

    local function CreateOptions(Options)
        for _, option in next, Options do
            optioninstances[option] = {}

            local OptionButton = NewInstance("TextButton", {
                Name = "option";
                Parent = realbox;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 20);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local OptionText = NewInstance("TextLabel", {
                Name = "text";
                Parent = OptionButton;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace =realfont;
                Text = option;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 9.000;
                TextStrokeTransparency = 0.000;
            })

            optioninstances[option].text = OptionText
            optioninstances[option].button = OptionButton

            updatevalues(option, OptionText)
        end
    end
    --
    CreateOptions(Listbox.Options)
    --
    local function Set(Option)
        if Listbox.Multi then
            table.clear(chosen)

            option = type(Option) == "table" and Option or {}

            for i, v in next, optioninstances do
                if not table.find(option, i) then
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
            end

            for i,v in next, Option do 
                if table.find(Listbox.Options, v) and Listbox.Multi then
                    table.insert(chosen, v)
                    optioninstances[v].text.TextColor3 = Library.accent
                end
            end

            local textchosen = {}
            
            for _, v in next, chosen do 
                table.insert(textchosen, v)
            end

            optioninstances[Option].text.TextColor3 = Library.accent
            Library.flags[Listbox.Flag] = chosen
            Listbox.Callback(chosen)
        end
    end

    Listbox.Set = function(option)
        if Listbox.Multi then
            Set(option)
        else
            for i,v in next, optioninstances do 
                if i ~= option then
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
            end

            if table.find(Listbox.Options, option) then
                optioninstances[option].text.TextColor3 = Library.accent
                chosen = option
                Library.flags[Listbox.Flag] = chosen
                Listbox.Callback(chosen)
            else
                chosen = nil
                for i, v in next, optioninstances do
                    v.text.TextColor3 = Color3.fromRGB(175,175,175)
                end
                Library.flags[Listbox.Flag] = chosen
                Listbox.Callback(chosen)
            end
        end
    end

    function Listbox:Refresh(tbl)
        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Destroy()
            end)()
        end
        table.clear(optioninstances)

        CreateOptions(tbl)

        if Listbox.Multi then
            table.clear(chosen)
        else
            chosen = nil
        end

        Library.flags[Listbox.Flag] = chosen
        Listbox.Callback(chosen)
    end

    Listbox.Set(Listbox.State)
    return Listbox
end

function Library.tabs:PlayerList(options)
    local PlayerList = {
        Tab = self,
        Players = {},
        CurrentPlr = nil,
        LastPlayer = nil,
        Flag = options.Flag or options.flag or math.random(1,999999999)
    }

    local Playerlist = NewInstance("Frame", {
        Name = "playerlist";
        Parent = PlayerList.Tab.Properties.Main;
        BackgroundColor3 = Color3.fromRGB(8, 8, 8);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(0, 7, 0, 7);
        Size = UDim2.new(1, -14, 0, 350);
    })

    local UIStroke = NewInstance("UIStroke", {
        Parent = Playerlist,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local List = NewInstance("ScrollingFrame", {
        Name = "list";
        Parent = Playerlist;
        Active = true;
        BackgroundColor3 = Color3.fromRGB(12, 12, 12);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 7);
        Size = UDim2.new(1, -10, 1, -90);
        BottomImage = "rbxassetid://7783554086";
        CanvasSize = UDim2.new(0, 0, 1, 0);
        MidImage = "rbxassetid://7783554086";
        ScrollBarThickness = 0;
        TopImage = "rbxassetid://7783554086";
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
    })

    local UIStroke2 = NewInstance("UIStroke", {
        Parent = List,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local BlackLiner = NewInstance("Frame", {
        Name = "liner";
        Parent = List;
        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 0, 0, 20);
        Size = UDim2.new(1, 0, 0, 1);
    })

    local LeftBar = NewInstance("Frame", {
        Name = "lefttbar";
        Parent = List;
        BackgroundColor3 = Color3.fromRGB(18, 18, 18);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(0.5, -1, 0, 20);
    })

    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(166, 166, 166))};
        Rotation = 90;
        Parent = LeftBar;
    })

    local PlayerName = NewInstance("TextLabel", {
        Name = "Name";
        Parent = LeftBar;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, 0, 0, 20);
        FontFace = realfont;
        Text = "Name";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local BlackLiner2 = NewInstance("Frame", {
        Name = "liner2";
        Parent = List;
        AnchorPoint = Vector2.new(0.5, 0);
        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0.5, 0, 0, 0);
        Size = UDim2.new(0, 1, 1, 0);
    })

    local RightBar = NewInstance("Frame", {
        Name = "rightbar";
        Parent = List;
        AnchorPoint = Vector2.new(1, 0);
        BackgroundColor3 = Color3.fromRGB(18, 18, 18);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(1, 0, 0, 0);
        Size = UDim2.new(0.5, -1, 0, 20);
    })

    local UIGradient2 = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(166, 166, 166))};
        Rotation = 90;
        Parent = RightBar;
    })

    local PlayerStatus = NewInstance("TextLabel", {
        Name = "Status";
        Parent = RightBar;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, 0, 0, 20);
        FontFace = realfont;
        Text = "Status";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local PlayerHolder = NewInstance("Frame", {
        Name = "holder";
        Parent = List;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 0, 0, 25);
        Size = UDim2.new(1, 0, 1, 0);
    })

    local UIListLayout = NewInstance("UIListLayout", {
        Parent = PlayerHolder;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 2);
    })

    local PlayerAvatar = NewInstance("ImageLabel", {
        Name = "avatar";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 5, 1, -5);
        Size = UDim2.new(0, 70, 0, 70);
        Image = "rbxassetid://116033171111626";
        BackgroundTransparency = 1
    })

    local UIStroke52 = NewInstance("UIStroke", {
        Parent = PlayerAvatar,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local Playername1 = NewInstance("TextLabel", {
        Name = "name";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 83, 1, -60);
        Size = UDim2.new(0, 200, 0, 15);
        FontFace = realfont;
        Text = "No player selected";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local playerid1 = NewInstance("TextLabel", {
        Name = "id";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 83, 1, -45);
        Size = UDim2.new(0, 200, 0, 15);
        FontFace = realfont;
        Text = "";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local accountage1 = NewInstance("TextLabel", {
        Name = "age";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 83, 1, -30);
        Size = UDim2.new(0, 200, 0, 15);
        FontFace = realfont;
        Text = "";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })

    local priority = NewInstance("TextButton", {
        Name = "priority";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(1, 1);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, -7, 1, -50);
        Size = UDim2.new(0, 120, 0, 25);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke3 = NewInstance("UIStroke", {
        Parent = priority,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local inline1 = NewInstance("Frame", {
        Name = "inline";
        Parent = priority;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })
    
    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = inline1;
    })
    
    local text1 = NewInstance("TextLabel", {
        Name = "text";
        Parent = priority;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = realfont;
        Text = "Prioritize";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })
    
    local friendly = NewInstance("TextButton", {
        Name = "friendly";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(1, 1);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, -7, 1, -15);
        Size = UDim2.new(0, 120, 0, 25);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke4 = NewInstance("UIStroke", {
        Parent = friendly,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local inline = NewInstance("Frame", {
        Name = "inline";
        Parent = friendly;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })
    
    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = inline;
    })

    local text = NewInstance("TextLabel", {
        Name = "text";
        Parent = friendly;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace =realfont;
        Text = "Friendly";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local friend2 = NewInstance("TextButton", {
        Name = "friendly";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(1, 1);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, -136, 1, -15);
        Size = UDim2.new(0, 120, 0, 25);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke5 = NewInstance("UIStroke", {
        Parent = friend2,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local inlin22e = NewInstance("Frame", {
        Name = "inline";
        Parent = friend2;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })
    
    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = inlin22e;
    })

    local text23 = NewInstance("TextLabel", {
        Name = "text";
        Parent = friend2;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace =realfont;
        Text = "Friend";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })

    local enemybutton = NewInstance("TextButton", {
        Name = "enemy";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(1, 1);
        BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Position = UDim2.new(1, -136, 1, -50);
        Size = UDim2.new(0, 120, 0, 25);
        AutoButtonColor = false;
        Font = Enum.Font.SourceSans;
        Text = "";
        TextColor3 = Color3.fromRGB(0, 0, 0);
        TextSize = 14.000;
    })

    local UIStroke54 = NewInstance("UIStroke", {
        Parent = enemybutton,
        Color = Color3.fromRGB(35,35,35),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local inlin22e4 = NewInstance("Frame", {
        Name = "inline";
        Parent = enemybutton;
        BackgroundColor3 = Color3.fromRGB(24, 24, 24);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
    })
    
    local UIGradient = NewInstance("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(158, 158, 158))};
        Rotation = 90;
        Parent = inlin22e4;
    })

    local text234 = NewInstance("TextLabel", {
        Name = "text";
        Parent = enemybutton;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace =realfont;
        Text = "Enemy";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
    })
    
    local healthtext = NewInstance("TextLabel", {
        Name = "health";
        Parent = Playerlist;
        AnchorPoint = Vector2.new(0, 1);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 83, 1, -15);
        Size = UDim2.new(0, 200, 0, 15);
        FontFace =realfont;
        Text = "";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 9.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })
    

    local Choosen = nil
    local OptionInstances = {}

    local function updatevalues(Option, Button, Text, Text2)
        Button.MouseButton1Down:Connect(function()
            Choosen = Option
            Library.flags[PlayerList.Flag] = Option
            PlayerList.CurrentPlr = Option
            -- 
            for option, table in OptionInstances do
                if option ~= Option then
                    table.Text.TextTransparency = 0.530
                    table.Text2.TextTransparency = 0.530
                end
            end

            Text.TextTransparency = 0
            Text2.TextTransparency = 0

            if PlayerList.CurrentPlr ~= PlayerList.LastPlayer then
                PlayerList.LastPlayer = PlayerList.CurrentPlr 
                local Name = `{PlayerList.CurrentPlr.DisplayName} (@{PlayerList.CurrentPlr.Name})`
                local ID = `{PlayerList.CurrentPlr.UserId}`
                local Age = `{PlayerList.CurrentPlr.AccountAge} days old`
                local Health = `health: {PlayerList.CurrentPlr.Character.Humanoid.Health}`
                local ImageData = game:GetService("Players"):GetUserThumbnailAsync(PlayerList.CurrentPlr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

                Playername1.Text = Name 
                playerid1.Text = ID 
                accountage1.Text = Age
                PlayerAvatar.Image = ImageData
                healthtext.Text = Health
            end
        end)
    end

    local function CreateOptions(tbl)
        for i, option in tbl do
            OptionInstances[option] = {}

            local NewPlayer = NewInstance("TextButton", {
                Name = "newplayer";
                Parent = PlayerHolder;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 15);
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local NewPlayerName = NewInstance("TextLabel", {
                Name = "name";
                Parent = NewPlayer;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 7, 0, 0);
                Size = UDim2.new(0.5, 0, 1, 0);
                FontFace = realfont;
                Text = option.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 9.000;
                TextStrokeTransparency = 0.000;
                TextTransparency = 0.530;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local NewPlayerStatus = NewInstance("TextLabel", {
                Name = "status";
                Parent = NewPlayer;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, 7, 0, 0);
                Size = UDim2.new(0.5, 0, 1, 0);
                FontFace =realfont;
                Text = "None";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 9.000;
                TextStrokeTransparency = 0.000;
                TextTransparency = 0.530;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            if option == LocalPlayer then
                NewPlayerStatus.Text = "LocalPlayer"
                NewPlayerStatus.TextColor3 = Color3.fromRGB(0,0,255)
            end

            OptionInstances[option].Button = NewPlayer
            OptionInstances[option].Text = NewPlayerName
            OptionInstances[option].Text2 = NewPlayerStatus

            if option == Choosen then
                Choosen = option
                Library.flags[PlayerList.Flag] = option
                PlayerList.CurrentPlr = option
                -- 
                for optiont, table in OptionInstances do
                    if optiont ~= option then
                        table.Text.TextTransparency = 0.530
                    end
                end
    
                NewPlayerName.TextTransparency = 0
    
                if PlayerList.CurrentPlr ~= PlayerList.LastPlayer then
                    PlayerList.LastPlayer = PlayerList.CurrentPlr 
                    local Name = `{PlayerList.CurrentPlr.DisplayName} (@{PlayerList.CurrentPlr.Name})`
                    local ID = `{PlayerList.CurrentPlr.UserId}`
                    local Age = `{PlayerList.CurrentPlr.AccountAge} days old`
                    local ImageData = game:GetService("Players"):GetUserThumbnailAsync(PlayerList.CurrentPlr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    
                    Playername1.Text = Name 
                    playerid1.Text = ID 
                    accountage1 = Age
                    PlayerAvatar.Image = ImageData
                end
            end

            updatevalues(option, NewPlayer, NewPlayerName, NewPlayerStatus)
        end
    end

    function PlayerList:Refresh(tbl, dontchange)
        local content = table.clone(tbl)

        for _, opt in next, OptionInstances do
            coroutine.wrap(function()
                opt.Button:Destroy()
            end)()
        end

        table.clear(OptionInstances)

        CreateOptions(content)

        if dontchange then
            Choosen = PlayerList.CurrentPlr
            PlayerList.CurrentPlr = Choosen
        else
            Choosen = nil
            PlayerList.CurrentPlr = nil
        end
        Library.flags[PlayerList.Flag] = Choosen
    end
    -- 
    CreateOptions(game.Players:GetPlayers())
    -- 
    friendly.MouseButton1Down:Connect(function()
        if PlayerList.CurrentPlr ~= nil and table.find(Library.priorities, PlayerList.CurrentPlr) then
            table.remove(Library.friendly, table.find(Library.priorities, PlayerList.CurrentPlr))
        end
        if  PlayerList.CurrentPlr ~= LocalPlayer then
            if PlayerList.CurrentPlr ~= nil and not table.find(Library.friendly, PlayerList.CurrentPlr) then
                table.insert(Library.friendly, PlayerList.CurrentPlr)
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "Friendly"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(0,255,0)
            elseif PlayerList.CurrentPlr ~= nil and table.find(Library.friendly, PlayerList.CurrentPlr) then
                table.remove(Library.friendly, table.find(Library.friendly, PlayerList.CurrentPlr))
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "None"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end)
    -- 
    priority.MouseButton1Down:Connect(function()
        if PlayerList.CurrentPlr ~= nil and table.find(Library.friendly, PlayerList.CurrentPlr) then
            table.remove(Library.priorities, table.find(Library.friendly, PlayerList.CurrentPlr))
        end

        if  PlayerList.CurrentPlr ~= LocalPlayer then
            if PlayerList.CurrentPlr ~= nil and not table.find(Library.priorities, PlayerList.CurrentPlr) then
                table.insert(Library.priorities, PlayerList.CurrentPlr)
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "Prioritized"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,0,0)
            elseif PlayerList.CurrentPlr ~= nil and table.find(Library.priorities, PlayerList.CurrentPlr) then
                table.remove(Library.priorities, table.find(Library.priorities, PlayerList.CurrentPlr))
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "None"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end)
    --
    friend2.MouseButton1Down:Connect(function()
        if PlayerList.CurrentPlr ~= nil and table.find(Library.enemies, PlayerList.CurrentPlr) then
            table.remove(Library.friends, table.find(Library.enemies, PlayerList.CurrentPlr))
        end
        if  PlayerList.CurrentPlr ~= LocalPlayer then
            if PlayerList.CurrentPlr ~= nil and not table.find(Library.friends, PlayerList.CurrentPlr) then
                table.insert(Library.friends, PlayerList.CurrentPlr)
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "Friend"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(125, 255, 153)
            elseif PlayerList.CurrentPlr ~= nil and table.find(Library.friends, PlayerList.CurrentPlr) then
                table.remove(Library.friends, table.find(Library.friends, PlayerList.CurrentPlr))
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "None"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end)
    -- 
    enemybutton.MouseButton1Down:Connect(function()
        if PlayerList.CurrentPlr ~= nil and table.find(Library.friends, PlayerList.CurrentPlr) then
            table.remove(Library.enemies, table.find(Library.friends, PlayerList.CurrentPlr))
        end

        if  PlayerList.CurrentPlr ~= LocalPlayer then
            if PlayerList.CurrentPlr ~= nil and not table.find(Library.enemies, PlayerList.CurrentPlr) then
                table.insert(Library.enemies, PlayerList.CurrentPlr)
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "Enemy"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,32,55)
            elseif PlayerList.CurrentPlr ~= nil and table.find(Library.enemies, PlayerList.CurrentPlr) then
                table.remove(Library.enemies, table.find(Library.enemies, PlayerList.CurrentPlr))
                OptionInstances[PlayerList.CurrentPlr].Text2.Text = "None"
                OptionInstances[PlayerList.CurrentPlr].Text2.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end)
    --
    game.Players.PlayerAdded:Connect(function()
        PlayerList:Refresh(game.Players:GetPlayers(), true)
    end)
    --
    game.Players.PlayerRemoving:Connect(function()
        PlayerList:Refresh(game.Players:GetPlayers(), true)
    end)
    -- Real Position
    self.Properties.Left.Position = UDim2.new(0,7,0,365)
    self.Properties.Right.Position = UDim2.new(1,-7,0,365)
    return PlayerList
end
