---
title: "Log Generation and Capture"
parent: "Logging System"
nav_order: 2
---

# Log Generation and Capture

## Overview

The logging system provides automatic log generation and capture for all ESP32 development operations, ensuring comprehensive documentation of build, flash, and monitor activities.

## Automatic Log Generation

### Built-in Logging

All scripts automatically generate logs when the `--log` option is specified:

```bash
## Automatic log generation
./build_app.sh gpio_test Release --log
./flash_app.sh flash gpio_test Release --log
./flash_app.sh monitor --log

## Custom log names
./flash_app.sh flash gpio_test Release --log production_deploy
./flash_app.sh monitor --log debug_session
```

### Log File Naming Convention

```
{operation}_{app}_{build_type}_{timestamp}.log
{operation}_{app}_{build_type}_{idf_version}_{timestamp}.log
{operation}_{custom_name}_{timestamp}.log
```

**Examples**:
- `build_gpio_test_Release_20250115_143022.log`
- `flash_gpio_test_Release_20250115_143022.log`
- `monitor_debug_session_20250115_143022.log`
- `size_gpio_test_Release_20250115_143022.log`

## Log Content Structure

### Log Header

Each log file begins with a comprehensive header containing operation metadata:

```
## Log Header
# Operation: flash
# Application: gpio_test
# Build Type: Release
# ESP-IDF Version: release/v5.5
# Timestamp: 2025-01-15 14:30:22
# Duration: 45.2 seconds
# Status: SUCCESS
# Working Directory: /workspace/examples/esp32
# Command: ./flash_app.sh flash gpio_test Release --log
# Environment: DEBUG=0, ESPPORT=/dev/ttyUSB0
```

### Command Execution Details

```
## Command Execution
Command: ./flash_app.sh flash gpio_test Release --log
Working Directory: /workspace/examples/esp32
Environment Variables:
  DEBUG=0
  ESPPORT=/dev/ttyUSB0
  ESPBAUD=115200
  PROJECT_PATH=/workspace/examples/esp32
```

### Output Capture

The system captures all script output with timestamps and log levels:

```
## Output Capture
[Timestamp] [Level] [Component] Message
2025-01-15 14:30:22 INFO  flash_app    Starting flash operation
2025-01-15 14:30:22 INFO  detect_ports Port detection: /dev/ttyUSB0
2025-01-15 14:30:23 INFO  esptool     Flashing firmware...
2025-01-15 14:30:45 INFO  flash_app    Flash completed successfully
```

### Performance Metrics

Each log includes performance metrics and resource usage:

```
## Performance Metrics
- Port Detection: 0.5s
- Flash Operation: 42.1s
- Total Duration: 45.2s
- Memory Usage: 256MB
- CPU Usage: 45%
- Log File Size: 1.2MB
```

## Log Types and Categories

### Build Logs

Build logs capture the complete build process:

```bash
## Build log generation
./build_app.sh gpio_test Release --log

## Log content includes:
- Build configuration
- Compilation output
- Linker output
- Build statistics
- Error messages and warnings
- Performance metrics
```

### Flash Logs

Flash logs document the firmware flashing process:

```bash
## Flash log generation
./flash_app.sh flash gpio_test Release --log

## Log content includes:
- Port detection results
- Flash operation details
- Device communication
- Verification results
- Error handling
- Performance metrics
```

### Monitor Logs

Monitor logs capture device output and communication:

```bash
## Monitor log generation
./flash_app.sh monitor --log

## Log content includes:
- Device output
- Serial communication
- Error messages
- Performance data
- Session statistics
```

### Size Analysis Logs

Size analysis logs document firmware size analysis:

```bash
## Size analysis log generation
./flash_app.sh size gpio_test Release --log

## Log content includes:
- Firmware size analysis
- Component breakdown
- Memory usage summary
- Build validation
- Analysis results
```

## Log Generation Features

### Timestamped Entries

All log entries include precise timestamps:

```
[2025-01-15 14:30:22.123] INFO  flash_app    Starting operation
[2025-01-15 14:30:22.456] DEBUG detect_ports Scanning for ports
[2025-01-15 14:30:22.789] INFO  detect_ports Found port: /dev/ttyUSB0
```

### Log Levels

The system supports multiple log levels:

- **DEBUG**: Detailed debugging information
- **INFO**: General information messages
- **WARN**: Warning messages
- **ERROR**: Error messages
- **FATAL**: Fatal error messages

### Component Identification

Each log entry identifies the source component:

```
[Timestamp] [Level] [Component] Message
- flash_app: Main flash script
- detect_ports: Port detection script
- esptool: ESP-IDF tools
- idf.py: ESP-IDF build system
- monitor: Monitor session
```

## Log Capture Mechanisms

### Output Redirection

The system captures all script output using output redirection:

```bash
## Output redirection
exec > >(tee -a "$LOG_FILE") 2>&1

## This captures:
- Standard output (stdout)
- Standard error (stderr)
- All script output
- Error messages
- Debug information
```

### Error Capture

All errors and warnings are automatically captured:

```bash
## Error capture
set -e  # Exit on error
trap 'log_error "Script failed at line $LINENO"' ERR

## Captured errors:
- Script execution errors
- Command failures
- Validation errors
- System errors
```

### Performance Monitoring

The system automatically tracks performance metrics:

```bash
## Performance tracking
start_time=$(date +%s.%N)
# ... operation ...
end_time=$(date +%s.%N)
duration=$(echo "$end_time - $start_time" | bc)
```

## Log Configuration

### Environment Variables

```bash
## Log configuration
export LOG_LEVEL="INFO"           # Log level (DEBUG, INFO, WARN, ERROR)
export LOG_DIR="./logs"           # Log directory
export LOG_RETENTION_DAYS="30"    # Log retention period
export LOG_MAX_SIZE="100MB"       # Maximum log file size
export LOG_FORMAT="timestamp,level,message"  # Log format
```

### Log Format Configuration

```bash
## Log format options
export LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"  # Timestamp format
export LOG_INCLUDE_DEBUG="true"    # Include debug information
export LOG_INCLUDE_PERFORMANCE="true"  # Include performance metrics
export LOG_COMPRESS="true"         # Compress archived logs
```

## Log File Management

### Automatic Organization

Logs are automatically organized by operation type:

```
logs/
├── build/                    # Build operation logs
├── flash/                    # Flash operation logs
├── monitor/                  # Monitor session logs
├── size/                     # Size analysis logs
└── archive/                  # Archived logs
```

### Log Rotation

The system automatically rotates logs based on size and age:

```bash
## Log rotation triggers
- File size exceeds maximum (default: 100MB)
- Log age exceeds retention period (default: 30 days)
- Manual rotation request
- System cleanup
```

### Log Compression

Old logs are automatically compressed to save space:

```bash
## Compression settings
- Compress logs older than 7 days
- Use gzip compression
- Maintain original file structure
- Preserve log accessibility
```

## Integration with Scripts

### Build Script Integration

```bash
## build_app.sh logging
if [ "$ENABLE_LOGGING" = "true" ]; then
    LOG_FILE="logs/build/${APP}_${BUILD_TYPE}_$(date +%Y%m%d_%H%M%S).log"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi
```

### Flash Script Integration

```bash
## flash_app.sh logging
if [ "$ENABLE_LOGGING" = "true" ]; then
    LOG_FILE="logs/flash/${APP}_${BUILD_TYPE}_$(date +%Y%m%d_%H%M%S).log"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi
```

### Monitor Script Integration

```bash
## monitor logging
if [ "$ENABLE_LOGGING" = "true" ]; then
    LOG_FILE="logs/monitor/${LOG_NAME}_$(date +%Y%m%d_%H%M%S).log"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi
```

## Best Practices

### Log Generation

- **Always Use Logging**: Enable logging for all operations
- **Use Descriptive Names**: Use descriptive log file names
- **Include Context**: Include relevant context in logs
- **Monitor Performance**: Track log generation performance

### Log Content

- **Comprehensive Capture**: Capture all relevant output
- **Structured Format**: Use consistent log format
- **Error Details**: Include detailed error information
- **Performance Metrics**: Track performance metrics

### Log Management

- **Regular Cleanup**: Perform regular log cleanup
- **Monitor Storage**: Monitor log storage usage
- **Backup Important Logs**: Backup critical logs
- **Archive Old Logs**: Archive old logs appropriately