---
layout: default
title: "HardFOC ESP32 Project Tools"
description: "Advanced CI/CD Tools for HardFOC ESP32 Projects - Comprehensive GitHub Actions workflows for ESP-IDF development with matrix builds, security auditing, and automated documentation"
nav_order: 1
permalink: /
---

# HardFOC ESP32 Project Tools

Welcome to the **HardFOC ESP32 Project Tools** - a comprehensive suite of CI/CD tools designed specifically for HardFOC ESP32 projects. This toolkit provides everything you need to set up robust, automated development workflows for your ESP32 applications.

## 🚀 Quick Start

Get up and running in minutes:

```bash
# Add as submodule to your ESP32 project
git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts

# Copy workflows
cp scripts/.github/workflows/* .github/workflows/

# Start building
./scripts/build_app.sh your_app Release
```

## ✨ Key Features

- **🔧 Intelligent Build System** - Smart configuration management and validation
- **⚡ Advanced CI Pipeline** - Parallel execution with intelligent caching
- **📱 ESP32 Flash System** - Automated port detection and firmware flashing
- **📊 Comprehensive Logging** - Detailed build and deployment logs
- **🔍 Port Detection** - Cross-platform ESP32 device identification
- **📚 Multi-Version ESP-IDF** - Support for multiple ESP-IDF versions
- **🛠️ Utility Scripts** - Automation and workflow management tools

## 📖 Documentation

Explore our comprehensive documentation:

- **[Getting Started](getting-started/)** - Quick start guide and installation
- **[Build System](build-system/)** - Configuration and build management
- **[CI Pipeline](ci-pipeline/)** - GitHub Actions workflows and automation
- **[Configuration](configuration/)** - YAML-based configuration system
- **[Flash System](flash-system/)** - ESP32 flashing and monitoring
- **[Logging System](logging-system/)** - Log management and analysis
- **[Advanced Topics](advanced/multi-version-idf/)** - Advanced features and utilities

## 🎯 Perfect For

- **HardFOC ESP32 Projects** - Optimized for HardFOC development workflows
- **CI/CD Automation** - GitHub Actions integration with matrix builds
- **Team Development** - Consistent build environments across teams
- **Production Deployment** - Reliable, automated deployment pipelines

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](contributing/) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/n3b3x/hf-espidf-project-tools/blob/main/LICENSE) file for details.

---

**Ready to get started?** Check out our [Quick Start Guide](getting-started/) or browse the [Examples](examples/) to see the tools in action!
