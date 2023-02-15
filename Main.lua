--[[

	Config Library by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys

]]

local HttpService, ConfigLibrary = game:GetService("HttpService"), {}

ConfigLibrary.Encode = function(Table)
	assert(Table, "ConfigLibrary.Encode => Parameter \"Table\" is missing!")
	assert(type(Table) == "table", "ConfigLibrary.Encode => Parameter \"Table\" must be of type <table>. Type given: <"..type(Table)..">")

	if Table and type(Table) == "table" then
		return HttpService:JSONEncode(Table)
	end
end
ConfigLibrary.Decode = function(Content)
	assert(Content, "ConfigLibrary.Decode => Parameter \"Content\" is missing!")
	assert(type(Content) == "string", "ConfigLibrary.Decode => Parameter \"Content\" must be of type <string>. Type given: <"..type(Content)..">")

	return HttpService:JSONDecode(Content)
end

ConfigLibrary.Recursive = function(self, Table, Callback)
	assert(Table, "ConfigLibrary.Recursive => Parameter \"Table\" is missing!")
	assert(Callback, "ConfigLibrary.Recursive => Parameter \"Callback\" is missing!")
	assert(type(Table) == "table", "ConfigLibrary.Recursive => Parameter \"Table\" must be of type <table>. Type given: <"..type(Table)..">")
	assert(type(Callback) == "function", "ConfigLibrary.Recursive => Parameter \"Callback\" must be of type <string>. Type given: <"..type(Callback)..">")

	for i, v in next, Table do
		Callback(i, v)

		if type(v) == "table" then
			self:Recursive(v, Callback)
		end
	end
end

ConfigLibrary.EditValue = function(Value)
	--assert(Value, "ConfigLibrary.EditValue => Parameter \"Value\" is missing!")

	if typeof(Value) == "Color3" then
		Value = "Color3_("..math.floor(Value.R * 255)..", "..math.floor(Value.G * 255)..", "..math.floor(Value.B * 255)..")"
	elseif typeof(Value) == "Vector3" or typeof(Value) == "Vector2" or typeof(Value) == "CFrame" then
		Value = typeof(Value).."_("..tostring(Value)..")"
	elseif typeof(Value) == "EnumItem" then
		Value = "EnumItem_("..string.match(tostring(Value), "Enum%.(.+)")..")"
	end

	return Value
end

ConfigLibrary.RestoreValue = function(Value)
	--assert(Value, "ConfigLibrary.RestoreValue => Parameter \"Value\" is missing!")

	if type(Value) == "string" then
		local Type, Content = string.match(Value, "(.+)_%("), string.match(Value, ".+_%((.+)%)")

		if Type == "Color3" then
			Content = string.split(Content, ", ")

			for i, v in next, Content do
				Content[i] = tonumber(v)
			end

			Value = Color3.fromRGB(unpack(Content))
		elseif Type == "Vector3" or Type == "Vector2" or Type == "CFrame" then
			Content = string.split(Content, ", ")

			for i, v in next, Content do
				Content[i] = tonumber(v)
			end

			Value = getfenv()[Type].new(unpack(Content))
		elseif typeof(Value) == "EnumItem" then
			Value = loadstring("return Enum."..Content)()
		end
	end

	return Value
end

ConfigLibrary.ConvertValues = function(self, Data, Method)
	assert(Data, "ConfigLibrary.ConvertValues => Parameter \"Data\" is missing!")
	assert(Method, "ConfigLibrary.ConvertValues => Parameter \"Method\" is missing!")
	assert(type(Data) == "table", "ConfigLibrary.ConvertValues => Parameter \"Data\" must be of type <table>. Type given: <"..type(Data)..">")
	assert(type(Method) == "string", "ConfigLibrary.ConvertValues => Parameter \"Method\" must be of type <string>. Type given: <"..type(Method)..">")

	local Result, Passed, Stack = Data, {[Data] = true}, {Data}

	repeat
		local Current = table.remove(Stack) -- "Pop"

		for i, v in next, Current do
			if type(v) == "table" and not Passed[v] then
				Passed[v] = true
				Stack[#Stack + 1] = v -- "Push" to stack
			else
				Current[i] = self[Method.."Value"](v)
			end
		end
	until #Stack == 0

	return Result
end

ConfigLibrary.SaveConfig = function(self, Path, Data)
	assert(Path, "ConfigLibrary.SaveConfig => Parameter \"Path\" is missing!")
	assert(Data, "ConfigLibrary.SaveConfig => Parameter \"Data\" is missing!")
	assert(type(Path) == "string", "ConfigLibrary.SaveConfig => Parameter \"Path\" must be of type <string>. Type given: <"..type(Path)..">")
	assert(type(Data) == "table", "ConfigLibrary.SaveConfig => Parameter \"Data\" must be of type <table>. Type given: <"..type(Data)..">")

	Data = self.Encode(self:ConvertValues(Data, "Edit"))

	if select(2, pcall(function() readfile(Path) end)) then
		self.CreatePath(self, Path, Data)
	end

	writefile(Path, Data)
end

ConfigLibrary.LoadConfig = function(self, Path)
	assert(Path, "ConfigLibrary.LoadConfig => Parameter \"Path\" is missing!")
	assert(type(Path) == "string", "ConfigLibrary.LoadConfig => Parameter \"Path\" must be of type <string>. Type given: <"..type(Path)..">")

	return self:ConvertValues(self.Decode(readfile(Path)), "Restore")
end

ConfigLibrary.CreatePath = function(self, Path, Content)
	assert(Path, "ConfigLibrary.CreatePath => Parameter \"Path\" is missing!")
	assert(type(Path) == "string", "ConfigLibrary.CreatePath => Parameter \"Path\" must be of type <string>. Type given: <"..type(Path)..">")

	local Folders, Destination, File = string.split(Path, "/"), ""
	File = Folders[#Folders]; table.remove(Folders)

	for i = 1, #Folders do
		Destination = Destination..Folders[i].."/"

		if not isfolder(Destination) then
			makefolder(Destination)
		end
	end

	if not isfile(Destination..File) then
		writefile(Destination..File, Content or "")
	end
end

return ConfigLibrary
