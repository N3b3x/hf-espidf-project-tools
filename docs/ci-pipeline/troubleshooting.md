---
title: "Troubleshooting"
parent: "CI Pipeline"
nav_order: 4
---

# CI Pipeline Troubleshooting

## Overview

This guide helps resolve common issues with the HardFOC ESP32 CI Pipeline when using the reusable workflows from the separate CI repository.

## Common Issues

### Workflow Integration Issues

#### Workflow Not Found
**Symptoms**: "Workflow not found" or "Action not found" errors
**Solutions**:
```yaml
# Ensure correct workflow reference
uses: N3b3x/hf-espidf-ci-tools/.github/workflows/build.yml@main

# Check if the repository exists and is accessible
# Verify the workflow file exists at the specified path
```

#### Permission Issues
**Symptoms**: "Permission denied" or "Insufficient permissions" errors
**Solutions**:
```yaml
# Add required permissions to your workflow
permissions:
  contents: read
  actions: read
  pull-requests: write   # needed for PR comment in size-report
  security-events: write # needed for security workflow
```

### Build Failures

#### Project Directory Not Found
**Symptoms**: "Project directory not found" or "CMakeLists.txt not found" errors
**Solutions**:
```yaml
# Verify project_dir path is correct
with:
  project_dir: "examples/esp32"  # Should contain CMakeLists.txt
  project_tools_dir: "scripts"   # Should contain build scripts
```

#### Tools Directory Issues
**Symptoms**: "Scripts not found" or "build_app.sh not found" errors
**Solutions**:
```yaml
# Enable auto-clone tools if scripts are missing
with:
  auto_clone_tools: true
  project_tools_dir: "scripts"  # Leave empty to auto-detect
```

#### Configuration Errors
**Symptoms**: Build fails with configuration errors
**Solutions**:
```bash
# Validate configuration
./config_loader.sh validate

# Check YAML syntax
yq eval '.' app_config.yml

# Check configuration structure
./config_loader.sh check-structure

# Use default configuration
./build_app.sh my_app release esp32 --use-defaults
```

#### Build Type Not Supported
**Symptoms**: Build fails with "Build type not supported" errors
**Solutions**:
```bash
# Check supported build types
./build_app.sh list

# Validate build type
./build_app.sh validate my_app Release

# Use supported build type
./build_app.sh my_app Debug esp32
```

#### Target Not Supported
**Symptoms**: Build fails with "Target not supported" errors
**Solutions**:
```bash
# Check supported targets
./build_app.sh list

# Validate target
./build_app.sh validate my_app Release esp32

# Use supported target
./build_app.sh my_app Release esp32s2
```

### CI/CD Issues

#### Workflow Not Triggering
**Symptoms**: Workflow doesn't run on push or pull request
**Solutions**:
```bash
# Check workflow triggers
cat .github/workflows/build.yml

# Verify branch names
git branch -a

# Check workflow syntax
yamllint .github/workflows/build.yml

# Test workflow manually
gh workflow run build.yml
```

#### Matrix Build Failures
**Symptoms**: Some matrix entries fail while others succeed
**Solutions**:
```bash
# Check matrix generation
python generate_matrix.py --debug

# Validate matrix configuration
python generate_matrix.py --validate

# Check individual matrix entries
./build_app.sh validate my_app Release esp32
```

#### Artifact Upload Failures
**Symptoms**: Artifacts fail to upload or are corrupted
**Solutions**:
```bash
# Check artifact size
ls -lh build/

# Check disk space
df -h

# Clean build directory
./build_app.sh my_app release esp32 --clean

# Check artifact permissions
ls -la build/
```

### Performance Issues

#### Slow Builds
**Symptoms**: Builds take longer than expected
**Solutions**:
```bash
# Check ccache status
ccache -s

# Enable ccache
export IDF_CCACHE_ENABLE=1

# Clear ccache
ccache -C

# Use more parallel jobs
export MAKEFLAGS="-j$(nproc)"
```

#### High Memory Usage
**Symptoms**: Build fails due to memory issues
**Solutions**:
```bash
# Check memory usage
free -h

# Reduce parallel jobs
export MAKEFLAGS="-j2"

# Use swap
sudo swapon -a

# Check for memory leaks
ps aux --sort=-%mem
```

#### Cache Performance Issues
**Symptoms**: Low cache hit rates or cache corruption
**Solutions**:
```bash
# Check cache statistics
ccache -s

# Clear cache
ccache -C

# Reconfigure cache
ccache -M 10G

# Check cache directory
ls -la ~/.ccache/
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

### CI/CD Logs
```bash
# Check GitHub Actions logs
gh run list
gh run view <run-id>

# Download logs
gh run download <run-id>

# Check specific job logs
gh run view <run-id> --log-failed
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

## Configuration Issues

### YAML Configuration
```bash
# Validate YAML syntax
yq eval '.' app_config.yml

# Check YAML structure
yq eval '.metadata' app_config.yml
yq eval '.apps' app_config.yml
yq eval '.build_config' app_config.yml

# Fix YAML indentation
yq eval '.' app_config.yml > app_config_fixed.yml
```

### Environment Variables
```bash
# Check environment variables
env | grep IDF
env | grep ESP
env | grep BUILD

# Set required variables
export IDF_PATH=/path/to/esp-idf
export IDF_VERSION=v4.4.2
export IDF_TARGET=esp32

# Verify variables
echo $IDF_PATH
echo $IDF_VERSION
echo $IDF_TARGET
```

### Tool Configuration
```bash
# Check tool availability
which yq
which jq
which cmake
which ninja

# Install missing tools
./setup_repo.sh --install-tools

# Check tool versions
yq --version
jq --version
cmake --version
ninja --version
```

## Performance Troubleshooting

### Build Performance
```bash
# Check build time
time ./build_app.sh my_app release esp32

# Profile build process
strace -c ./build_app.sh my_app release esp32

# Check resource usage
htop
iostat -x 1
```

### Cache Performance
```bash
# Check cache hit rate
ccache -s

# Monitor cache usage
watch -n 1 'ccache -s'

# Check cache directory
du -sh ~/.ccache/
ls -la ~/.ccache/
```

### Memory Performance
```bash
# Check memory usage
free -h
ps aux --sort=-%mem

# Monitor memory usage
watch -n 1 'free -h'

# Check for memory leaks
valgrind --tool=memcheck ./build_app.sh my_app release esp32
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

## Diagnostic Checklist

### Pre-Flight Checks
- [ ] ESP-IDF is installed and accessible
- [ ] Required tools are installed
- [ ] Configuration file exists and is valid
- [ ] Environment variables are set correctly
- [ ] Project files are accessible

### Build System Checks
- [ ] Configuration validation passes
- [ ] Build parameters are valid
- [ ] Dependencies are available
- [ ] Build directory is writable
- [ ] Cache is configured correctly

### CI/CD Checks
- [ ] Workflow files are valid
- [ ] Matrix generation works
- [ ] Artifacts are generated correctly
- [ ] Logs are accessible
- [ ] Notifications are working

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