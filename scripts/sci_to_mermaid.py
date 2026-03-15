import sys
import os
import xml.etree.ElementTree as ET

def sci_to_mermaid(sci_path):
    if not os.path.exists(sci_path):
        print(f"Error: {sci_path} not found.")
        return

    try:
        tree = ET.parse(sci_path)
        root = tree.getroot()
    except Exception as e:
        print(f"Error parsing XML: {e}")
        return

    # Use a namespace-agnostic search for KeyValueOfstringstring
    links = []
    for elem in root.iter():
        if 'KeyValueOfstringstring' in elem.tag:
            key_elem = None
            val_elem = None
            for child in elem:
                if 'Key' in child.tag:
                    key_elem = child
                if 'Value' in child.tag:
                    val_elem = child
            
            if key_elem is not None and key_elem.text and val_elem is not None and val_elem.text:
                links.append((key_elem.text, val_elem.text))
    
    if not links:
        print("Error: No transitions found in the SCI file.")
        return "stateDiagram-v2\n    Note over Error: No transitions found"

    machines = {}
    mermaid = ["stateDiagram-v2"]

    for key, val in links:
        # Format: PImplementation.Machine.SourceState->PImplementation.Machine.TargetState(id)
        if "->" in key:
            parts = key.split("->")
            source_full = parts[0]
            target_full = parts[1].split("(")[0]
            
            source_parts = source_full.split(".")
            target_parts = target_full.split(".")
            
            # Expected format: PImplementation.MachineName.StateName
            if len(source_parts) >= 3 and len(target_parts) >= 3:
                machine_name = source_parts[1]
                source_state = source_parts[2]
                target_state = target_parts[2]
                
                # Check if target belongs to the same machine
                if machine_name not in machines:
                    machines[machine_name] = []
                
                machines[machine_name].append(f"        {source_state} --> {target_state}: {val}")

    for machine, transitions in machines.items():
        mermaid.append(f"    state {machine} {{")
        mermaid.extend(list(sorted(set(transitions))))
        mermaid.append("    }")

    return "\n".join(mermaid)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python sci_to_mermaid.py <file.sci>")
        sys.exit(1)
    
    print(sci_to_mermaid(sys.argv[1]))
