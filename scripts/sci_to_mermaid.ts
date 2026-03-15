import * as fs from 'fs';

function sciToMermaid(sciPath: string): string | undefined {
    if (!fs.existsSync(sciPath)) {
        console.error(`Error: ${sciPath} not found.`);
        return undefined;
    }

    const xmlData = fs.readFileSync(sciPath, 'utf-8');
    
    // 1. Isolate the InternalAllocatedLinkIds section
    const linkIdsMatch = xmlData.match(/<InternalAllocatedLinkIds[^>]*>(.*?)<\/InternalAllocatedLinkIds>/);
    if (!linkIdsMatch) {
        console.error("Error: Could not find InternalAllocatedLinkIds section.");
        return undefined;
    }
    const linkIdsSection = linkIdsMatch[1];

    // 2. Extract Key/Value pairs from this section only
    const links: [string, string][] = [];
    const entryRegex = /<a:KeyValueOfstringstring>.*?<a:Key[^>]*>(.*?)<\/a:Key>.*?<a:Value[^>]*>(.*?)<\/a:Value>.*?<\/a:KeyValueOfstringstring>/g;

    let match;
    while ((match = entryRegex.exec(linkIdsSection)) !== null) {
        let key = match[1];
        let val = match[2];
        
        // Decode XML entities
        key = key.replace(/&gt;/g, '>').replace(/&lt;/g, '<').replace(/&amp;/g, '&');
        val = val.replace(/&gt;/g, '>').replace(/&lt;/g, '<').replace(/&amp;/g, '&');
        
        links.push([key, val]);
    }

    if (links.length === 0) {
        console.error("Error: No transitions found in the SCI file.");
        return "stateDiagram-v2\n    Note over Error: No transitions found";
    }

    const machines: Record<string, string[]> = {};
    const mermaid: string[] = ["stateDiagram-v2"];

    for (const [key, val] of links) {
        // Format: PImplementation.Machine.SourceState->PImplementation.Machine.TargetState(id)
        if (key.includes("->")) {
            const parts = key.split("->");
            const sourceFull = parts[0];
            const targetFull = parts[1].split("(")[0];
            
            const sourceParts = sourceFull.split(".");
            const targetParts = targetFull.split(".");
            
            if (sourceParts.length >= 3 && targetParts.length >= 3) {
                const machineName = sourceParts[1];
                const sourceState = sourceParts[2];
                const targetState = targetParts[2];
                
                // Only include if it's a "normal" transition (ignoring internal IDs)
                if (val !== "0" && val !== "1") {
                    if (!machines[machineName]) {
                        machines[machineName] = [];
                    }
                    machines[machineName].push(`        ${sourceState} --> ${targetState}: ${val}`);
                }
            }
        }
    }

    for (const machine in machines) {
        mermaid.push(`    state ${machine} {`);
        const uniqueTransitions = Array.from(new Set(machines[machine])).sort();
        mermaid.push(...uniqueTransitions);
        mermaid.push("    }");
    }

    return mermaid.join("\n");
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log("Usage: ts-node sci_to_mermaid.ts <file.sci>");
    process.exit(1);
}

const result = sciToMermaid(args[0]);
if (result) {
    console.log(result);
}
