"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chalk = require("chalk");
var typescript_to_lua_1 = require("typescript-to-lua");
function transpile(config) {
    var _a, _b;
    var tstlOpt = { strict: true, luaTarget: typescript_to_lua_1.LuaTarget.Lua52, luaLibImport: typescript_to_lua_1.LuaLibImportKind.Inline };
    if (config.profile == "debug") {
        // tstlOpt.sourceMapTraceback = true;
    }
    var res = typescript_to_lua_1.transpileFiles([config.entry], tstlOpt);
    for (var i = 0; i != res.diagnostics.length; ++i) {
        console.log(((_a = res.diagnostics[i].file) === null || _a === void 0 ? void 0 : _a.fileName) + ":" + ((_b = res.diagnostics[i].file) === null || _b === void 0 ? void 0 : _b.identifierCount));
        var message = "";
        if (typeof res.diagnostics[i].messageText === "string") {
            message = res.diagnostics[i].messageText;
        }
        else {
            message = res.diagnostics[i].messageText.messageText;
        }
        console.log(chalk.red(message));
        process.exit(1);
    }
    console.log("    " + chalk.yellow("" + res.emitResult.length) + " inputs");
    return res;
}
exports.transpile = transpile;