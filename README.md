# Config Library [![Visitors](https://visitor-badge.glitch.me/badge?page_id=Exunys.Config-Library)](https://github.com/Exunys/Config-Library)

This library allows you to save the settings of your script in the easiest way possible. This library handles converting of datatypes like *Color3* into *strings* in the way so the table can be encoded into JSON format without any `null` values.

### `Color3.fromRGB(255, 255, 255)` (*Raw*) > `"Color3_(255, 255, 255)"` (*Config Library Archive*)

For loading configs, the library decodes the JSON table (turns it into a Lua table) and later restores all the values by checking the signature types.

### `"Vector3_(10, 50, 20)"` (*Config Library Archive*) > `Vector3.new(10, 50, 20)` (*Raw*)

## Signatures
- **`Color3.fromRGB(...)`** -> **`"Color3_(...)"`**
- **`Vector3.new(...)`** -> **`"Vector3_(...)"`**
- **`Vector2.new(...)`** -> **`"Vector2_(...)"`**
- **`CFrame.new(...)`** -> **`"CFrame_(...)"`**
- **`Enum[...]`** -> **`"EnumItem_(...)"`**

# Documentation

## ConfigLibrary.**Encode**(*\<table> Table*)
- Encodes *Table* to JSON format.
```lua
print(ConfigLibrary.Encode({Bool = true})) -- {"Bool":true}
```
## ConfigLibrary.**Decode**(*\<string> Content*)
- Decodes JSON Table (*Content*) to a Lua table.
```lua
print(ConfigLibrary.Decode([[{"Bool":true}]])[1]) -- true
```
## ConfigLibrary:**Recursive**(*\<table> Table*, *\<function> Callback*)
- Iterates through nested / inner tables. Will pass through every value and call *Callback* with the parameters **i** (index of value) & **v** (value).
```lua
local TestTable = {
	Bool = true,
	Number = 123,
	String = "Hello",
	Color = Color3.fromRGB(255, 255, 255),
	InnerTable = {
		Color2 = Color3.fromRGB(150, 150, 150),
		InnerInnerTable = {
			Color3_ = Color3.fromRGB(100, 100, 100),
			Vector3_ = Vector3.new(50, 200, 100),
			Vector2_ = Vector2.new(10, 20),
			InnerInnerInnerTable = {
				Key = Enum.KeyCode.X
			}
		}
	}
}

ConfigLibrary:Recursive(TestTable, warn)
```
Output:

![image](https://user-images.githubusercontent.com/76539058/218896002-0955af45-d75d-4e26-b02a-6eed2d2e71bf.png)
## ConfigLibrary.**EditValue**(*\<any> Value*)
- Edits the parsed value's type to the library's signature type.
```lua
print(ConfigLibrary.EditValue(Color3.fromRGB(50, 100, 200))) -- Color3_(50, 100, 200)
```
## ConfigLibrary.**RestoreValue**(*\<any> Value*)
- Edits the parsed value (if the value's type is the library's signature type) to a default Luau value.
```lua
print(ConfigLibrary.RestoreValue("Color3_(50, 100, 200)")) -- 50, 100, 200 <Color3>
```
## ConfigLibrary:**ConvertValues**(*\<table> Data*, *\<string> Method*)
- Edits all the values of parsed table (*Data*) depending on the *Method*.
- "Edit" method calls ConfigLibrary.**EditValue** function.
- "Restore" method calls ConfigLibrary.**RestoreValue** function.
```lua
local TestTable = {
	Bool = true,
	Number = 123,
	String = "Hello",
	Color = Color3.fromRGB(255, 255, 255),
	InnerTable = {
		Color2 = Color3.fromRGB(150, 150, 150),
		InnerInnerTable = {
			Color3_ = Color3.fromRGB(100, 100, 100),
			Vector3_ = Vector3.new(50, 200, 100),
			Vector2_ = Vector2.new(10, 20),
			InnerInnerInnerTable = {
				Key = Enum.KeyCode.X
			}
		}
	}
}

ConfigLibrary:Recursive(ConfigLibrary:ConvertValues(TestTable, "Edit"), warn)
```
Output:

![image](https://user-images.githubusercontent.com/76539058/218897458-a520863f-db4f-4c18-a47d-ee00a651b2fd.png)
## ConfigLibrary:**SaveConfig**(*\<string> Path*, *\<table> Data*)
- Converts the parsed *Data*'s values to the library's signature values and later encodes the result to a JSON table. The JSON-Encoded table later gets saved at the parsed *Path*. If *Path* doesn't exist, the library creates the path and the file with the given extension (with folders and everything).
```lua
local TestTable = {
	Bool = true,
	Number = 123,
	String = "Hello",
	Color = Color3.fromRGB(255, 255, 255),
	InnerTable = {
		Color2 = Color3.fromRGB(150, 150, 150),
		InnerInnerTable = {
			Color3_ = Color3.fromRGB(100, 100, 100),
			Vector3_ = Vector3.new(50, 200, 100),
			Vector2_ = Vector2.new(10, 20),
			InnerInnerInnerTable = {
				Key = Enum.KeyCode.X
			}
		}
	}
}

ConfigLibrary:SaveConfig("a/b/c/d/test.json", TestTable)
```
![image](https://user-images.githubusercontent.com/76539058/218898447-39d76d20-27f1-4878-8d8b-118493779de8.png)
![image](https://user-images.githubusercontent.com/76539058/218898455-abd7a78f-6d14-47e2-bc14-78aeec70df7e.png)
### ConfigLibrary:**LoadConfig**(*\<string> Path*, *\<table> Data*)
- Opens the file located at *Path* and decodes the JSON table and restores its values to Luau format.
```lua
local TestTable = {}

TestTable = ConfigLibrary:LoadConfig("a/b/c/d/test.json")

ConfigLibrary:Recursive(TestTable, warn)
```
Output:

![image](https://user-images.githubusercontent.com/76539058/218898896-a277e595-4727-4928-9614-bc3bdd1f550c.png)

# Install

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()
```
# Examples

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local ESP_Settings = {
  TextColor = Color3.fromRGB(255, 0, 0),
  Outline = true,
  OutlineColor = Color3.fromRGB(0, 0, 0),
  Transparency = 0.7
}

Library:SaveConfig("My Cool Hub/Config.json", ESP_Settings)
```
![image](https://user-images.githubusercontent.com/76539058/218899502-8edd80ae-c6f1-4192-b5af-2f3a21e1e7ce.png)
![image](https://user-images.githubusercontent.com/76539058/218899512-649d067e-cce6-42c0-8c7f-c49ef2a6db81.png)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local ESP_Settings = {}

ESP_Settings = Library:LoadConfig("My Cool Hub/Config.json")
```
# Contact Information
- **[Discord](https://discord.com/users/611111398818316309)**
- **[E-Mail](mailto:exunys@gang.email)**
