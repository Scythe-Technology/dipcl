--!strict
type DipclContainer = 
    ((lib: "FileSystem") -> typeof(require("layers/filesystem")));

local cache = {};

--// TODO: probably should be dynamic, for less load.
cache["filesystem"] = require("layers/filesystem")

return (function(system: string)
    local lib = system:lower();
    -- if (lib == "filesystem") then
        -- if (cache[lib]) then
        --     return cache[lib];
        -- end
        -- cache[lib] = require("layers/filesystem");
    -- end
    return cache[lib];
end)::DipclContainer;
