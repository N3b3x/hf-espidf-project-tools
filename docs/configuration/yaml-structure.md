---
title: "YAML Structure"
parent: "Configuration"
nav_order: 1
---

# YAML Configuration Structure

## Overview

The HardFOC ESP32 CI Tools use a centralized YAML configuration system that defines all aspects of the build process, from application definitions to build parameters and system settings.

## Configuration File Location

The main configuration file is `app_config.yml` and should be located in your project root or specified via the `CONFIG_FILE` environment variable.

## File Structure

### Metadata Section

The metadata section contains global project information and default values:

```yaml
metadata:
  name: "ESP32 Project"
  version: "1.0.0"
  description: "ESP32 project with HardFOC CI Tools"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2", "v5.0.0"]
  target: "esp32c6"
```

**Key Fields**:
- **`name`**: Project name
- **`version`**: Project version
- **`description`**: Project description
- **`default_app`**: Default application to build
- **`default_build_type`**: Default build configuration
- **`default_target`**: Default ESP32 target
- **`idf_versions`**: Supported ESP-IDF versions
- **`target`**: Target MCU architecture

### Applications Section

The applications section defines all available applications and their configurations:

```yaml
apps:
  sensor_app:
    name: "Sensor Application"
    description: "IoT sensor application"
    path: "apps/sensor"
    source_file: "SensorApp.cpp"
    category: "iot"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: true
    configurations:
      - default
      - low_power
      - high_performance

  control_app:
    name: "Control Application"
    description: "Control system application"
    path: "apps/control"
    source_file: "ControlApp.cpp"
    category: "control"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2"]
    ci_enabled: true
    featured: false
    configurations:
      - default
      - safety_critical
```

**Key Fields**:
- **`name`**: Application display name
- **`description`**: Application description
- **`path`**: Path to application directory
- **`source_file`**: Main source file name
- **`category`**: Application category
- **`build_types`**: Supported build types
- **`targets`**: Supported ESP32 targets
- **`idf_versions`**: Compatible ESP-IDF versions
- **`ci_enabled`**: Include in CI builds
- **`featured`**: Show in featured applications
- **`configurations`**: Available configurations

### Build Configuration Section

The build configuration section defines build types and their parameters:

```yaml
build_config:
  build_types:
    Debug:
      description: "Debug build with symbols and verbose logging"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG", "VERBOSE_LOGGING"]
      assertions: true
      warnings: "all"
      sanitizers: ["address", "undefined"]
    
    Release:
      description: "Optimized build for production deployment"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g"
      defines: ["NDEBUG"]
      assertions: false
      warnings: "all"
      sanitizers: []
    
    Production:
      description: "Maximum optimization for production"
      cmake_build_type: "Release"
      optimization: "-Os"
      debug_level: ""
      defines: ["NDEBUG", "PRODUCTION"]
      assertions: false
      warnings: "all"
      sanitizers: []
  
  build_directory_pattern: "build_{app_type}_{build_type}_{target}"
  project_name_pattern: "esp32_{app_type}_{build_type}"
  parallel_jobs: 4
  verbose_build: false
  clean_build: false
```

**Key Fields**:
- **`build_types`**: Build type definitions
- **`build_directory_pattern`**: Build directory naming pattern
- **`project_name_pattern`**: Project name pattern
- **`parallel_jobs`**: Number of parallel build jobs
- **`verbose_build`**: Enable verbose build output
- **`clean_build`**: Force clean build

### Flash Configuration Section

The flash configuration section defines flash operation parameters:

```yaml
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
  
  baud_rates: [115200, 230400, 460800, 921600, 1500000]
  flash_modes: ["qio", "qout", "dio", "dout"]
  flash_freqs: ["40m", "26m", "20m", "80m"]
  flash_sizes: ["1MB", "2MB", "4MB", "8MB", "16MB"]
```

**Key Fields**:
- **`default_port`**: Default serial port
- **`default_baud`**: Default baud rate
- **`default_mode`**: Default flash mode
- **`default_freq`**: Default flash frequency
- **`default_size`**: Default flash size
- **`ports`**: Platform-specific port patterns
- **`baud_rates`**: Supported baud rates
- **`flash_modes`**: Supported flash modes
- **`flash_freqs`**: Supported flash frequencies
- **`flash_sizes`**: Supported flash sizes

### System Configuration Section

The system configuration section defines system-level settings:

```yaml
system_config:
  logging:
    level: "INFO"
    directory: "logs"
    max_files: 100
    max_size: "10MB"
    rotation: "daily"
  
  caching:
    enabled: true
    directory: "cache"
    max_size: "1GB"
    cleanup_interval: "weekly"
  
  environment:
    setup_script: "setup_common.sh"
    idf_script: "setup_repo.sh"
    python_requirements: "requirements.txt"
  
  ci_cd:
    matrix_generation: true
    parallel_builds: true
    artifact_upload: true
    notification_enabled: true
```

**Key Fields**:
- **`logging`**: Logging configuration
- **`caching`**: Caching configuration
- **`environment`**: Environment setup configuration
- **`ci_cd`**: CI/CD configuration

## Configuration Validation

### Required Fields

The following fields are required in the configuration:

- **`metadata.name`**: Project name
- **`metadata.default_app`**: Default application
- **`metadata.default_build_type`**: Default build type
- **`metadata.default_target`**: Default target
- **`apps`**: At least one application definition
- **`build_config.build_types`**: At least one build type

### Optional Fields

The following fields are optional and have default values:

- **`metadata.version`**: Defaults to "1.0.0"
- **`metadata.description`**: Defaults to project name
- **`metadata.idf_versions`**: Defaults to ["v4.4.2"]
- **`flash_config`**: Uses system defaults
- **`system_config`**: Uses system defaults

### Validation Rules

1. **Application Names**: Must be unique and valid identifiers
2. **Build Types**: Must be supported by the build system
3. **Targets**: Must be valid ESP32 targets
4. **ESP-IDF Versions**: Must be valid version strings
5. **Paths**: Must be valid file system paths
6. **Categories**: Must be valid category names

## Configuration Examples

### Minimal Configuration

```yaml
metadata:
  name: "My ESP32 Project"
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

### Advanced Configuration

```yaml
metadata:
  name: "Advanced ESP32 Project"
  version: "2.0.0"
  description: "Advanced ESP32 project with multiple configurations"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2", "v5.0.0"]

apps:
  sensor_app:
    name: "Sensor Application"
    description: "IoT sensor application"
    path: "apps/sensor"
    source_file: "SensorApp.cpp"
    category: "iot"
    build_types: ["Debug", "Release", "Production"]
    targets: ["esp32", "esp32s2", "esp32c3"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: true
    configurations:
      - default
      - low_power
      - high_performance

  control_app:
    name: "Control Application"
    description: "Control system application"
    path: "apps/control"
    source_file: "ControlApp.cpp"
    category: "control"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2"]
    ci_enabled: true
    featured: false
    configurations:
      - default
      - safety_critical

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
    
    Production:
      description: "Maximum optimization for production"
      cmake_build_type: "Release"
      optimization: "-Os"
      debug_level: ""
      defines: ["NDEBUG", "PRODUCTION"]
      assertions: false
      warnings: "all"
      sanitizers: []
  
  build_directory_pattern: "build_{app_type}_{build_type}_{target}"
  project_name_pattern: "esp32_{app_type}_{build_type}"
  parallel_jobs: 4
  verbose_build: false
  clean_build: false

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
  
  baud_rates: [115200, 230400, 460800, 921600, 1500000]
  flash_modes: ["qio", "qout", "dio", "dout"]
  flash_freqs: ["40m", "26m", "20m", "80m"]
  flash_sizes: ["1MB", "2MB", "4MB", "8MB", "16MB"]

system_config:
  logging:
    level: "INFO"
    directory: "logs"
    max_files: 100
    max_size: "10MB"
    rotation: "daily"
  
  caching:
    enabled: true
    directory: "cache"
    max_size: "1GB"
    cleanup_interval: "weekly"
  
  environment:
    setup_script: "setup_common.sh"
    idf_script: "setup_repo.sh"
    python_requirements: "requirements.txt"
  
  ci_cd:
    matrix_generation: true
    parallel_builds: true
    artifact_upload: true
    notification_enabled: true
```

## Best Practices

### Configuration Organization

1. **Logical Grouping**: Group related settings together
2. **Clear Naming**: Use descriptive names for applications and configurations
3. **Consistent Structure**: Maintain consistent structure across sections
4. **Documentation**: Include descriptions for complex configurations

### Application Definitions

1. **Unique Names**: Ensure application names are unique
2. **Complete Information**: Provide complete application information
3. **Supported Combinations**: Only define supported build type/target combinations
4. **CI Integration**: Set appropriate CI flags

### Build Configuration

1. **Appropriate Optimization**: Use appropriate optimization levels
2. **Debug Information**: Include appropriate debug information
3. **Warnings**: Enable appropriate warnings
4. **Sanitizers**: Use sanitizers for development builds

### System Configuration

1. **Resource Management**: Set appropriate resource limits
2. **Logging**: Configure appropriate logging levels
3. **Caching**: Enable caching for performance
4. **CI/CD**: Configure CI/CD settings appropriately