---
title: "Configuration Loading Process"
parent: "Configuration"
nav_order: 2
---

# Configuration Loading Process

## Overview

The configuration loading process is responsible for parsing, validating, and providing access to the YAML configuration file. It includes fallback mechanisms, error handling, and environment variable overrides.

## Loading Architecture

### Primary Method: YAML Parsing with `yq`

The primary method uses `yq` for reliable YAML parsing:

```bash
# Primary YAML parsing
yq eval '.metadata.name' app_config.yml
yq eval '.apps.sensor_app.build_types' app_config.yml
yq eval '.build_config.build_types.Debug' app_config.yml
```

**Advantages**:
- Reliable YAML parsing
- Support for complex YAML structures
- Good error handling
- Cross-platform compatibility

### Fallback Method: Basic Parsing with `grep`/`sed`

When `yq` is not available, the system falls back to basic parsing:

```bash
# Fallback parsing with grep/sed
grep -A 10 "metadata:" app_config.yml | grep "name:" | sed 's/.*name: *//'
grep -A 20 "apps:" app_config.yml | grep -A 10 "sensor_app:" | grep "build_types:" | sed 's/.*build_types: *//'
```

**Advantages**:
- No external dependencies
- Works on minimal systems
- Fast execution
- Reliable fallback

## Configuration Discovery

### Automatic Discovery

The system automatically discovers configuration files in the following order:

1. **Environment Variable**: `CONFIG_FILE` environment variable
2. **Project Root**: `app_config.yml` in project root
3. **Script Directory**: `app_config.yml` in script directory
4. **Current Directory**: `app_config.yml` in current directory

### Discovery Process

```bash
# Configuration discovery logic
if [[ -n "${CONFIG_FILE:-}" ]]; then
    CONFIG_FILE_PATH="$CONFIG_FILE"
elif [[ -f "app_config.yml" ]]; then
    CONFIG_FILE_PATH="app_config.yml"
elif [[ -f "scripts/app_config.yml" ]]; then
    CONFIG_FILE_PATH="scripts/app_config.yml"
elif [[ -f "../app_config.yml" ]]; then
    CONFIG_FILE_PATH="../app_config.yml"
else
    echo "Error: Configuration file not found"
    exit 1
fi
```

## Validation Process

### Configuration Validation

The system validates configuration files at multiple levels:

#### 1. File Existence
```bash
# Check if configuration file exists
if [[ ! -f "$CONFIG_FILE_PATH" ]]; then
    echo "Error: Configuration file not found: $CONFIG_FILE_PATH"
    exit 1
fi
```

#### 2. YAML Syntax Validation
```bash
# Validate YAML syntax with yq
if command -v yq >/dev/null 2>&1; then
    if ! yq eval '.' "$CONFIG_FILE_PATH" >/dev/null 2>&1; then
        echo "Error: Invalid YAML syntax in $CONFIG_FILE_PATH"
        exit 1
    fi
fi
```

#### 3. Required Fields Validation
```bash
# Validate required fields
validate_required_field "metadata.name"
validate_required_field "metadata.default_app"
validate_required_field "metadata.default_build_type"
validate_required_field "metadata.default_target"
```

#### 4. Application Validation
```bash
# Validate application definitions
for app in $(get_app_list); do
    validate_app_field "$app" "source_file"
    validate_app_field "$app" "build_types"
    validate_app_field "$app" "targets"
done
```

### Validation Functions

#### `validate_required_field()`
```bash
validate_required_field() {
    local field="$1"
    local value
    
    if command -v yq >/dev/null 2>&1; then
        value=$(yq eval ".$field" "$CONFIG_FILE_PATH" 2>/dev/null)
    else
        value=$(grep -A 5 "metadata:" "$CONFIG_FILE_PATH" | grep "$field:" | sed 's/.*: *//' | tr -d '"')
    fi
    
    if [[ -z "$value" || "$value" == "null" ]]; then
        echo "Error: Required field '$field' is missing or empty"
        exit 1
    fi
}
```

#### `validate_app_field()`
```bash
validate_app_field() {
    local app="$1"
    local field="$2"
    local value
    
    if command -v yq >/dev/null 2>&1; then
        value=$(yq eval ".apps.$app.$field" "$CONFIG_FILE_PATH" 2>/dev/null)
    else
        value=$(grep -A 20 "apps:" "$CONFIG_FILE_PATH" | grep -A 10 "$app:" | grep "$field:" | sed 's/.*: *//' | tr -d '"')
    fi
    
    if [[ -z "$value" || "$value" == "null" ]]; then
        echo "Error: Required field '$field' is missing for app '$app'"
        exit 1
    fi
}
```

## Environment Variable Overrides

### Override Priority

Environment variables can override configuration values with the following priority:

1. **Environment Variables**: Highest priority
2. **Configuration File**: Medium priority
3. **Default Values**: Lowest priority

### Override Examples

```bash
# Override default application
export CONFIG_DEFAULT_APP="sensor_app"

# Override default build type
export CONFIG_DEFAULT_BUILD_TYPE="Debug"

# Override default target
export CONFIG_DEFAULT_TARGET="esp32s2"

# Override ESP-IDF version
export CONFIG_DEFAULT_IDF_VERSION="v5.0.0"
```

### Override Implementation

```bash
# Environment variable override logic
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
        if command -v yq >/dev/null 2>&1; then
            value=$(yq eval ".$field" "$CONFIG_FILE_PATH" 2>/dev/null)
        else
            value=$(grep -A 5 "metadata:" "$CONFIG_FILE_PATH" | grep "$field:" | sed 's/.*: *//' | tr -d '"')
        fi
        
        # Use default value if not found
        if [[ -z "$value" || "$value" == "null" ]]; then
            value="$default_value"
        fi
    fi
    
    echo "$value"
}
```

## Caching and Performance

### Configuration Caching

The system caches configuration values to improve performance:

```bash
# Configuration cache
declare -A CONFIG_CACHE

# Cache configuration value
cache_config_value() {
    local key="$1"
    local value="$2"
    CONFIG_CACHE["$key"]="$value"
}

# Get cached configuration value
get_cached_config_value() {
    local key="$1"
    echo "${CONFIG_CACHE[$key]:-}"
}
```

### Performance Optimization

#### 1. Lazy Loading
```bash
# Load configuration only when needed
load_config_if_needed() {
    if [[ -z "${CONFIG_LOADED:-}" ]]; then
        load_configuration
        export CONFIG_LOADED=1
    fi
}
```

#### 2. Batch Loading
```bash
# Load multiple configuration values at once
load_configuration_batch() {
    local fields=("$@")
    for field in "${fields[@]}"; do
        value=$(get_config_value "$field" "")
        cache_config_value "$field" "$value"
    done
}
```

#### 3. Validation Caching
```bash
# Cache validation results
declare -A VALIDATION_CACHE

validate_config_cached() {
    local key="$1"
    
    if [[ -n "${VALIDATION_CACHE[$key]:-}" ]]; then
        return ${VALIDATION_CACHE[$key]}
    fi
    
    # Perform validation
    if validate_config "$key"; then
        VALIDATION_CACHE[$key]=0
        return 0
    else
        VALIDATION_CACHE[$key]=1
        return 1
    fi
}
```

## Error Handling

### Error Types

#### 1. File Not Found
```bash
# Handle missing configuration file
if [[ ! -f "$CONFIG_FILE_PATH" ]]; then
    echo "Error: Configuration file not found: $CONFIG_FILE_PATH"
    echo "Please create app_config.yml or set CONFIG_FILE environment variable"
    exit 1
fi
```

#### 2. Invalid YAML
```bash
# Handle invalid YAML syntax
if command -v yq >/dev/null 2>&1; then
    if ! yq eval '.' "$CONFIG_FILE_PATH" >/dev/null 2>&1; then
        echo "Error: Invalid YAML syntax in $CONFIG_FILE_PATH"
        echo "Please check the YAML syntax and try again"
        exit 1
    fi
fi
```

#### 3. Missing Required Fields
```bash
# Handle missing required fields
if [[ -z "$(get_config_value 'metadata.name' '')" ]]; then
    echo "Error: Required field 'metadata.name' is missing"
    echo "Please add 'name' field to metadata section"
    exit 1
fi
```

#### 4. Invalid Application Definitions
```bash
# Handle invalid application definitions
for app in $(get_app_list); do
    if [[ -z "$(get_app_config_value "$app" 'source_file' '')" ]]; then
        echo "Error: Application '$app' is missing required field 'source_file'"
        echo "Please add 'source_file' field to app '$app'"
        exit 1
    fi
done
```

### Error Recovery

#### 1. Fallback to Defaults
```bash
# Fallback to default values when configuration is invalid
get_config_value_with_fallback() {
    local field="$1"
    local default_value="$2"
    local value
    
    value=$(get_config_value "$field" "")
    if [[ -z "$value" || "$value" == "null" ]]; then
        echo "Warning: Using default value for '$field': $default_value"
        value="$default_value"
    fi
    
    echo "$value"
}
```

#### 2. Configuration Repair
```bash
# Attempt to repair configuration
repair_configuration() {
    local config_file="$1"
    
    echo "Attempting to repair configuration file: $config_file"
    
    # Create backup
    cp "$config_file" "${config_file}.backup"
    
    # Attempt basic repairs
    if ! yq eval '.' "$config_file" >/dev/null 2>&1; then
        echo "Warning: YAML syntax errors detected, attempting basic repair"
        # Basic YAML repair logic
    fi
}
```

## Integration with Scripts

### Script Integration

The configuration loading process integrates with all scripts:

#### 1. Build Scripts
```bash
# Load configuration in build scripts
load_configuration
APP_NAME=$(get_config_value "metadata.default_app" "main_app")
BUILD_TYPE=$(get_config_value "metadata.default_build_type" "Release")
TARGET=$(get_config_value "metadata.default_target" "esp32")
```

#### 2. Flash Scripts
```bash
# Load configuration in flash scripts
load_configuration
PORT=$(get_config_value "flash_config.default_port" "auto")
BAUD=$(get_config_value "flash_config.default_baud" "921600")
```

#### 3. CI Scripts
```bash
# Load configuration in CI scripts
load_configuration
MATRIX_APPS=$(get_app_list)
MATRIX_BUILD_TYPES=$(get_build_type_list)
MATRIX_TARGETS=$(get_target_list)
```

### Configuration Access Functions

#### 1. Basic Access
```bash
# Get configuration value
get_config_value "metadata.name"

# Get application configuration
get_app_config_value "sensor_app" "build_types"

# Get build configuration
get_build_config_value "Debug" "optimization"
```

#### 2. List Access
```bash
# Get list of applications
get_app_list

# Get list of build types
get_build_type_list

# Get list of targets
get_target_list

# Get list of ESP-IDF versions
get_idf_version_list
```

#### 3. Validation Access
```bash
# Validate configuration
validate_configuration

# Validate application
validate_application "sensor_app"

# Validate build type
validate_build_type "Debug"

# Validate target
validate_target "esp32"
```

## Best Practices

### Configuration Management

1. **Version Control**: Keep configuration files in version control
2. **Documentation**: Document configuration changes
3. **Validation**: Validate configuration before deployment
4. **Backup**: Create backups before major changes

### Performance Optimization

1. **Caching**: Use configuration caching for frequently accessed values
2. **Lazy Loading**: Load configuration only when needed
3. **Batch Loading**: Load multiple values at once
4. **Validation Caching**: Cache validation results

### Error Handling

1. **Graceful Degradation**: Provide fallback values
2. **Clear Error Messages**: Provide clear error messages
3. **Recovery Procedures**: Implement recovery procedures
4. **Logging**: Log configuration loading errors