---
title: "Architecture"
parent: "CI Pipeline"
nav_order: 1
---

# CI Pipeline Architecture

## Overview

The HardFOC ESP32 CI Pipeline is now implemented as reusable workflows hosted in a separate repository. This architecture provides better separation of concerns, easier maintenance, and consistent CI/CD across multiple projects.

## Repository Structure

### CI Pipeline Repository
**Location**: https://github.com/N3b3x/hf-espidf-ci-tools

**Contents**:
- **Reusable Workflows**: `build.yml` and `security.yml`
- **GitHub Actions**: Helper actions for tool management
- **Documentation**: Complete CI pipeline documentation

### Project Repository Integration

```
┌─────────────────────────────────────────────────────────────────┐
│                    PROJECT REPOSITORY                           │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │   .github/      │    │   examples/     │    │   scripts/  │  │
│  │   workflows/    │    │   esp32/        │    │             │  │
│  │   ├─ build.yml  │    │   ├─ CMakeLists │    │   ├─ build_ │  │
│  │   └─ security.  │    │   │   .txt      │    │   │   app.  │  │
│  │      yml        │    │   ├─ app_config │    │   │   sh    │  │
│  │                 │    │   │   .yml      │    │   ├─ flash_ │  │
│  │                 │    │   └─ main/      │    │   │   app.  │  │
│  │                 │    │                 │    │   │   sh    │  │
│  │                 │    │                 │    │   └─ ...    │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                CI PIPELINE REPOSITORY                          │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │   .github/      │    │   .github/      │    │   docs/     │  │
│  │   workflows/    │    │   actions/      │    │             │  │
│  │   ├─ build.yml  │    │   ├─ ensure-    │    │   ├─ README │  │
│  │   └─ security.  │    │   │   tools-    │    │   │   .md   │  │
│  │      yml        │    │   │   directory │    │   └─ ...    │  │
│  │                 │    │   └─ ...        │    │             │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Workflow Architecture

### Build Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    BUILD WORKFLOW                              │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │   generate-     │    │   build         │    │   size-     │  │
│  │   matrix        │    │   (matrix)      │    │   report    │  │
│  │                 │    │                 │    │             │  │
│  │   • Validate    │    │   • Matrix      │    │   • Download│  │
│  │     tools dir   │    │     execution   │    │     artifacts│  │
│  │   • Generate    │    │   • ESP-IDF     │    │   • Size    │  │
│  │     matrix      │    │     build       │    │     analysis│  │
│  │   • Output      │    │   • Artifact    │    │   • PR      │  │
│  │     matrix      │    │     upload      │    │     comment │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Security Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  SECURITY WORKFLOW                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │   generate-     │    │   dependencies  │    │   secrets   │  │
│  │   matrix        │    │                 │    │             │  │
│  │                 │    │   • pip-audit   │    │   • gitleaks│  │
│  │   • Validate    │    │   • safety      │    │   • Secret  │  │
│  │     tools dir   │    │   • bandit      │    │     detection│  │
│  │   • Generate    │    │   • Python      │    │   • Report  │  │
│  │     matrix      │    │     analysis    │    │     upload  │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
│                                │                                │
│                                ▼                                │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    codeql                                  │ │
│  │                                                             │ │
│  │   • Matrix execution                                       │ │
│  │   • CodeQL analysis                                        │ │
│  │   • Security scanning                                      │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Component Interaction

- **Matrix Generation**: Single execution with result reuse
- **Build Jobs**: Independent runners for each matrix entry
- **Analysis Jobs**: Parallel static analysis and quality checks
- **Artifact Management**: Centralized artifact collection and distribution

## Job Structure

### 1. Generate Matrix Job

**Purpose**: Generate build matrix for parallel execution
**Execution**: Single job, runs once
**Output**: Matrix configuration for downstream jobs

**Key Features**:
- YAML configuration parsing
- Matrix generation for build combinations
- ESP-IDF version and target combinations
- CI/CD optimization

### 2. Build Jobs

**Purpose**: Build ESP32 applications
**Execution**: Parallel execution based on matrix
**Dependencies**: ESP-IDF toolchain, project files

**Key Features**:
- Independent execution per matrix entry
- Fresh runner for each build
- Direct project building
- Artifact generation

### 3. Static Analysis Jobs

**Purpose**: Code quality and security analysis
**Execution**: Parallel execution independent of builds
**Dependencies**: Source code, analysis tools

**Key Features**:
- Parallel static analysis
- Security scanning
- Code quality checks
- Performance analysis

### 4. Workflow Lint Jobs

**Purpose**: Workflow validation and linting
**Execution**: Parallel execution
**Dependencies**: Workflow files, linting tools

**Key Features**:
- YAML linting
- Workflow validation
- Security scanning
- Best practices checking

## Environment Setup Architecture

### Local Development Setup

**Script**: `setup_repo.sh`
**Purpose**: Local environment setup
**Features**:
- Tool installation
- Environment configuration
- Permission management
- Integration with setup_common.sh

### CI/CD Environment Setup

**Action**: Direct ESP-IDF CI action
**Purpose**: CI/CD environment setup
**Features**:
- Optimized for CI/CD workflows
- Minimal local dependencies
- Fresh environment per job
- Toolchain management

### Shared Utilities

**Script**: `setup_common.sh`
**Purpose**: Shared environment setup utilities
**Features**:
- Environment variable management
- Tool installation and verification
- Cross-platform compatibility
- Error handling and validation

## Performance Optimizations

### Matrix Generation Optimization

- **Single Execution**: Matrix generated once, reused across jobs
- **Result Caching**: Cached results for faster subsequent runs
- **Parallel Processing**: Concurrent matrix generation
- **Memory Optimization**: Efficient memory usage

### Build Job Optimization

- **Independent Execution**: Each matrix entry gets fresh runner
- **Parallel Processing**: Multiple builds run simultaneously
- **Resource Optimization**: Optimal resource allocation per job
- **Cache Management**: Intelligent caching strategies

### Analysis Job Optimization

- **Parallel Execution**: Analysis runs independently of builds
- **Lightweight Setup**: Minimal setup for analysis jobs
- **Tool Optimization**: Efficient tool usage
- **Result Aggregation**: Centralized result collection

## Integration Points

### ESP-IDF Integration

- **Toolchain Management**: Automatic ESP-IDF setup
- **Version Support**: Multi-version ESP-IDF support
- **Target Support**: Multiple ESP32 targets
- **Build Integration**: Seamless build process integration

### GitHub Actions Integration

- **Workflow Triggers**: Push, pull request, manual triggers
- **Matrix Strategy**: Dynamic matrix generation
- **Artifact Management**: Automatic artifact collection
- **Notification Integration**: Status notifications

### Quality Assurance Integration

- **Static Analysis**: Code quality checks
- **Security Scanning**: Security vulnerability scanning
- **Performance Testing**: Performance benchmarks
- **Compliance Checking**: Regulatory compliance validation

## Scalability and Reliability

### Horizontal Scaling

- **Parallel Execution**: Multiple jobs run simultaneously
- **Resource Distribution**: Optimal resource allocation
- **Load Balancing**: Intelligent load distribution
- **Auto-scaling**: Dynamic resource allocation

### Vertical Scaling

- **Resource Optimization**: Efficient resource usage
- **Memory Management**: Optimal memory allocation
- **CPU Optimization**: Multi-core utilization
- **Storage Optimization**: Efficient storage usage

### Reliability Features

- **Error Handling**: Comprehensive error handling
- **Retry Logic**: Automatic retry mechanisms
- **Fallback Strategies**: Alternative execution paths
- **Monitoring**: Real-time monitoring and alerting

## Security Considerations

### Access Control

- **Permission Management**: Granular permission control
- **Authentication**: Secure authentication mechanisms
- **Authorization**: Role-based access control
- **Audit Logging**: Comprehensive audit trails

### Data Protection

- **Encryption**: Data encryption at rest and in transit
- **Secrets Management**: Secure secrets handling
- **Data Isolation**: Isolated data processing
- **Privacy Protection**: Privacy-preserving techniques

### Compliance

- **Regulatory Compliance**: Industry standard compliance
- **Security Standards**: Security best practices
- **Audit Requirements**: Audit trail maintenance
- **Risk Management**: Risk assessment and mitigation