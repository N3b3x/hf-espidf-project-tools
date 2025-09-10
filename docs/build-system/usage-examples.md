---
title: "Usage Examples"
parent: "Build System"
nav_order: 4
---

# Usage Examples

## Basic Usage

### Project-Integrated Mode

```bash
# Build a specific application
./build_app.sh my_app release esp32

# Build with custom configuration
./build_app.sh my_app debug esp32s2 --config custom_config

# Clean build
./build_app.sh my_app release esp32 --clean

# Build with verbose output
./build_app.sh my_app release esp32 --verbose
```

### Portable Mode

```bash
# Use portable mode
./build_app.sh --portable my_app release esp32

# Build with custom ESP-IDF version
./build_app.sh --portable my_app release esp32 --idf-version v4.4.2

# Build with custom build directory
./build_app.sh --portable my_app release esp32 --build-dir /tmp/build
```

## Advanced Usage

### Multi-Version ESP-IDF

```bash
# List available ESP-IDF versions
./manage_idf.sh list

# Install specific ESP-IDF version
./manage_idf.sh install v4.4.2

# Switch to specific version
./manage_idf.sh switch v4.4.2

# Build with specific version
./build_app.sh my_app release esp32 --idf-version v4.4.2
```

### Custom Build Types

```bash
# Build with custom build type
./build_app.sh my_app custom esp32 --build-type production

# Build with multiple configurations
./build_app.sh my_app release esp32 --config config1,config2

# Build with custom CMake options
./build_app.sh my_app release esp32 --cmake-options "-DOPTION1=ON -DOPTION2=OFF"
```

### Flash Operations

```bash
# Flash firmware
./flash_app.sh flash my_app release esp32

# Monitor device output
./flash_app.sh monitor my_app release esp32

# Flash and monitor
./flash_app.sh flash_monitor my_app release esp32

# Show firmware size
./flash_app.sh size my_app release esp32
```

## Configuration Examples

### Basic Configuration

```yaml
# app_config.yml
metadata:
  name: "My ESP32 Project"
  version: "1.0.0"
  description: "ESP32 project with HardFOC tools"

apps:
  my_app:
    name: "My Application"
    path: "apps/my_app"
    description: "Main application"
    build_types:
      - release
      - debug
    targets:
      - esp32
      - esp32s2

build_config:
  default_idf_version: "v4.4.2"
  default_build_type: "release"
  default_target: "esp32"
  build_dir: "build"
  log_dir: "logs"
```

### Advanced Configuration

```yaml
# app_config.yml
metadata:
  name: "Advanced ESP32 Project"
  version: "2.0.0"
  description: "Advanced ESP32 project with multiple configurations"

apps:
  sensor_app:
    name: "Sensor Application"
    path: "apps/sensor"
    description: "IoT sensor application"
    build_types:
      - release
      - debug
      - production
    targets:
      - esp32
      - esp32s2
      - esp32c3
    configurations:
      - default
      - low_power
      - high_performance

  control_app:
    name: "Control Application"
    path: "apps/control"
    description: "Control system application"
    build_types:
      - release
      - debug
    targets:
      - esp32
      - esp32s2
    configurations:
      - default
      - safety_critical

build_config:
  default_idf_version: "v4.4.2"
  default_build_type: "release"
  default_target: "esp32"
  build_dir: "build"
  log_dir: "logs"
  cache_dir: "cache"
  
  # Build options
  parallel_jobs: 4
  verbose_build: false
  clean_build: false
  
  # Flash options
  flash_port: "auto"
  flash_baud: 921600
  flash_mode: "dio"
  flash_freq: "80m"
  flash_size: "4MB"
```

## CI/CD Examples

### GitHub Actions Workflow

```yaml
# .github/workflows/build.yml
name: ESP32 Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        include:
          - app: sensor_app
            build_type: release
            target: esp32
          - app: sensor_app
            build_type: debug
            target: esp32s2
          - app: control_app
            build_type: release
            target: esp32
            config: safety_critical

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup ESP-IDF
        uses: espressif/esp-idf-ci-action@v1
        with:
          esp_idf_version: v4.4.2
          target: ${{ matrix.target }}
      
      - name: Build Application
        run: |
          ./build_app.sh ${{ matrix.app }} ${{ matrix.build_type }} ${{ matrix.target }}
          if [ -n "${{ matrix.config }}" ]; then
            ./build_app.sh ${{ matrix.app }} ${{ matrix.build_type }} ${{ matrix.target }} --config ${{ matrix.config }}
          fi
      
      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ${{ matrix.app }}-${{ matrix.build_type }}-${{ matrix.target }}
          path: build/${{ matrix.app }}/${{ matrix.build_type }}/${{ matrix.target }}/
```

### Matrix Generation

```bash
# Generate build matrix
python generate_matrix.py --output matrix.json

# Generate matrix with specific options
python generate_matrix.py --output matrix.json --include-debug --include-production

# Generate matrix for specific apps
python generate_matrix.py --output matrix.json --apps sensor_app,control_app
```

## Troubleshooting Examples

### Common Issues

```bash
# Check configuration
./config_loader.sh validate

# Check environment
./setup_common.sh check-environment

# Check tools
./setup_common.sh check-tools

# Check ports
./detect_ports.sh --list

# Check logs
./manage_logs.sh list
./manage_logs.sh analyze
```

### Debug Mode

```bash
# Enable debug mode
export DEBUG=1

# Build with debug output
./build_app.sh my_app release esp32 --debug

# Flash with debug output
./flash_app.sh flash my_app release esp32 --debug

# Check debug logs
./manage_logs.sh analyze --debug
```

### Environment Issues

```bash
# Check ESP-IDF installation
./manage_idf.sh list
./manage_idf.sh switch v4.4.2

# Check environment variables
env | grep IDF
env | grep ESP

# Reinstall tools
./setup_repo.sh --force
```

## Best Practices

### Configuration Management
- Use version control for configuration files
- Document configuration changes
- Use environment-specific configurations
- Validate configuration before building

### Build Management
- Use clean builds for release builds
- Enable caching for development builds
- Use parallel builds for faster compilation
- Monitor build logs for issues

### CI/CD Integration
- Use matrix builds for comprehensive testing
- Cache dependencies and build artifacts
- Use appropriate build types for different environments
- Monitor build performance and optimize accordingly

### Logging and Monitoring
- Enable comprehensive logging
- Use log rotation to manage disk space
- Monitor build performance
- Use log analysis for troubleshooting