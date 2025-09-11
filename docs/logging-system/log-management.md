---
title: "Log Management and Organization"
parent: "Logging System"
nav_order: 3
---

# Log Management and Organization

## Overview

The logging system provides comprehensive log management and organization capabilities, including automatic rotation, cleanup, and structured storage for efficient log access and analysis.

## Log Organization Structure

### Directory Hierarchy

```
logs/
├── build/                    # Build operation logs
│   ├── gpio_test_Release_20250115_143022.log
│   ├── adc_test_Debug_20250115_143045.log
│   └── uart_test_Release_20250115_143100.log
├── flash/                    # Flash operation logs
│   ├── gpio_test_Release_20250115_143022.log
│   ├── adc_test_Debug_20250115_143045.log
│   └── production_deploy_20250115_143100.log
├── monitor/                  # Monitor session logs
│   ├── gpio_test_Release_20250115_143022.log
│   ├── debug_session_20250115_143022.log
│   └── test_session_20250115_143100.log
├── size/                     # Size analysis logs
│   ├── gpio_test_Release_20250115_143022.log
│   └── adc_test_Debug_20250115_143045.log
└── archive/                  # Archived logs
    ├── 2025-01/
    │   ├── build/
    │   ├── flash/
    │   ├── monitor/
    │   └── size/
    └── 2025-02/
        ├── build/
        ├── flash/
        ├── monitor/
        └── size/
```

### Log File Naming Convention

The system uses a consistent naming convention for all log files:

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

## Log Management Commands

### Basic Log Management

```bash
## List all logs
./manage_logs.sh list

## Show latest log
./manage_logs.sh latest

## Show log statistics
./manage_logs.sh stats

## Clean old logs
./manage_logs.sh clean
```

### Log Search and Filtering

```bash
## Search for specific patterns
./manage_logs.sh search "ERROR"
./manage_logs.sh search "WARNING"
./manage_logs.sh search "Flash completed"
./manage_logs.sh search "Upload failed"

## Search with filters
./manage_logs.sh search "ERROR" --type flash
./manage_logs.sh search "WARNING" --app gpio_test
./manage_logs.sh search "Flash completed" --date 2025-01-15
```

### Log Export and Backup

```bash
## Export logs to file
./manage_logs.sh export --output logs_export.tar.gz

## Export specific log types
./manage_logs.sh export --type flash --output flash_logs.tar.gz

## Export logs by date range
./manage_logs.sh export --from 2025-01-01 --to 2025-01-31
```

## Automatic Log Rotation

### Rotation Triggers

The system automatically rotates logs based on several criteria:

#### Size-Based Rotation
```bash
## Rotate when log file exceeds size limit
LOG_MAX_SIZE="100MB"  # Default maximum size
LOG_ROTATE_ON_SIZE="true"  # Enable size-based rotation
```

#### Time-Based Rotation
```bash
## Rotate logs daily
LOG_ROTATE_DAILY="true"  # Enable daily rotation
LOG_ROTATE_TIME="00:00"  # Rotation time (midnight)
```

#### Age-Based Rotation
```bash
## Rotate logs older than specified age
LOG_MAX_AGE_DAYS="7"  # Rotate logs older than 7 days
LOG_ROTATE_ON_AGE="true"  # Enable age-based rotation
```

### Rotation Process

When rotation is triggered, the system:

1. **Creates Archive**: Moves current log to archive directory
2. **Compresses Log**: Compresses archived log to save space
3. **Updates Index**: Updates log index and metadata
4. **Cleans Up**: Removes old logs based on retention policy
5. **Starts New Log**: Creates new log file for continued logging

### Rotation Configuration

```bash
## Rotation settings
export LOG_ROTATE_SIZE="100MB"      # Size-based rotation threshold
export LOG_ROTATE_DAILY="true"      # Enable daily rotation
export LOG_ROTATE_TIME="00:00"      # Daily rotation time
export LOG_MAX_AGE_DAYS="30"        # Maximum log age
export LOG_COMPRESS="true"          # Compress archived logs
export LOG_RETENTION_DAYS="90"      # Log retention period
```

## Log Cleanup and Retention

### Automatic Cleanup

The system automatically cleans up old logs based on retention policies:

```bash
## Cleanup settings
export LOG_RETENTION_DAYS="30"      # Keep logs for 30 days
export LOG_CLEANUP_INTERVAL="24h"   # Run cleanup every 24 hours
export LOG_CLEANUP_DRY_RUN="false"  # Actually delete old logs
```

### Manual Cleanup

```bash
## Manual cleanup commands
./manage_logs.sh clean                    # Clean old logs
./manage_logs.sh clean --dry-run          # Show what would be cleaned
./manage_logs.sh clean --force            # Force cleanup without confirmation
./manage_logs.sh clean --older-than 7     # Clean logs older than 7 days
```

### Cleanup Policies

#### Retention by Age
```bash
## Keep logs for specified number of days
LOG_RETENTION_DAYS="30"  # Keep logs for 30 days
```

#### Retention by Size
```bash
## Keep logs until total size exceeds limit
LOG_MAX_TOTAL_SIZE="10GB"  # Maximum total log size
```

#### Retention by Count
```bash
## Keep specified number of log files
LOG_MAX_FILES="1000"  # Maximum number of log files
```

## Log Compression and Storage

### Automatic Compression

The system automatically compresses archived logs to save storage space:

```bash
## Compression settings
export LOG_COMPRESS="true"           # Enable compression
export LOG_COMPRESS_ALGORITHM="gzip" # Compression algorithm
export LOG_COMPRESS_LEVEL="6"        # Compression level (1-9)
```

### Compression Process

1. **Identify Logs**: Find logs eligible for compression
2. **Compress Files**: Compress log files using specified algorithm
3. **Update Metadata**: Update log metadata and index
4. **Verify Integrity**: Verify compressed log integrity
5. **Clean Up**: Remove original uncompressed files

### Storage Optimization

```bash
## Storage optimization
export LOG_DEDUPLICATE="true"        # Remove duplicate log entries
export LOG_OPTIMIZE="true"           # Optimize log storage
export LOG_COMPACT="true"            # Compact log files
```

## Log Indexing and Metadata

### Automatic Indexing

The system automatically creates and maintains log indexes:

```bash
## Index file structure
logs/
├── .index/
│   ├── logs.idx          # Main log index
│   ├── metadata.idx      # Metadata index
│   ├── search.idx        # Search index
│   └── stats.idx         # Statistics index
```

### Metadata Management

Each log file includes comprehensive metadata:

```yaml
## Log metadata example
operation: "flash"
application: "gpio_test"
build_type: "Release"
idf_version: "release/v5.5"
timestamp: "2025-01-15T14:30:22Z"
duration: 45.2
status: "SUCCESS"
file_size: 1250000
compressed_size: 250000
checksum: "sha256:abc123..."
```

### Search Index

The system maintains a search index for fast log searching:

```bash
## Search index features
- Full-text search across all logs
- Pattern matching and filtering
- Metadata-based searches
- Performance-optimized queries
```

## Log Statistics and Analysis

### Log Statistics

```bash
## View log statistics
./manage_logs.sh stats

## Statistics include:
- Total number of logs
- Total log size
- Log distribution by type
- Log distribution by date
- Compression ratios
- Storage usage
```

### Performance Metrics

```bash
## Performance metrics
- Log generation rate
- Search performance
- Compression performance
- Storage efficiency
- Cleanup performance
```

### Trend Analysis

```bash
## Trend analysis
./manage_logs.sh trends --days 30    # 30-day trends
./manage_logs.sh trends --type flash # Flash operation trends
./manage_logs.sh trends --app gpio_test # Application trends
```

## Log Management Best Practices

### Organization

- **Use Consistent Naming**: Follow standard naming conventions
- **Organize by Type**: Group logs by operation type
- **Maintain Hierarchy**: Keep organized directory structure
- **Update Metadata**: Keep metadata current and accurate

### Storage Management

- **Monitor Storage Usage**: Track log storage consumption
- **Implement Rotation**: Use appropriate rotation policies
- **Compress Archives**: Compress old logs to save space
- **Regular Cleanup**: Perform regular log cleanup

### Performance

- **Optimize Indexing**: Maintain efficient search indexes
- **Monitor Performance**: Track log management performance
- **Use Compression**: Compress logs to improve performance
- **Batch Operations**: Use batch operations for efficiency

### Backup and Recovery

- **Regular Backups**: Backup important logs regularly
- **Test Recovery**: Test log recovery procedures
- **Document Procedures**: Document backup and recovery procedures
- **Monitor Integrity**: Monitor log file integrity