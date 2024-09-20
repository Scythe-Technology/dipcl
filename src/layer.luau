--!strict
local Runtime = require("runtime");

local layer = {};

local function semverToString(version: Runtime.Semver): string
    return string.format("%d.%d.%d", version.major, version.minor, version.patch);
end

function layer.logError(layer: string, errorMsg: string): never
    local funcName = debug.info(2, "n");
    return error(string.format("(%s %s) [%s] (%s): %s", Runtime.platform.kind, semverToString(Runtime.platform.version), layer, funcName, errorMsg), 3);
end

return layer;
