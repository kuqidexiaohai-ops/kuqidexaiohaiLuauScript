local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
	return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles;

local assert = function(condition, errorMessage) 
	if (not condition) then
		error(if errorMessage then errorMessage else "assert failed", 3)
	end
end

if typeof(clonefunction) == "function" then

	local
		isfolder_copy,
		isfile_copy,
		listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

	local isfolder_success, isfolder_error = pcall(function()
		return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
	end)

	if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
		isfolder = function(folder)
			local success, data = pcall(isfolder_copy, folder)
			return (if success then data else false)
		end

		isfile = function(file)
			local success, data = pcall(isfile_copy, file)
			return (if success then data else false)
		end

		listfiles = function(folder)
			local success, data = pcall(listfiles_copy, folder)
			return (if success then data else {})
		end
	end
end

local ThemeManager = {} do
	local ThemeFields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
	ThemeManager.Folder = "LinoriaLibSettings"

	ThemeManager.Library = nil

	ThemeManager.DefaultColors = {
		FontColor = "ffffff",
		MainColor = "191925",
		AccentColor = "6759b3",
		BackgroundColor = "16161f",
		OutlineColor = "323232",
	}

	function ThemeManager:SetLibrary(library)
		self.Library = library
	end

	function ThemeManager:GetPaths()
		local paths = {}

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		paths[#paths + 1] = self.Folder .. '/themes'
		
		return paths
	end

	function ThemeManager:BuildFolderTree()
		local paths = self:GetPaths()

		for i = 1, #paths do
			local str = paths[i]
			if isfolder(str) then continue end
			makefolder(str)
		end
	end

	function ThemeManager:CheckFolderTree()
		if isfolder(self.Folder) then return end
		self:BuildFolderTree()

		task.wait(0.1)
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

	function ThemeManager:ApplyColors(scheme)
		for idx, col in next, scheme do
			self.Library[idx] = Color3.fromHex(col)

			if self.Library.Options[idx] then
				self.Library.Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		if not customThemeData then return end

		self:ApplyColors(customThemeData)
	end

	function ThemeManager:ThemeUpdate()
		for i, field in next, ThemeFields do
			if self.Library.Options and self.Library.Options[field] then
				self.Library[field] = self.Library.Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file .. '.json'
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:LoadDefault()
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		if content and self:GetCustomTheme(content) then
			self:ApplyTheme(content)
		else
			self:ApplyColors(self.DefaultColors)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			self.Library:Notify('主题名称无效（不能为空）', 3)
			return
		end

		local theme = {}
		for _, field in next, ThemeFields do
			theme[field] = self.Library.Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', HttpService:JSONEncode(theme))
	end

	function ThemeManager:Delete(name)
		if (not name) then
			return false, '未选择配置文件'
		end

		local file = self.Folder .. '/themes/' .. name .. '.json'
		if not isfile(file) then return false, '文件无效' end

		local success = pcall(delfile, file)
		if not success then return false, '删除文件失败' end
		
		return true
	end
	
	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then

				local pos = file:find('.json', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1, start - 1))
				end
			end
		end

		return out
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('背景颜色'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('主颜色')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('强调色'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('轮廓颜色'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('字体颜色')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });
		
		groupbox:AddDivider()

		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = '自定义主题名称' })
		groupbox:AddButton('创建主题', function() 
			local name = self.Library.Options.ThemeManager_CustomThemeName.Value
			if name:gsub(" ", "") == "" then
				self.Library:Notify("主题名称无效（不能为空）", 2)
				return
			end

			self:SaveCustomTheme(name)

			self.Library:Notify(string.format("已创建主题 %q", name))
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddDivider()

		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = '自定义主题', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddButton('加载主题', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			self:ApplyTheme(name)
			self.Library:Notify(string.format('已加载主题 %q', name))
		end)
		groupbox:AddButton('覆盖主题', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			self:SaveCustomTheme(name)
			self.Library:Notify(string.format('已覆盖主题 %q', name))
		end)
		groupbox:AddButton('删除主题', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			local success, err = self:Delete(name)
			if not success then
				self.Library:Notify('删除主题失败：' .. err)
				return
			end

			self.Library:Notify(string.format('已删除主题 %q', name))
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)
		groupbox:AddButton('设为默认', function()
			if self.Library.Options.ThemeManager_CustomThemeList.Value ~= nil and self.Library.Options.ThemeManager_CustomThemeList.Value ~= '' then
				self:SaveDefault(self.Library.Options.ThemeManager_CustomThemeList.Value)
				self.Library:Notify(string.format('已将默认主题设为 %q', self.Library.Options.ThemeManager_CustomThemeList.Value))
			end
		end)
		groupbox:AddButton('重置默认', function()
			local success = pcall(delfile, self.Folder .. '/themes/default.txt')
			if not success then 
				self.Library:Notify('重置默认失败：删除文件出错')
				return
			end
				
			self.Library:Notify('已清除默认主题')
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		self:LoadDefault()

		local function UpdateTheme() self:ThemeUpdate() end
		self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
		self.Library.Options.MainColor:OnChanged(UpdateTheme)
		self.Library.Options.AccentColor:OnChanged(UpdateTheme)
		self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
		self.Library.Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'ThemeManager:CreateGroupBox -> Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('主题')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'ThemeManager:ApplyToTab -> Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'ThemeManager:ApplyToGroupbox -> Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

getgenv().LinoriaThemeManager = ThemeManager
return ThemeManager
