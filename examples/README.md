# Myko Monitor - Configuration Examples

This directory contains example configurations demonstrating different ways to set up and use Myko Monitor devices.

## Quick Start

### Option 1: Using Remote Packages (Recommended)

This approach is best for production deployments where you want devices to automatically pull the latest configuration from GitHub.

1. **Copy the ESP8266 base template:**
   ```bash
   cp examples/myko-monitor-ii.esp8266.yml myko-monitor-ii.esp8266.yml
   ```

2. **Create a device-specific file** (e.g., `myko-monitor-greenhouse.yaml`):
   ```yaml
   substitutions:
     device_name_suffix: "greenhouse"
     standard_ip: 192.168.1.210

   packages:
     device_base: !include myko-monitor-ii.esp8266.yml
   ```

3. **Compile and upload:**
   ```bash
   esphome compile myko-monitor-greenhouse.yaml
   esphome upload myko-monitor-greenhouse.yaml
   ```

### Option 2: Using Local Files

For development or when you need to customize the base configuration:

1. **Use base.yml directly:**
   ```bash
   esphome compile base.yml
   esphome upload base.yml
   ```

2. **Create a secrets.yaml file** with your specific values (see secrets.yaml.example)

## Example Files

### myko-monitor-ii.esp8266.yml
Base template for ESP8266 devices that pulls configuration from GitHub. This file:
- Defines all necessary substitutions
- Configures hardware pins for ESP8266
- Sets up WiFi, MQTT, and sensor parameters
- Includes the remote `base.yml` from GitHub

**Key Features:**
- Remote package fetching from GitHub
- Battery-optimized defaults (5-minute sleep cycles)
- Standard ESP8266 GPIO pin mappings

### myko-monitor-ii1.yaml
Minimal device-specific configuration for Device #1:
- Sets unique device name suffix: "1"
- Assigns static IP: 192.168.1.210
- Inherits all settings from ESP8266 base template

**Use Case:** Quick deployment of multiple identical devices with different IPs

### myko-monitor-ii2.yaml
Similar to device #1, but for a second device:
- Device name suffix: "2"
- Static IP: 192.168.1.211

**Use Case:** Scale to multiple devices easily by copying and modifying device number and IP

### myko-monitor-ii-no-sleep.yaml
Configuration for mains-powered operation without deep sleep:
- Sets `sleep_time: "0"` to disable deep sleep
- Suitable for USB or wall-powered devices
- Enables continuous monitoring and instant OTA updates

**Use Case:** Development, debugging, or permanent installation with reliable power

## Configuration Patterns

### Disabling Deep Sleep

**Method 1: Set sleep_time to "0"** (Recommended)
```yaml
substitutions:
  sleep_time: "0"
```

**Method 2: Comment out in base.yml** (For local development)
```yaml
packages:
  # deep_sleep: !include modules/deep_sleep_optional.yml
```

### Switching Monitoring Modes

**Battery-Optimized Mode** (Default in examples):
```yaml
packages:
  battery_optimized: !include modules/battery_optimized_monitoring.yml
  sleep_coordinator: !include modules/sleep_coordinator.yml
```

**Full Monitoring Mode** (For mains power):
```yaml
packages:
  error_handling: !include modules/error_handling.yml
  telemetry: !include modules/telemetry.yml
  sensor_diagnostics: !include modules/sensor_diagnostics.yml
  battery_monitoring: !include modules/battery_monitoring.yml
```

### Custom Hardware Pins

Override pin assignments in your device-specific file:
```yaml
substitutions:
  mh_z16_rx: GPIO13
  mh_z16_tx: GPIO15
  sda_pin: GPIO4
  scl_pin: GPIO5
```

## Remote Package Configuration

The ESP8266 base template uses ESPHome's remote package feature:

```yaml
packages:
  remote_package_files:
    url: https://github.com/vdwals/myko_monitor
    files: [base.yml]
    ref: main        # Branch to fetch from
    refresh: 0d      # Cache duration (0d = always fetch latest)
```

**Benefits:**
- Devices automatically get updates when you push to GitHub
- Centralized configuration management
- Easy to deploy firmware to multiple devices

**Cache Settings:**
- `refresh: 0d` - Always fetch latest (development)
- `refresh: 7d` - Cache for 7 days (production)
- `refresh: never` - Only fetch once (offline deployments)

## Deployment Workflow

### Initial Setup
1. Flash device via USB with initial configuration
2. Device connects to WiFi and registers with Home Assistant
3. Deploy Home Assistant automations for sleep coordination

### Updates
1. Modify configuration in GitHub
2. Compile new firmware: `esphome compile device.yaml`
3. Upload via OTA: `esphome upload device.yaml --device IP_ADDRESS`
4. Device automatically fetches latest config on next boot

### Multiple Devices
1. Create base template once (myko-monitor-ii.esp8266.yml)
2. For each device, create minimal YAML with unique ID and IP
3. Compile and flash each device
4. All devices share the same core configuration from GitHub

## Troubleshooting

### Device won't compile
- Check that all secrets are defined in `secrets.yaml`
- Verify GitHub URL and branch name are correct
- Ensure `base.yml` exists in the repository

### Device won't sleep
- Verify `sleep_time` is not set to "0"
- Check Home Assistant automation is running
- Monitor MQTT topics for sleep coordination messages

### Can't connect to device for OTA
- Device may be in deep sleep - wait for next wake cycle
- Try setting `sleep_time: "0"` temporarily
- Use serial connection to reflash if needed

## Tips

- Keep the ESP8266 base template generic and device-agnostic
- Use device-specific files only for unique identifiers (name, IP)
- Test configuration changes on one device before deploying to all
- Use version control (git tags) for stable releases
- Document any hardware modifications in device-specific files
