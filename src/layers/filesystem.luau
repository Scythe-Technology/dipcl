--!strict
local Layer= require("../layer");
local Runtime = require("../runtime");

local LAYER_NAME = "FileSystem";
local FileSystem = {};

if (Runtime:isLune()) then
    FileSystem.__lune = {
        fs = require("@lune/fs");
    }
elseif (Runtime:isZune()) then
    FileSystem.__zune = {
        fs = require("@zcore/fs");
    }
end

export type ReadFileOptions = {
    buffer: boolean,
};

export type WriteFileOptions = {
    data: string | buffer,
};

export type WriteDirOptions = {
    recursive: boolean,
};

export type RemoveDirOptions = {
    recursive: boolean,
};

export type MoveOptions = {
    overwrite: boolean,
};

export type Metadata = {
    accessedAt: number,
    createdAt: number,
    kind: string,
    modifiedAt: number,
    permissions: {
        readOnly: boolean
    },
    size: number,
    symlink: boolean
};

local function pathParts(path: string): {string}
    local result = {};
    local index = 1;
    while (true) do
        local ps, pe = path:find("[/(\\\\)]", index);
        if (not ps or not pe) then
            break;
        end
        local part = path:sub(index, pe - 1);
        if (#result == 0 and part == "") then
            index = pe + 1;
            table.insert(result, "");
            continue;
        end
        index = pe + 1;
        if (#part == 0) then
            continue;
        end
        table.insert(result, part);
    end
    if (index < #path) then
        table.insert(result, path:sub(index));
    end
    return result;
end

function FileSystem.readFile(path: string, options: ReadFileOptions?): string | buffer
    if (Runtime:isLune()) then
        local result = FileSystem.__lune.fs.readFile(path);
        if (options and options.buffer) then 
            return buffer.fromstring(result);
        end
        return result;
    elseif (Runtime:isZune()) then
        local ok, result = FileSystem.__zune.fs.readFile(path, if (options) then options.buffer else false);
        assert(ok, result);
        return result;
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.readDir(path: string): {string}
    if (Runtime:isLune()) then
        local result = FileSystem.__lune.fs.readDir(path);
        return result;
    elseif (Runtime:isZune()) then
        local ok, result = FileSystem.__zune.fs.readDir(path);
        assert(ok, result);
        return result::{string};
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.writeFile(path: string, options: WriteFileOptions): ()
    if (Runtime:isLune()) then
        FileSystem.__lune.fs.writeFile(path, options.data);
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.writeFile(path, options.data));
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.writeDir(path: string, options: WriteDirOptions): ()
    if (Runtime:isLune()) then
        if (options.recursive) then
            local parts = pathParts(path);
            for i, _ in parts do
                FileSystem.__lune.fs.writeDir(table.concat(parts,  "/", 1, i));
            end
        else
            FileSystem.__lune.fs.writeDir(path);
        end
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.writeDir(path, options.recursive));
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.removeFile(path: string): ()
    if (Runtime:isLune()) then
        FileSystem.__lune.fs.removeFile(path);
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.removeFile(path));
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.removeDir(path: string, options: RemoveDirOptions?): ()
    if (Runtime:isLune()) then
        if (options and options.recursive) then
            local parts = pathParts(path);
            for i, _ in parts do
                FileSystem.__lune.fs.removeDir(table.concat(parts,  "/", 1, i));
            end
        else
            FileSystem.__lune.fs.removeDir(path);
        end
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.removeDir(path, if (options) then options.recursive else false));
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.isFile(path: string): boolean
    if (Runtime:isLune()) then
        return FileSystem.__lune.fs.isFile(path);
    elseif (Runtime:isZune()) then
        return FileSystem.__zune.fs.isFile(path);
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.isDir(path: string): boolean
    if (Runtime:isLune()) then
        return FileSystem.__lune.fs.isDir(path);
    elseif (Runtime:isZune()) then
        return FileSystem.__zune.fs.isDir(path);
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.move(from: string, to: string, options: MoveOptions?): ()
    if (Runtime:isLune()) then
        FileSystem.__lune.fs.move(from, to, {
            overwrite = if (options) then options.overwrite else false,
        });
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.move(from, to, if (options) then options.overwrite else false));
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.copy(from: string, to: string, options: MoveOptions?): ()
    if (Runtime:isLune()) then
        FileSystem.__lune.fs.copy(from, to, {
            overwrite = if (options) then options.overwrite else false,
        });
    elseif (Runtime:isZune()) then
        assert(FileSystem.__zune.fs.copy(from, to, if (options) then options.overwrite else false))
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

function FileSystem.metadata(path: string): Metadata
    if (Runtime:isLune()) then
        local metadata = FileSystem.__lune.fs.metadata(path);
        if (not metadata.kind) then
           return Layer.logError(LAYER_NAME, "failed to get metadata.");
        end
        return {
            accessedAt = metadata.accessedAt.unixTimestampMillis / 1000,
            createdAt = metadata.createdAt.unixTimestampMillis / 1000,
            kind = metadata.kind,
            modifiedAt = metadata.modifiedAt.unixTimestampMillis / 1000,
            permissions = {
                readOnly = metadata.permissions.readOnly,
            },
            size = -1,
            symlink = false,
        }
    elseif (Runtime:isZune()) then
        local ok, metadata = FileSystem.__zune.fs.metadata(path);
        assert(ok, metadata);
        assert(type(metadata) == "table"); -- type refinement
        return metadata::any;
    elseif (Runtime:isLuau() or Runtime:isRoblox()) then
        return Layer.logError(LAYER_NAME, "is not supported in Roblox or Luau.");
    else
        return Layer.logError(LAYER_NAME, "unsupported runtime.");
    end
end

if (Runtime:isZune()) then
    local testing = require("@zcore/testing");

    local test = testing.test;
    local expect = testing.expect;
    local describe = testing.describe;

    describe("FileSystem", function()
        describe("PathParter", function()
            test("Generic", function()
                local path = "C:/Users/username/Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"C:", "Users", "username", "Documents"}));
            end)

            test("Generic Backslash", function()
                local path = "C:\\Users\\username\\Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"C:", "Users", "username", "Documents"}));
            end)

            test("Generic Mixed", function()
                local path = "C:/Users\\username/Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"C:", "Users", "username", "Documents"}));
            end)

            test("Generic Lead", function()
                local path = "Users/username/Documents/";
                local result_lead = pathParts(path);
                expect(result_lead).toBe(expect.similar({"Users", "username", "Documents"}));
            end);

            test("Generic Lead Backslash", function()
                local path = "Users\\username\\Documents\\";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"Users", "username", "Documents"}));
            end);

            test("Generic Lead Mixed", function()
                local path = "Users/username\\Documents/";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"Users", "username", "Documents"}));
            end);

            test("Generic End", function()
                local path = "/Users/username/Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"", "Users", "username", "Documents"}));
            end);

            test("Generic End Backslash", function()
                local path = "\\Users\\username\\Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"", "Users", "username", "Documents"}));
            end);

            test("Generic End Mixed", function()
                local path = "/Users\\username/Documents";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"", "Users", "username", "Documents"}));
            end);

            test("Path Hole", function()
                local path = "/Users//Documents/";
                local result = pathParts(path);
                expect(result).toBe(expect.similar({"", "Users", "Documents"}));
            end);
        end);
    end);
end

return FileSystem;
