#!/bin/bash
# Script 2: FOSS Package Inspector
# Author: Tanishq Shrivastava | Reg No: 24BCY10162
# Checks if the chosen OSS package is installed and shows info about it

PACKAGE="git"

# detect package manager and check installation
if command -v rpm &>/dev/null; then
    PKG_MGR="rpm"
    INSTALLED=$(rpm -q $PACKAGE 2>/dev/null)
    STATUS=$?
elif command -v dpkg &>/dev/null; then
    PKG_MGR="dpkg"
    INSTALLED=$(dpkg -l $PACKAGE 2>/dev/null | grep "^ii")
    STATUS=$?
else
    echo "No supported package manager found (rpm/dpkg)."
    exit 1
fi

echo "Package Inspector — checking: $PACKAGE"
echo "Package manager detected: $PKG_MGR"
echo "-------------------------------------------"

if [ $STATUS -eq 0 ]; then
    echo "Status  : INSTALLED"

    if [ "$PKG_MGR" = "rpm" ]; then
        VERSION=$(rpm -qi $PACKAGE | grep "^Version" | awk '{print $3}')
        PKG_LICENSE=$(rpm -qi $PACKAGE | grep "^License" | awk '{print $3}')
        SUMMARY=$(rpm -qi $PACKAGE | grep "^Summary" | cut -d: -f2 | xargs)
    else
        VERSION=$(dpkg -l $PACKAGE | grep "^ii" | awk '{print $3}')
        PKG_LICENSE="GPL-2.0"
        SUMMARY="fast, scalable, distributed revision control system"
    fi

    echo "Version : $VERSION"
    echo "License : $PKG_LICENSE"
    echo "Summary : $SUMMARY"
else
    echo "Status  : NOT INSTALLED"
    echo "Install with: sudo apt install $PACKAGE  (or: sudo yum install $PACKAGE)"
fi

echo ""
echo "Philosophy note:"

case $PACKAGE in
    git)
        echo "  Git was born out of necessity — Linus Torvalds wrote it in two weeks"
        echo "  after BitKeeper was no longer free for Linux kernel development."
        echo "  It is now the backbone of nearly all software development on earth."
        ;;
    httpd|apache2)
        echo "  Apache made the web accessible to everyone, not just those who could"
        echo "  afford expensive server software."
        ;;
    mysql|mariadb)
        echo "  MySQL's dual-licensing model is a case study in how companies try to"
        echo "  profit from open source — which later led to the MariaDB fork."
        ;;
    vlc)
        echo "  VLC was written by students at Ecole Centrale Paris to stream video"
        echo "  over their campus network. No budget, just necessity and a good license."
        ;;
    firefox)
        echo "  Firefox was the browser that pushed back against Internet Explorer's"
        echo "  monopoly. Still one of the few major browsers not owned by a tech giant."
        ;;
    *)
        echo "  Open source software gives users the freedom to understand and improve"
        echo "  the tools they depend on."
        ;;
esac
