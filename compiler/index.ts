import * as fs from "fs";

import * as minimist from "minimist";
import * as chalk from "chalk";

import {emit} from "./src/ts/emit";
import {BuildOptions} from "./src/ts/buildOptions";
import {transpile} from "./src/ts/transpile";
import {squishAndCopy} from "./src/ts/squishAndCopy";
import {configHash} from "./src/ts/configHash";

const argv = minimist(process.argv.slice(2));

const entry = argv.t;
const modName = argv.m;
const outDir = argv.d;
const profile = argv.p;

if (!entry) 
{
    console.log("Entry file must be specified with -t switch");
    process.exit(1);
}
else 
{
    if (!fs.statSync(entry)) 
    {
        console.log("Entry file does not exist");
        process.exit(1);
    }
}

if (!modName) 
{
    console.log("Output module name must be specified with -m switch");
    process.exit(1);
}

if (!outDir) 
{
    console.log("Output directory must be specified with -d switch");
    process.exit(1);
}

if (!fs.existsSync(".hydroc")) 
{
    fs.mkdirSync(".hydroc");
}

function transpileTS(config: BuildOptions): void
{
    const hash = configHash(config);
    console.log(`Build ${chalk.yellow(hash)}`);
    const res = transpile(config);
    emit(config,res);
    squishAndCopy(config);
    console.log(`${chalk.green(config.entry)} ----> ${chalk.blue(`${config.outDir}/${config.modName}`)}`);
}

transpileTS({
    entry:entry,
    modName:modName,
    outDir:outDir,
    profile:profile
});