local repo = "https://raw.githubusercontent.com/kuqidexiaohai-ops/kuqidexaiohaiLuauScript/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.luau"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.luau"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.luau"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true -- 让开关类按键在按键界面里生效（即在 UI 中额外加一个开关）。适合手机用户（默认值 = true）
Library.ShowCustomCursor = true -- 全局切换 Linoria 光标（默认值 = true）
Library.NotifySide = "Left" -- 全局修改通知的显示侧（Left、Right）（默认值 = Left）

local Window = Library:CreateWindow({
	-- 想让菜单出现在屏幕中央就设 Center = true
	-- 想让菜单创建时就显示就设 AutoShow = true
	-- 想拥有游戏内可调整大小的窗口就设 Resizable = true
	-- 不想用 Linoria 光标就设 ShowCustomCursor = false
	-- 不想在 UI 打开时解锁鼠标就设 UnlockMouseWhileOpen = false
	-- NotifySide = 修改通知显示侧（Left、Right）（默认值 = Left）
	-- Position 和 Size 也都可以自定义
	-- 除非你要改，否则不用写 :)

	Title = "示例菜单",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

-- 回调说明：
-- 在控件初始参数里直接传回调函数（如 Callback = function(Value)...）是可行的
-- 但更推荐用 Toggles/Options.INDEX:OnChanged(function(Value) ... ) 的方式。
-- 强烈建议把 UI 代码和逻辑代码解耦：先创建 UI 元素，之后再设置 :OnChanged 函数。

-- 你不必按这种方式组织标签页和分组，这只是一种偏好。
local Tabs = {
	-- 创建一个名为「主页面」的新标签页
	Main = Window:AddTab("主页面"),
	["界面设置"] = Window:AddTab("界面设置"),
}

-- Groupbox 和 Tabbox 拥有相同的方法
-- 只不过 Tabbox 需要在它的标签页上调用方法（Tabbox:AddTab(name)）
local LeftGroupBox = Tabs.Main:AddLeftGroupbox("分组框")

-- 也可以通过下列代码获取 Main 标签页：
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox("分组框")

-- Tabbox 稍有不同，这里是一个基础示例：
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- 在左侧添加一个 Tabbox

local Tab1 = TabBox:AddTab("标签页 1")
local Tab2 = TabBox:AddTab("标签页 2")

-- 现在你可以对加入 Tabbox 的标签页调用 AddToggle 等函数了
]]

-- Groupbox:AddToggle
-- 参数：索引, 选项
LeftGroupBox:AddToggle("MyToggle", {
	Text = "这是一个开关",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 开关被禁用后悬停显示的信息

	Default = true, -- 默认值（true / false）
	Disabled = false, -- 是否禁用该开关（true / false）
	Visible = true, -- 是否隐藏该开关（true / false）
	Risky = false, -- 让文字变红（颜色可用 Library.RiskColor 修改）（默认值 = false）

	Callback = function(Value)
		print("[回调] MyToggle 变更为:", Value)
	end
}):AddColorPicker("ColorPicker1", {
	Default = Color3.new(1, 0, 0),
	Title = "颜色1", -- 可选。允许自定义颜色选择器标题（打开时显示）
	Transparency = 0, -- 可选。为该颜色选择器启用透明度调整（留空即禁用）

	Callback = function(Value, Transparency)
		print("[回调] 颜色已改变！", Value, "| 透明度改变为:", Transparency)
	end
}):AddColorPicker("ColorPicker2", {
	Default = Color3.new(0, 1, 0),
	Title = "颜色2",
	Transparency = 0,

	Callback = function(Value, Transparency)
		print("[回调] 颜色已改变！", Value, "| 透明度改变为:", Transparency)
	end
}):AddColorPicker("ColorPicker3", {
	Default = Color3.new(0, 0, 1),
	Title = "颜色3",
	Transparency = 0,

	Callback = function(Value, Transparency)
		print("[回调] 颜色已改变！", Value, "| 透明度改变为:", Transparency)
	end
})


-- 之后获取开关对象的方式：
-- Toggles.MyToggle.Value

-- Toggles 是库添加到 getgenv() 的表
-- 用指定的索引去取，这里索引是 "MyToggle"
-- 获取开关状态用 toggle.Value

-- 开关更新时会调用传入的函数
Toggles.MyToggle:OnChanged(function()
	-- 这里拿到开关对象再取它的值
	print("MyToggle 变更为:", Toggles.MyToggle.Value)
end)

-- 这应当向控制台打印："MyToggle 变更为: false"
Toggles.MyToggle:SetValue(false)

-- 2023/1/15
-- 弃用旧的按钮创建方式，改为使用表
-- 新增了双击按钮功能

--[[
	Groupbox:AddButton
	参数：{
		Text = string,
		Func = function,
		DoubleClick = boolean
		Tooltip = string,
	}

	你可以在一个按钮上调用 :AddButton 来添加子按钮！
]]

local MyButton = LeftGroupBox:AddButton({
	Text = "按钮",
	Func = function()
		print("你点击了一个按钮！")
		Library:Notify("这是一条通知")
	end,
	DoubleClick = false,

	Tooltip = "这是主按钮",
	DisabledTooltip = "我已禁用！", -- 按钮禁用后悬停显示的信息

	Disabled = false, -- 是否禁用该按钮（true / false）
	Visible = true -- 是否隐藏该按钮（true / false）
})

local MyButton2 = MyButton:AddButton({
	Text = "子按钮",
	Func = function()
		print("你点击了一个子按钮！")
		Library:Notify("这是一条带声音的通知", nil, 4590657391)
	end,
	DoubleClick = true, -- 需要点击两次才会触发回调
	Tooltip = "这是子按钮（双击我！）"
})

local MyDisabledButton = LeftGroupBox:AddButton({
	Text = "已禁用的按钮",
	Func = function()
		print("你居然点到了一个已禁用的按钮！")
	end,
	DoubleClick = false,
	Tooltip = "这是一个已禁用的按钮",
	DisabledTooltip = "我已禁用！", -- 按钮禁用后悬停显示的信息
	Disabled = true
})

--[[
	注意：按钮方法可以链式调用！
	示例：

	LeftGroupBox:AddButton({ Text = "全部击杀", Func = Functions.KillAll, Tooltip = "这会击杀游戏内所有人！" })
		:AddButton({ Text = "全部踢出", Func = Functions.KickAll, Tooltip = "这会把游戏内所有人踢出！" })
]]


-- Groupbox:AddLabel
-- 参数：文本, 是否换行, 索引
-- 参数：索引, 选项
LeftGroupBox:AddLabel("这是一个标签")
LeftGroupBox:AddLabel("这是一个标签\n\n会自动换行！", true)
LeftGroupBox:AddLabel("这个标签已暴露给 Labels", true, "TestLabel")
LeftGroupBox:AddLabel("SecondTestLabel", {
	Text = "这是一个用表选项和索引创建的标签",
	DoesWrap = true -- 默认 false
})

LeftGroupBox:AddLabel("SecondTestLabel", {
	Text = "这是一个不会自动换行的标签",
	DoesWrap = false -- 默认 false
})

-- Labels 是 Library 内的一个表，会被添加到 getgenv()
-- 用指定索引去取 Library.Labels，这里索引是 "SecondTestLabel" 和 "TestLabel"
-- 设置标签文本用 label:SetText

-- Library.Labels.TestLabel:SetText("第一次修改！")
-- Library.Labels.SecondTestLabel:SetText("第二次修改！")


-- Groupbox:AddDivider
-- 参数：无
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider
	参数：Idx, SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	Text、Default、Min、Max、Rounding 必须指定。
	Suffix 为可选。
	Rounding 是小数位数（精度）。

	Compact 会隐藏滑块的标题标签

	HideMax 只显示当前值，而不显示「当前值/最大值」
	Compact 效果类似
]]
LeftGroupBox:AddSlider("MySlider", {
	Text = "这是我的滑块！",
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		print("[回调] MySlider 已改变！新值:", Value)
	end,

	Tooltip = "我是一个滑块！", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 滑块禁用后悬停显示的信息

	Disabled = false, -- 是否禁用该滑块（true / false）
	Visible = true, -- 是否隐藏该滑块（true / false）
})

-- Options 是库添加到 getgenv() 的表
-- 用指定索引去取 Options，这里索引是 "MySlider"
-- 获取滑块的值用 slider.Value

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
	print("MySlider 已改变！新值:", Options.MySlider.Value)
end)

-- 这应当向控制台打印："MySlider 已改变！新值: 3"
Options.MySlider:SetValue(3)

LeftGroupBox:AddSlider("MySlider2", {
	Text = "这是我自定义显示文本的滑块！",
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	FormatDisplayValue = function(slider, value)
		if value == slider.Max then return "全部" end
		if value == slider.Min then return "无" end
		-- 如果返回 nil，则使用默认格式
	end,

	Tooltip = "我是一个滑块！", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 滑块禁用后悬停显示的信息

	Disabled = false, -- 是否禁用该滑块（true / false）
	Visible = true, -- 是否隐藏该滑块（true / false）
})

-- Groupbox:AddInput
-- 参数：Idx, Info
LeftGroupBox:AddInput("MyTextbox", {
	Default = "我的文本框！",
	Numeric = false, -- true / false，只允许输入数字
	Finished = false, -- true / false，仅在按下回车时调用回调
	ClearTextOnFocus = true, -- true / false，若为 false 聚焦时不会清空文本

	Text = "这是一个文本框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息

	Placeholder = "占位文本", -- 输入框为空时的占位文本
	-- MaxLength 也是一个选项，表示文本的最大长度

	Callback = function(Value)
		print("[回调] 文本已更新。新文本:", Value)
	end
})

Options.MyTextbox:OnChanged(function()
	print("文本已更新。新文本:", Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- 参数：Idx, Info

local DropdownGroupBox = Tabs.Main:AddRightGroupbox("下拉框")

DropdownGroupBox:AddDropdown("MyDropdown", {
	Values = { "这个", "是", "一个", "下拉框" },
	Default = 1, -- 值的数字索引 / 字符串
	Multi = false, -- true / false，是否允许选择多个

	Text = "一个下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

	Searchable = false, -- true / false，使下拉框可搜索（适合很长的列表）

	Callback = function(Value)
		print("[回调] 下拉框已改变。新值:", Value)
	end,

	Disabled = false, -- 是否禁用该下拉框（true / false）
	Visible = true, -- 是否隐藏该下拉框（true / false）
})

Options.MyDropdown:OnChanged(function()
	print("下拉框已改变。新值:", Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue("这个")

DropdownGroupBox:AddDropdown("MySearchableDropdown", {
	Values = { "这个", "是", "一个", "可搜索的", "下拉框" },
	Default = 1, -- 值的数字索引 / 字符串
	Multi = false, -- true / false，是否允许选择多个

	Text = "一个可搜索的下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

	Searchable = true, -- true / false，使下拉框可搜索（适合很长的列表）

	Callback = function(Value)
		print("[回调] 下拉框已改变。新值:", Value)
	end,

	Disabled = false, -- 是否禁用该下拉框（true / false）
	Visible = true, -- 是否隐藏该下拉框（true / false）
})

DropdownGroupBox:AddDropdown("MyDisplayFormattedDropdown", {
	Values = { "这个", "是", "一个", "已格式化的", "下拉框" },
	Default = 1, -- 值的数字索引 / 字符串
	Multi = false, -- true / false，是否允许选择多个

	Text = "一个显示格式化的下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

	FormatDisplayValue = function(Value) -- 你可以为任意值修改显示文本。值本身不变，只有 UI 变化。
		if Value == "已格式化的" then
			return "显示已格式化" -- 已格式化的 -> 显示已格式化，但 Options.MyDisplayFormattedDropdown.Value 若选中仍返回「已格式化的」
		end;

		return Value
	end,

	Searchable = false, -- true / false，使下拉框可搜索（适合很长的列表）

	Callback = function(Value)
		print("[回调] 显示格式化的下拉框已改变。新值:", Value)
	end,

	Disabled = false, -- 是否禁用该下拉框（true / false）
	Visible = true, -- 是否隐藏该下拉框（true / false）
})

-- 多选下拉框
DropdownGroupBox:AddDropdown("MyMultiDropdown", {
	-- Default 是数字索引（例如 "这个" 是 1，因为它是列表第一个）
	-- Default 也接受字符串

	-- 目前无法通过 dropdown 设置多个默认值

	Values = { "这个", "是", "一个", "下拉框" },
	Default = 1,
	Multi = true, -- true / false，是否允许选择多个

	Text = "一个多选下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息

	Callback = function(Value)
		print("[回调] 多选下拉框已改变:")
		for key, value in next, Options.MyMultiDropdown.Value do
			print(key, value) -- 应当打印类似 这个, true
		end
	end
})

Options.MyMultiDropdown:SetValue({
	["这个"] = true,
	["是"] = true,
})

DropdownGroupBox:AddDropdown("MyDisabledDropdown", {
    Values = { "这个", "是", "一个", "下拉框" },
    Default = 1, -- 值的数字索引 / 字符串
    Multi = false, -- true / false，是否允许选择多个

    Text = "一个已禁用的下拉框",
    Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
    DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

    Callback = function(Value)
        print("[回调] 已禁用的下拉框已改变。新值:", Value)
    end,

    Disabled = true, -- 是否禁用该下拉框（true / false）
    Visible = true, -- 是否隐藏该下拉框（true / false）
})

DropdownGroupBox:AddDropdown("MyDisabledValueDropdown", {
    Values = { "这个", "是", "一个", "下拉框", "带", "禁用", "值" },
    DisabledValues = { "禁用" }, -- 不可点击的禁用值
    Default = 1, -- 值的数字索引 / 字符串
    Multi = false, -- true / false，是否允许选择多个

    Text = "一个带禁用值的下拉框",
    Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
    DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

    Callback = function(Value)
        print("[回调] 带禁用值的下拉框已改变。新值:", Value)
    end,

    Disabled = false, -- 是否禁用该下拉框（true / false）
    Visible = true, -- 是否隐藏该下拉框（true / false）
})

DropdownGroupBox:AddDropdown("MyVeryLongDropdown", {
	Values = { "这个", "是", "一个", "非常", "长", "的", "下拉框", "里面", "有", "很多", "值", "但", "你", "可以", "看到", "超过", "8", "个", "值" },
	Default = 1, -- 值的数字索引 / 字符串
	Multi = false, -- true / false，是否允许选择多个

	MaxVisibleDropdownItems = 12, -- 默认：8，可修改下拉列表的显示高度

	Text = "一个非常长的下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

	Searchable = false, -- true / false，使下拉框可搜索（适合很长的列表）

	Callback = function(Value)
		print("[回调] 非常长的下拉框已改变。新值:", Value)
	end,

	Disabled = false, -- 是否禁用该下拉框（true / false）
	Visible = true, -- 是否隐藏该下拉框（true / false）
})

DropdownGroupBox:AddDropdown("MyPlayerDropdown", {
	SpecialType = "Player",
	ExcludeLocalPlayer = true, -- true / false，从 Player 类型中排除本地玩家
	Text = "一个玩家下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息

	Callback = function(Value)
		print("[回调] 玩家下拉框已改变:", Value)
	end
})

DropdownGroupBox:AddDropdown("MyTeamDropdown", {
	SpecialType = "Team",
	Text = "一个队伍下拉框",
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息

	Callback = function(Value)
		print("[回调] 队伍下拉框已改变:", Value)
	end
})

-- Label:AddColorPicker
-- 参数：Idx, Info

-- 你也可以给开关添加 ColorPicker 和 KeyPicker

LeftGroupBox:AddLabel("颜色"):AddColorPicker("ColorPicker", {
	Default = Color3.new(0, 1, 0), -- 亮绿色
	Title = "某个颜色", -- 可选。允许自定义颜色选择器标题（打开时显示）
	Transparency = 0, -- 可选。为该颜色选择器启用透明度调整（留空即禁用）

	Callback = function(Value)
		print("[回调] 颜色已改变！", Value)
	end
})

Options.ColorPicker:OnChanged(function()
	print("颜色已改变！", Options.ColorPicker.Value)
	print("透明度已改变！", Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Label:AddKeyPicker
-- 参数：Idx, Info

LeftGroupBox:AddLabel("按键"):AddKeyPicker("KeyPicker", {
	-- SyncToggleState 只对开关有效。
	-- 它允许你创建一个与父开关状态同步的按键绑定

	-- 示例：用于切换飞行外挂等的按键绑定
	-- 改变开关会禁用按键状态，而切换按键又会切换开关状态

	Default = "MB2", -- 字符串作为按键名（鼠标按键为 MB1、MB2）
	SyncToggleState = false,

	-- 你可以自定义 Mode，不过我从没用过。
	Mode = "Toggle", -- 模式：Always、Toggle、Hold、Press（下面有示例）

	Text = "自动撬锁保险箱", -- 显示在按键菜单中的文本
	NoUI = false, -- 若设为 true，则从按键菜单中隐藏

	-- 按键被点击时触发，Value 为 `true`/`false`
	Callback = function(Value)
		print("[回调] 按键已点击！", Value)
	end,

	-- 按键本身被修改时触发，`NewKey` 是 KeyCode 枚举或 UserInputType 枚举，`NewModifiers` 是包含 KeyCode 枚举的表或 nil
	ChangedCallback = function(NewKey, NewModifiers)
		print("[回调] 按键已改变！", NewKey, table.unpack(NewModifiers or {}))
	end,
})

-- OnClick 仅在按下按键且模式为 Toggle 时触发
-- 否则，你需要使用 Keybind:GetState()
Options.KeyPicker:OnClick(function()
	print("按键已点击！", Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
	print("按键已改变！", Options.KeyPicker.Value, table.unpack(Options.KeyPicker.Modifiers or {}))
end)

task.spawn(function()
	while task.wait(1) do
		-- 检查某个按键是否被按住的示例
		local state = Options.KeyPicker:GetState()
		if state then
			print("KeyPicker 正被按住")
		end

		if Library.Unloaded then break end
	end
end)

Options.KeyPicker:SetValue({ "MB2", "Hold" }) -- 将按键设为 MB2，模式设为 Hold

-- Label:KeyPicker（按下模式）

local KeybindNumber = 0

LeftGroupBox:AddLabel("按下按键"):AddKeyPicker("KeyPicker2", {
	-- 示例：用于在按键按下时运行回调的「按下」按键绑定。

	Default = "X", -- 字符串作为按键名（鼠标按键为 MB1、MB2）

	Mode = "Press",
	WaitForCallback = false, -- 在执行 Callback 和 OnChanged 期间锁定按键。

	Text = "增加数字", -- 显示在按键菜单中的文本

	-- 按键被点击时触发，对于「按下」按键 Value 始终为 `true`。
	Callback = function()
		KeybindNumber = KeybindNumber + 1
		print("[回调] 按键已点击！数字增加到:", KeybindNumber)
	end
})

-- Label:AddDropdown
-- 参数：Idx, Info

-- Info 表与普通下拉框相同
-- 这些下拉框非常紧凑

LeftGroupBox:AddLabel("下拉框"):AddDropdown("MyDropdown", {
	Values = { "附加", "下拉框" },
	Default = 1, -- 值的数字索引 / 字符串
	Multi = false, -- true / false，是否允许选择多个

	-- 此下拉框不需要 Text --
	Tooltip = "这是一个提示", -- 鼠标悬停时显示的信息
	DisabledTooltip = "我已禁用！", -- 下拉框禁用后悬停显示的信息

	Searchable = false, -- true / false，使下拉框可搜索（适合很长的列表）

	Callback = function(Value)
		print("[回调] 下拉框已改变。新值:", Value)
	end,

	Disabled = false, -- 是否禁用该下拉框（true / false）
	Visible = true, -- 是否隐藏该下拉框（true / false）
})

-- 长文本标签，用于演示 UI 的滚动行为。
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("分组框 #2");
LeftGroupBox2:AddLabel("哦不……\n这个标签跨了很多行！\n\n我们的 UI 空间要不够了……\n开玩笑的！往下滚！\n\n\n来自下方的问候！", true)

local TabBox = Tabs.Main:AddRightTabbox() -- 在右侧添加 Tabbox

-- 在 Groupbox 里能做的，在 Tabbox 标签页里也能做（AddToggle、AddSlider、AddLabel 等等……）
local Tab1 = TabBox:AddTab("标签页 1")
Tab1:AddToggle("Tab1Toggle", { Text = "标签页 1 开关" });

local Tab2 = TabBox:AddTab("标签页 2")
Tab2:AddToggle("Tab2Toggle", { Text = "标签页 2 开关" });

-- 依赖盒让我们可以根据其他 UI 元素的状态来控制某些 UI 元素的可见性。
-- 例如：我们有一个「功能已启用」开关，只希望在该开关启用时显示它对应的滑块、下拉框等！
-- 依赖盒示例：
local RightGroupbox = Tabs.Main:AddRightGroupbox("分组框 #3");
RightGroupbox:AddToggle("ControlToggle", { Text = "依赖盒控制开关" });

local Depbox = RightGroupbox:AddDependencyBox();
Depbox:AddToggle("DepboxToggle", { Text = "子依赖盒开关" });

-- 我们还可以嵌套依赖盒！
-- 这样做时，我们的 SubDepbox 会自动依赖 Depbox 的可见性——再加上我们自己设置的附加依赖
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider("DepboxSlider", { Text = "滑块", Default = 50, Min = 0, Max = 100, Rounding = 0 });
SubDepbox:AddDropdown("DepboxDropdown", { Text = "下拉框", Default = 1, Values = {"a", "b", "c"} });

local SecretDepbox = SubDepbox:AddDependencyBox();
SecretDepbox:AddLabel("你发现了一个秘密！")

Depbox:SetupDependencies({
	{ Toggles.ControlToggle, true } -- 也可以传 `false`，表示只在开关关闭时显示我们的功能！
});

SubDepbox:SetupDependencies({
	{ Toggles.DepboxToggle, true }
});

SecretDepbox:SetupDependencies({
	{ Options.DepboxDropdown, "ĉ"} -- 对于下拉框，它会自动检查指定的下拉值是否被选中
})

-- 库函数
-- 设置水印可见性
Library:SetWatermarkVisibility(true)

-- 动态更新水印的示例，包含常见信息（fps 和 ping）
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local GetPing = (function() return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
local CanDoPing = pcall(function() return GetPing(); end)

local WatermarkConnection = game:GetService("RunService").RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	if CanDoPing then
		Library:SetWatermark(("LinoriaLib 演示 | %d 帧 | %d 毫秒"):format(
			math.floor(FPS),
			GetPing()
		));
	else
		Library:SetWatermark(("LinoriaLib 演示 | %d 帧"):format(
			math.floor(FPS)
		));
	end
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print("已卸载！")
	Library.Unloaded = true
end)

-- 界面设置
local MenuGroup = Tabs["界面设置"]:AddLeftGroupbox("菜单")

MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "打开按键菜单", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "自定义光标", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单按键"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "菜单按键" })
MenuGroup:AddButton("卸载", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind -- 允许你为菜单设置一个自定义按键

-- 附加组件：
-- SaveManager（配置系统）
-- ThemeManager（菜单主题系统）

-- 把库交给我们的管理器
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- 忽略 ThemeManager 用到的键。
-- （我们可不想让配置去保存主题，对吧？）
SaveManager:IgnoreThemeSettings()

-- 把我们的 MenuKeybind 加入忽略列表
-- （你希望每个配置都有不同的菜单键吗？大概不想吧。）
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- 这样做的用途：
-- 脚本中心可以把主题放在全局文件夹
-- 而游戏配置放在每个游戏单独的文件夹里
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- 如果游戏内有多个地点（例如：DOORS）
					   -- 你可以用它为这些地点单独保存配置
					   -- 本脚本中的路径会是：MyScriptHub/specific-game/settings/specific-place
					   -- [ 此项可选 ]

-- 在我们的标签页右侧构建配置菜单
SaveManager:BuildConfigSection(Tabs["界面设置"])

-- 在我们的标签页左侧构建主题菜单（附带大量内置主题）
-- 注意：你也可以调用 ThemeManager:ApplyToGroupbox 把它加到指定分组框里
ThemeManager:ApplyToTab(Tabs["界面设置"])

-- 你可以用 SaveManager:LoadAutoloadConfig() 加载一个
-- 被标记为自动加载的配置！
SaveManager:LoadAutoloadConfig()
