---
title: "Command Reference and Configuration"
parent: "Flash System"
nav_order: 7
---

# Command Reference and Configuration

## Overview

This document provides comprehensive command reference and configuration information for the ESP32 flash system, including all available commands, options, and configuration parameters.

## Command Reference

### Flash Script Parameters

```bash
./flash_app.sh [operation] [app_type] [build_type] [idf_version] [options]

## Parameters:
##   operation    - What to do (flash, monitor, flash_monitor, list)
##   app_type     - Application to flash (from app_config.yml)
##   build_type   - Build type to flash (Debug, Release)
##   idf_version  - ESP-IDF version used for build
##   options      - Flash options (--log, --port, etc.)
```

### Flash Operations

#### Basic Operations
- **`flash`**: Flash firmware only (no monitoring)
- **`flash_monitor`**: Flash firmware and start monitoring (default)
- **`monitor`**: Monitor existing firmware (no flashing)
- **`size`**: Show firmware size information and memory usage analysis
- **`list`**: List available applications and configurations

#### Operation Syntax
```bash
## Operation-first syntax (RECOMMENDED)
./flash_app.sh flash gpio_test Release
./flash_app.sh monitor --log
./flash_app.sh flash_monitor adc_test Debug
./flash_app.sh size gpio_test Release
./flash_app.sh size gpio_test Release release/v5.5

## Legacy syntax (still supported)
./flash_app.sh gpio_test Release flash
./flash_app.sh gpio_test Release flash_monitor
./flash_app.sh gpio_test Release size
```

### Flash Options

#### Logging Options
- **`--log [name]`**: Enable logging with optional custom name
- **`--no-log`**: Disable logging (override default)

#### Port Options
- **`--port <port>`**: Override automatic port detection
- **`--baud <rate>`**: Set custom baud rate for monitoring
- **`--test-port`**: Test port connectivity before operation

#### Build Options
- **`--clean`**: Perform clean build before flashing
- **`--no-build`**: Skip build verification
- **`--force`**: Force operation even if validation fails

#### Monitor Options
- **`--timeout <seconds>`**: Set monitoring timeout
- **`--no-monitor`**: Skip monitoring after flash
- **`--monitor-only`**: Only monitor, don't flash

#### General Options
- **`--help`**: Show usage information
- **`--version`**: Show version information
- **`--verbose`**: Enable verbose output
- **`--debug`**: Enable debug mode

### Port Detection Script

#### Basic Commands
```bash
./detect_ports.sh [options]

## Options:
##   --verbose          - Show detailed port information
##   --test-connection  - Test port connectivity
##   --filter <type>    - Filter by device type
##   --port <port>      - Test specific port
##   --identify         - Identify device types
##   --help             - Show usage information
```

#### Port Detection Examples
```bash
## List all available ports
./detect_ports.sh

## Show detailed port information
./detect_ports.sh --verbose

## Test port connectivity
./detect_ports.sh --test-connection

## Filter by device type
./detect_ports.sh --filter "CP210x"

## Test specific port
./detect_ports.sh --port /dev/ttyUSB0 --test-connection
```

### Log Management Script

#### Basic Commands
```bash
./manage_logs.sh [command] [options]

## Commands:
##   list                    - List all logs
##   latest                  - Show latest log
##   search <pattern>        - Search for pattern in logs
##   stats                   - Show log statistics
##   clean                   - Clean old logs
##   export                  - Export logs
##   help                    - Show usage information
```

#### Log Management Examples
```bash
## List all logs
./manage_logs.sh list

## Show latest log
./manage_logs.sh latest

## Search for errors
./manage_logs.sh search "ERROR"

## Search for warnings
./manage_logs.sh search "WARNING"

## Show log statistics
./manage_logs.sh stats

## Clean old logs
./manage_logs.sh clean
```

## Environment Variables

### Flash Configuration

```bash
## Override default application
export CONFIG_DEFAULT_APP="gpio_test"

## Override default build type
export CONFIG_DEFAULT_BUILD_TYPE="Debug"

## Override default ESP-IDF version
export CONFIG_DEFAULT_IDF_VERSION="release/v5.4"

## Override port detection
export ESPPORT="/dev/ttyUSB0"

## Override baud rate
export ESPBAUD="115200"
```

### Debug Configuration

```bash
## Enable debug mode
export DEBUG=1

## Enable verbose ESP-IDF output
export IDF_VERBOSE=1

## Set log level
export LOG_LEVEL="DEBUG"

## Set log directory
export LOG_DIR="/path/to/logs"
```

### Project Configuration

```bash
## Override project path
export PROJECT_PATH="/path/to/project"

## Override scripts path
export SCRIPTS_PATH="/path/to/scripts"

## Override build directory
export BUILD_DIR="/path/to/build"
```

## Configuration Files

### App Configuration (app_config.yml)

#### Minimal Configuration
```yaml
## app_config.yml minimal configuration
metadata:
  default_app: "gpio_test"
  default_build_type: "Release"
  target: "esp32c6"

apps:
  gpio_test:
    source_file: "GpioComprehensiveTest.cpp"
    build_types: ["Debug", "Release"]
```

#### Advanced Configuration
```yaml
## app_config.yml advanced configuration
metadata:
  default_app: "gpio_test"
  default_build_type: "Release"
  target: "esp32c6"
  idf_versions: ["release/v5.5", "release/v5.4"]

apps:
  gpio_test:
    description: "GPIO testing application"
    source_file: "GpioComprehensiveTest.cpp"
    category: "peripheral"
    build_types: ["Debug", "Release"]
    idf_versions: ["release/v5.5"]
    ci_enabled: true
    featured: true
```

### Port Configuration

#### Linux udev Rules
```bash
## /etc/udev/rules.d/99-esp32.rules
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
```

#### Port Preference File
```bash
## ~/.esp32_port_prefs
DEFAULT_PORT=/dev/ttyUSB0
LAST_USED_PORT=/dev/ttyUSB1
PREFERRED_BAUD=115200
AUTO_DETECT=true
```

### Log Configuration

#### Log Settings
```bash
## Log configuration file
LOG_LEVEL=INFO
LOG_DIR=./logs
LOG_RETENTION_DAYS=30
LOG_MAX_SIZE=100MB
LOG_FORMAT=timestamp,level,message
LOG_TIMESTAMP_FORMAT=%Y-%m-%d %H:%M:%S
```

## Integration Examples

### CMake Integration

```cmake
## CMakeLists.txt flash integration
cmake_minimum_required(VERSION 3.16)

## Flash target integration
add_custom_target(flash
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/flash_app.sh flash ${APP_TYPE} ${BUILD_TYPE}
    DEPENDS ${PROJECT_NAME}
    COMMENT "Flashing ${APP_TYPE} ${BUILD_TYPE} to device"
)

## Monitor target integration
add_custom_target(monitor
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/flash_app.sh monitor --log
    COMMENT "Monitoring device"
)

## Size analysis target
add_custom_target(size
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/flash_app.sh size ${APP_TYPE} ${BUILD_TYPE}
    COMMENT "Analyzing firmware size"
)
```

### Makefile Integration

```makefile
## Makefile flash integration
.PHONY: flash monitor size

flash:
	@echo "Flashing $(APP) $(BUILD_TYPE)"
	@./scripts/flash_app.sh flash $(APP) $(BUILD_TYPE)

monitor:
	@echo "Monitoring device"
	@./scripts/flash_app.sh monitor --log

size:
	@echo "Analyzing firmware size"
	@./scripts/flash_app.sh size $(APP) $(BUILD_TYPE)

flash-monitor: flash monitor
	@echo "Flash and monitor completed"
```

### CI/CD Integration

```yaml
## GitHub Actions flash workflow
name: ESP32 Flash and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  flash-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup ESP-IDF
      uses: espressif/esp-idf-ci-action@v1
      with:
        esp_idf_version: 'release/v5.5'
        target: 'esp32c6'
    
    - name: Build Application
      run: |
        cd examples/esp32
        ./scripts/build_app.sh gpio_test Release
    
    - name: Flash Application
      run: |
        cd examples/esp32
        ./scripts/flash_app.sh flash gpio_test Release --log ci_deploy
    
    - name: Verify Flash
      run: |
        cd examples/esp32
        timeout 30s ./scripts/flash_app.sh monitor --log ci_verify
```

## Error Codes and Messages

### Common Error Codes

- **0**: Success
- **1**: General error
- **2**: Invalid parameters
- **3**: Port not found
- **4**: Permission denied
- **5**: Flash failed
- **6**: Monitor failed
- **7**: Build not found
- **8**: Configuration error

### Error Messages

#### Port Errors
- "No ports detected"
- "Port not accessible"
- "Permission denied"
- "Port busy"

#### Flash Errors
- "Flash failed"
- "Upload failed"
- "Flash timeout"
- "Verification failed"

#### Monitor Errors
- "Monitor failed"
- "No output"
- "Connection lost"
- "Monitor timeout"

#### Configuration Errors
- "App not found"
- "Build type not supported"
- "ESP-IDF version not supported"
- "Configuration error"

## Best Practices

### Command Usage

- **Use Operation-First Syntax**: Prefer operation-first syntax for clarity
- **Always Use Logging**: Enable logging for debugging and troubleshooting
- **Verify Parameters**: Check parameters before execution
- **Handle Errors**: Implement proper error handling

### Configuration

- **Use Minimal Configuration**: Start with minimal configuration
- **Validate Settings**: Always validate configuration settings
- **Document Changes**: Document configuration changes
- **Backup Configuration**: Backup important configuration files

### Integration

- **Use Standard Patterns**: Follow standard integration patterns
- **Test Integration**: Test integration thoroughly
- **Handle Errors**: Implement proper error handling in integration
- **Document Integration**: Document integration procedures