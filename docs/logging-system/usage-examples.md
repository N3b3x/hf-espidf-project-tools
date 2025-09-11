---
title: "Usage Examples and Patterns"
parent: "Logging System"
nav_order: 6
---

# Usage Examples and Patterns

## Overview

This document provides comprehensive usage examples and patterns for the ESP32 logging system, covering common workflows, advanced patterns, and integration scenarios.

## Basic Usage Examples

### Simple Log Generation

```bash
## Generate logs for build operations
./build_app.sh gpio_test Release --log

## Generate logs for flash operations
./flash_app.sh flash gpio_test Release --log

## Generate logs for monitor sessions
./flash_app.sh monitor --log

## Generate logs for size analysis
./flash_app.sh size gpio_test Release --log
```

### Custom Log Names

```bash
## Use custom log names
./flash_app.sh flash gpio_test Release --log production_deploy
./flash_app.sh monitor --log debug_session
./build_app.sh gpio_test Release --log ci_build
./flash_app.sh size gpio_test Release --log size_analysis
```

### Log Management

```bash
## List all logs
./manage_logs.sh list

## Show latest log
./manage_logs.sh latest

## Search for errors
./manage_logs.sh search "ERROR"

## Show log statistics
./manage_logs.sh stats
```

## Advanced Usage Patterns

### Development Workflow

```bash
#!/bin/bash
## Development workflow with comprehensive logging

## Build application with logging
echo "Building application..."
./build_app.sh gpio_test Debug --log dev_build

## Check build status
if [ $? -eq 0 ]; then
    echo "Build successful"
    
    ## Flash application with logging
    echo "Flashing application..."
    ./flash_app.sh flash_monitor gpio_test Debug --log dev_flash
    
    ## Monitor for debugging
    echo "Starting monitor session..."
    ./flash_app.sh monitor --log dev_monitor
else
    echo "Build failed, checking logs..."
    ./manage_logs.sh search "ERROR" --type build
fi
```

### Production Deployment

```bash
#!/bin/bash
## Production deployment with logging

## Build for production
echo "Building production firmware..."
./build_app.sh gpio_test Release --log production_build

## Verify build
if [ $? -eq 0 ]; then
    echo "Production build successful"
    
    ## Flash to production device
    echo "Flashing production firmware..."
    ./flash_app.sh flash gpio_test Release --log production_deploy
    
    ## Verify flash
    if [ $? -eq 0 ]; then
        echo "Production deployment successful"
        
        ## Generate deployment report
        ./manage_logs.sh report --type flash --output production_report.html
    else
        echo "Production deployment failed"
        ./manage_logs.sh search "ERROR" --type flash
    fi
else
    echo "Production build failed"
    ./manage_logs.sh search "ERROR" --type build
fi
```

### Automated Testing

```bash
#!/bin/bash
## Automated testing with logging

## Test configuration
TEST_APPS=("gpio_test" "adc_test" "uart_test")
BUILD_TYPES=("Debug" "Release")
TEST_TIMEOUT=60

## Run tests for each application
for app in "${TEST_APPS[@]}"; do
    for build_type in "${BUILD_TYPES[@]}"; do
        echo "Testing $app $build_type"
        
        ## Build application
        ./build_app.sh $app $build_type --log "test_build_${app}_${build_type}"
        
        if [ $? -eq 0 ]; then
            ## Flash application
            ./flash_app.sh flash $app $build_type --log "test_flash_${app}_${build_type}"
            
            if [ $? -eq 0 ]; then
                ## Monitor and test
                timeout $TEST_TIMEOUT ./flash_app.sh monitor --log "test_monitor_${app}_${build_type}"
                
                ## Analyze test results
                ./manage_logs.sh search "ERROR" --type monitor --app $app
            fi
        fi
    done
done

## Generate test report
./manage_logs.sh report --type all --output test_report.html
```

## Log Analysis Examples

### Error Analysis

```bash
## Find all errors in the last 7 days
./manage_logs.sh search "ERROR" --days 7

## Find errors by type
./manage_logs.sh search "ERROR" --type flash --days 7
./manage_logs.sh search "ERROR" --type build --days 7

## Find errors by application
./manage_logs.sh search "ERROR" --app gpio_test --days 7
./manage_logs.sh search "ERROR" --app adc_test --days 7

## Analyze error patterns
./manage_logs.sh analyze-errors --days 7
./manage_logs.sh analyze-errors --type flash --days 7
```

### Performance Analysis

```bash
## Find performance issues
./manage_logs.sh search "timeout" --days 7
./manage_logs.sh search "slow" --days 7
./manage_logs.sh search "memory" --days 7

## Analyze performance trends
./manage_logs.sh analyze-performance --days 30
./manage_logs.sh analyze-performance --type flash --days 30

## Generate performance report
./manage_logs.sh report --type performance --output performance_report.html
```

### Success Rate Analysis

```bash
## Find successful operations
./manage_logs.sh search "completed successfully" --days 7
./manage_logs.sh search "Flash completed" --days 7
./manage_logs.sh search "Build completed" --days 7

## Analyze success rates
./manage_logs.sh analyze-success --days 7
./manage_logs.sh analyze-success --type flash --days 7

## Generate success report
./manage_logs.sh report --type success --output success_report.html
```

## Integration Examples

### CI/CD Integration

```yaml
## GitHub Actions workflow with logging
name: ESP32 Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup ESP-IDF
      uses: espressif/esp-idf-ci-action@v1
      with:
        esp_idf_version: 'release/v5.5'
        target: 'esp32c6'
    
    - name: Build Application
      run: |
        cd examples/esp32
        ./scripts/build_app.sh gpio_test Release --log ci_build
    
    - name: Flash Application
      run: |
        cd examples/esp32
        ./scripts/flash_app.sh flash gpio_test Release --log ci_flash
    
    - name: Run Tests
      run: |
        cd examples/esp32
        timeout 60s ./scripts/flash_app.sh monitor --log ci_test
    
    - name: Analyze Logs
      run: |
        cd examples/esp32
        ./scripts/manage_logs.sh search "ERROR" --ci
        ./scripts/manage_logs.sh analyze-errors --ci
    
    - name: Upload Logs
      uses: actions/upload-artifact@v4
      with:
        name: build-logs
        path: examples/esp32/logs/
```

### Docker Integration

```dockerfile
## Dockerfile with logging support
FROM espressif/idf:release-v5.5

## Copy project files
COPY . /workspace
WORKDIR /workspace

## Install logging tools
RUN apt-get update && apt-get install -y \
    jq \
    && rm -rf /var/lib/apt/lists/*

## Create logging script
RUN echo '#!/bin/bash\n\
cd /workspace/examples/esp32\n\
./scripts/manage_logs.sh "$@"' > /usr/local/bin/logs
RUN chmod +x /usr/local/bin/logs

## Default command
CMD ["/bin/bash"]
```

```bash
## Docker usage with logging
docker build -t esp32-dev .
docker run -it --device=/dev/ttyUSB0 esp32-dev \
  ./scripts/flash_app.sh flash gpio_test Release --log docker_flash
```

### Python Integration

```python
#!/usr/bin/env python3
## Python script for log analysis

import subprocess
import json
import sys
import os

class LogAnalyzer:
    def __init__(self, project_path="examples/esp32"):
        self.project_path = project_path
        self.scripts_path = os.path.join(project_path, "scripts")
    
    def search_logs(self, pattern, log_type=None, days=7):
        """Search logs for specific pattern"""
        cmd = [
            os.path.join(self.scripts_path, "manage_logs.sh"),
            "search", pattern
        ]
        
        if log_type:
            cmd.extend(["--type", log_type])
        
        cmd.extend(["--days", str(days)])
        
        try:
            result = subprocess.run(cmd, cwd=self.project_path,
                                  capture_output=True, text=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            print(f"Search failed: {e}")
            return None
    
    def analyze_errors(self, days=7):
        """Analyze error patterns"""
        cmd = [
            os.path.join(self.scripts_path, "manage_logs.sh"),
            "analyze-errors", "--days", str(days)
        ]
        
        try:
            result = subprocess.run(cmd, cwd=self.project_path,
                                  capture_output=True, text=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            print(f"Analysis failed: {e}")
            return None
    
    def get_statistics(self, days=7):
        """Get log statistics"""
        cmd = [
            os.path.join(self.scripts_path, "manage_logs.sh"),
            "stats", "--days", str(days)
        ]
        
        try:
            result = subprocess.run(cmd, cwd=self.project_path,
                                  capture_output=True, text=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            print(f"Statistics failed: {e}")
            return None

## Usage example
if __name__ == "__main__":
    analyzer = LogAnalyzer()
    
    # Search for errors
    errors = analyzer.search_logs("ERROR", days=7)
    if errors:
        print("Errors found:")
        print(errors)
    
    # Analyze error patterns
    analysis = analyzer.analyze_errors(days=7)
    if analysis:
        print("Error analysis:")
        print(analysis)
    
    # Get statistics
    stats = analyzer.get_statistics(days=7)
    if stats:
        print("Log statistics:")
        print(stats)
```

## Monitoring and Alerting Examples

### Log Monitoring Script

```bash
#!/bin/bash
## Log monitoring script

## Configuration
LOG_DIR="logs"
ERROR_THRESHOLD=5
WARNING_THRESHOLD=10
CHECK_INTERVAL=300  # 5 minutes

## Monitor logs for errors
monitor_logs() {
    while true; do
        ## Check error count
        error_count=$(./manage_logs.sh search "ERROR" --count --days 1)
        
        if [ "$error_count" -gt "$ERROR_THRESHOLD" ]; then
            echo "ALERT: High error count: $error_count"
            ## Send alert notification
            send_alert "High error count: $error_count"
        fi
        
        ## Check warning count
        warning_count=$(./manage_logs.sh search "WARNING" --count --days 1)
        
        if [ "$warning_count" -gt "$WARNING_THRESHOLD" ]; then
            echo "WARNING: High warning count: $warning_count"
            ## Send warning notification
            send_warning "High warning count: $warning_count"
        fi
        
        ## Wait before next check
        sleep $CHECK_INTERVAL
    done
}

## Send alert notification
send_alert() {
    local message="$1"
    echo "ALERT: $message"
    ## Add notification logic here (email, Slack, etc.)
}

## Send warning notification
send_warning() {
    local message="$1"
    echo "WARNING: $message"
    ## Add notification logic here (email, Slack, etc.)
}

## Start monitoring
monitor_logs
```

### Automated Reporting

```bash
#!/bin/bash
## Automated reporting script

## Configuration
REPORT_DIR="reports"
DAYS=7

## Generate daily report
generate_daily_report() {
    local date=$(date +%Y%m%d)
    local report_file="$REPORT_DIR/daily_report_$date.html"
    
    echo "Generating daily report for $date..."
    
    ## Generate comprehensive report
    ./manage_logs.sh report --days $DAYS --output "$report_file"
    
    ## Generate error analysis
    ./manage_logs.sh analyze-errors --days $DAYS --output "$REPORT_DIR/error_analysis_$date.html"
    
    ## Generate performance analysis
    ./manage_logs.sh analyze-performance --days $DAYS --output "$REPORT_DIR/performance_analysis_$date.html"
    
    echo "Daily report generated: $report_file"
}

## Generate weekly report
generate_weekly_report() {
    local date=$(date +%Y%m%d)
    local report_file="$REPORT_DIR/weekly_report_$date.html"
    
    echo "Generating weekly report for $date..."
    
    ## Generate comprehensive report
    ./manage_logs.sh report --days 7 --output "$report_file"
    
    echo "Weekly report generated: $report_file"
}

## Generate monthly report
generate_monthly_report() {
    local date=$(date +%Y%m%d)
    local report_file="$REPORT_DIR/monthly_report_$date.html"
    
    echo "Generating monthly report for $date..."
    
    ## Generate comprehensive report
    ./manage_logs.sh report --days 30 --output "$report_file"
    
    echo "Monthly report generated: $report_file"
}

## Main execution
case "$1" in
    daily)
        generate_daily_report
        ;;
    weekly)
        generate_weekly_report
        ;;
    monthly)
        generate_monthly_report
        ;;
    *)
        echo "Usage: $0 {daily|weekly|monthly}"
        exit 1
        ;;
esac
```

## Best Practices

### Log Generation

- **Always Use Logging**: Enable logging for all operations
- **Use Descriptive Names**: Use descriptive log file names
- **Include Context**: Include relevant context in logs
- **Monitor Performance**: Track log generation performance

### Log Analysis

- **Regular Analysis**: Perform regular log analysis
- **Use Filters**: Use appropriate filters for analysis
- **Monitor Trends**: Monitor trends over time
- **Document Findings**: Document analysis findings

### Integration

- **Use Standard Formats**: Export to standard log formats
- **Maintain Compatibility**: Ensure compatibility with external tools
- **Document APIs**: Document all API endpoints and usage
- **Test Integration**: Test integration thoroughly

### Automation

- **Automate Analysis**: Automate log analysis where possible
- **Set Up Monitoring**: Set up automated monitoring and alerting
- **Regular Cleanup**: Automate log cleanup and maintenance
- **Backup Important Logs**: Backup critical logs regularly