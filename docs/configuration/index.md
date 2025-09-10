---
layout: default
title: "Configuration System"
description: "ESP32 configuration system with YAML management, validation, and smart defaults"
has_children: true
nav_order: 5
permalink: /configuration/
---

# ESP32 Configuration System Guide

The ESP32 configuration system provides centralized, intelligent configuration management for all scripts in the HardFOC Interface Wrapper project. It features YAML-based configuration, automatic validation, intelligent fallbacks, and cross-platform compatibility.

## Core Features

- **Centralized Configuration**: Single YAML file manages all script behavior
- **Enhanced Validation**: Smart combination validation and error prevention
- **Smart Defaults**: Automatic ESP-IDF version selection based on app and build type
- **Smart Fallbacks**: Graceful degradation when configuration is incomplete
- **Cross-Platform**: Consistent behavior across Linux and macOS
- **Environment Integration**: Environment variable overrides and customization

## Key Capabilities

- YAML configuration parsing with `yq` and fallback methods
- **Smart combination validation** - Prevents invalid app + build type + IDF version combinations
- **Automatic ESP-IDF version selection** - Chooses the right version when not specified
- Application and build type validation
- ESP-IDF version compatibility checking
- Environment variable override support
- Configuration integrity validation
- Cross-script configuration sharing

## Quick Start

### Basic Configuration
```yaml
# app_config.yml
metadata:
  name: "My ESP32 Project"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"

apps:
  sensor_app:
    source_file: "SensorApp.cpp"
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

### Environment Variables
```bash
# Override configuration values
export CONFIG_DEFAULT_APP="sensor_app"
export CONFIG_DEFAULT_BUILD_TYPE="Debug"
export CONFIG_DEFAULT_TARGET="esp32s2"
```

## Documentation Sections

- **[YAML Structure](yaml-structure/)**: Configuration file structure and schema
- **[Loading Process](loading-process/)**: Configuration loading and validation process
- **[Environment Variables](environment-variables/)**: Environment variable overrides and customization
- **[Usage Examples](usage-examples/)**: Practical configuration examples and patterns