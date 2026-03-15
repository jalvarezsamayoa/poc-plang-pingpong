import json
import sys
import os
import re

def trace_to_mermaid(file_path):
    if not os.path.exists(file_path):
        print(f"Error: {file_path} not found.")
        return

    mermaid = ["sequenceDiagram"]

    # Handle JSON (Bug Trace)
    if file_path.endswith('.json'):
        with open(file_path, 'r') as f:
            trace = json.load(f)
        for entry in trace:
            etype = entry.get("type")
            details = entry.get("details", {})
            if etype == "CreateStateMachine":
                mid = details.get("id")
                creator = details.get("creatorName")
                if creator and mid:
                    mermaid.append(f"    {creator}->>+{mid}: create {mid}")
            elif etype == "StateTransition" and details.get("isEntry"):
                mermaid.append(f"    Note over {details['id']}: Enter {details['state']}")
            elif etype == "SendEvent":
                mermaid.append(f"    {details['sender']}->>{details['target']}: {details['event']}")

    # Handle Log (Successful Verbose Run)
    else:
        with open(file_path, 'r') as f:
            lines = f.readlines()
        
        for line in lines:
            # Creation: <CreateLog> Ponger(2) was created by Main(1).
            m = re.search(r"<CreateLog> (.*) was created by (.*)\.", line)
            if m:
                mid, creator = m.groups()
                # Clean up names like 'task '2''
                creator = creator.replace("task '2'", "Main(0)")
                mermaid.append(f"    {creator}->>+{mid}: create {mid}")
                continue

            # Event Send: <SendLog> 'Pinger(3)' in state 'PingState' sent event 'Ping with payload (Pinger(3))' to 'Ponger(2)'.
            m = re.search(r"<SendLog> '(.*)' .* sent event '(.*)' to '(.*)'\.", line)
            if m:
                sender, event, target = m.groups()
                # Clean up event name (remove payload info)
                event = event.split(" ")[0]
                mermaid.append(f"    {sender}->>{target}: {event}")
                continue

            # State Entry: <StateLog> Pinger(3) enters state 'Init'.
            m = re.search(r"<StateLog> (.*) enters state '(.*)'\.", line)
            if m:
                mid, state = m.groups()
                # Remove namespaces if any
                state = state.split(".")[-1]
                mermaid.append(f"    Note over {mid}: Enter {state}")
                continue

    return "\n".join(mermaid)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python trace_to_mermaid.py <trace.json|verbose.log>")
        sys.exit(1)
    
    print(trace_to_mermaid(sys.argv[1]))
