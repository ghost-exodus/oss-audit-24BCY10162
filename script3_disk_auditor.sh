#!/bin/bash
# Script 3: Disk and Permission Auditor
# Author: Tanishq Shrivastava | Reg No: 24BCY10162
# Loops through key system directories, reports permissions and size

DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share/doc/git")

echo "Directory Audit Report"
echo "=================================="
printf "%-30s %-20s %-10s\n" "Path" "Permissions (type/owner/grp)" "Size"
echo "------------------------------------------------------------------"

for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)
        printf "%-30s %-20s %-10s\n" "$DIR" "$PERMS" "$SIZE"
    else
        printf "%-30s %s\n" "$DIR" "[does not exist on this system]"
    fi
done

echo ""
echo "Git config directory check:"
echo "----------------------------------"

GIT_CONFIG_DIRS=("/etc/gitconfig" "$HOME/.gitconfig" "$HOME/.git")

for GPATH in "${GIT_CONFIG_DIRS[@]}"; do
    if [ -f "$GPATH" ] || [ -d "$GPATH" ]; then
        PERMS=$(ls -ld "$GPATH" | awk '{print $1, $3, $4}')
        echo "  Found : $GPATH"
        echo "  Perms : $PERMS"
    else
        echo "  Not found : $GPATH"
    fi
done

echo ""
echo "Note: /etc/gitconfig is the system-wide git config (root-owned)."
echo "      ~/.gitconfig is per-user. Understanding this separation matters"
echo "      for multi-user systems where you don't want global config leaks."
