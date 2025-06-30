# Myko Monitor - Environmental Monitoring System

An ESPHome-based IoT solution for monitoring CO₂ levels, temperature, and humidity in mushroom cultivation environments. This project provides firmware configurations for ESP32 and ESP8266 microcontrollers with modular, reusable components.

## 🌟 Features

- **CO₂ Monitoring**: MH-Z16/MH-Z19 sensor integration with automatic calibration
- **Climate Monitoring**: SHT35 temperature and humidity sensing
- **Power Efficient**: Deep sleep mode for battery-powered operation
- **Remote Control**: MQTT-based commands for calibration and sleep control
- **Home Assistant Integration**: Native API support with encryption
- **OTA Updates**: Over-the-air firmware updates
- **WiFi Diagnostics**: Signal strength monitoring and fallback hotspot
- **Modular Design**: Reusable YAML components for easy customization

## 🏗️ Architecture

The project uses a modular ESPHome configuration architecture:

```
base.yml                 # Main template with package imports
├── sensor_I.yml         # ESP32 Mark I configuration
├── sensor_II.yml        # ESP8266 Mark II configuration
└── components/
    ├── mh-z16.yml       # CO₂ sensor configuration
    ├── sht35.yml        # Temperature/humidity sensor
    ├── wifi.yml         # WiFi connectivity
    ├── mqtt.yml         # MQTT messaging
    ├── deep_sleep.yml   # Power management
    ├── status_led.yml   # Status indicators
    └── logger.yml       # Logging configuration
```

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
- [ESPHome](https://esphome.io/) installed
- ESP32 or ESP8266 development board
- MH-Z16/MH-Z19 CO₂ sensor
- SHT35 temperature/humidity sensor (Mark II)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd myko_monitor
   ```

2. **Configure WiFi and MQTT**:
   - Edit `wifi.yml` with your network credentials
   - Update `mqtt.yml` with your broker settings

3. **Customize device settings**:
   - Modify substitutions in sensor configuration files
   - Set device-specific names and IDs

4. **Compile and upload**:
   ```bash
   # For Mark I (ESP32)
   esphome compile sensor_I.yml
   esphome upload sensor_I.yml
   
   # For Mark II (ESP8266)
   esphome compile sensor_II.yml
   esphome upload sensor_II.yml
   ```

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

- **Deep Sleep**: Configurable sleep duration (15-60 minutes)
- **Remote Sleep**: MQTT command to trigger sleep mode
- **Wake Triggers**: Timer-based wake from deep sleep
- **Power Optimization**: Reduced logging and WiFi power settings

### Sleep Commands
```yaml
# Trigger sleep via MQTT
topic: mykomonitor/myko-monitor-ii-{device}/button/sleep/command
payload: "ON"
```

## 🔧 Configuration

### Device Naming
Use substitutions to customize device names:
```yaml
substitutions:
  device_name_suffix: "greenhouse-01"
  friendly_name: "Greenhouse Monitor 01"
```

### Sensor Calibration
CO₂ sensors support remote calibration:
- **Automatic**: Disabled by default for accuracy
- **Manual**: Button trigger via Home Assistant or MQTT
- **Zero Calibration**: Perform in fresh air (400ppm CO₂)

### Sleep Duration
Configure deep sleep timing:
```yaml
substitutions:
  sleep_duration: "30min"  # 15min, 30min, 45min, 60min
```

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
- Check WiFi credentials in `wifi.yml`
- Verify network supports 2.4GHz
- Use fallback hotspot for initial setup

**Sensor Readings Incorrect**:
- Allow 3-minute warmup time for CO₂ sensor
- Perform zero calibration in fresh air
- Check UART wiring and baud rate (9600)

**Deep Sleep Not Working**:
- Verify MQTT broker connectivity
- Check sleep duration substitutions
- Monitor device logs before sleep activation

**OTA Updates Failing**:
- Ensure device is awake (not in deep sleep)
- Check OTA password configuration
- Verify network connectivity

### Debug Mode
Enable verbose logging temporarily:
```yaml
logger:
  level: DEBUG
  baud_rate: 115200
```

## 📝 Development

### Adding New Sensors
1. Create new component YAML file
2. Add to `packages` section in `base.yml`
3. Update substitutions as needed
4. Test configuration with `esphome config`

### Customizing Sleep Behavior
Modify `deep_sleep.yml` for different sleep patterns:
- Conditional sleep based on sensor readings
- Time-based sleep schedules
- External wake triggers

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test configuration changes
4. Submit a pull request with clear description

## 📚 Resources

- [ESPHome Documentation](https://esphome.io/)
- [MH-Z19 Sensor Guide](https://esphome.io/components/sensor/mhz19.html)
- [SHT3X Sensor Guide](https://esphome.io/components/sensor/sht3xd.html)
- [ESP Deep Sleep Guide](https://esphome.io/components/deep_sleep.html)

---

**Project Version**: 2.4.0  
**Maintainer**: vdwals  
**Last Updated**: 2024