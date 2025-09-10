---
title: "Troubleshooting"
parent: "Build System"
nav_order: 5
---

# Build System Troubleshooting

## Common Issues

### Configuration Issues

#### Invalid Configuration File
**Symptoms**: Build fails with configuration errors
**Solutions**:
```bash
# Validate configuration
./config_loader.sh validate

# Check YAML syntax
yq eval '.' app_config.yml

# Check configuration structure
./config_loader.sh check-structure
```

#### Missing Configuration
**Symptoms**: Build fails with missing configuration errors
**Solutions**:
```bash
# Check configuration file exists
ls -la app_config.yml

# Use default configuration
./build_app.sh my_app release esp32 --use-defaults

# Generate sample configuration
./config_loader.sh generate-sample
```

### Environment Issues

#### ESP-IDF Not Found
**Symptoms**: Build fails with ESP-IDF not found errors
**Solutions**:
```bash
# Check ESP-IDF installation
./manage_idf.sh list

# Install ESP-IDF
./manage_idf.sh install v4.4.2

# Set ESP-IDF path
export IDF_PATH=/path/to/esp-idf
export PATH=$IDF_PATH/tools:$PATH
```

#### Missing Tools
**Symptoms**: Build fails with missing tool errors
**Solutions**:
```bash
# Check tool availability
./setup_common.sh check-tools

# Install missing tools
./setup_repo.sh --install-tools

# Check specific tool
which yq
which jq
which cmake
```

#### Permission Issues
**Symptoms**: Build fails with permission denied errors
**Solutions**:
```bash
# Check file permissions
ls -la build_app.sh

# Fix permissions
chmod +x build_app.sh
chmod +x flash_app.sh

# Check directory permissions
ls -la build/
chmod -R 755 build/
```

### Build Issues

#### Build Fails
**Symptoms**: Build process fails with errors
**Solutions**:
```bash
# Clean build directory
./build_app.sh my_app release esp32 --clean

# Check build logs
./manage_logs.sh analyze --build

# Enable verbose output
./build_app.sh my_app release esp32 --verbose

# Check dependencies
./setup_common.sh check-dependencies
```

#### Memory Issues
**Symptoms**: Build fails with memory errors
**Solutions**:
```bash
# Reduce parallel jobs
./build_app.sh my_app release esp32 --jobs 1

# Check available memory
free -h

# Use swap if available
sudo swapon -a
```

#### Compilation Errors
**Symptoms**: Compilation fails with errors
**Solutions**:
```bash
# Check ESP-IDF version
./manage_idf.sh list

# Switch to compatible version
./manage_idf.sh switch v4.4.2

# Check target compatibility
./build_app.sh my_app release esp32 --check-target

# Clean and rebuild
./build_app.sh my_app release esp32 --clean
```

### Flash Issues

#### Port Not Found
**Symptoms**: Flash fails with port not found errors
**Solutions**:
```bash
# List available ports
./detect_ports.sh --list

# Check port permissions
ls -la /dev/ttyUSB*

# Fix port permissions
sudo chmod 666 /dev/ttyUSB0

# Use specific port
./flash_app.sh flash my_app release esp32 --port /dev/ttyUSB0
```

#### Permission Denied
**Symptoms**: Flash fails with permission denied errors
**Solutions**:
```bash
# Check user groups
groups $USER

# Add user to dialout group
sudo usermod -a -G dialout $USER

# Log out and log back in
# Or use newgrp
newgrp dialout
```

#### Device Not Responding
**Symptoms**: Device doesn't respond to flash commands
**Solutions**:
```bash
# Check device connection
./detect_ports.sh --test

# Try different baud rate
./flash_app.sh flash my_app release esp32 --baud 115200

# Reset device manually
# Press and hold BOOT button, press RESET, release BOOT

# Check device drivers
lsmod | grep usbserial
```

## Debug Mode

### Enable Debug Mode
```bash
# Set debug environment variable
export DEBUG=1

# Or use debug flag
./build_app.sh my_app release esp32 --debug
./flash_app.sh flash my_app release esp32 --debug
```

### Debug Output
```bash
# Check debug logs
./manage_logs.sh analyze --debug

# View debug log files
ls -la logs/debug/

# Tail debug logs
tail -f logs/debug/build.log
```

### Debug Information
```bash
# Show environment information
./setup_common.sh show-environment

# Show configuration information
./config_loader.sh show-config

# Show tool information
./setup_common.sh show-tools
```

## Log Analysis

### Build Logs
```bash
# List build logs
./manage_logs.sh list --build

# Analyze build logs
./manage_logs.sh analyze --build

# Show build statistics
./manage_logs.sh stats --build
```

### Flash Logs
```bash
# List flash logs
./manage_logs.sh list --flash

# Analyze flash logs
./manage_logs.sh analyze --flash

# Show flash statistics
./manage_logs.sh stats --flash
```

### Error Logs
```bash
# List error logs
./manage_logs.sh list --error

# Analyze error logs
./manage_logs.sh analyze --error

# Show error statistics
./manage_logs.sh stats --error
```

## Performance Issues

### Slow Builds
**Symptoms**: Builds take too long
**Solutions**:
```bash
# Enable ccache
export CCACHE_ENABLE=1

# Check ccache status
ccache -s

# Clear ccache
ccache -C

# Use more parallel jobs
./build_app.sh my_app release esp32 --jobs 8
```

### High Memory Usage
**Symptoms**: System runs out of memory during build
**Solutions**:
```bash
# Reduce parallel jobs
./build_app.sh my_app release esp32 --jobs 2

# Check memory usage
free -h
top

# Use swap
sudo swapon -a
```

### Disk Space Issues
**Symptoms**: Build fails due to insufficient disk space
**Solutions**:
```bash
# Check disk space
df -h

# Clean build directory
./build_app.sh my_app release esp32 --clean

# Clean logs
./manage_logs.sh clean --old

# Clean cache
./manage_logs.sh clean --cache
```

## Recovery Procedures

### Complete Reset
```bash
# Clean everything
./build_app.sh my_app release esp32 --clean
./manage_logs.sh clean --all

# Reinstall tools
./setup_repo.sh --force

# Reinstall ESP-IDF
./manage_idf.sh remove v4.4.2
./manage_idf.sh install v4.4.2
```

### Configuration Reset
```bash
# Backup current configuration
cp app_config.yml app_config.yml.backup

# Generate new configuration
./config_loader.sh generate-sample > app_config.yml

# Restore from backup if needed
cp app_config.yml.backup app_config.yml
```

### Environment Reset
```bash
# Reset environment variables
unset IDF_PATH
unset IDF_VERSION
unset IDF_TARGET

# Re-source environment
source ~/.bashrc
source ~/.profile

# Re-run setup
./setup_repo.sh
```

## Getting Help

### Self-Service
- Check this troubleshooting guide
- Review build logs
- Check configuration files
- Verify environment setup

### Community Support
- GitHub Issues: Report bugs and request features
- GitHub Discussions: Ask questions and share experiences
- Documentation: Check comprehensive documentation

### Professional Support
- Contact HardFOC for professional support
- Custom development and consulting
- Training and workshops