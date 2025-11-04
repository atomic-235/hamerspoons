# Hammerspoon Scripts

Clean and efficient Hammerspoon configuration for macOS window management.

## Features

### Window Search
- **Hotkey**: `Ctrl+Cmd+W`
- Lists all open application windows
- Real-time filtering by application name or window title
- One-click window focusing
- Clean, simple interface

**Usage:**
1. Press `Ctrl+Cmd+W` to open the window search
2. Type to filter windows (searches app names and titles)
3. Select a window to focus it

## Installation

1. Clone this repository to your Hammerspoon config directory:
```bash
git clone git@github.com:atomic-235/hamerspoons.git ~/.hammerspoon
```

2. Grant Accessibility permissions to Hammerspoon:
   - Open **System Settings > Privacy & Security > Accessibility**
   - Toggle **Hammerspoon** ON
   - Restart Hammerspoon

3. Reload Hammerspoon configuration (or restart Hammerspoon)

## Requirements

- macOS with Hammerspoon installed
- Accessibility permissions granted to Hammerspoon

## Configuration

The main configuration is in `init.lua`. Feel free to modify the hotkey bindings or add additional scripts.

## Contributing

Feel free to submit issues or pull requests for improvements and additional Hammerspoon scripts.

## License

MIT License - feel free to use and modify as needed.