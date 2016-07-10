#!/usr/bin/env bash

echo ""
echo "Downloading XXAlignOnSave..."

# Prepare
mkdir -p /var/tmp/XXAlignOnSave.tmp && cd /var/tmp/XXAlignOnSave.tmp

echo ""
# Clone from git
git clone https://github.com/yangjunsss/XXAlignOnSave.git --depth 1 /var/tmp/XXAlignOnSave.tmp > /dev/null

echo ""
echo "Installing XXAlignOnSave..."

# Then build
xcodebuild clean > /dev/null
xcodebuild > /dev/null

# Remove tmp files
cd ~
rm -rf /var/tmp/XXAlignOnSave.tmp

# Done
echo ""
echo "XXAlignOnSave successfully installed! 🍻 Please restart your Xcode."
echo ""