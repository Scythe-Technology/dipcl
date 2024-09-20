# Drop-In Platform Compatibility Layer (DIPCL)

DIPCL is a compatibility library that provides a common API for most [Luau](https://luau.org/) runtimes, written in luau & strictly typed.

DIPCL brings some features from other runtimes that might not be available in the target runtime.

## Supported Runtimes
- [Lune](https://github.com/lune-org/lune)
- [Zune](https://github.com/Scythe-Technology/Zune)

## Usage
Every API for each layer will try to support all runtimes, while remaining the same regardless from where it is running from.

### Importing
```luau
-- ✅ Recommended to support the runtimes.
local dipcl = require("@dipcl/dipcl")

-- ❌ Not recommended.
-- This will not work on lune, as it needs a '/' delimiter.
-- Would work on zune, but it is not recommended to use it.
local dipcl = require("@dipcl")
```

### Using a Layer
```luau
local dipcl = require("@dipcl/dipcl")

-- Case-insensitive
local layer = dipcl("LayerName")
-- Case-insensitive
local layer = dipcl "layername"
```

### Layers
---
- FileSystem
  ```luau
  local dipcl = require("@dipcl/dipcl")

  local fs = dipcl "FileSystem"

  fs.writeDir("./out/sub/path", {recursive = true})
  fs.removeDir("./out/sub/path", {recursive = true})
  ```
- ... more soon.

## Goals
- Provide a common API for most Luau runtimes.
- Emulate/Bring features from other runtimes to the target runtime.
- Make it easier to port code between runtimes.
- Make it easier to write code that works on multiple runtimes.