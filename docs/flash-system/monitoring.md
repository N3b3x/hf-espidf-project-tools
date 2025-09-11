---
title: "Monitoring and Logging"
parent: "Flash System"
nav_order: 4
---

# Monitoring and Logging

## Overview

The flash system provides comprehensive monitoring and logging capabilities for ESP32 development, including real-time device monitoring, integrated logging system, and advanced log management tools.

## Integrated Logging System

### Log Generation

The flash system automatically generates comprehensive logs:

```bash
## Automatic log creation
./flash_app.sh flash_monitor gpio_test Release --log

## Log file naming convention
gpio_test_Release_20250115_143022.log
## Format: {app}_{build_type}_{date}_{time}.log
```

### Log Content and Structure

```bash
## Log file contents
- Command execution details
- Port detection results
- Flash operation output
- Monitor session data
- Error messages and warnings
- Performance metrics
```

### Log Management Integration

The system integrates with the comprehensive logging system:

```bash
## Integrated log management
./manage_logs.sh list          # List all logs
./manage_logs.sh latest        # Show latest log
./manage_logs.sh search "ERROR" # Search for errors
./manage_logs.sh stats         # Log statistics
```

## Monitoring Capabilities

### Real-Time Monitoring

```bash
## Start monitoring after flash
./flash_app.sh flash_monitor gpio_test Release --log

## Monitor existing firmware
./flash_app.sh monitor --log

## Monitor with custom log name
./flash_app.sh monitor --log debug_session
```

### Monitor Configuration

```bash
## Monitor options
- Baud rate: 115200 (configurable)
- Data bits: 8
- Parity: None
- Stop bits: 1
- Flow control: None
```

### Monitor Options

- **`--log [name]`**: Enable logging with optional custom name
- **`--baud <rate>`**: Set custom baud rate for monitoring
- **`--port <port>`**: Override automatic port detection
- **`--timeout <seconds>`**: Set monitoring timeout

## Log Management Features

### Automatic Log Rotation

```bash
## Log rotation features
- Timestamped log files
- Automatic log directory management
- Configurable retention policies
- Storage optimization
```

### Log Analysis Tools

```bash
## Log analysis commands
./manage_logs.sh list                    # List all logs
./manage_logs.sh latest                  # Show latest log
./manage_logs.sh search "ERROR"          # Search for errors
./manage_logs.sh search "WARNING"        # Search for warnings
./manage_logs.sh stats                   # Log statistics
./manage_logs.sh clean                   # Clean old logs
./manage_logs.sh export                  # Export logs
```

### Log Search and Filtering

```bash
## Search patterns
./manage_logs.sh search "Flash completed"
./manage_logs.sh search "Upload failed"
./manage_logs.sh search "monitor"
./manage_logs.sh search "serial"
./manage_logs.sh search "ESP32"
./manage_logs.sh search "boot"
```

## Monitoring Workflows

### Development Monitoring

```bash
## Monitor for development debugging
./flash_app.sh flash_monitor gpio_test Debug --log dev_session

## Expected result:
## - Firmware flashed to device
## - Monitoring started automatically
## - Debug output captured in logs
## - Real-time debugging available
```

### Production Monitoring

```bash
## Monitor production firmware
./flash_app.sh monitor --log production_monitor

## Expected result:
## - Monitor existing firmware
## - Production output captured
## - Performance monitoring
## - Error tracking
```

### Testing Monitoring

```bash
## Monitor for automated testing
./flash_app.sh flash_monitor gpio_test Release --log test_session

## Expected result:
## - Test firmware flashed
## - Test output captured
## - Automated test monitoring
## - Test result logging
```

## Log Analysis and Debugging

### Flash Log Analysis

```bash
## Check flash operation logs
./manage_logs.sh latest
./manage_logs.sh search "ERROR"
./manage_logs.sh search "FAILED"

## Analyze flash patterns
./manage_logs.sh search "Flash completed"
./manage_logs.sh search "Upload failed"
```

### Monitor Log Analysis

```bash
## Check monitor session logs
./manage_logs.sh search "monitor"
./manage_logs.sh search "serial"

## Analyze device output
./manage_logs.sh search "ESP32"
./manage_logs.sh search "boot"
```

### Error Pattern Analysis

```bash
## Search for specific error patterns
./manage_logs.sh search "ERROR"
./manage_logs.sh search "WARNING"
./manage_logs.sh search "FAILED"
./manage_logs.sh search "TIMEOUT"
```

## Advanced Monitoring Features

### Multi-Device Monitoring

```bash
## Monitor multiple devices
for port in /dev/ttyUSB0 /dev/ttyUSB1; do
    export ESPPORT="$port"
    ./flash_app.sh monitor --log "device_${port}"
done
```

### Conditional Monitoring

```bash
## Monitor only if device responds
if ./detect_ports.sh --test-connection; then
    ./flash_app.sh monitor --log
fi
```

### Automated Monitoring

```bash
## Automated monitoring with timeout
timeout 60s ./flash_app.sh monitor --log auto_monitor

## Monitor with retry logic
for i in {1..3}; do
    if ./flash_app.sh monitor --log "attempt_${i}"; then
        break
    fi
    sleep 5
done
```

## Log Configuration

### Log Settings

```bash
## Log configuration options
export LOG_LEVEL="DEBUG"           # Log level (DEBUG, INFO, WARN, ERROR)
export LOG_DIR="/path/to/logs"     # Log directory
export LOG_RETENTION_DAYS="30"     # Log retention period
export LOG_MAX_SIZE="100MB"        # Maximum log file size
```

### Log Format Configuration

```bash
## Log format options
export LOG_FORMAT="timestamp,level,message"  # Log format
export LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"  # Timestamp format
export LOG_INCLUDE_DEBUG="true"    # Include debug information
```

## Performance Monitoring

### Monitor Performance Metrics

```bash
## Monitor performance
- Connection establishment time
- Data transfer rates
- Error rates
- Response times
- Resource usage
```

### Log Performance Metrics

```bash
## Log performance
- Log file sizes
- Log generation rates
- Search performance
- Storage usage
- Cleanup efficiency
```

## Troubleshooting Monitoring Issues

### Common Monitoring Problems

#### Monitor Connection Issues
**Problem**: Cannot establish monitor connection
**Symptoms**: "Monitor failed" or "No output" errors

**Solutions**:
```bash
## Check baud rate compatibility
./flash_app.sh monitor --log

## Verify device is running
./flash_app.sh monitor --log debug_monitor

## Check for bootloader mode
## Press RESET button to restart
```

#### Log Generation Issues
**Problem**: Logs not being generated
**Symptoms**: No log files created

**Solutions**:
```bash
## Check log directory permissions
ls -la /path/to/logs

## Verify log configuration
echo $LOG_DIR
echo $LOG_LEVEL

## Test log generation
./flash_app.sh monitor --log test_log
```

#### Log Search Issues
**Problem**: Log search not working
**Symptoms**: Search returns no results

**Solutions**:
```bash
## Check log file existence
./manage_logs.sh list

## Test search functionality
./manage_logs.sh search "test"

## Verify log content
./manage_logs.sh latest
```

### Debug Mode for Monitoring

```bash
## Enable debug mode
export DEBUG=1
./flash_app.sh monitor --log

## Enable verbose ESP-IDF output
export IDF_VERBOSE=1
./flash_app.sh monitor --log
```

### Debug Information Available

- Port detection and selection details
- Monitor connection establishment
- Data transfer monitoring
- Error context and troubleshooting suggestions
- Performance metrics and timing

## Best Practices

### Monitoring Best Practices

- **Use Appropriate Logging**: Enable logging for debugging and troubleshooting
- **Monitor Performance**: Track monitoring performance and reliability
- **Regular Log Maintenance**: Perform regular log cleanup and maintenance
- **Error Analysis**: Analyze logs for error patterns and issues

### Log Management Best Practices

- **Organize Logs**: Use descriptive log names and organization
- **Regular Cleanup**: Implement regular log cleanup and rotation
- **Backup Important Logs**: Backup critical logs before cleanup
- **Monitor Storage**: Monitor log storage usage and limits

### Performance Best Practices

- **Optimize Log Settings**: Use appropriate log levels and formats
- **Efficient Searching**: Use efficient search patterns and filters
- **Resource Management**: Monitor resource usage for log operations
- **Storage Optimization**: Optimize log storage and retention policies