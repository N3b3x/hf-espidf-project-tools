---
layout: default
title: "CI Pipeline"
description: "Optimized ESP32 CI pipeline with parallel execution, intelligent caching, and performance monitoring"
has_children: true
nav_order: 4
permalink: /ci-pipeline/
---

# ESP32 CI Pipeline Integration

The ESP32 CI pipeline has been moved to a separate repository and is now available as reusable workflows. This allows for better separation of concerns and easier maintenance across multiple projects.

## CI Pipeline Repository

The CI pipeline is now hosted at: **https://github.com/N3b3x/hf-espidf-ci-tools**

This repository contains:
- **Reusable Workflows**: `build.yml` and `security.yml`
- **GitHub Actions**: Helper actions for tool management
- **Documentation**: Complete CI pipeline documentation

## Core Features

- **🔄 Reusable Workflows**: Use the same CI pipeline across multiple projects
- **🎯 Smart Matrix Generation**: Automatic build matrix generation from project configuration
- **📦 Tool Management**: Automatic tool directory detection and cloning
- **🔧 Flexible Configuration**: Customizable build parameters and security scanning
- **📊 Size Reporting**: Automatic firmware size analysis and PR comments
- **🛡️ Security Scanning**: Comprehensive security audit capabilities

## Quick Start

### Using the Reusable Build Workflow

Create a `.github/workflows/build.yml` file in your project:

```yaml
name: ESP32 Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    uses: N3b3x/hf-espidf-ci-tools/.github/workflows/build.yml@main
    with:
      project_dir: "examples/esp32"  # Path to your ESP-IDF project
      project_tools_dir: "scripts"   # Path to your scripts directory
      clean_build: false
      auto_clone_tools: true
      max_dec_total: "0"  # Disable size budget (0) or set max size in bytes
    secrets: inherit
```

### Using the Reusable Security Workflow

Create a `.github/workflows/security.yml` file in your project:

```yaml
name: Security Audit

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM

jobs:
  security:
    uses: N3b3x/hf-espidf-ci-tools/.github/workflows/security.yml@main
    with:
      project_dir: "examples/esp32"
      project_tools_dir: "scripts"
      scan_type: "all"  # all | dependencies | secrets | codeql
      run_codeql: true
      codeql_languages: "cpp"
      auto_clone_tools: true
    secrets: inherit
```

## Documentation Sections

- **[Architecture](architecture/)**: Pipeline architecture and job structure
- **[Configuration](configuration/)**: Configuration files and environment setup
- **[Performance Optimization](optimization/)**: Performance improvements and caching strategies
- **[Troubleshooting](troubleshooting/)**: Common issues and debugging guide