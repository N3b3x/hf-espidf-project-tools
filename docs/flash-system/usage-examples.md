---
title: "Usage Examples and Patterns"
parent: "Flash System"
nav_order: 5
---

# Usage Examples and Patterns

## Overview

This document provides comprehensive usage examples and patterns for the ESP32 flash system, covering common workflows, advanced patterns, and integration scenarios.

## Basic Flash Workflows

### Development Flash Workflow

```bash
## Build and flash for development
./build_app.sh gpio_test Debug
./flash_app.sh flash_monitor gpio_test Debug --log

## Expected result:
## - Firmware flashed to device
## - Monitoring started automatically
## - Debug output captured in logs
## - Real-time debugging available
```

### Production Flash Workflow

```bash
## Build and flash for production
./build_app.sh gpio_test Release
./flash_app.sh flash gpio_test Release --log production_deploy

## Expected result:
## - Optimized firmware flashed
## - No monitoring (production mode)
## - Deployment log generated
## - Ready for production use
```

### Portable Flash Usage

```bash
## Default behavior (scripts in project/scripts/)
./flash_app.sh flash_monitor gpio_test Release

## Portable usage with --project-path
./flash_app.sh --project-path /path/to/project flash_monitor gpio_test Release
./flash_app.sh --project-path ../project flash adc_test Debug --log

## Environment variable usage
export PROJECT_PATH=/path/to/project
./flash_app.sh flash_monitor gpio_test Release

## Multiple project support
./flash_app.sh --project-path ~/projects/robot-controller flash_monitor gpio_test Release
./flash_app.sh --project-path ~/projects/sensor-node flash adc_test Debug
```

### Debugging Workflow

```bash
## Monitor existing firmware
./flash_app.sh monitor --log debug_session

## Search for issues
./manage_logs.sh search "ERROR"
./manage_logs.sh search "WARNING"

## Analyze log patterns
./manage_logs.sh stats
```

### Size Analysis Workflow

```bash
## Analyze firmware size before deployment
./flash_app.sh size gpio_test Release

## Check memory usage for optimization
./flash_app.sh size gpio_test Debug

## Compare sizes between versions
./flash_app.sh size gpio_test Release release/v5.5
./flash_app.sh size gpio_test Release release/v5.4

## Expected result:
## - Comprehensive size analysis
## - Component breakdown
## - Memory usage summary
## - No device connection required
```

## Advanced Flash Patterns

### Multi-Device Deployment

```bash
## Flash to multiple devices
for port in /dev/ttyUSB0 /dev/ttyUSB1 /dev/ttyUSB2; do
    export ESPPORT="$port"
    ./flash_app.sh flash gpio_test Release --log "deploy_${port}"
done
```

### Conditional Flash Operations

```bash
## Flash only if build is newer
if [ "build_gpio_test_Release/gpio_test.bin" -nt "last_flash" ]; then
    ./flash_app.sh flash gpio_test Release --log
    touch last_flash
fi
```

### Automated Testing Flash

```bash
## Flash for automated testing
./flash_app.sh flash gpio_test Release --log "test_$(date +%Y%m%d_%H%M%S)"

## Run automated tests
## Monitor test results
## Collect test logs
```

### Batch Flash Operations

```bash
## Flash multiple applications
for app in gpio_test adc_test uart_test; do
    ./build_app.sh $app Release
    ./flash_app.sh flash $app Release --log "batch_${app}"
done
```

### Version-Specific Flash Operations

```bash
## Flash with specific ESP-IDF versions
for version in release/v5.5 release/v5.4; do
    ./flash_app.sh flash gpio_test Release $version --log "version_${version}"
done
```

## Integration Examples

### Build-Flash Integration

```bash
## Combined build and flash
./build_app.sh gpio_test Release && \
./flash_app.sh flash_monitor gpio_test Release --log

## Automatic build verification
- Ensures build exists before flashing
- Validates build type compatibility
- Checks firmware integrity
```

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

### Docker Integration

```dockerfile
## Dockerfile for ESP32 development
FROM espressif/idf:release-v5.5

## Copy project files
COPY . /workspace
WORKDIR /workspace

## Install additional tools
RUN apt-get update && apt-get install -y \
    screen \
    minicom \
    && rm -rf /var/lib/apt/lists/*

## Create flash script
RUN echo '#!/bin/bash\n\
cd /workspace/examples/esp32\n\
./scripts/flash_app.sh "$@"' > /usr/local/bin/flash
RUN chmod +x /usr/local/bin/flash

## Default command
CMD ["/bin/bash"]
```

```bash
## Docker usage
docker build -t esp32-dev .
docker run -it --device=/dev/ttyUSB0 esp32-dev flash flash_monitor gpio_test Release --log
```

## Scripting and Automation

### Bash Scripting Examples

```bash
#!/bin/bash
## Automated flash script

## Configuration
APP_NAME="gpio_test"
BUILD_TYPE="Release"
LOG_PREFIX="auto_flash"

## Function to flash with retry
flash_with_retry() {
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "Flash attempt $attempt of $max_attempts"
        
        if ./flash_app.sh flash $APP_NAME $BUILD_TYPE --log "${LOG_PREFIX}_attempt_${attempt}"; then
            echo "Flash successful on attempt $attempt"
            return 0
        fi
        
        echo "Flash failed on attempt $attempt"
        attempt=$((attempt + 1))
        sleep 5
    done
    
    echo "Flash failed after $max_attempts attempts"
    return 1
}

## Main execution
echo "Starting automated flash process"
flash_with_retry
```

### Python Integration

```python
#!/usr/bin/env python3
## Python script for ESP32 flash automation

import subprocess
import sys
import os
import time

class ESP32FlashManager:
    def __init__(self, project_path="examples/esp32"):
        self.project_path = project_path
        self.scripts_path = os.path.join(project_path, "scripts")
    
    def flash_app(self, app_name, build_type="Release", log_name=None):
        """Flash an application to ESP32 device"""
        cmd = [
            os.path.join(self.scripts_path, "flash_app.sh"),
            "flash",
            app_name,
            build_type
        ]
        
        if log_name:
            cmd.extend(["--log", log_name])
        
        try:
            result = subprocess.run(cmd, cwd=self.project_path, 
                                  capture_output=True, text=True, check=True)
            print(f"Successfully flashed {app_name} {build_type}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Flash failed: {e}")
            print(f"Error output: {e.stderr}")
            return False
    
    def monitor_device(self, log_name=None):
        """Monitor ESP32 device"""
        cmd = [os.path.join(self.scripts_path, "flash_app.sh"), "monitor"]
        
        if log_name:
            cmd.extend(["--log", log_name])
        
        try:
            subprocess.run(cmd, cwd=self.project_path, check=True)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Monitor failed: {e}")
            return False
    
    def analyze_size(self, app_name, build_type="Release"):
        """Analyze firmware size"""
        cmd = [
            os.path.join(self.scripts_path, "flash_app.sh"),
            "size",
            app_name,
            build_type
        ]
        
        try:
            result = subprocess.run(cmd, cwd=self.project_path,
                                  capture_output=True, text=True, check=True)
            print(f"Size analysis for {app_name} {build_type}:")
            print(result.stdout)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Size analysis failed: {e}")
            return False

## Usage example
if __name__ == "__main__":
    flash_manager = ESP32FlashManager()
    
    # Flash application
    if flash_manager.flash_app("gpio_test", "Release", "python_flash"):
        print("Flash successful")
        
        # Monitor device
        flash_manager.monitor_device("python_monitor")
    
    # Analyze size
    flash_manager.analyze_size("gpio_test", "Release")
```

## Testing and Validation

### Automated Testing

```bash
#!/bin/bash
## Automated testing script

## Test configuration
TEST_APPS=("gpio_test" "adc_test" "uart_test")
BUILD_TYPES=("Debug" "Release")
TEST_TIMEOUT=60

## Function to run tests
run_tests() {
    local app=$1
    local build_type=$2
    
    echo "Testing $app $build_type"
    
    ## Build application
    if ! ./build_app.sh $app $build_type; then
        echo "Build failed for $app $build_type"
        return 1
    fi
    
    ## Flash application
    if ! ./flash_app.sh flash $app $build_type --log "test_${app}_${build_type}"; then
        echo "Flash failed for $app $build_type"
        return 1
    fi
    
    ## Monitor and test
    timeout $TEST_TIMEOUT ./flash_app.sh monitor --log "test_${app}_${build_type}_monitor"
    
    echo "Test completed for $app $build_type"
    return 0
}

## Run all tests
for app in "${TEST_APPS[@]}"; do
    for build_type in "${BUILD_TYPES[@]}"; do
        run_tests $app $build_type
    done
done
```

### Validation Scripts

```bash
#!/bin/bash
## Validation script for flash operations

## Validate flash operation
validate_flash() {
    local app=$1
    local build_type=$2
    local log_file=$3
    
    echo "Validating flash operation for $app $build_type"
    
    ## Check if log file exists
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file $log_file not found"
        return 1
    fi
    
    ## Check for flash success
    if grep -q "Flash completed successfully" "$log_file"; then
        echo "Flash validation passed"
        return 0
    else
        echo "Flash validation failed"
        return 1
    fi
}

## Validate monitor operation
validate_monitor() {
    local log_file=$1
    
    echo "Validating monitor operation"
    
    ## Check if log file exists
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file $log_file not found"
        return 1
    fi
    
    ## Check for monitor success
    if grep -q "Monitor started" "$log_file"; then
        echo "Monitor validation passed"
        return 0
    else
        echo "Monitor validation failed"
        return 1
    fi
}
```

## Best Practices

### Flash Operations

- **Always Use Logging**: Enable logging for debugging and troubleshooting
- **Verify Device Connections**: Check device connections before flashing
- **Use Appropriate Build Types**: Choose correct build type for purpose
- **Test in Development**: Test flash operations in development before production

### Port Management

- **Use Automatic Port Detection**: Let the system choose the best port
- **Verify Port Permissions**: Ensure proper user group membership
- **Test Port Connectivity**: Always test port connectivity before operations
- **Handle Multiple Device Scenarios**: Use appropriate port selection logic

### Error Handling

- **Check Flash Operation Results**: Always verify flash operation results
- **Use Debug Mode**: Enable debug mode for troubleshooting
- **Analyze Logs**: Review logs for error patterns
- **Implement Proper Error Handling**: Use appropriate error handling in automation

### Performance Optimization

- **Use Appropriate Flash Parameters**: Set correct flash parameters
- **Optimize Monitor Settings**: Configure monitoring for your use case
- **Regular Log Maintenance**: Perform regular log maintenance and cleanup
- **Monitor Flash Performance**: Track flash performance and reliability

### Automation Best Practices

- **Implement Retry Logic**: Use retry logic for unreliable operations
- **Validate Operations**: Always validate operation results
- **Use Timeouts**: Implement appropriate timeouts for operations
- **Handle Errors Gracefully**: Implement proper error handling and recovery