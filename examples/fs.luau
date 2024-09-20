local dipcl = require("@dipcl/dipcl");

local fs = dipcl "FileSystem";

print(fs.readFile("./examples/test.txt", {buffer = false}));

print(fs.metadata("./examples/test.txt"));

fs.writeDir("./out/sub/path", {recursive = true});