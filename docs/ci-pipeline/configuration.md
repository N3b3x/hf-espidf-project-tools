---
title: "Configuration"
parent: "CI Pipeline"
nav_order: 2
---

# CI Pipeline Configuration

## Overview

The CI pipeline configuration system provides flexible and comprehensive configuration options for ESP32 projects, enabling efficient build automation and quality assurance.

## Configuration Files

### Primary Configuration

#### `app_config.yml`
**Purpose**: Centralized application and build configuration
**Location**: Project root or specified path
**Format**: YAML

**Key Sections**:
- **Metadata**: Global project information and defaults
- **Apps**: Application definitions and configurations
- **Build Config**: Build type configurations and options
- **Flash Config**: Flash operation configurations
- **System Config**: System-level configurations

#### Example Configuration
```yaml
metadata:
  name: "ESP32 Project"
  version: "1.0.0"
  description: "ESP32 project with CI/CD"
  default_app: "sensor_app"
  default_build_type: "Release"
  default_target: "esp32"
  idf_versions: ["v4.4.2", "v5.0.0"]

apps:
  sensor_app:
    name: "Sensor Application"
    description: "IoT sensor application"
    path: "apps/sensor"
    build_types: ["Debug", "Release"]
    targets: ["esp32", "esp32s2"]
    idf_versions: ["v4.4.2", "v5.0.0"]
    ci_enabled: true
    featured: true

build_config:
  build_types:
    Debug:
      description: "Debug build with symbols"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG", "VERBOSE_LOGGING"]
    Release:
      description: "Production build"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g"
      defines: ["NDEBUG"]
```

### Workflow Configuration

#### GitHub Actions Workflows
**Location**: `.github/workflows/`
**Format**: YAML

**Key Workflows**:
- **Build Workflow**: Main build automation
- **Security Workflow**: Security scanning and auditing
- **Quality Workflow**: Code quality and static analysis
- **Deploy Workflow**: Deployment automation

#### Example Workflow
```yaml
name: ESP32 Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  generate-matrix:
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
      - uses: actions/checkout@v3
      - name: Generate Build Matrix
        id: set-matrix
        run: |
          python generate_matrix.py --output matrix.json
          echo "matrix=$(cat matrix.json)" >> $GITHUB_OUTPUT

  build:
    needs: generate-matrix
    runs-on: ubuntu-latest
    strategy:
      matrix: ${{ fromJson(needs.generate-matrix.outputs.matrix) }}
    steps:
      - uses: actions/checkout@v3
      - name: Setup ESP-IDF
        uses: espressif/esp-idf-ci-action@v1
        with:
          esp_idf_version: ${{ matrix.idf_version }}
          target: ${{ matrix.target }}
      - name: Build Application
        run: |
          ./build_app.sh ${{ matrix.app }} ${{ matrix.build_type }} ${{ matrix.target }}
```

## Environment Configuration

### Environment Variables

#### Required Variables
```bash
# Project configuration
export ESP32_PROJECT_PATH="/path/to/project"
export CONFIG_FILE="app_config.yml"

# ESP-IDF configuration
export IDF_PATH="/path/to/esp-idf"
export IDF_VERSION="v4.4.2"
export IDF_TARGET="esp32"

# Build configuration
export BUILD_TYPE="Release"
export BUILD_DIR="build"
export LOG_DIR="logs"
```

#### Optional Variables
```bash
# Performance optimization
export IDF_CCACHE_ENABLE=1
export CCACHE_DIR="$HOME/.ccache"
export MAKEFLAGS="-j$(nproc)"

# Debug configuration
export DEBUG=1
export IDF_VERBOSE=1
export VERBOSE_BUILD=1

# CI/CD configuration
export CI=true
export GITHUB_ACTIONS=true
export RUNNER_OS="ubuntu-latest"
```

### Tool Configuration

#### ESP-IDF Configuration
```bash
# ESP-IDF environment setup
source $IDF_PATH/export.sh

# Target configuration
idf.py set-target $IDF_TARGET

# Build configuration
idf.py menuconfig
```

#### Build Tool Configuration
```bash
# CMake configuration
export CMAKE_BUILD_TYPE="Release"
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# Ninja configuration
export NINJA_STATUS="[%f/%t] %e "

# ccache configuration
export CCACHE_ENABLE=1
export CCACHE_DIR="$HOME/.ccache"
export CCACHE_MAXSIZE="10G"
```

## Matrix Configuration

### Build Matrix Generation

#### Matrix Parameters
- **Applications**: List of applications to build
- **Build Types**: Debug, Release, Production
- **Targets**: esp32, esp32s2, esp32c3, esp32s3
- **ESP-IDF Versions**: v4.4.2, v5.0.0, v5.1.0
- **Configurations**: Custom build configurations

#### Matrix Optimization
- **Parallel Execution**: Multiple builds run simultaneously
- **Resource Allocation**: Optimal resource distribution
- **Dependency Management**: Efficient dependency handling
- **Cache Utilization**: Intelligent caching strategies

### Matrix Examples

#### Basic Matrix
```yaml
strategy:
  matrix:
    include:
      - app: sensor_app
        build_type: Release
        target: esp32
        idf_version: v4.4.2
      - app: sensor_app
        build_type: Debug
        target: esp32
        idf_version: v4.4.2
      - app: control_app
        build_type: Release
        target: esp32s2
        idf_version: v5.0.0
```

#### Advanced Matrix
```yaml
strategy:
  matrix:
    include:
      - app: sensor_app
        build_type: Release
        target: esp32
        idf_version: v4.4.2
        config: default
      - app: sensor_app
        build_type: Release
        target: esp32
        idf_version: v4.4.2
        config: low_power
      - app: control_app
        build_type: Release
        target: esp32s2
        idf_version: v5.0.0
        config: safety_critical
```

## Quality Assurance Configuration

### Static Analysis Configuration

#### Code Quality Tools
- **cppcheck**: Static analysis for C/C++
- **clang-tidy**: Clang-based static analysis
- **pylint**: Python code analysis
- **shellcheck**: Shell script analysis

#### Security Scanning Tools
- **bandit**: Python security linter
- **safety**: Python dependency security
- **pip-audit**: Python package vulnerability scanning
- **gitleaks**: Secret detection

#### Configuration Example
```yaml
static_analysis:
  cppcheck:
    enabled: true
    args: ["--enable=all", "--inconclusive", "--std=c++17"]
    exclude_dirs: ["build", "test"]
  
  clang_tidy:
    enabled: true
    checks: ["*", "-readability-*"]
    header_filter: "src/.*"
  
  pylint:
    enabled: true
    args: ["--disable=C0114", "--disable=C0116"]
    config_file: ".pylintrc"
```

### Testing Configuration

#### Unit Testing
- **Framework**: Unity, Google Test
- **Coverage**: gcov, lcov
- **Reporting**: HTML, XML reports

#### Integration Testing
- **Hardware-in-the-Loop**: HIL testing
- **Simulation**: Software simulation
- **Performance**: Benchmark testing

#### Configuration Example
```yaml
testing:
  unit_tests:
    enabled: true
    framework: "unity"
    coverage: true
    threshold: 80
  
  integration_tests:
    enabled: true
    type: "simulation"
    timeout: 300
  
  performance_tests:
    enabled: true
    benchmarks: ["memory", "cpu", "power"]
```

## Deployment Configuration

### Artifact Management

#### Build Artifacts
- **Firmware Binaries**: .bin, .elf, .hex files
- **Build Logs**: Comprehensive build logs
- **Test Reports**: Test results and coverage
- **Documentation**: Generated documentation

#### Artifact Storage
- **GitHub Actions**: Built-in artifact storage
- **External Storage**: S3, Azure Blob, Google Cloud
- **CDN Integration**: Content delivery networks
- **Version Control**: Git-based artifact management

### Deployment Targets

#### Development Environment
- **Local Development**: Developer workstations
- **Staging Environment**: Pre-production testing
- **Integration Environment**: Continuous integration

#### Production Environment
- **Production Deployment**: Live production systems
- **Rollback Capability**: Quick rollback mechanisms
- **Monitoring**: Production monitoring and alerting

## Performance Configuration

### Build Performance

#### Parallel Processing
- **Job Parallelization**: Multiple jobs run simultaneously
- **Build Parallelization**: Multi-core build processes
- **Cache Optimization**: Intelligent caching strategies
- **Resource Management**: Optimal resource allocation

#### Performance Monitoring
- **Build Metrics**: Build time, success rate
- **Resource Usage**: CPU, memory, disk usage
- **Cache Performance**: Cache hit rates, efficiency
- **Queue Management**: Job queue optimization

### CI/CD Performance

#### Pipeline Optimization
- **Matrix Optimization**: Efficient matrix generation
- **Job Optimization**: Optimized job execution
- **Dependency Optimization**: Efficient dependency management
- **Artifact Optimization**: Optimized artifact handling

#### Performance Metrics
- **Pipeline Duration**: End-to-end pipeline time
- **Job Duration**: Individual job execution time
- **Queue Time**: Time spent in job queue
- **Resource Utilization**: Resource usage efficiency

## Troubleshooting Configuration

### Debug Configuration

#### Debug Modes
- **Verbose Logging**: Detailed logging output
- **Debug Symbols**: Debug symbol generation
- **Trace Logging**: Execution trace logging
- **Performance Profiling**: Performance analysis

#### Debug Tools
- **Log Analysis**: Comprehensive log analysis
- **Error Tracking**: Error tracking and reporting
- **Performance Profiling**: Performance analysis tools
- **Memory Debugging**: Memory leak detection

### Error Handling

#### Error Recovery
- **Retry Logic**: Automatic retry mechanisms
- **Fallback Strategies**: Alternative execution paths
- **Error Notifications**: Real-time error alerts
- **Recovery Procedures**: Automated recovery processes

#### Monitoring and Alerting
- **Real-time Monitoring**: Live pipeline monitoring
- **Alert Configuration**: Customizable alert rules
- **Notification Channels**: Multiple notification methods
- **Escalation Procedures**: Automated escalation processes