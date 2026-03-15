import * as fs from 'fs';
import * as path from 'path';

function traceToMermaid(filePath: string): string | undefined {
    if (!fs.existsSync(filePath)) {
        console.error(`Error: ${filePath} not found.`);
        return undefined;
    }

    const mermaid: string[] = ["sequenceDiagram"];

    if (filePath.endsWith('.json')) {
        const content = fs.readFileSync(filePath, 'utf-8');
        const trace = JSON.parse(content);
        for (const entry of trace) {
            const etype = entry.type;
            const details = entry.details || {};
            if (etype === "CreateStateMachine") {
                const mid = details.id;
                const creator = details.creatorName;
                if (creator && mid) {
                    mermaid.push(`    ${creator}->>+${mid}: create ${mid}`);
                }
            } else if (etype === "StateTransition" && details.isEntry) {
                mermaid.push(`    Note over ${details.id}: Enter ${details.state}`);
            } else if (etype === "SendEvent") {
                mermaid.push(`    ${details.sender}->>${details.target}: ${details.event}`);
            }
        }
    } else {
        const lines = fs.readFileSync(filePath, 'utf-8').split(/\r?\n/);
        for (const line of lines) {
            // Creation: <CreateLog> Ponger(2) was created by Main(1).
            let m = line.match(/<CreateLog> (.*) was created by (.*)\./);
            if (m) {
                const mid = m[1];
                let creator = m[2];
                creator = creator.replace("task '2'", "Main(0)");
                mermaid.push(`    ${creator}->>+${mid}: create ${mid}`);
                continue;
            }

            // Event Send: <SendLog> 'Pinger(3)' in state 'PingState' sent event 'Ping with payload (Pinger(3))' to 'Ponger(2)'.
            m = line.match(/<SendLog> '(.*)' .* sent event '(.*)' to '(.*)'\./);
            if (m) {
                const sender = m[1];
                let event = m[2];
                const target = m[3];
                event = event.split(" ")[0];
                mermaid.push(`    ${sender}->>${target}: ${event}`);
                continue;
            }

            // State Entry: <StateLog> Pinger(3) enters state 'Init'.
            m = line.match(/<StateLog> (.*) enters state '(.*)'\./);
            if (m) {
                const mid = m[1];
                let state = m[2];
                state = state.split(".").pop() || state;
                mermaid.push(`    Note over ${mid}: Enter ${state}`);
                continue;
            }
        }
    }

    return mermaid.join("\n");
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log("Usage: ts-node trace_to_mermaid.ts <trace.json|verbose.log>");
    process.exit(1);
}

const result = traceToMermaid(args[0]);
if (result) {
    console.log(result);
}
