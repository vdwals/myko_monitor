# Myko Monitor - Environmental Monitoring System

An ESPHome-based IoT solution for monitoring CO₂ levels, temperature, and humidity in mushroom cultivation environments. This project provides firmware configurations for ESP8266 microcontrollers with modular, reusable components optimized for battery operation.

## ⚡ Quick Start (TL;DR)

```bash
# 1. Copy base template and create secrets
cp examples/myko-monitor-ii.esp8266.yml .
cp secrets.yaml.example secrets.yaml

# 2. Edit secrets.yaml with your WiFi/MQTT credentials

# 3. Create device-specific config
cat > myko-monitor-greenhouse.yaml << 'EOF'
substitutions:
  device_name_suffix: "greenhouse"
  standard_ip: 192.168.1.210
packages:
  device_base: !include myko-monitor-ii.esp8266.yml
EOF

# 4. Flash to device
esphome compile myko-monitor-greenhouse.yaml
esphome upload myko-monitor-greenhouse.yaml

# 5. Add to Home Assistant and import automations from home_assistant_automations.yaml
```

**Need deep sleep disabled?** Set `sleep_time: "0"` in your device config or use `examples/myko-monitor-ii-no-sleep.yaml`.

## 🐳 Development Container

This project includes a fully configured VS Code devcontainer with ESPHome and all required tools pre-installed:

```bash
# Open in VS Code
code .

# Reopen in container (Cmd/Ctrl+Shift+P)
Dev Containers: Reopen in Container

# After container starts
./devcontainer/quick-start.sh
```

**What's included:**
- Python 3.12 + ESPHome
- Official ESPHome VS Code extension
- YAML validation and autocomplete
- Claude Code CLI
- All development tools pre-configured

See [.devcontainer/README.md](.devcontainer/README.md) for details.

## 🌟 Features

### Core Functionality
- **CO₂ Monitoring**: MH-Z16/MH-Z19 sensor integration with manual calibration
- **Climate Monitoring**: SHT35 temperature and humidity sensing
- **Optional Deep Sleep**: Enable/disable with a single parameter (`sleep_time: "0"`)
- **Home Assistant Sleep Coordination**: Ensures data delivery before sleep
- **Remote Control**: MQTT-based commands for calibration and sleep control

### Connectivity & Updates
- **Home Assistant Integration**: Native ESPHome API with encryption
- **MQTT Messaging**: Reliable data transmission and command handling
- **OTA Updates**: Over-the-air firmware updates (even with sleep mode)
- **WiFi Optimization**: Adjustable TX power for battery life
- **Static IP**: Consistent network addressing

### Power Management
- **Two Operating Modes**: Battery-optimized vs. full monitoring
- **Flexible Sleep Duration**: 5-60 minutes or disabled entirely
- **Emergency Sleep**: Automatic sleep on low battery
- **Power-Aware Logging**: Reduces power consumption

### Developer Experience
- **Modular Architecture**: Organized `modules/` directory structure
- **Remote Packages**: Pull configuration from GitHub automatically
- **Example Configurations**: Ready-to-use templates for quick deployment
- **Multiple Device Support**: Easy scaling with minimal configuration
- **Comprehensive Documentation**: Detailed guides for setup and development

## 🏗️ Architecture

The project uses a modular ESPHome configuration architecture with organized directories:

```
myko_monitor/
├── base.yml                          # Main template with package imports
├── modules/                          # Reusable configuration modules
│   ├── mh-z16.yml                   # CO₂ sensor configuration
│   ├── sht35.yml                    # Temperature/humidity sensor
│   ├── wifi.yml                     # WiFi connectivity
│   ├── mqtt.yml                     # MQTT messaging
│   ├── deep_sleep_optional.yml      # Power management (optional)
│   ├── status_led.yml               # Status indicators
│   ├── logger.yml                   # Logging configuration
│   ├── battery_monitoring.yml       # Full battery diagnostics
│   ├── battery_optimized_monitoring.yml  # Low-power monitoring
│   ├── sleep_coordinator.yml        # Home Assistant sleep sync
│   ├── telemetry.yml                # System telemetry
│   ├── sensor_diagnostics.yml       # Advanced sensor health
│   └── error_handling.yml           # Error recovery
└── examples/                         # Example configurations
    ├── myko-monitor-ii.esp8266.yml  # Remote package base template
    ├── myko-monitor-ii1.yaml        # Device-specific example #1
    ├── myko-monitor-ii2.yaml        # Device-specific example #2
    ├── myko-monitor-ii-no-sleep.yaml # No deep sleep example
    └── README.md                     # Examples documentation
```

### Two Operating Modes

**Full Monitoring Mode** (mains-powered):
- Comprehensive telemetry and diagnostics
- Full battery monitoring
- Error handling and recovery
- Best for development and USB-powered devices

**Battery-Optimized Mode** (default):
- Minimal memory footprint
- Sleep coordination with Home Assistant
- Quick health checks only
- Optimized for battery-powered operation

## 🛠️ Hardware Support

### Mark I (ESP32)
- **MCU**: ESP32 Development Board
- **CO₂ Sensor**: MH-Z19 via UART (GPIO 1/3)
- **Framework**: Arduino
- **Power**: USB or battery with deep sleep

### Mark II (ESP8266)
- **MCU**: ESP8266 Development Board  
- **CO₂ Sensor**: MH-Z16 via UART
- **Climate Sensor**: SHT35 via I2C (GPIO 4/5)
- **Framework**: Arduino
- **Power**: Optimized for battery operation

## 🚀 Quick Start

### Prerequisites
- [ESPHome](https://esphome.io/) installed (version 2023.12.0 or newer)
- ESP8266 development board (ESP-01 with 1MB flash recommended)
- MH-Z16/MH-Z19 CO₂ sensor
- SHT35 temperature/humidity sensor
- Home Assistant with MQTT broker (for battery-optimized mode)

### Installation Methods

There are two ways to set up Myko Monitor devices:

#### Method 1: Remote Packages (Recommended for Production)

This method automatically pulls the latest configuration from GitHub, making updates easier.

1. **Copy the ESP8266 base template**:
   ```bash
   cp examples/myko-monitor-ii.esp8266.yml myko-monitor-ii.esp8266.yml
   ```

2. **Create a secrets.yaml file**:
   ```bash
   cp secrets.yaml.example secrets.yaml
   ```
   Edit `secrets.yaml` with your WiFi, MQTT credentials, and OTA password.

3. **Create a device-specific configuration** (e.g., `myko-monitor-greenhouse.yaml`):
   ```yaml
   substitutions:
     device_name_suffix: "greenhouse"
     standard_ip: 192.168.1.210

   packages:
     device_base: !include myko-monitor-ii.esp8266.yml
   ```

4. **Compile and upload**:
   ```bash
   esphome compile myko-monitor-greenhouse.yaml
   esphome upload myko-monitor-greenhouse.yaml
   ```

#### Method 2: Local Development

For local development or when you need to modify the base configuration:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vdwals/myko_monitor
   cd myko_monitor
   ```

2. **Create secrets.yaml**:
   ```bash
   cp secrets.yaml.example secrets.yaml
   ```
   Edit with your credentials and device-specific values.

3. **Compile and upload**:
   ```bash
   esphome compile base.yml
   esphome upload base.yml
   ```

### First-Time Setup

1. **Flash firmware via USB**:
   ```bash
   esphome upload myko-monitor-greenhouse.yaml
   ```

2. **Device connects to WiFi** and appears in Home Assistant

3. **Add ESPHome integration** in Home Assistant:
   - Go to Configuration > Integrations
   - Add ESPHome integration
   - Enter device IP address
   - Use encryption key from your configuration

4. **Set up Home Assistant automations** (for battery mode):
   - Import automations from `home_assistant_automations.yaml`
   - These handle sleep coordination with the device

### Multiple Devices

To deploy multiple devices:

1. Create device-specific files for each location:
   ```yaml
   # myko-monitor-greenhouse.yaml
   substitutions:
     device_name_suffix: "greenhouse"
     standard_ip: 192.168.1.210

   packages:
     device_base: !include myko-monitor-ii.esp8266.yml
   ```

   ```yaml
   # myko-monitor-basement.yaml
   substitutions:
     device_name_suffix: "basement"
     standard_ip: 192.168.1.211

   packages:
     device_base: !include myko-monitor-ii.esp8266.yml
   ```

2. Flash each device with its specific configuration

3. All devices automatically pull updates from the shared base configuration

## 📡 Connectivity

### MQTT Topics
- **Data**: `mykomonitor/myko-monitor-ii-{device}/sensor/co2/state`
- **Commands**: `mykomonitor/myko-monitor-ii-{device}/button/sleep/command`
- **Status**: Device availability and WiFi signal strength

### Home Assistant Integration
- Native ESPHome API integration
- Automatic device discovery
- Encrypted communication
- Entity categories for organization

## ⚡ Power Management

The system includes intelligent power management for battery operation:

- **Optional Deep Sleep**: Enable/disable deep sleep as needed
- **Configurable Duration**: 5-60 minutes sleep intervals
- **Home Assistant Coordination**: Synchronized sleep/wake cycles
- **Emergency Sleep**: Automatic sleep on low battery
- **Power Optimization**: Reduced logging and WiFi power settings

### Enabling/Disabling Deep Sleep

**To enable deep sleep** (battery operation):
```yaml
substitutions:
  sleep_time: "30min"  # Options: 5min, 15min, 30min, 45min, 60min
```

**To disable deep sleep** (mains power):
```yaml
substitutions:
  sleep_time: "0"  # Device stays awake permanently
```

Or use the no-sleep example:
```bash
cp examples/myko-monitor-ii-no-sleep.yaml myko-monitor-office.yaml
```

### Sleep Coordination with Home Assistant

In battery-optimized mode, the device coordinates with Home Assistant:

1. Device wakes from deep sleep
2. Connects to WiFi and MQTT
3. Reads all sensors
4. Publishes data to Home Assistant
5. Sends "sleep_ready" signal
6. Waits for Home Assistant to process data
7. Home Assistant sends sleep command
8. Device enters deep sleep

This ensures no data is lost before the device sleeps.

### Sleep Commands
```yaml
# Manual sleep trigger via MQTT
topic: mykomonitor/myko-monitor-ii-{device}/command/sleep
payload: ""

# Force sleep (emergency)
topic: mykomonitor/myko-monitor-ii-{device}/command/force_sleep
payload: ""
```

## 🔧 Configuration

### Device-Specific Settings

Each device needs unique identifiers. Create a device-specific YAML file:

```yaml
# myko-monitor-greenhouse.yaml
substitutions:
  device_name_suffix: "greenhouse"  # Unique identifier
  standard_ip: 192.168.1.210        # Static IP for this device

packages:
  device_base: !include myko-monitor-ii.esp8266.yml
```

### Common Configuration Options

Override any substitution in your device-specific file:

```yaml
substitutions:
  device_name_suffix: "greenhouse"
  standard_ip: 192.168.1.210

  # Power management
  sleep_time: "30min"          # Or "0" to disable deep sleep

  # WiFi settings
  wifi_power: "17dB"           # Lower for better battery life (default: 20.5dB)

  # Sensor settings
  update_interval: "30s"       # How often to read sensors

  # Hardware pins (if different from defaults)
  mh_z16_rx: GPIO3
  mh_z16_tx: GPIO1
  sda_pin: GPIO4
  scl_pin: GPIO5
  sht_35_address: "0x44"      # Or "0x45" if using alternate address
```

### Sensor Calibration

CO₂ sensors support remote calibration:
- **Automatic**: Disabled by default for accuracy
- **Manual**: Button trigger via Home Assistant or MQTT
- **Zero Calibration**: Perform in fresh air (400ppm CO₂)

Calibration button in Home Assistant:
- Device page > Controls > "Kalibrieren" button
- Only use in fresh outdoor air!

### Switching Operating Modes

Edit `base.yml` to switch between monitoring modes:

**Battery-Optimized Mode** (default):
```yaml
packages:
  battery_optimized: !include modules/battery_optimized_monitoring.yml
  sleep_coordinator: !include modules/sleep_coordinator.yml
```

**Full Monitoring Mode** (mains power):
```yaml
packages:
  error_handling: !include modules/error_handling.yml
  telemetry: !include modules/telemetry.yml
  sensor_diagnostics: !include modules/sensor_diagnostics.yml
  battery_monitoring: !include modules/battery_monitoring.yml
```

### Remote Package Configuration

The ESP8266 base template pulls configuration from GitHub:

```yaml
packages:
  remote_package_files:
    url: https://github.com/vdwals/myko_monitor
    files: [base.yml]
    ref: main              # Branch to use
    refresh: 0d            # Cache duration (0d = always fetch latest)
```

**Cache options:**
- `0d` - Always fetch latest (development)
- `7d` - Cache for 7 days (production)
- `never` - Only fetch once (offline)

## 📊 Monitoring Data

### Sensor Readings
- **CO₂ Concentration**: ppm measurement (0-5000 range)
- **Temperature**: °C from CO₂ sensor or SHT35
- **Humidity**: % RH from SHT35 (Mark II only)
- **WiFi Signal**: dB and percentage

### Diagnostic Information
- Device uptime and boot count
- WiFi connection status and signal strength
- MQTT connection status
- Deep sleep statistics

## 🏠 Home Assistant Setup

1. **Add ESPHome Integration**:
   - Configuration > Integrations > Add Integration > ESPHome
   - Enter device IP address
   - Use encryption key from device configuration

2. **Entity Organization**:
   - Sensors are automatically categorized
   - Diagnostic entities are grouped separately
   - Calibration buttons available in device controls

3. **Automation Examples**:
   ```yaml
   # High CO₂ Alert
   - alias: "High CO₂ Warning"
     trigger:
       platform: numeric_state
       entity_id: sensor.myko_monitor_co2
       above: 1500
     action:
       service: notify.mobile_app
       data:
         message: "CO₂ levels high: {{ states('sensor.myko_monitor_co2') }}ppm"
   ```

## 🔒 Security

- **Encrypted API**: Home Assistant communication secured
- **OTA Password**: Protected firmware updates
- **WiFi Security**: WPA2 with fallback AP mode
- **No Hardcoded Secrets**: Use substitutions for credentials

## 🐛 Troubleshooting

### Common Issues

**Device Not Connecting**:
- Check WiFi credentials in `secrets.yaml`
- Verify network supports 2.4GHz (ESP8266 doesn't support 5GHz)
- Check static IP doesn't conflict with DHCP range
- Monitor serial logs during boot: `esphome logs device.yaml`

**Sensor Readings Incorrect**:
- Allow 3-minute warmup time for CO₂ sensor after power-on
- Perform zero calibration in fresh outdoor air (~400ppm)
- Check UART wiring (RX/TX not swapped) and baud rate (9600)
- Verify I2C address for SHT35 (0x44 or 0x45)

**Deep Sleep Not Working**:
- Check `sleep_time` is not set to "0"
- Verify Home Assistant automations are active (for battery mode)
- Check MQTT broker connectivity and topics
- Monitor device logs: look for "sleep_ready" messages
- Verify timeout protection (device sleeps after 5 minutes max)

**Deep Sleep Activating When Not Wanted**:
- Set `sleep_time: "0"` in device configuration
- Or use the no-sleep example configuration
- Verify the setting is applied: check device logs on boot

**OTA Updates Failing**:
- Ensure device is awake (not in deep sleep)
- Wait for next wake cycle if device is sleeping
- Temporarily set `sleep_time: "0"` to disable sleep
- Check OTA password matches `secrets.yaml`
- Verify network connectivity and device IP

**Configuration Validation Errors**:
- Run `esphome config device.yaml` to see detailed errors
- Check all required secrets are defined in `secrets.yaml`
- Verify module files exist in `modules/` directory
- Check YAML indentation (use spaces, not tabs)

### Debug Mode
Enable verbose logging temporarily:
```yaml
logger:
  level: DEBUG
  baud_rate: 115200
```

## 📝 Development

### Project Structure

```
myko_monitor/
├── base.yml                    # Main template (entry point)
├── modules/                    # Reusable configuration modules
│   ├── deep_sleep_optional.yml # Optional deep sleep (detects sleep_time: "0")
│   ├── mh-z16.yml             # CO₂ sensor
│   ├── sht35.yml              # Temperature/humidity
│   ├── wifi.yml               # WiFi with static IP
│   ├── mqtt.yml               # MQTT messaging
│   └── ...                    # Other modules
├── examples/                   # Example configurations
│   ├── myko-monitor-ii.esp8266.yml  # Remote package base
│   └── ...                    # Device-specific examples
└── secrets.yaml               # Local secrets (not in git)
```

### Adding New Sensors

1. Create new module file in `modules/`:
   ```yaml
   # modules/my_sensor.yml
   sensor:
     - platform: ...
       name: "My Sensor"
       # ... sensor configuration
   ```

2. Add to `base.yml` packages:
   ```yaml
   packages:
     my_sensor: !include modules/my_sensor.yml
   ```

3. Test configuration:
   ```bash
   esphome config base.yml
   ```

### Customizing Sleep Behavior

The `modules/deep_sleep_optional.yml` module supports:

- **Disabling sleep**: Set `sleep_time: "0"`
- **Variable duration**: Any ESPHome time value (`5min`, `30min`, `1h`)
- **Conditional sleep**: Modify module to check sensor values before sleeping
- **Home Assistant coordination**: Via `modules/sleep_coordinator.yml`

Example custom sleep logic:
```yaml
# In your custom module or deep_sleep_optional.yml
script:
  - id: conditional_sleep
    then:
      - if:
          condition:
            lambda: 'return id(co2_sensor).state < 2000;'
          then:
            - deep_sleep.enter: deep_sleep_1
          else:
            - logger.log: "CO₂ high, staying awake"
```

### Contributing to Base Configuration

1. Fork the repository
2. Make changes in `modules/` or `base.yml`
3. Test with `esphome config base.yml`
4. Create a pull request with:
   - Description of changes
   - Testing performed
   - Example configuration if adding new features

### Local vs Remote Development

**Local Development** (testing changes):
```bash
# Edit modules/something.yml
esphome config base.yml
esphome compile base.yml
esphome upload base.yml
```

**Remote Package Testing** (testing GitHub integration):
```yaml
packages:
  remote_package_files:
    url: https://github.com/YOUR_FORK/myko_monitor
    ref: your-test-branch
    refresh: 0d
```

### Testing Multiple Devices

Create test configurations for different scenarios:
```bash
# Test with sleep disabled
cp examples/myko-monitor-ii-no-sleep.yaml test-no-sleep.yaml

# Test with battery optimization
cp examples/myko-monitor-ii1.yaml test-battery.yaml

# Compile both
esphome config test-no-sleep.yaml
esphome config test-battery.yaml
```

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test configuration changes
4. Submit a pull request with clear description

## 📚 Resources

### Documentation
- [ESPHome Documentation](https://esphome.io/)
- [MH-Z19 Sensor Guide](https://esphome.io/components/sensor/mhz19.html)
- [SHT3X Sensor Guide](https://esphome.io/components/sensor/sht3xd.html)
- [ESP Deep Sleep Guide](https://esphome.io/components/deep_sleep.html)
- [ESPHome Packages](https://esphome.io/components/packages.html)

### Project Resources
- [Example Configurations](examples/README.md) - Detailed guide to using the provided examples
- [Home Assistant Automations](home_assistant_automations.yaml) - Required HA automations

### Community
- **Issues**: Report bugs or request features via GitHub Issues
- **Discussions**: Share your setups and ask questions
- **Contributing**: See Development section above

---

**Project Version**: 2.4.0
**Maintainer**: vdwals
**Repository**: https://github.com/vdwals/myko_monitor
**Last Updated**: 2025