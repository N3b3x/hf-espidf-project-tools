---
title: "Environment Variables"
parent: "Configuration"
nav_order: 3
---

# Environment Variables

## Overview

The HardFOC ESP32 CI Tools support extensive environment variable configuration, allowing users to override configuration file values and customize behavior without modifying configuration files.

## Environment Variable Categories

### Configuration Overrides

These variables override values from the configuration file:

#### Project Configuration
```bash
# Project metadata
export CONFIG_NAME="My ESP32 Project"
export CONFIG_VERSION="1.0.0"
export CONFIG_DESCRIPTION="Custom ESP32 project"

# Default values
export CONFIG_DEFAULT_APP="sensor_app"
export CONFIG_DEFAULT_BUILD_TYPE="Release"
export CONFIG_DEFAULT_TARGET="esp32"
export CONFIG_DEFAULT_IDF_VERSION="v4.4.2"
```

#### Build Configuration
```bash
# Build settings
export CONFIG_BUILD_DIR="build"
export CONFIG_LOG_DIR="logs"
export CONFIG_CACHE_DIR="cache"
export CONFIG_PARALLEL_JOBS="4"
export CONFIG_VERBOSE_BUILD="true"
export CONFIG_CLEAN_BUILD="false"
```

#### Flash Configuration
```bash
# Flash settings
export CONFIG_FLASH_PORT="auto"
export CONFIG_FLASH_BAUD="921600"
export CONFIG_FLASH_MODE="dio"
export CONFIG_FLASH_FREQ="80m"
export CONFIG_FLASH_SIZE="4MB"
```

### System Configuration

These variables control system behavior:

#### Tool Configuration
```bash
# Tool paths
export CONFIG_YQ_PATH="/usr/local/bin/yq"
export CONFIG_JQ_PATH="/usr/local/bin/jq"
export CONFIG_CMAKE_PATH="/usr/local/bin/cmake"
export CONFIG_NINJA_PATH="/usr/local/bin/ninja"
export CONFIG_CCACHE_PATH="/usr/local/bin/ccache"
```

#### ESP-IDF Configuration
```bash
# ESP-IDF settings
export IDF_PATH="/path/to/esp-idf"
export IDF_VERSION="v4.4.2"
export IDF_TARGET="esp32"
export IDF_CCACHE_ENABLE="1"
export IDF_VERBOSE="1"
```

#### Python Configuration
```bash
# Python settings
export CONFIG_PYTHON_PATH="/usr/bin/python3"
export CONFIG_PIP_PATH="/usr/bin/pip3"
export CONFIG_VIRTUAL_ENV="/path/to/venv"
export CONFIG_PYTHON_REQUIREMENTS="requirements.txt"
```

### Debug and Logging

These variables control debugging and logging behavior:

#### Debug Configuration
```bash
# Debug settings
export DEBUG="1"
export VERBOSE="1"
export CONFIG_DEBUG_LEVEL="INFO"
export CONFIG_DEBUG_OUTPUT="console"
export CONFIG_DEBUG_FILE="debug.log"
```

#### Logging Configuration
```bash
# Logging settings
export CONFIG_LOG_LEVEL="INFO"
export CONFIG_LOG_DIR="logs"
export CONFIG_LOG_MAX_FILES="100"
export CONFIG_LOG_MAX_SIZE="10MB"
export CONFIG_LOG_ROTATION="daily"
```

### CI/CD Configuration

These variables control CI/CD behavior:

#### CI/CD Settings
```bash
# CI/CD settings
export CI="true"
export GITHUB_ACTIONS="true"
export RUNNER_OS="ubuntu-latest"
export CONFIG_CI_MATRIX_GENERATION="true"
export CONFIG_CI_PARALLEL_BUILDS="true"
export CONFIG_CI_ARTIFACT_UPLOAD="true"
```

#### Matrix Configuration
```bash
# Matrix settings
export CONFIG_MATRIX_APPS="sensor_app,control_app"
export CONFIG_MATRIX_BUILD_TYPES="Debug,Release"
export CONFIG_MATRIX_TARGETS="esp32,esp32s2"
export CONFIG_MATRIX_IDF_VERSIONS="v4.4.2,v5.0.0"
```

## Environment Variable Processing

### Variable Naming Convention

Environment variables follow a consistent naming convention:

- **`CONFIG_`**: Configuration overrides
- **`IDF_`**: ESP-IDF specific variables
- **`DEBUG_`**: Debug and logging variables
- **`CI_`**: CI/CD specific variables

### Variable Resolution Order

Variables are resolved in the following order:

1. **Environment Variables**: Highest priority
2. **Configuration File**: Medium priority
3. **Default Values**: Lowest priority

### Variable Processing Functions

#### `get_config_value()`
```bash
get_config_value() {
    local field="$1"
    local default_value="$2"
    local env_var="CONFIG_$(echo "$field" | tr '[:lower:]' '[:upper:]' | tr '.' '_')"
    local value
    
    # Check environment variable first
    if [[ -n "${!env_var:-}" ]]; then
        value="${!env_var}"
    else
        # Get value from configuration file
        value=$(get_config_file_value "$field")
        
        # Use default value if not found
        if [[ -z "$value" || "$value" == "null" ]]; then
            value="$default_value"
        fi
    fi
    
    echo "$value"
}
```

#### `get_app_config_value()`
```bash
get_app_config_value() {
    local app="$1"
    local field="$2"
    local default_value="$3"
    local env_var="CONFIG_APP_${app^^}_$(echo "$field" | tr '[:lower:]' '[:upper:]' | tr '.' '_')"
    local value
    
    # Check environment variable first
    if [[ -n "${!env_var:-}" ]]; then
        value="${!env_var}"
    else
        # Get value from configuration file
        value=$(get_config_file_value "apps.$app.$field")
        
        # Use default value if not found
        if [[ -z "$value" || "$value" == "null" ]]; then
            value="$default_value"
        fi
    fi
    
    echo "$value"
}
```

## Configuration File Integration

### Environment Variable Overrides

Environment variables can override any configuration file value:

#### Basic Overrides
```bash
# Override metadata
export CONFIG_NAME="Custom Project Name"
export CONFIG_VERSION="2.0.0"
export CONFIG_DESCRIPTION="Custom project description"

# Override defaults
export CONFIG_DEFAULT_APP="custom_app"
export CONFIG_DEFAULT_BUILD_TYPE="Debug"
export CONFIG_DEFAULT_TARGET="esp32s2"
```

#### Application-Specific Overrides
```bash
# Override application settings
export CONFIG_APP_SENSOR_APP_BUILD_TYPES="Debug,Release,Production"
export CONFIG_APP_SENSOR_APP_TARGETS="esp32,esp32s2,esp32c3"
export CONFIG_APP_SENSOR_APP_IDF_VERSIONS="v4.4.2,v5.0.0"

# Override control app settings
export CONFIG_APP_CONTROL_APP_BUILD_TYPES="Debug,Release"
export CONFIG_APP_CONTROL_APP_TARGETS="esp32,esp32s2"
export CONFIG_APP_CONTROL_APP_IDF_VERSIONS="v4.4.2"
```

#### Build Configuration Overrides
```bash
# Override build settings
export CONFIG_BUILD_TYPES_DEBUG_OPTIMIZATION="-O0"
export CONFIG_BUILD_TYPES_DEBUG_DEBUG_LEVEL="-g3"
export CONFIG_BUILD_TYPES_DEBUG_DEFINES="DEBUG,VERBOSE_LOGGING"

export CONFIG_BUILD_TYPES_RELEASE_OPTIMIZATION="-O2"
export CONFIG_BUILD_TYPES_RELEASE_DEBUG_LEVEL="-g"
export CONFIG_BUILD_TYPES_RELEASE_DEFINES="NDEBUG"
```

### Configuration File Fallback

When environment variables are not set, the system falls back to configuration file values:

```bash
# Fallback logic
get_config_value_with_fallback() {
    local field="$1"
    local default_value="$2"
    local env_var="CONFIG_$(echo "$field" | tr '[:lower:]' '[:upper:]' | tr '.' '_')"
    local value
    
    # Check environment variable first
    if [[ -n "${!env_var:-}" ]]; then
        value="${!env_var}"
        echo "Using environment variable $env_var: $value"
    else
        # Get value from configuration file
        value=$(get_config_file_value "$field")
        
        if [[ -n "$value" && "$value" != "null" ]]; then
            echo "Using configuration file value for $field: $value"
        else
            # Use default value
            value="$default_value"
            echo "Using default value for $field: $value"
        fi
    fi
    
    echo "$value"
}
```

## Portable Configuration

### Environment-Specific Configuration

Different environments can use different configuration approaches:

#### Development Environment
```bash
# Development settings
export CONFIG_DEBUG="true"
export CONFIG_VERBOSE="true"
export CONFIG_LOG_LEVEL="DEBUG"
export CONFIG_CLEAN_BUILD="false"
export CONFIG_USE_CACHE="true"
```

#### Production Environment
```bash
# Production settings
export CONFIG_DEBUG="false"
export CONFIG_VERBOSE="false"
export CONFIG_LOG_LEVEL="INFO"
export CONFIG_CLEAN_BUILD="true"
export CONFIG_USE_CACHE="true"
```

#### CI/CD Environment
```bash
# CI/CD settings
export CI="true"
export CONFIG_CI_MATRIX_GENERATION="true"
export CONFIG_CI_PARALLEL_BUILDS="true"
export CONFIG_CI_ARTIFACT_UPLOAD="true"
export CONFIG_CI_NOTIFICATION_ENABLED="true"
```

### Configuration Profiles

Users can create configuration profiles for different scenarios:

#### Development Profile
```bash
# Load development profile
source profiles/development.env

# Development profile contents
export CONFIG_DEBUG="true"
export CONFIG_VERBOSE="true"
export CONFIG_LOG_LEVEL="DEBUG"
export CONFIG_DEFAULT_BUILD_TYPE="Debug"
export CONFIG_USE_CACHE="true"
```

#### Production Profile
```bash
# Load production profile
source profiles/production.env

# Production profile contents
export CONFIG_DEBUG="false"
export CONFIG_VERBOSE="false"
export CONFIG_LOG_LEVEL="INFO"
export CONFIG_DEFAULT_BUILD_TYPE="Release"
export CONFIG_USE_CACHE="true"
```

#### CI/CD Profile
```bash
# Load CI/CD profile
source profiles/ci-cd.env

# CI/CD profile contents
export CI="true"
export CONFIG_CI_MATRIX_GENERATION="true"
export CONFIG_CI_PARALLEL_BUILDS="true"
export CONFIG_CI_ARTIFACT_UPLOAD="true"
```

## Validation and Error Handling

### Environment Variable Validation

The system validates environment variables before use:

#### Type Validation
```bash
# Validate boolean values
validate_boolean() {
    local var_name="$1"
    local value="${!var_name}"
    
    if [[ -n "$value" ]]; then
        case "$value" in
            "true"|"false"|"1"|"0"|"yes"|"no"|"on"|"off")
                return 0
                ;;
            *)
                echo "Error: $var_name must be a boolean value (true/false, 1/0, yes/no, on/off)"
                return 1
                ;;
        esac
    fi
}
```

#### Range Validation
```bash
# Validate numeric ranges
validate_range() {
    local var_name="$1"
    local value="${!var_name}"
    local min="$2"
    local max="$3"
    
    if [[ -n "$value" ]]; then
        if ! [[ "$value" =~ ^[0-9]+$ ]]; then
            echo "Error: $var_name must be a number"
            return 1
        fi
        
        if [[ "$value" -lt "$min" || "$value" -gt "$max" ]]; then
            echo "Error: $var_name must be between $min and $max"
            return 1
        fi
    fi
}
```

#### Enum Validation
```bash
# Validate enum values
validate_enum() {
    local var_name="$1"
    local value="${!var_name}"
    shift
    local valid_values=("$@")
    
    if [[ -n "$value" ]]; then
        for valid_value in "${valid_values[@]}"; do
            if [[ "$value" == "$valid_value" ]]; then
                return 0
            fi
        done
        
        echo "Error: $var_name must be one of: ${valid_values[*]}"
        return 1
    fi
}
```

### Error Handling

#### Missing Required Variables
```bash
# Check for required environment variables
check_required_vars() {
    local required_vars=("$@")
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            echo "Error: Required environment variable $var is not set"
            return 1
        fi
    done
}
```

#### Invalid Variable Values
```bash
# Validate environment variable values
validate_env_vars() {
    # Validate boolean variables
    validate_boolean "CONFIG_DEBUG" || return 1
    validate_boolean "CONFIG_VERBOSE" || return 1
    validate_boolean "CONFIG_CLEAN_BUILD" || return 1
    
    # Validate numeric variables
    validate_range "CONFIG_PARALLEL_JOBS" 1 16 || return 1
    validate_range "CONFIG_LOG_MAX_FILES" 1 1000 || return 1
    
    # Validate enum variables
    validate_enum "CONFIG_DEFAULT_BUILD_TYPE" "Debug" "Release" "Production" || return 1
    validate_enum "CONFIG_DEFAULT_TARGET" "esp32" "esp32s2" "esp32c3" "esp32s3" || return 1
}
```

## Best Practices

### Environment Variable Management

1. **Consistent Naming**: Use consistent naming conventions
2. **Documentation**: Document all environment variables
3. **Validation**: Validate environment variable values
4. **Default Values**: Provide sensible default values

### Configuration Profiles

1. **Profile Organization**: Organize profiles by environment
2. **Profile Documentation**: Document profile purposes
3. **Profile Validation**: Validate profile configurations
4. **Profile Testing**: Test profiles before deployment

### Error Handling

1. **Clear Error Messages**: Provide clear error messages
2. **Graceful Degradation**: Provide fallback values
3. **Validation**: Validate all environment variables
4. **Logging**: Log environment variable usage