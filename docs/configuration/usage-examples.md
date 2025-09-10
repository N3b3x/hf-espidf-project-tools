---
title: "Usage Examples"
parent: "Configuration"
nav_order: 4
---

# Configuration Usage Examples

## Overview

This section provides practical examples of how to use the HardFOC ESP32 CI Tools configuration system in various scenarios.

## Basic Configuration Examples

### Minimal Project Configuration

For a simple ESP32 project with basic requirements:

```yaml
# app_config.yml
metadata:
  name: "Simple ESP32 Project"
  default_app: "main_app"
  default_build_type: "Release"
  default_target: "esp32"

apps:
  main_app:
    source_file: "main.cpp"
    build_types: ["Debug", "Release"]
    targets: ["esp32"]

build_config:
  build_types:
    Debug:
      cmake_build_type: "Debug"
      optimization: "-O0"
    Release:
      cmake_build_type: "Release"
      optimization: "-O2"
```

### Multi-Application Project

For a project with multiple applications:

```yaml
# app_config.yml
metadata:
  name: "Multi-App ESP32 Project"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2", "v5.0.0"]

apps:
  sensor_app:
    name: "Sensor Application"
    description: "IoT sensor data collection"
    path: "apps/sensor"
    source_file: "SensorApp.cpp"
    category: "iot"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: true

  control_app:
    name: "Control Application"
    description: "Device control and automation"
    path: "apps/control"
    source_file: "ControlApp.cpp"
    category: "control"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2"]
    ci_enabled: true
    featured: false

  test_app:
    name: "Test Application"
    description: "Unit and integration tests"
    path: "apps/test"
    source_file: "TestApp.cpp"
    category: "testing"
    build_types: ["Debug"]
    targets: ["esp32"]
    idf_versions: ["v4.4.2"]
    ci_enabled: false
    featured: false

build_config:
  build_types:
    Debug:
      description: "Debug build with symbols"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG", "VERBOSE_LOGGING"]
      assertions: true
      warnings: "all"
      sanitizers: ["address", "undefined"]
    
    Release:
      description: "Optimized build for production"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g"
      defines: ["NDEBUG"]
      assertions: false
      warnings: "all"
      sanitizers: []
  
  build_directory_pattern: "build_{app_type}_{build_type}_{target}"
  project_name_pattern: "esp32_{app_type}_{build_type}"
  parallel_jobs: 4
  verbose_build: false
  clean_build: false
```

## Advanced Configuration Examples

### Production-Ready Configuration

For a production-ready ESP32 project with comprehensive settings:

```yaml
# app_config.yml
metadata:
  name: "Production ESP32 Project"
  version: "2.0.0"
  description: "Production-ready ESP32 project with comprehensive CI/CD"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2", "v5.0.0", "v5.1.0"]

apps:
  sensor_app:
    name: "Sensor Application"
    description: "IoT sensor data collection and processing"
    path: "apps/sensor"
    source_file: "SensorApp.cpp"
    category: "iot"
    build_types: ["Debug", "Release", "Production"]
    targets: ["esp32", "esp32s2", "esp32c3"]
    idf_versions: ["v4.4.2", "v5.0.0", "v5.1.0"]
    ci_enabled: true
    featured: true
    configurations:
      - default
      - low_power
      - high_performance
      - battery_optimized

  control_app:
    name: "Control Application"
    description: "Device control and automation system"
    path: "apps/control"
    source_file: "ControlApp.cpp"
    category: "control"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: true
    configurations:
      - default
      - safety_critical
      - high_reliability

  gateway_app:
    name: "Gateway Application"
    description: "IoT gateway and protocol translation"
    path: "apps/gateway"
    source_file: "GatewayApp.cpp"
    category: "gateway"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2", "esp32s3"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: false
    configurations:
      - default
      - high_throughput
      - low_latency

build_config:
  build_types:
    Debug:
      description: "Debug build with symbols and verbose logging"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG", "VERBOSE_LOGGING", "ENABLE_ASSERTIONS"]
      assertions: true
      warnings: "all"
      sanitizers: ["address", "undefined", "leak"]
      coverage: true
    
    Release:
      description: "Optimized build for production deployment"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g"
      defines: ["NDEBUG", "PRODUCTION"]
      assertions: false
      warnings: "all"
      sanitizers: []
      coverage: false
    
    Production:
      description: "Maximum optimization for production"
      cmake_build_type: "Release"
      optimization: "-Os"
      debug_level: ""
      defines: ["NDEBUG", "PRODUCTION", "MAXIMUM_OPTIMIZATION"]
      assertions: false
      warnings: "all"
      sanitizers: []
      coverage: false
  
  build_directory_pattern: "build_{app_type}_{build_type}_{target}_{idf_version}"
  project_name_pattern: "esp32_{app_type}_{build_type}"
  parallel_jobs: 8
  verbose_build: false
  clean_build: false
  use_ccache: true
  ccache_max_size: "2GB"

flash_config:
  default_port: "auto"
  default_baud: 921600
  default_mode: "dio"
  default_freq: "80m"
  default_size: "4MB"
  
  ports:
    linux: ["/dev/ttyUSB*", "/dev/ttyACM*"]
    macos: ["/dev/cu.usbserial*", "/dev/cu.usbmodem*"]
    windows: ["COM*"]
  
  baud_rates: [115200, 230400, 460800, 921600, 1500000, 2000000]
  flash_modes: ["qio", "qout", "dio", "dout"]
  flash_freqs: ["40m", "26m", "20m", "80m"]
  flash_sizes: ["1MB", "2MB", "4MB", "8MB", "16MB", "32MB"]

system_config:
  logging:
    level: "INFO"
    directory: "logs"
    max_files: 1000
    max_size: "100MB"
    rotation: "daily"
    compression: true
  
  caching:
    enabled: true
    directory: "cache"
    max_size: "5GB"
    cleanup_interval: "weekly"
    compression: true
  
  environment:
    setup_script: "setup_common.sh"
    idf_script: "setup_repo.sh"
    python_requirements: "requirements.txt"
    python_version: "3.11"
  
  ci_cd:
    matrix_generation: true
    parallel_builds: true
    artifact_upload: true
    notification_enabled: true
    security_scanning: true
    performance_testing: true
```

## Environment Variable Examples

### Development Environment

```bash
# development.env
export CONFIG_DEBUG="true"
export CONFIG_VERBOSE="true"
export CONFIG_LOG_LEVEL="DEBUG"
export CONFIG_DEFAULT_BUILD_TYPE="Debug"
export CONFIG_USE_CACHE="true"
export CONFIG_CLEAN_BUILD="false"
export CONFIG_PARALLEL_JOBS="4"
export CONFIG_VERBOSE_BUILD="true"
export CONFIG_ENABLE_SANITIZERS="true"
export CONFIG_ENABLE_COVERAGE="true"
```

### Production Environment

```bash
# production.env
export CONFIG_DEBUG="false"
export CONFIG_VERBOSE="false"
export CONFIG_LOG_LEVEL="INFO"
export CONFIG_DEFAULT_BUILD_TYPE="Release"
export CONFIG_USE_CACHE="true"
export CONFIG_CLEAN_BUILD="true"
export CONFIG_PARALLEL_JOBS="8"
export CONFIG_VERBOSE_BUILD="false"
export CONFIG_ENABLE_SANITIZERS="false"
export CONFIG_ENABLE_COVERAGE="false"
```

### CI/CD Environment

```bash
# ci-cd.env
export CI="true"
export GITHUB_ACTIONS="true"
export RUNNER_OS="ubuntu-latest"
export CONFIG_CI_MATRIX_GENERATION="true"
export CONFIG_CI_PARALLEL_BUILDS="true"
export CONFIG_CI_ARTIFACT_UPLOAD="true"
export CONFIG_CI_NOTIFICATION_ENABLED="true"
export CONFIG_CI_SECURITY_SCANNING="true"
export CONFIG_CI_PERFORMANCE_TESTING="true"
export CONFIG_CI_COVERAGE_REPORTING="true"
```

## Configuration Scripts

### Configuration Validation Script

```bash
#!/bin/bash
# validate_config.sh

set -e

echo "Validating configuration..."

# Check if configuration file exists
if [[ ! -f "app_config.yml" ]]; then
    echo "Error: app_config.yml not found"
    exit 1
fi

# Validate YAML syntax
if command -v yq >/dev/null 2>&1; then
    if ! yq eval '.' app_config.yml >/dev/null 2>&1; then
        echo "Error: Invalid YAML syntax in app_config.yml"
        exit 1
    fi
fi

# Validate required fields
validate_required_field "metadata.name"
validate_required_field "metadata.default_app"
validate_required_field "metadata.default_build_type"
validate_required_field "metadata.default_target"

# Validate applications
for app in $(get_app_list); do
    echo "Validating application: $app"
    validate_app_field "$app" "source_file"
    validate_app_field "$app" "build_types"
    validate_app_field "$app" "targets"
done

# Validate build types
for build_type in $(get_build_type_list); do
    echo "Validating build type: $build_type"
    validate_build_type_field "$build_type" "cmake_build_type"
    validate_build_type_field "$build_type" "optimization"
done

echo "Configuration validation completed successfully"
```

### Configuration Generation Script

```bash
#!/bin/bash
# generate_config.sh

set -e

echo "Generating configuration..."

# Create basic configuration
cat > app_config.yml << EOF
metadata:
  name: "Generated ESP32 Project"
  version: "1.0.0"
  description: "Auto-generated ESP32 project configuration"
  default_app: "main_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2"]

apps:
  main_app:
    name: "Main Application"
    description: "Main application"
    source_file: "main.cpp"
    category: "main"
    build_types: ["Debug", "Release"]
    targets: ["esp32"]
    idf_versions: ["v4.4.2"]
    ci_enabled: true
    featured: true

build_config:
  build_types:
    Debug:
      description: "Debug build with symbols"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG"]
      assertions: true
    
    Release:
      description: "Optimized build for production"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g"
      defines: ["NDEBUG"]
      assertions: false
  
  build_directory_pattern: "build_{app_type}_{build_type}_{target}"
  project_name_pattern: "esp32_{app_type}_{build_type}"
  parallel_jobs: 4
  verbose_build: false
  clean_build: false
EOF

echo "Configuration generated: app_config.yml"
```

## CI/CD Integration Examples

### GitHub Actions Workflow

```yaml
# .github/workflows/build.yml
name: ESP32 Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  ESP32_PROJECT_PATH: "/examples/esp32"
  CONFIG_CI_MATRIX_GENERATION: "true"
  CONFIG_CI_PARALLEL_BUILDS: "true"
  CONFIG_CI_ARTIFACT_UPLOAD: "true"

jobs:
  generate-matrix:
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.generate-matrix.outputs.matrix }}
    steps:
      - uses: actions/checkout@v3
      - name: Generate Build Matrix
        run: |
          python3 generate_matrix.py --output matrix.json
          echo "matrix=$(cat matrix.json)" >> $GITHUB_OUTPUT

  build:
    needs: generate-matrix
    runs-on: ubuntu-latest
    strategy:
      matrix: ${{ fromJson(needs.generate-matrix.outputs.matrix) }}
    steps:
      - uses: actions/checkout@v3
      - name: Setup ESP-IDF
        uses: espressif/esp-idf-ci-action@v1
        with:
          esp_idf_version: ${{ matrix.idf_version }}
          target: ${{ matrix.target }}
      - name: Build Application
        run: |
          ./build_app.sh ${{ matrix.app }} ${{ matrix.build_type }} ${{ matrix.target }}
      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ${{ matrix.app }}-${{ matrix.build_type }}-${{ matrix.target }}
          path: build/${{ matrix.app }}/${{ matrix.build_type }}/${{ matrix.target }}/
```

### Matrix Generation Script

```python
#!/usr/bin/env python3
# generate_matrix.py

import yaml
import json
import sys
import argparse

def load_config(config_file):
    """Load configuration from YAML file"""
    with open(config_file, 'r') as f:
        return yaml.safe_load(f)

def generate_matrix(config):
    """Generate build matrix from configuration"""
    matrix = []
    
    for app_name, app_config in config['apps'].items():
        if not app_config.get('ci_enabled', True):
            continue
            
        for build_type in app_config.get('build_types', []):
            for target in app_config.get('targets', []):
                for idf_version in app_config.get('idf_versions', []):
                    matrix.append({
                        'app': app_name,
                        'build_type': build_type,
                        'target': target,
                        'idf_version': idf_version,
                        'idf_version_docker': idf_version.replace('v', ''),
                        'app_name': app_config.get('name', app_name),
                        'description': app_config.get('description', ''),
                        'category': app_config.get('category', ''),
                        'featured': app_config.get('featured', False)
                    })
    
    return matrix

def main():
    parser = argparse.ArgumentParser(description='Generate ESP32 build matrix')
    parser.add_argument('--config', default='app_config.yml', help='Configuration file')
    parser.add_argument('--output', help='Output file (default: stdout)')
    args = parser.parse_args()
    
    # Load configuration
    config = load_config(args.config)
    
    # Generate matrix
    matrix = generate_matrix(config)
    
    # Output matrix
    if args.output:
        with open(args.output, 'w') as f:
            json.dump(matrix, f, indent=2)
    else:
        print(json.dumps(matrix, indent=2))

if __name__ == '__main__':
    main()
```

## Troubleshooting Examples

### Common Configuration Issues

#### Missing Required Fields
```bash
# Check for missing required fields
check_required_fields() {
    local config_file="$1"
    
    echo "Checking required fields..."
    
    # Check metadata fields
    if ! yq eval '.metadata.name' "$config_file" >/dev/null 2>&1; then
        echo "Error: metadata.name is missing"
        return 1
    fi
    
    if ! yq eval '.metadata.default_app' "$config_file" >/dev/null 2>&1; then
        echo "Error: metadata.default_app is missing"
        return 1
    fi
    
    # Check apps section
    if ! yq eval '.apps' "$config_file" >/dev/null 2>&1; then
        echo "Error: apps section is missing"
        return 1
    fi
    
    echo "All required fields are present"
}
```

#### Invalid Application Definitions
```bash
# Validate application definitions
validate_applications() {
    local config_file="$1"
    
    echo "Validating applications..."
    
    for app in $(yq eval '.apps | keys | .[]' "$config_file"); do
        echo "Validating app: $app"
        
        # Check required fields
        if ! yq eval ".apps.$app.source_file" "$config_file" >/dev/null 2>&1; then
            echo "Error: $app is missing source_file"
            return 1
        fi
        
        if ! yq eval ".apps.$app.build_types" "$config_file" >/dev/null 2>&1; then
            echo "Error: $app is missing build_types"
            return 1
        fi
        
        if ! yq eval ".apps.$app.targets" "$config_file" >/dev/null 2>&1; then
            echo "Error: $app is missing targets"
            return 1
        fi
    done
    
    echo "All applications are valid"
}
```

#### Configuration File Repair
```bash
# Repair configuration file
repair_config() {
    local config_file="$1"
    local backup_file="${config_file}.backup"
    
    echo "Repairing configuration file: $config_file"
    
    # Create backup
    cp "$config_file" "$backup_file"
    echo "Backup created: $backup_file"
    
    # Basic repairs
    if ! yq eval '.' "$config_file" >/dev/null 2>&1; then
        echo "Attempting basic YAML repair..."
        
        # Remove trailing commas
        sed -i 's/,$//' "$config_file"
        
        # Fix common YAML issues
        sed -i 's/^[[:space:]]*$//' "$config_file"
        
        # Validate again
        if yq eval '.' "$config_file" >/dev/null 2>&1; then
            echo "Configuration repaired successfully"
        else
            echo "Error: Could not repair configuration"
            return 1
        fi
    fi
}
```

## Best Practices

### Configuration Management

1. **Version Control**: Keep configuration files in version control
2. **Documentation**: Document configuration changes
3. **Validation**: Validate configuration before deployment
4. **Backup**: Create backups before major changes

### Environment Variables

1. **Consistent Naming**: Use consistent naming conventions
2. **Documentation**: Document all environment variables
3. **Validation**: Validate environment variable values
4. **Default Values**: Provide sensible default values

### CI/CD Integration

1. **Matrix Generation**: Use automated matrix generation
2. **Parallel Builds**: Enable parallel builds for efficiency
3. **Artifact Management**: Properly manage build artifacts
4. **Notification**: Set up appropriate notifications