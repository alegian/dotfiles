#!/bin/bash

crontab - <<'EOF'
0 */4 * * * /usr/bin/bootc upgrade
EOF
