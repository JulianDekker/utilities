#!/bin/bash

eval "$(ssh-agent -s)" > /dev/null
ssh-add ~/.ssh/id_rsa 2>/dev/null

PUSH_TARGET=${1:-"."}

cd /home/jjdekker1/utilities/storage_monitor/logs/ || exit 1

# Stage and commit a specific file
git add $PUSH_TARGET

# Use a timestamp in the commit message
git commit -m "Automatic update: $(date '+%d %B %Y')" || exit 0

# Push the change
git push origin main
