import tl = require('azure-pipelines-task-lib/task');

async function run() {
    try {
        const Icons: string | undefined = tl.getInput('Icons');
        
        var args = [__dirname + "\\MommaScript.ps1"];
        
        // we need to get the verbose flag passed in as script flag
        var verbose = (tl.getVariable("System.Debug") === "true");
        if (verbose) {
            args.push("-Verbose");
        }

        if (Icons) {
            // Icons variable is set. 
            args.push("-Icons");
            args.push(Icons);
        }

        // find the executeable
        let executable = "pwsh";

        console.log(`${executable} ${args.join(" ")}`);

        var spawn = require("child_process").spawn, child;
        child = spawn(executable, args);
        child.stdout.on("data", function (data: { toString: () => any; }) {
            console.log(data.toString());
        });
        child.stderr.on("data", function (data: { toString: () => string; }) {        
            tl.error(data.toString());
            tl.setResult(tl.TaskResult.Failed, data.toString());
        });
        child.on("exit", function () {
            console.log("Script finished");
        });
    }
    catch (err) {
        // @ts-ignore
        tl.setResult(tl.TaskResult.Failed, err.message);
    }
}

run();
