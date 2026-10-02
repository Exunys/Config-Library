# ⚙️Config Library [![Visitors](https://visitor-badge.laobi.icu/badge?page_id=Exunys.Config-Library&right_color=grey)](https://github.com/Exunys/Config-Library)

| [Library](https://github.com/Exunys/Config-Library/blob/main/Main.lua) | [Install](https://github.com/Exunys/Config-Library#Install) | [Documentation](https://github.com/Exunys/Config-Library#Documentation) | [Examples](https://github.com/Exunys/Config-Library#Examples) | [Contact Information](https://github.com/Exunys/Config-Library#Contact-Information) |
| :---: | :---: | :---: | :---: | :---: |

**Config Library** simplifies saving and loading script settings in Roblox executor environments. It solves the common issue where standard JSON encoders convert complex Luau data types into `null` or strip them out completely. 

By automatically serializing native Roblox objects into tagged string signatures prior to JSON encoding, the library preserves your settings and re-instantiates them into native objects upon loading.

> 💡**Quick Start:** The core functions of this library are [`SaveConfig`](#configlibrarysaveconfig) for serializing and storing settings to disk, and [`LoadConfig`](#configlibraryloadconfig) for retrieving and restoring them back into native Luau objects.

---

# ❓How It Works

### 1. Saving Configurations
When saving, the library converts complex Luau types into serialized string signatures before translating the settings table into JSON.

> **`Color3.fromRGB(255, 255, 255)`** *(Raw Object)* $\rightarrow$ **`"Color3_(255, 255, 255)"`** *(Saved Signature)*

### 2. Loading Configurations
When loading, the library decodes the JSON data back into a Lua table and scans for signature types, restoring each string into its original Roblox object.

> **`"Vector3_(10, 50, 20)"`** *(Saved Signature)* $\rightarrow$ **`Vector3.new(10, 50, 20)`** *(Restored Object)*

---

# 💽Supported Datatype Signatures

The library automatically maps the following Roblox datatypes:

| Native Luau Object | Serialized String Signature |
| :--- | :--- |
| `Color3.fromRGB(...)` | `"Color3_(...)"` |
| `Vector3.new(...)` | `"Vector3_(...)"` |
| `Vector2.new(...)` | `"Vector2_(...)"` |
| `CFrame.new(...)` | `"CFrame_(...)"` |
| `Enum[...]` | `"EnumItem_(...)"` |

---

# 🛠️System Requirements

To read and write files locally, your executor environment must support the following standard filesystem API functions:

* `readfile`
* `writefile`
* `isfile`
* `isfolder`
* `makefolder`

# 💻Integrate

You can load this library into your script's environment by copying the code below.

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()
```


# 📑API Reference

### `ConfigLibrary.Encode`
Encodes a Lua table into a JSON-formatted string.

```lua
ConfigLibrary.Encode(Table: table) -> string
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Table` | `table` | The Lua table to encode. |

**Returns:** `string` — JSON-encoded string.

<details>
<summary><b>View Example</b></summary>

```lua
print(ConfigLibrary.Encode({Bool = true})) 
-- Output: {"Bool":true}
```
</details>

---

### `ConfigLibrary.Decode`
Decodes a JSON string and converts it back into a Lua table.

```lua
ConfigLibrary.Decode(Content: string) -> table
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Content` | `string` | The JSON string to decode. |

**Returns:** `table` — Decoded Lua table.

<details>
<summary><b>View Example</b></summary>

```lua
print(ConfigLibrary.Decode([[{"Bool":true}]])[1]) 
-- Output: true
```
</details>

---

### `ConfigLibrary:Recursive`
Iterates recursively through nested tables and executes a callback function for every index-value pair found.

```lua
ConfigLibrary:Recursive(Table: table, Callback: function)
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Table` | `table` | The target table (including nested sub-tables). |
| `Callback` | `function` | Function called with parameters `(index, value)`. |

<details>
<summary><b>View Example & Output</b></summary>

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

![Recursive Output](https://user-images.githubusercontent.com/76539058/218896002-0955af45-d75d-4e26-b02a-6eed2d2e71bf.png)
</details>

---

### `ConfigLibrary.EditValue`
Converts a supported native Luau data type into the library's custom string signature.

```lua
ConfigLibrary.EditValue(Value: any) -> any
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Value` | `any` | The Luau value to convert. |

**Returns:** `any` — The converted signature string (or original value if unsupported).

<details>
<summary><b>View Example</b></summary>

```lua
print(ConfigLibrary.EditValue(Color3.fromRGB(50, 100, 200))) 
-- Output: Color3_(50, 100, 200)
```
</details>

---

### `ConfigLibrary.RestoreValue`
Restores a serialized signature string back into its native Luau data type.

```lua
ConfigLibrary.RestoreValue(Value: any) -> any
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Value` | `any` | The signature string to parse. |

**Returns:** `any` — Native Luau object or original value.

<details>
<summary><b>View Example</b></summary>

```lua
print(ConfigLibrary.RestoreValue("Color3_(50, 100, 200)")) 
-- Output: Color3 object (50, 100, 200)
```
</details>

---

### `ConfigLibrary:CloneTable`
Performs a deep clone of the provided table and returns the new copy.

```lua
ConfigLibrary:CloneTable(Table: table) -> table
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Table` | `table` | The table to duplicate. |

**Returns:** `table` — Cloned instance.

<details>
<summary><b>View Example & Output</b></summary>

```lua
local TestTable = {
    Bool = true,
    Number = 123,
    InnerTable = {
        Key = Enum.KeyCode.X
    }
}

local Clone = ConfigLibrary:CloneTable(TestTable)

print(TestTable == Clone) -- Output: false
```

![Clone Output](https://user-images.githubusercontent.com/76539058/219037944-a3561fba-3a39-46d0-9a8d-6b4c3333cc71.png)
</details>

---

### `ConfigLibrary:ConvertValues`
Mass-converts all values within a table (recursively) using the specified method.

```lua
ConfigLibrary:ConvertValues(Data: table, Method: "Edit" | "Restore") -> table
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Data` | `table` | The table containing values to convert. |
| `Method` | `string` | `"Edit"` to apply signatures, or `"Restore"` to convert back to objects. |

**Returns:** `table` — Processed table.

<details>
<summary><b>View Example & Output</b></summary>

```lua
local ConvertedTable = ConfigLibrary:ConvertValues(TestTable, "Edit")
ConfigLibrary:Recursive(ConvertedTable, warn)
```

![Convert Output](https://user-images.githubusercontent.com/76539058/218897458-a520863f-db4f-4c18-a47d-ee00a651b2fd.png)
</details>

---

### `ConfigLibrary:SaveConfig`
Converts complex values in a table to signatures, encodes it to JSON, and writes it to disk. Generates required folders automatically if they do not exist.

```lua
ConfigLibrary:SaveConfig(Path: string, Data: table)
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Path` | `string` | File destination path (e.g., `"Folder/Subfolder/Config.json"`). |
| `Data` | `table` | The configuration table to save. |

<details>
<summary><b>View Example & Output</b></summary>

```lua
ConfigLibrary:SaveConfig("a/b/c/d/test.json", TestTable)
```

![Save Output 1](https://user-images.githubusercontent.com/76539058/218898447-39d76d20-27f1-4878-8d8b-118493779de8.png)
![Save Output 2](https://user-images.githubusercontent.com/76539058/218898455-abd7a78f-6d14-47e2-bc14-78aeec70df7e.png)
</details>

---

### `ConfigLibrary:LoadConfig`
Reads a JSON file from disk, parses it into a Lua table, and restores all serialized signature strings back to native Luau objects.

```lua
ConfigLibrary:LoadConfig(Path: string) -> table
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Path` | `string` | File path to load. |

**Returns:** `table` — Restored configuration table.

<details>
<summary><b>View Example & Output</b></summary>

```lua
local LoadedConfig = ConfigLibrary:LoadConfig("a/b/c/d/test.json")
ConfigLibrary:Recursive(LoadedConfig, warn)
```

![Load Output](https://user-images.githubusercontent.com/76539058/218914924-cec542d4-a783-43e9-88c7-f6acd5973f02.png)
</details>

---

# 📝Usage Examples

### 1. Saving Configuration
```lua
local ConfigLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local ESP_Settings = {
    TextColor = Color3.fromRGB(255, 0, 0),
    Outline = true,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    Transparency = 0.7
}

ConfigLib:SaveConfig("My Cool Hub/Config.json", ESP_Settings)
```

<details>
<summary><b>View Output Files</b></summary>

![Save Example 1](https://user-images.githubusercontent.com/76539058/218899502-8edd80ae-c6f1-4192-b5af-2f3a21e1e7ce.png)
![Save Example 2](https://user-images.githubusercontent.com/76539058/218899512-649d067e-cce6-42c0-8c7f-c49ef2a6db81.png)
</details>

---

### 2. Loading Configuration
```lua
local ConfigLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local ESP_Settings = ConfigLib:LoadConfig("My Cool Hub/Config.json")
```

---

### 3. One-Liner Inline Saving
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))():SaveConfig("test.json", {
    b = "c", 
    d = {
        e = "f", 
        g = {
            h = "i", 
            j = {"k"}
        }
    }
})
```

**Generated JSON output (`test.json`):**
```json
{
  "b": "c",
  "d": {
    "e": "f",
    "g": {
      "h": "i",
      "j": ["k"]
    }
  }
}
```

---

# 📧Contact Information

* [Discord](https://discord.com/users/611111398818316309)
* [Email](mailto:exunys@gmail.com)
