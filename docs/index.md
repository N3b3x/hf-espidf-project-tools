---
layout: default
title: "HardFOC ESP-IDF Project Tools"
description: "Development Scripts for HardFOC ESP-IDF Projects - Multi-application build system with intelligent configuration management for ESP-IDF development"
nav_order: 1
permalink: /
---

# HardFOC ESP-IDF Project Tools

Welcome to the **HardFOC ESP-IDF Project Tools** - a comprehensive suite of development scripts designed specifically for ESP-IDF projects with multiple applications. This toolkit provides everything you need to manage multi-application builds, configuration, and development workflows for your ESP-IDF projects.

## 🚀 Quick Start

Get up and running in minutes:

### Option 1: Automated Setup (Recommended)
```bash
# Clone the tools repository
git clone https://github.com/n3b3x/hf-espidf-project-tools.git
cd hf-espidf-project-tools

# Create a complete ESP-IDF project
./setup_basic.sh my-awesome-project

# Navigate to your new project
cd my-awesome-project

# Build and flash
./scripts/build_app.sh main_app Release
./scripts/flash_app.sh flash main_app Release
```

### Option 2: Add to Existing Project
```bash
# Go into your ESP-IDF project
cd your/esp-idf-project

# Add as submodule to your ESP-IDF project
git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts

# Start building
./scripts/build_app.sh your_app Release
```

## ✨ Key Features

- **🔧 Multi-Application Build System** - Build multiple applications from a single ESP-IDF project
- **📋 Intelligent Configuration** - YAML-based configuration management with `app_config.yml`
- **📱 ESP32 Flash System** - Automated port detection and firmware flashing
- **📊 Comprehensive Logging** - Detailed build and development logs
- **🔍 Port Detection** - Cross-platform ESP32 device identification
- **📚 Multi-Version ESP-IDF** - Support for multiple ESP-IDF versions
- **🛠️ Development Scripts** - Build, flash, and utility management tools

## 📖 Documentation

Explore our comprehensive documentation:

- **[Getting Started](getting-started/)** - Quick start guide and installation
- **[Build System](build-system/)** - Multi-application build management
- **[Configuration](configuration/)** - YAML-based configuration system
- **[Flash System](flash-system/)** - ESP32 flashing and monitoring
- **[Logging System](logging-system/)** - Log management and analysis
- **[Advanced Topics](advanced/multi-version-idf/)** - Advanced features and utilities

## 🎯 Perfect For

- **Multi-Application ESP-IDF Projects** - Build multiple test applications from a single project
- **Library Testing** - Test different aspects of your library with separate applications
- **Development Workflows** - Streamlined build and flash processes for development
- **Team Development** - Consistent development environments across teams

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](contributing/) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/n3b3x/hf-espidf-project-tools/blob/main/LICENSE) file for details.

---

**Ready to get started?** Check out our [Quick Start Guide](getting-started/) or browse the [Examples](examples/) to see the tools in action!
