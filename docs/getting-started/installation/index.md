---
layout: default
title: "Installation"
description: "Detailed installation guide for HardFOC ESP32 CI Tools"
nav_order: 1
parent: "Getting Started"
permalink: /getting-started/installation/
---

# Installation Guide

This guide provides detailed instructions for installing and setting up the HardFOC ESP32 CI Tools in your project.

## 📋 Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or Windows (WSL2)
- **Git**: Version 2.0 or later
- **GitHub Account**: For repository access and Actions
- **ESP32 Project**: Existing ESP32 project with ESP-IDF

### ESP-IDF Requirements

- **ESP-IDF Version**: v4.4 or later (v5.5 recommended)
- **Python**: 3.8 or later
- **CMake**: 3.16 or later

## 🔧 Installation Methods

### Method 1: Direct Copy (Recommended)

This is the simplest method for most users:

1. **Download the repository**:
   ```bash
   git clone https://github.com/n3b3x/hf-espidf-project-tools.git
   cd hf-espidf-project-tools
   ```

2. **Copy workflow files** to your project:
   ```bash
   # Navigate to your ESP32 project
   cd /path/to/your/esp32-project
   
   # Copy workflow files
   cp -r hf-espidf-project-tools/.github/workflows/* .github/workflows/
   
   # Copy configuration files (if needed)
   cp hf-espidf-project-tools/examples/esp32/app_config.yml examples/esp32/
   ```

3. **Update configuration** for your project:
   - Edit `.github/workflows/build.yml` to match your project structure
   - Update `app_config.yml` with your applications
   - Configure ESP-IDF versions as needed

### Method 2: Git Submodule

For projects that want to track updates:

1. **Add as submodule**:
   ```bash
   cd /path/to/your/esp32-project
   git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts
   ```

2.. **Update submodule** when needed:
   ```bash
   git submodule update --remote scripts
   ```

### Method 3: Manual Download

For offline or restricted environments:

1. **Download ZIP** from GitHub releases
2. **Extract** to a temporary directory
3. **Copy** workflow files to your project
4. **Manually configure** as needed

## ⚙️ Configuration

### Basic Configuration

1. **Update project paths** in workflow files:
   ```yaml
   # In .github/workflows/build.yml
   - name: Set Project Path
     run: echo "ESP32_PROJECT_PATH=examples/esp32" >> $GITHUB_ENV
   ```

2. **Configure ESP-IDF versions**:
   ```yaml
   # In .github/workflows/build.yml
   strategy:
     matrix:
       idf_version: ["release/v5.5", "release/v5.4"]
   ```

3. **Set up build configurations**:
   ```yaml
   # In examples/esp32/app_config.yml
   apps:
     your_app:
       source_file: "YourApp.cpp"
       build_types: ["Debug", "Release"]
       idf_versions: ["release/v5.5"]
   ```

### Advanced Configuration

For more complex setups, see:
- **[Configuration System](configuration/)** - Centralized configuration management
- **[Build System](build-system/)** - ESP-IDF build optimization
- **[CI Pipeline](ci-pipeline/)** - Workflow customization

## 🔍 Verification

### Test Installation

1. **Commit changes** to your repository:
   ```bash
   git add .github/workflows/
   git commit -m "Add HardFOC ESP32 CI Tools"
   git push
   ```

2. **Check GitHub Actions**:
   - Navigate to your repository on GitHub
   - Go to "Actions" tab
   - Verify workflows are visible and enabled

3. **Run a test build**:
   - Click on "Build ESP32 Applications" workflow
   - Click "Run workflow" button
   - Monitor the execution

### Troubleshooting

If you encounter issues:

- **Check file paths** in workflow configurations
- **Verify ESP-IDF versions** are available
- **Review GitHub Actions logs** for specific errors
- **See [Troubleshooting](troubleshooting/)** for common issues

## 🚀 Next Steps

After successful installation:

1. **[Configuration](getting-started/configuration/)** - Configure for your project
2. **[Build System](build-system/)** - Learn about build management
3. **[CI Pipeline](ci-pipeline/)** - Optimize your workflows
4. **[Advanced Topics](advanced/)** - Explore advanced features

## 📚 Additional Resources

- **[GitHub Repository](https://github.com/n3b3x/hf-espidf-project-tools)** - Source code and issues
- **[Examples](examples/)** - Real-world usage examples
- **[Troubleshooting](troubleshooting/)** - Common issues and solutions

---

**Installation complete?** Move on to [Configuration](getting-started/configuration/) to customize the tools for your project.
