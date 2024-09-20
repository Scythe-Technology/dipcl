--!strict
local runtime = {};

runtime.platform = {
    kind = "Unknown",
    version = { major = 0, minor = 0, patch = 0 },
}
runtime.luau = { major = 0, minor = 0 };

type Runtime = typeof(runtime);

export type Semver = {
    major: number,
    minor: number,
    patch: number,
}

local function simpleSemver(version): Semver?
    local major, minor, patch = string.match(version, "(%d+)%.(%d+)%.(%d+)");
    if (not major or not minor or not patch) then
        return;
    end
    return {
        major = tonumber(major) or 0,
        minor = tonumber(minor) or 0,
        patch = tonumber(patch) or 0
    };
end

function runtime:_load()
    if (_VERSION == "Luau") then
        runtime.platform = {
            kind = if (game and script) then "Roblox" else "Luau",
            version = {major = 0, minor = 0, patch = 0},
        }
        runtime.luau = { major = 0, minor = 0 }
    else
        if (_VERSION:sub(1, 4) == "Lune") then
            local isLune, luneVersion, luauVersion = string.match(_VERSION, "(Lune) (%d+%.%d+%.%d+)+(%d+)")
            if (isLune and luneVersion and luauVersion) then
                runtime.platform = {
                    kind = "Lune",
                    version = assert(simpleSemver(luneVersion), "[Runtime] Failed to parse runtime version (Lune)"),
                };
                runtime.luau = {
                    major = 0,
                    minor = assert(tonumber(luauVersion), "[Runtime] Failed to parse luau version (Lune)"),
                }
                return;
            end
        elseif (_VERSION:sub(1, 4) == "Zune") then
            local isZune, zuneVersion, luauVersion = string.match(_VERSION, "(Zune) (%d+%.%d+%.%d+)+(%d+%.%d+)")
            if (isZune and zuneVersion and luauVersion) then
                runtime.platform = {
                    kind = "Zune",
                    version = assert(simpleSemver(zuneVersion), "[Runtime] Failed to parse runtime version (Zune)"),
                };
                local split = luauVersion:split(".");
                runtime.luau = {
                    major = assert(tonumber(split[1]), "[Runtime] Failed to parse luau version (Zune)"),
                    minor = assert(tonumber(split[2]), "[Runtime] Failed to parse luau version (Zune)"),
                }
                return;
            end
        end
    end
end

function runtime.isRoblox(self: Runtime)
    return self.platform.kind == "Roblox";
end

function runtime.isLuau(self: Runtime)
    return self.platform.kind == "Luau";
end

function runtime.isLune(self: Runtime)
    return self.platform.kind == "Lune";
end

function runtime.isZune(self: Runtime)
    return self.platform.kind == "Zune";
end

function runtime.getLuauVersion(self: Runtime)
    return self.luau;
end

runtime:_load();

return runtime;
