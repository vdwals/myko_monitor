#!/bin/bash
# Quick start script for ESPHome development

echo "🚀 Myko Monitor ESPHome Development Environment"
echo ""

# Check installations
echo "📦 Checking installations..."
echo "  Python: $(python --version 2>&1)"
echo "  ESPHome: $(esphome version 2>&1)"
echo "  Node.js: $(node --version 2>&1)"
echo "  Git: $(git --version 2>&1)"
echo ""

# Show available commands
echo "🛠️  Available commands:"
echo "  esphome config <file.yaml>     - Validate configuration"
echo "  esphome compile <file.yaml>    - Compile firmware"
echo "  esphome upload <file.yaml>     - Upload to device"
echo "  esphome logs <file.yaml>       - View device logs"
echo "  esphome dashboard .            - Start web dashboard (port 6052)"
echo ""

# Check for secrets.yaml
if [ ! -f "secrets.yaml" ]; then
  echo "⚠️  Warning: secrets.yaml not found"
  echo "   Create it from secrets.yaml.example:"
  echo "   cp secrets.yaml.example secrets.yaml"
  echo ""
fi

# List example configs
echo "📝 Example configurations:"
ls -1 examples/*.yaml 2>/dev/null | sed 's/^/   /'
echo ""

echo "✨ Ready to develop! See .devcontainer/README.md for more info."
