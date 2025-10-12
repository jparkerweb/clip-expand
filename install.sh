#!/bin/bash

# ClipExpand Installer
# Automates the installation and setup of ClipExpand

set -e

echo "╔════════════════════════════════════════════════╗"
echo "║       ClipExpand Installer                     ║"
echo "║  Clipboard-based Text Expansion for Linux      ║"
echo "╚════════════════════════════════════════════════╝"
echo

# Check if running on supported system
if ! command -v apt &> /dev/null; then
    echo "❌ Error: This installer requires apt (Debian/Ubuntu-based system)"
    echo "Please install dependencies manually and follow the manual installation instructions."
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install dependencies
echo "📦 Installing dependencies..."
echo

MISSING_DEPS=()

if ! command_exists xsel; then
    MISSING_DEPS+=("xsel")
fi

if ! command_exists zenity; then
    MISSING_DEPS+=("zenity")
fi

if ! command_exists notify-send; then
    MISSING_DEPS+=("libnotify-bin")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "Installing: ${MISSING_DEPS[*]}"
    sudo apt update
    sudo apt install -y "${MISSING_DEPS[@]}"
    echo "✅ Dependencies installed"
else
    echo "✅ All dependencies already installed"
fi

echo

# Create bin directory if it doesn't exist
echo "📁 Setting up directories..."
mkdir -p ~/bin
mkdir -p ~/.clipexpand

# Copy script
echo "📝 Installing ClipExpand script..."
cp clipexpand.sh ~/bin/
chmod +x ~/bin/clipexpand.sh
echo "✅ Script installed to ~/bin/clipexpand.sh"
echo

# Copy example snippets
echo "📄 Installing example snippets..."
if [ -d "examples" ] && [ "$(ls -A examples)" ]; then
    cp examples/* ~/.clipexpand/ 2>/dev/null || true
    echo "✅ Example snippets copied to ~/.clipexpand/"
    echo "   (You can customize or remove these later)"
else
    echo "⚠️  No example snippets found, skipping..."
fi
echo

# Setup keyboard shortcut for GNOME
if command_exists gsettings && [ "$XDG_CURRENT_DESKTOP" != "" ]; then
    echo "⌨️  Configuring keyboard shortcut (Ctrl+Shift+T)..."

    # Get current custom keybindings
    CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

    # Check if clipexpand binding already exists
    if echo "$CURRENT_BINDINGS" | grep -q "clipexpand"; then
        echo "⚠️  ClipExpand keyboard shortcut already configured"
    else
        # Add new binding path
        NEW_BINDINGS=$(echo "$CURRENT_BINDINGS" | sed "s/]$/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/clipexpand\/']/" | sed "s/@as //" | sed "s/\[/[/")

        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_BINDINGS"

        # Configure the binding
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ name 'ClipExpand'
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ command "$HOME/bin/clipexpand.sh"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ binding '<Ctrl><Shift>t'

        echo "✅ Keyboard shortcut configured: Ctrl+Shift+T"
    fi
else
    echo "⚠️  Could not auto-configure keyboard shortcut"
    echo "   Please set up manually in your desktop environment settings:"
    echo "   Command: $HOME/bin/clipexpand.sh"
    echo "   Suggested shortcut: Ctrl+Shift+T"
fi

echo
echo "╔════════════════════════════════════════════════╗"
echo "║  ✅ Installation Complete!                     ║"
echo "╚════════════════════════════════════════════════╝"
echo
echo "🚀 Quick Start:"
echo "   1. Press Ctrl+Shift+T to open ClipExpand"
echo "   2. Select a snippet from the list"
echo "   3. Press Ctrl+V to paste"
echo
echo "📝 Create your own snippets:"
echo "   echo 'your text' > ~/.clipexpand/mysnippet"
echo
echo "📖 For more information, see the README.md"
echo
echo "Enjoy ClipExpand! 🎉"
