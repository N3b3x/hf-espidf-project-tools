---
title: "Architecture"
parent: "Build System"
nav_order: 1
---

# Build System Architecture

## Overview

The HardFOC ESP32 Build System is designed with a decoupled architecture that supports both project-integrated and portable usage modes. This design provides flexibility while maintaining consistency across different development environments.

## Decoupled Design

The build system follows a modular approach where each component has a specific responsibility:

- **Core Scripts**: Handle the main build operations
- **Configuration Discovery**: Automatically detect and load configuration
- **Environment Setup**: Manage ESP-IDF and toolchain setup
- **Validation System**: Ensure configuration consistency and validity

## Core Scripts

### Primary Scripts

- **`build_app.sh`**: Main build orchestrator
- **`flash_app.sh`**: Firmware flashing and monitoring
- **`config_loader.sh`**: Configuration management and validation

### Supporting Scripts

- **`setup_common.sh`**: Shared environment setup utilities
- **`setup_repo.sh`**: Local repository setup
- **`manage_idf.sh`**: ESP-IDF version management
- **`detect_ports.sh`**: Port detection and validation
- **`manage_logs.sh`**: Log management and analysis

## Configuration Discovery

The system uses a hierarchical configuration discovery process:

1. **Primary Method**: YAML parsing with `yq`
2. **Fallback Method**: `grep` and `sed` for basic parsing
3. **Environment Variables**: Override configuration values
4. **Smart Defaults**: Provide sensible defaults when configuration is missing

## New Environment Setup Architecture

### Local Development
- Uses `setup_repo.sh` for local environment setup
- Installs required tools and dependencies
- Configures environment variables
- Sets up ESP-IDF toolchain

### CI/CD Environment
- Uses Direct ESP-IDF CI action
- Leverages GitHub Actions for environment setup
- Optimized for CI/CD workflows
- Minimal local dependencies

## Script Categories

### Build Scripts
- `build_app.sh`: Main build orchestrator
- `flash_app.sh`: Firmware flashing and monitoring

### Setup Scripts
- `setup_common.sh`: Shared utilities
- `setup_repo.sh`: Local setup
- Direct ESP-IDF CI action: CI setup

### Utility Scripts
- `config_loader.sh`: Configuration management
- `manage_idf.sh`: ESP-IDF version management
- `detect_ports.sh`: Port detection
- `manage_logs.sh`: Log management

### Configuration Scripts
- `generate_matrix.py`: CI matrix generation
- `get_app_info.py`: Application information retrieval
- `app_config.yml`: Centralized configuration

## Integration Points

The build system integrates with:

- **ESP-IDF Toolchain**: Multi-version support
- **GitHub Actions**: CI/CD workflows
- **Logging System**: Comprehensive logging
- **Port Detection**: Automatic device detection
- **Configuration System**: Centralized configuration management

## Benefits of This Architecture

1. **Modularity**: Each component has a specific responsibility
2. **Flexibility**: Supports multiple usage modes
3. **Maintainability**: Easy to update individual components
4. **Scalability**: Can be extended with new features
5. **Consistency**: Uniform behavior across different environments