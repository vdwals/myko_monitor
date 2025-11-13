# Development Container for Myko Monitor

This devcontainer provides a fully configured development environment for ESPHome-based firmware development.

## What's Included

### Tools & Runtimes
- **Python 3.12** - Core runtime for ESPHome
- **ESPHome** - IoT firmware framework (installed automatically)
- **Node.js LTS** - For Claude Code and other tools
- **Git** - Version control
- **Zsh with Oh My Zsh** - Enhanced shell experience

### VS Code Extensions

#### ESPHome Development
- **ESPHome.esphome-vscode** - Official ESPHome extension with syntax highlighting and validation
- **redhat.vscode-yaml** - Advanced YAML language support with schema validation

#### Python Development
- **ms-python.python** - Python language support
- **ms-python.vscode-pylance** - Fast Python language server

#### General Productivity
- **esbenp.prettier-vscode** - Code formatter
- **editorconfig.editorconfig** - Consistent coding styles
- **eamodio.gitlens** - Enhanced Git integration

#### Documentation
- **yzhang.markdown-all-in-one** - Markdown editing support
- **davidanson.vscode-markdownlint** - Markdown linting

### Pre-configured Settings

- **YAML schema validation** for ESPHome configurations
- **Custom YAML tags** support (!secret, !include, !lambda, etc.)
- **Auto-formatting** on save for YAML files
- **2-space indentation** for YAML
- **Port forwarding** for ESPHome dashboard (6052)

## Getting Started

### First Time Setup

1. **Open in devcontainer:**
   - VS Code will prompt you to reopen in container
   - Or use Command Palette: `Dev Containers: Reopen in Container`

2. **Wait for setup:**
   - Container will build and install all dependencies
   - ESPHome and Claude Code will be installed automatically
   - Takes 2-5 minutes on first run

3. **Verify installation:**
   ```bash
   esphome version
   python --version
   node --version
   ```

### Daily Workflow

```bash
# Validate configuration
esphome config base.yml

# Compile firmware
esphome compile myko-monitor-device.yaml

# View logs (if device is connected)
esphome logs myko-monitor-device.yaml

# Run ESPHome dashboard (optional)
esphome dashboard .
# Access at http://localhost:6052
```

## Features

### ESPHome Schema Validation

YAML files are automatically validated against the ESPHome schema. You'll see:
- ✅ Autocomplete for ESPHome components
- ⚠️ Warnings for invalid configurations
- 💡 Inline documentation for properties

### Custom YAML Tags

The following ESPHome-specific YAML tags are recognized:
- `!secret` - Reference secrets.yaml values
- `!include` - Include external YAML files
- `!lambda` - Inline C++ code
- `!extend` - Extend existing configurations
- `!remove` - Remove items from lists

### Auto-formatting

YAML files are automatically formatted on save:
- 2-space indentation
- Consistent spacing
- Sorted keys (where appropriate)

### Port Forwarding

The ESPHome dashboard (port 6052) is automatically forwarded when running:
```bash
esphome dashboard .
```

Access it in your browser at `http://localhost:6052`

## Troubleshooting

### ESPHome not found
```bash
# Reinstall ESPHome
pip3 install --upgrade esphome
```

### Extensions not loading
1. Reload VS Code: Command Palette → `Developer: Reload Window`
2. Check extension is installed: Extensions sidebar
3. Rebuild container: Command Palette → `Dev Containers: Rebuild Container`

### Python environment issues
```bash
# Check Python version
python --version  # Should be 3.12.x

# Check pip packages
pip3 list | grep esphome
```

### USB device access (for flashing)

USB devices are not automatically available in devcontainers. For initial flashing:

**Option 1: Flash outside container**
```bash
# Exit devcontainer and run on host
exit
esphome upload device.yaml
```

**Option 2: Use OTA updates**
- After initial USB flash, use OTA:
```bash
esphome upload device.yaml --device 192.168.1.210
```

## Customization

### Adding Python Packages

Edit `.devcontainer/devcontainer.json`:
```json
"postCreateCommand": "pip3 install esphome custom-package && npm install -g @anthropic-ai/claude-code"
```

### Adding VS Code Extensions

Edit `.devcontainer/devcontainer.json`:
```json
"extensions": [
  "ESPHome.esphome-vscode",
  "your-extension-id-here"
]
```

### Changing Python Version

Edit `.devcontainer/devcontainer.json`:
```json
"image": "mcr.microsoft.com/devcontainers/python:1-3.11-bookworm"
```

## Additional Resources

- [ESPHome Documentation](https://esphome.io/)
- [Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Python in VS Code](https://code.visualstudio.com/docs/languages/python)
