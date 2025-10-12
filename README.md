# ClipExpand
A lightweight, clipboard-based text expansion tool for Linux systems. Designed with Remote Desktop sessions in mind, ClipExpand copies your text snippets to the clipboard for easy pasting, making it perfect for both local and remote workflows.

<img src="./.readme/clip-expand.jpg" height="250">

## Features

- 📋 **Clipboard-based**: Works seamlessly in Remote Desktop sessions
- ⌨️ **Keyboard-driven**: Quick access via customizable keyboard shortcut
- 📁 **File-based snippets**: Simple text files in `~/.clipexpand/` directory
- 🔍 **Easy selection**: Visual dialog for snippet selection
- 📢 **Toast notifications**: Non-intrusive confirmation messages
- 🗂️ **Subdirectory support**: Organize snippets in folders
- 🚀 **Lightweight**: Minimal dependencies, fast execution

## Compatible Systems

- **Ubuntu** 20.04+ (tested on 24.04)
- **Linux Mint**
- **Debian** 10+
- **Pop!_OS**
- **Elementary OS**
- Other Debian-based distributions with GNOME or similar desktop environments

Works with:
- ✅ Local sessions (X11/Wayland)
- ✅ Remote Desktop (RDP, VNC, etc.)
- ✅ SSH with X forwarding

## Requirements

- `bash`
- `zenity` - for the selection dialog
- `xsel` - for clipboard management
- `notify-send` (libnotify-bin) - for notifications
- `find`, `sed`, `tr` - standard Unix utilities (usually pre-installed)

## Installation

### Quick Install

Run the install script to automatically set everything up:

```bash
./install.sh
```

The script will:
1. Install required dependencies
2. Copy the script to `~/bin/clipexpand.sh`
3. Create the `~/.clipexpand/` directory
4. Install example snippets
5. Configure the keyboard shortcut (Ctrl+Shift+T)

### Manual Installation

1. **Install dependencies:**

   ```bash
   sudo apt install xsel zenity libnotify-bin
   ```

2. **Copy the script:**

   ```bash
   mkdir -p ~/bin
   cp clipexpand.sh ~/bin/
   chmod +x ~/bin/clipexpand.sh
   ```

3. **Create snippets directory:**

   ```bash
   mkdir -p ~/.clipexpand
   ```

4. **Copy example snippets (optional):**

   ```bash
   cp examples/* ~/.clipexpand/
   ```

5. **Set up keyboard shortcut:**

   **For GNOME/Ubuntu:**

   ```bash
   # Add custom keybinding entry
   gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
     "$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | \
     sed "s/]$/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/clipexpand\/']/")"

   # Configure the keybinding
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ \
     name 'ClipExpand'
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ \
     command "$HOME/bin/clipexpand.sh"
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ \
     binding '<Ctrl><Shift>t'
   ```

   **For other desktop environments:**

   Use your desktop environment's keyboard settings to create a custom shortcut:
   - **Command:** `~/bin/clipexpand.sh`
   - **Shortcut:** Ctrl+Shift+T (or your preference)

## Usage

1. **Trigger ClipExpand:**
   - Press your configured keyboard shortcut (default: **Ctrl+Shift+T**)

2. **Select a snippet:**
   - Press **Tab** to focus the snippet list
   - Use **arrow keys** to navigate
   - Press **Enter** to select

3. **Paste:**
   - The snippet is copied to your clipboard
   - You'll see a brief notification: "Text copied to clipboard!"
   - Press **Ctrl+V** to paste the text

## Creating Snippets

Snippets are simple text files stored in `~/.clipexpand/`. The filename becomes the snippet name.

### Basic Snippet

Create a file with your text content:

```bash
echo "your.email@example.com" > ~/.clipexpand/email
```

### Multi-line Snippet

Use a text editor for multi-line snippets:

```bash
nano ~/.clipexpand/signature
```

Content:
```
Best regards,
John Doe
Software Engineer
john.doe@example.com
```

### Organizing with Subdirectories

Keep snippets organized in folders:

```bash
mkdir -p ~/.clipexpand/work
mkdir -p ~/.clipexpand/personal

echo "work@company.com" > ~/.clipexpand/work/email
echo "personal@email.com" > ~/.clipexpand/personal/email
```

Snippets will appear as:
- `work/email`
- `personal/email`

## Examples

The `examples/` directory contains sample snippets:

- `email` - Email address template
- `phone` - Phone number template
- `signature` - Email signature
- `meeting-link` - Meeting room URL

Copy them to your snippets directory:

```bash
cp examples/* ~/.clipexpand/
```

Then customize them with your information!

## Why Clipboard-Based?

ClipExpand uses a clipboard-based approach instead of direct keyboard injection. This design choice provides several advantages:

- ✅ **Remote Desktop compatible**: Works perfectly with RDP, VNC, and other remote desktop protocols
- ✅ **Wayland compatible**: No issues with Wayland's security restrictions
- ✅ **Universal**: Works in any application that supports clipboard pasting
- ✅ **Reliable**: No timing issues or focus problems
- ✅ **Simple**: Fewer dependencies and easier to maintain

The trade-off is one extra step (Ctrl+V to paste), but this makes the tool far more versatile and reliable across different environments.

## Troubleshooting

### Keyboard shortcut doesn't work

- Check if the shortcut conflicts with another application
- Try a different key combination
- Verify the script is executable: `chmod +x ~/bin/clipexpand.sh`

### Dialog doesn't appear

- Ensure zenity is installed: `sudo apt install zenity`
- Check if the script is in your PATH or use full path in keyboard shortcut

### Nothing copied to clipboard

- Verify xsel is installed: `sudo apt install xsel`
- Test manually: `echo "test" | xsel -b -i && xsel -b -o`

### Snippets not showing

- Check that `~/.clipexpand/` directory exists
- Ensure snippet files are readable: `ls -la ~/.clipexpand/`
- Verify files are regular text files, not hidden or special files

## Uninstallation

To remove ClipExpand:

```bash
# Remove the script
rm ~/bin/clipexpand.sh

# Remove snippets (backup first if needed!)
rm -rf ~/.clipexpand

# Remove keyboard shortcut (GNOME)
gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ name
gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ command
gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipexpand/ binding
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Credits

Inspired by [Texpander](https://github.com/leehblue/texpander) by Lee Blue, reimagined for clipboard-based workflow and Remote Desktop compatibility.

---

**Enjoy ClipExpand!** 🚀
