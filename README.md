# ⚙️Config Library [![Visitors](https://visitor-badge.glitch.me/badge?page_id=Exunys.Config-Library)](https://github.com/Exunys/Config-Library)

| [Install](https://github.com/Exunys/Config-Library#Install) | [Documentation](https://github.com/Exunys/Config-Library#Documentation) | [Examples](https://github.com/Exunys/Config-Library#Examples) | [Contact Information](https://github.com/Exunys/Config-Library#Contact-Information) |
| :---: | :---: | :---: | :---: |

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

# 💻Install

You can load this library into your script's environment by copying the code below.

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()
```

# 📑Documentation

## ConfigLibrary.**Encode**(*\<table> Table*) --> JSON-Encoded Lua Table \<string>
- Encodes *Table* to JSON format.
```lua
print(ConfigLibrary.Encode({Bool = true})) -- {"Bool":true}
```
## ConfigLibrary.**Decode**(*\<string> Content*) --> Decoded JSON Table \<table>
- Decodes JSON Table (*Content*) & converts it to a Lua table.
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
## ConfigLibrary.**EditValue**(*\<any> Value*) --> Edited Value \<any>
- Edits the parsed value's type to the library's signature type.
```lua
print(ConfigLibrary.EditValue(Color3.fromRGB(50, 100, 200))) -- Color3_(50, 100, 200)
```
## ConfigLibrary.**RestoreValue**(*\<any> Value*) --> Restored Value \<any>
- Edits the parsed value (if the value's type is the library's signature type) to a default Luau value.
```lua
print(ConfigLibrary.RestoreValue("Color3_(50, 100, 200)")) -- 50, 100, 200 <Color3>
```
## ConfigLibrary:**CloneTable**(*\<table> Table*) --> Clone \<table>
- Clones the parsed Table and returns the Clone.
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

local Clone = ConfigLibrary:CloneTable(TestTable)

print(TestTable)
print(Clone)
print(TestTable == Clone)

print(string.rep("=", 25))

ConfigLibrary:Recursive(TestTable, warn)
print(string.rep("=", 10).."Clone"..string.rep("=", 10))
ConfigLibrary:Recursive(Clone, warn)
```
Output:

![image](https://user-images.githubusercontent.com/76539058/219037944-a3561fba-3a39-46d0-9a8d-6b4c3333cc71.png)
## ConfigLibrary:**ConvertValues**(*\<table> Data*, *\<string> Method*) --> Result (Converted Data) \<table>
- Edits all the values of parsed table (*Data*) depending on the *Method*.
- `"Edit"` method calls ConfigLibrary.**EditValue** function.
- `"Restore"` method calls ConfigLibrary.**RestoreValue** function.
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
## ConfigLibrary:**LoadConfig**(*\<string> Path*, *\<table> Data*) --> Config \<table>
- Opens the file located at *Path* and decodes the JSON table and restores its values to Luau format.
```lua
local TestTable = {}

TestTable = ConfigLibrary:LoadConfig("a/b/c/d/test.json")

ConfigLibrary:Recursive(TestTable, warn)
```
Output:

![image](https://user-images.githubusercontent.com/76539058/218914924-cec542d4-a783-43e9-88c7-f6acd5973f02.png)

# 📝Examples

### Saving a configuration:
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

### Loading a configuration:
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local ESP_Settings = {}

ESP_Settings = Library:LoadConfig("My Cool Hub/Config.json")
```
##
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))():SaveConfig("test.json", {b = "c", d = {e = "f", g = {h = "i", j = {"k"}}}})
```
->
```json
{"b":"c","d":{"e":"f","g":{"h":"i","j":["k"]}}}
```
# 📧Contact Information
- **[Discord](https://discord.com/users/611111398818316309)**
- **[E-Mail](mailto:exunys@gang.email)**
