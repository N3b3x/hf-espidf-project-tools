---
title: "Script Reference"
parent: "Build System"
nav_order: 3
---

# Script Reference

## File Structure

The build system consists of several key scripts organized by functionality:

```
build_app.sh          # Main build orchestrator
flash_app.sh          # Firmware flashing and monitoring
config_loader.sh      # Configuration management
setup_common.sh       # Shared environment setup utilities
setup_repo.sh         # Local repository setup
manage_idf.sh         # ESP-IDF version management
detect_ports.sh       # Port detection and validation
manage_logs.sh        # Log management and analysis
generate_matrix.py    # CI matrix generation
get_app_info.py       # Application information retrieval
```

## Dependencies

### Required Tools
- **`yq`**: YAML processor for configuration parsing
- **`jq`**: JSON processor for data manipulation
- **`grep`**: Text search utility
- **`sed`**: Stream editor for text manipulation
- **`awk`**: Text processing utility
- **`curl`**: HTTP client for downloads
- **`wget`**: Alternative HTTP client
- **`git`**: Version control system
- **`cmake`**: Build system generator
- **`ninja`**: Build system
- **`ccache`**: Compiler cache

### Python Dependencies
- **`pyyaml`**: YAML parsing library
- **`esptool`**: ESP32 toolchain utilities
- **`pyserial`**: Serial communication library
- **`esp-idf-kconfig`**: ESP-IDF configuration utilities
- **`esp-idf-size`**: ESP-IDF size analysis utilities

## Core Scripts

### build_app.sh

**Purpose**: Main build orchestrator for ESP32 applications

**Key Features**:
- Dual-mode operation (project-integrated and portable)
- Multi-version ESP-IDF support
- Intelligent configuration discovery
- Build caching with ccache
- Comprehensive validation
- Structured output with build statistics

**Usage**:
```bash
./build_app.sh [OPTIONS] [APP_NAME] [BUILD_TYPE] [TARGET]
```

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-c, --clean`: Clean build directory
- `-j, --jobs N`: Set number of parallel jobs
- `-p, --portable`: Use portable mode
- `-i, --integrated`: Use project-integrated mode

### flash_app.sh

**Purpose**: ESP32 firmware flashing and monitoring

**Key Features**:
- Intelligent port detection
- Multiple flash operations (flash, monitor, flash_monitor, size)
- Cross-platform device detection
- Comprehensive error handling
- Integration with logging system

**Usage**:
```bash
./flash_app.sh [OPTIONS] [OPERATION] [APP_NAME] [BUILD_TYPE] [TARGET]
```

**Operations**:
- `flash`: Flash firmware to device
- `monitor`: Monitor device output
- `flash_monitor`: Flash and monitor
- `size`: Show firmware size information

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-p, --port PORT`: Specify serial port
- `-b, --baud BAUD`: Set baud rate
- `-f, --force`: Force operation

## Setup Scripts

### setup_common.sh

**Purpose**: Shared environment setup utilities

**Key Features**:
- Environment variable management
- Tool installation and verification
- Cross-platform compatibility
- Error handling and validation

**Functions**:
- `setup_environment()`: Set up environment variables
- `install_tools()`: Install required tools
- `verify_tools()`: Verify tool installation
- `setup_paths()`: Set up PATH variables

### setup_repo.sh

**Purpose**: Local repository setup

**Key Features**:
- Tool installation
- Environment configuration
- Permission management
- Integration with setup_common.sh

**Usage**:
```bash
./setup_repo.sh [OPTIONS]
```

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-f, --force`: Force installation

## Utility Scripts

### config_loader.sh

**Purpose**: Configuration management and validation

**Key Features**:
- YAML configuration parsing
- Fallback mechanisms
- Environment variable overrides
- Configuration caching

**Functions**:
- `load_config()`: Load configuration from YAML
- `validate_config()`: Validate configuration
- `get_config_value()`: Get configuration value
- `set_config_value()`: Set configuration value

### manage_idf.sh

**Purpose**: ESP-IDF version management

**Key Features**:
- Multi-version ESP-IDF installation
- Version switching and management
- Environment setup
- Integration with build system

**Usage**:
```bash
./manage_idf.sh [COMMAND] [OPTIONS]
```

**Commands**:
- `install`: Install ESP-IDF version
- `list`: List installed versions
- `switch`: Switch to version
- `update`: Update version
- `remove`: Remove version

### detect_ports.sh

**Purpose**: Port detection and validation

**Key Features**:
- Cross-platform device detection
- Port validation and troubleshooting
- Integration with flash system
- Comprehensive error handling

**Usage**:
```bash
./detect_ports.sh [OPTIONS]
```

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-l, --list`: List available ports
- `-t, --test`: Test port connectivity

### manage_logs.sh

**Purpose**: Log management and analysis

**Key Features**:
- Log file management
- Log rotation and cleanup
- Log analysis and statistics
- Integration with other scripts

**Usage**:
```bash
./manage_logs.sh [COMMAND] [OPTIONS]
```

**Commands**:
- `list`: List log files
- `clean`: Clean old logs
- `analyze`: Analyze logs
- `rotate`: Rotate logs

## Configuration Scripts

### generate_matrix.py

**Purpose**: CI matrix generation for GitHub Actions

**Key Features**:
- YAML configuration parsing
- Matrix generation for build configurations
- ESP-IDF version and target combinations
- CI/CD optimization

**Usage**:
```bash
python generate_matrix.py [OPTIONS]
```

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-o, --output FILE`: Output file path

### get_app_info.py

**Purpose**: Application information retrieval

**Key Features**:
- Configuration parsing
- Information extraction
- Error handling
- Integration with build system

**Usage**:
```bash
python get_app_info.py [OPTIONS] [APP_NAME]
```

**Options**:
- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `-d, --debug`: Enable debug mode
- `-f, --format FORMAT`: Output format (json, yaml, text)

## Script Integration

### Build Process Integration
- Scripts are designed to work together seamlessly
- Shared configuration and environment variables
- Consistent error handling and logging
- Unified command-line interface

### CI/CD Integration
- Scripts integrate with GitHub Actions
- Support for matrix builds
- Automated testing and validation
- Artifact generation and management

### Logging Integration
- All scripts use consistent logging
- Centralized log management
- Log rotation and cleanup
- Log analysis and statistics