#!/bin/bash

# Updates the xctestplan file with current PBX target identifiers from the generated project.
# Run this after `tuist generate` to keep the test plan in sync.

set -e

PBXPROJ="Listen-anonymously.xcodeproj/project.pbxproj"
TESTPLAN="config/Listen anonymously Test Plan.xctestplan"

if [ ! -f "$PBXPROJ" ]; then
    echo "Error: $PBXPROJ not found. Run tuist generate first."
    exit 1
fi

if [ ! -f "$TESTPLAN" ]; then
    echo "Error: $TESTPLAN not found."
    exit 1
fi

python3 -c "
import json, re

# Parse PBX target identifiers from project.pbxproj
with open('$PBXPROJ', 'r') as f:
    content = f.read()

# Match: <ID> /* <TargetName> */ = { isa = PBXNativeTarget;
pattern = r'(\w+)\s*/\*\s*(.+?)\s*\*/\s*=\s*\{[^}]*isa\s*=\s*PBXNativeTarget;'
targets = {}
for match in re.finditer(pattern, content):
    identifier = match.group(1)
    name = match.group(2)
    targets[name] = identifier

# Update test plan
with open('$TESTPLAN', 'r') as f:
    data = json.load(f)

def update_identifiers(obj):
    if isinstance(obj, dict):
        if 'name' in obj and 'containerPath' in obj:
            name = obj['name']
            if name in targets:
                obj['identifier'] = targets[name]
        for v in obj.values():
            update_identifiers(v)
    elif isinstance(obj, list):
        for item in obj:
            update_identifiers(item)

update_identifiers(data)

with open('$TESTPLAN', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')

print('Updated test plan identifiers successfully.')
for name, ident in sorted(targets.items()):
    print(f'  {name}: {ident}')
"
